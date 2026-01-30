import React, { useState } from 'react'

export default function UMLPreview({ title, diagramType, subtype, pumlContent }) {
  const [showSource, setShowSource] = useState(false)
  const [copied, setCopied] = useState(false)

  const handleCopy = () => {
    navigator.clipboard.writeText(pumlContent)
    setCopied(true)
    setTimeout(() => setCopied(false), 2000)
  }

  return (
    <div className="not-prose my-4 border border-gray-200 rounded-lg overflow-hidden">
      <div className="bg-gray-50 px-4 py-3 border-b border-gray-200 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <span className="text-sm font-medium text-gray-900">{title || 'UML Diagram'}</span>
          <span className="inline-flex items-center rounded-full bg-indigo-100 text-indigo-800 px-2 py-0.5 text-xs font-medium">
            {diagramType}
          </span>
          {subtype && (
            <span className="inline-flex items-center rounded-full bg-gray-100 text-gray-700 px-2 py-0.5 text-xs font-medium">
              {subtype}
            </span>
          )}
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={() => setShowSource(!showSource)}
            className="text-xs text-indigo-600 hover:text-indigo-900"
          >
            {showSource ? 'Hide Source' : 'View Source'}
          </button>
          <button
            onClick={handleCopy}
            className="text-xs text-indigo-600 hover:text-indigo-900"
          >
            {copied ? 'Copied!' : 'Copy'}
          </button>
        </div>
      </div>

      {showSource && pumlContent && (
        <div className="p-4">
          <pre className="bg-gray-900 text-gray-100 rounded-md p-4 text-xs overflow-x-auto font-mono">
            {pumlContent}
          </pre>
        </div>
      )}

      {!showSource && (
        <div className="p-4 text-center text-sm text-gray-500">
          <p>PlantUML source available. Click "View Source" to see the diagram code.</p>
          <p className="mt-1 text-xs text-gray-400">
            Copy the source and paste into a PlantUML renderer to visualize.
          </p>
        </div>
      )}
    </div>
  )
}
