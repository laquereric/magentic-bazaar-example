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

    // Find participant header text nodes matching the label
    const textNodes = svg.querySelectorAll('text')
    for (const textNode of textNodes) {
      const content = textNode.textContent.trim()
      if (content === highlightParticipant) {
        // The participant box is typically the preceding rect sibling or parent group rect
        const parent = textNode.closest('g') || textNode.parentElement
        const rect = parent ? parent.querySelector('rect') : null

        if (rect) {
          const highlight = document.createElementNS('http://www.w3.org/2000/svg', 'rect')
          const x = parseFloat(rect.getAttribute('x')) - 4
          const y = parseFloat(rect.getAttribute('y')) - 4
          const width = parseFloat(rect.getAttribute('width')) + 8
          const height = parseFloat(rect.getAttribute('height')) + 8

          highlight.setAttribute('x', x)
          highlight.setAttribute('y', y)
          highlight.setAttribute('width', width)
          highlight.setAttribute('height', height)
          highlight.setAttribute('rx', '6')
          highlight.setAttribute('ry', '6')
          highlight.setAttribute('fill', 'rgba(99, 102, 241, 0.15)')
          highlight.setAttribute('stroke', '#4F46E5')
          highlight.setAttribute('stroke-width', '2.5')
          highlight.setAttribute('class', 'participant-highlight')

          rect.parentNode.insertBefore(highlight, rect)
        }
        break
      }
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
