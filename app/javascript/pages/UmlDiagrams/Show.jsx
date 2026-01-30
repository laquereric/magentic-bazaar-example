import React, { useState } from 'react'
import MdxRenderer from '../../components/MdxRenderer'

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

export default function UmlDiagramsShow({ uml_diagram, document, mdx }) {
  const hasRendered = mdx && mdx.compiled_source
  const [tab, setTab] = useState(hasRendered ? 'rendered' : 'raw')

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
        <div className="border-b border-gray-200 flex items-center justify-between">
          <nav className="flex -mb-px">
            <button
              onClick={() => setTab('rendered')}
              className={`px-6 py-3 text-sm font-medium border-b-2 ${
                tab === 'rendered'
                  ? 'border-indigo-500 text-indigo-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              }`}
            >
              Rendered
            </button>
            <button
              onClick={() => setTab('raw')}
              className={`px-6 py-3 text-sm font-medium border-b-2 ${
                tab === 'raw'
                  ? 'border-indigo-500 text-indigo-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              }`}
            >
              Raw
            </button>
          </nav>
          <div className="pr-4">
            <CopyButton text={uml_diagram.puml_content} />
          </div>
        </div>
        <div className="p-6">
          {tab === 'rendered' ? (
            hasRendered ? (
              <MdxRenderer compiledSource={mdx.compiled_source} frontmatter={mdx.frontmatter} />
            ) : (
              <p className="text-sm text-gray-500 text-center py-4">No rendered content available.</p>
            )
          ) : (
            <pre className="bg-gray-50 rounded-md p-6 text-sm overflow-x-auto font-mono whitespace-pre-wrap">
              {uml_diagram.puml_content}
            </pre>
          )}
        </div>
      </div>
    </>
  )
}
