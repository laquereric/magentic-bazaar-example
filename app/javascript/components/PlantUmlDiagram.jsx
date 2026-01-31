import React, { useState, useEffect, useRef, useMemo } from 'react'
import plantumlEncoder from 'plantuml-encoder'

// PlantUML participant alias -> display label used in SVG text nodes
const PARTICIPANT_LABELS = ['User', 'Device', 'Service', 'Middleware', 'Provider']

export default function PlantUmlDiagram({ pumlContent, highlightParticipant }) {
  const [svgMarkup, setSvgMarkup] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(false)
  const containerRef = useRef(null)

  const src = useMemo(() => {
    if (!pumlContent) return null
    const encoded = plantumlEncoder.encode(pumlContent)
    return `https://www.plantuml.com/plantuml/svg/${encoded}`
  }, [pumlContent])

  // Fetch SVG as text so we can inline it and manipulate the DOM
  useEffect(() => {
    if (!src) return
    setLoading(true)
    setError(false)
    setSvgMarkup(null)

    fetch(src)
      .then(res => {
        if (!res.ok) throw new Error('Failed to fetch')
        return res.text()
      })
      .then(text => {
        setSvgMarkup(text)
        setLoading(false)
      })
      .catch(() => {
        setError(true)
        setLoading(false)
      })
  }, [src])

  // Apply highlight to the matching participant
  useEffect(() => {
    if (!containerRef.current || !svgMarkup) return
    const svg = containerRef.current.querySelector('svg')
    if (!svg) return

    // Remove previous highlights
    svg.querySelectorAll('.participant-highlight').forEach(el => el.remove())

    if (!highlightParticipant) return

    const addHighlight = (targetEl) => {
      let x, y, width, height, parent
      if (targetEl.tagName === 'rect') {
        x = parseFloat(targetEl.getAttribute('x')) - 4
        y = parseFloat(targetEl.getAttribute('y')) - 4
        width = parseFloat(targetEl.getAttribute('width')) + 8
        height = parseFloat(targetEl.getAttribute('height')) + 8
        parent = targetEl.parentNode
      } else if (targetEl.tagName === 'polygon') {
        const points = targetEl.getAttribute('points')
        if (!points) return
        const coords = points.trim().split(/[\s,]+/).map(Number)
        let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity
        for (let i = 0; i < coords.length; i += 2) {
          minX = Math.min(minX, coords[i])
          maxX = Math.max(maxX, coords[i])
          minY = Math.min(minY, coords[i + 1])
          maxY = Math.max(maxY, coords[i + 1])
        }
        x = minX - 4; y = minY - 4
        width = (maxX - minX) + 8; height = (maxY - minY) + 8
        parent = targetEl.parentNode
      } else return

      const hl = document.createElementNS('http://www.w3.org/2000/svg', 'rect')
      hl.setAttribute('x', x)
      hl.setAttribute('y', y)
      hl.setAttribute('width', width)
      hl.setAttribute('height', height)
      hl.setAttribute('rx', '6')
      hl.setAttribute('ry', '6')
      hl.setAttribute('fill', 'rgba(99, 102, 241, 0.15)')
      hl.setAttribute('stroke', '#4F46E5')
      hl.setAttribute('stroke-width', '2.5')
      hl.setAttribute('class', 'participant-highlight')
      parent.insertBefore(hl, targetEl)
    }

    const highlighted = new Set()
    const textNodes = svg.querySelectorAll('text')

    // 1. Find and highlight participant header/footer boxes, and record x-center
    let participantCenterX = null
    for (const textNode of textNodes) {
      const content = textNode.textContent.trim()
      if (content === highlightParticipant) {
        const parent = textNode.closest('g') || textNode.parentElement
        const rect = parent ? parent.querySelector('rect') : null
        if (rect && !highlighted.has(rect)) {
          highlighted.add(rect)
          addHighlight(rect)
          if (participantCenterX === null) {
            participantCenterX = parseFloat(rect.getAttribute('x')) + parseFloat(rect.getAttribute('width')) / 2
          }
        }
      }
    }

    // 2. Find note polygons and rects horizontally aligned with the participant
    if (participantCenterX !== null) {
      svg.querySelectorAll('polygon').forEach(polygon => {
        const points = polygon.getAttribute('points')
        if (!points) return
        const coords = points.trim().split(/[\s,]+/).map(Number)
        let minX = Infinity, maxX = -Infinity
        for (let i = 0; i < coords.length; i += 2) {
          minX = Math.min(minX, coords[i])
          maxX = Math.max(maxX, coords[i])
        }
        const polyCenterX = (minX + maxX) / 2
        if (Math.abs(polyCenterX - participantCenterX) < 30 && !highlighted.has(polygon)) {
          highlighted.add(polygon)
          addHighlight(polygon)
        }
      })

      svg.querySelectorAll('rect').forEach(rect => {
        if (highlighted.has(rect)) return
        const rx = parseFloat(rect.getAttribute('x'))
        const rw = parseFloat(rect.getAttribute('width'))
        if (isNaN(rx) || isNaN(rw)) return
        const rectCenterX = rx + rw / 2
        if (Math.abs(rectCenterX - participantCenterX) < 30) {
          highlighted.add(rect)
          addHighlight(rect)
        }
      })
    }
  }, [svgMarkup, highlightParticipant])

  if (!pumlContent) {
    return (
      <p className="text-sm text-gray-500 text-center py-4">
        No diagram content available.
      </p>
    )
  }

  return (
    <div className="flex items-center justify-center min-h-[200px]">
      {loading && !error && (
        <div className="absolute">
          <svg className="animate-spin h-8 w-8 text-indigo-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z" />
          </svg>
        </div>
      )}

      {error ? (
        <div className="text-center py-4">
          <p className="text-sm text-red-600">Failed to render diagram.</p>
          <p className="text-xs text-gray-400 mt-1">
            The PlantUML server could not process this diagram.
          </p>
        </div>
      ) : svgMarkup ? (
        <div
          ref={containerRef}
          className="max-w-full"
          dangerouslySetInnerHTML={{ __html: svgMarkup }}
        />
      ) : null}
    </div>
  )
}
