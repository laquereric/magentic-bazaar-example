import React, { useState, useMemo } from 'react'
import plantumlEncoder from 'plantuml-encoder'

export default function PlantUmlDiagram({ pumlContent }) {
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(false)

  const src = useMemo(() => {
    if (!pumlContent) return null
    const encoded = plantumlEncoder.encode(pumlContent)
    return `https://www.plantuml.com/plantuml/svg/${encoded}`
  }, [pumlContent])

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
      ) : (
        <img
          src={src}
          alt="PlantUML Diagram"
          className={`max-w-full ${loading ? 'opacity-0' : 'opacity-100'}`}
          onLoad={() => setLoading(false)}
          onError={() => { setLoading(false); setError(true) }}
        />
      )}
    </div>
  )
}
