import React, { useState } from 'react'

function CopyButton({ text, label = 'Copy to Clipboard' }) {
  const [copied, setCopied] = useState(false)

  const handleCopy = () => {
    navigator.clipboard.writeText(text)
    setCopied(true)
    setTimeout(() => setCopied(false), 2000)
  }

  return (
    <button
      onClick={handleCopy}
      className="inline-flex items-center gap-1 text-sm text-indigo-600 hover:text-indigo-900"
    >
      {copied ? 'Copied!' : label}
    </button>
  )
}

export default function UmlDiagramsShow({ uml_diagram, document }) {
  const [fontSize, setFontSize] = useState(14)

  return (
    <>
      <div className="mb-6">
        <a href="/uml_diagrams" className="text-sm text-indigo-600 hover:text-indigo-900">
          &larr; Back to UML Diagrams
        </a>
      </div>

      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">
          {uml_diagram.title || 'Untitled Diagram'}
        </h1>
        <div className="mt-2 flex items-center gap-3">
          <span className="inline-flex items-center rounded-full bg-indigo-100 text-indigo-800 px-2.5 py-0.5 text-xs font-medium">
            {uml_diagram.diagram_type}
          </span>
          {uml_diagram.subtype && (
            <span className="inline-flex items-center rounded-full bg-gray-100 text-gray-800 px-2.5 py-0.5 text-xs font-medium">
              {uml_diagram.subtype}
            </span>
          )}
          {document && (
            <span className="text-sm text-gray-500">
              From: <a href={`/documents/${document.id}`} className="text-indigo-600 hover:text-indigo-900">{document.title}</a>
            </span>
          )}
        </div>
      </div>

      <div className="bg-white shadow rounded-lg">
        <div className="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
          <h2 className="text-lg font-medium text-gray-900">PlantUML Source</h2>
          <div className="flex items-center gap-4">
            <div className="flex items-center gap-2">
              <button
                onClick={() => setFontSize(s => Math.max(10, s - 2))}
                className="text-sm text-gray-500 hover:text-gray-700 px-1"
                title="Decrease font size"
              >
                A-
              </button>
              <span className="text-xs text-gray-400">{fontSize}px</span>
              <button
                onClick={() => setFontSize(s => Math.min(24, s + 2))}
                className="text-sm text-gray-500 hover:text-gray-700 px-1"
                title="Increase font size"
              >
                A+
              </button>
            </div>
            <CopyButton text={uml_diagram.puml_content} />
          </div>
        </div>
        <div className="p-6">
          <pre
            className="bg-gray-50 rounded-md p-6 overflow-x-auto font-mono whitespace-pre-wrap"
            style={{ fontSize: `${fontSize}px` }}
          >
            {uml_diagram.puml_content}
          </pre>
        </div>
      </div>
    </>
  )
}
