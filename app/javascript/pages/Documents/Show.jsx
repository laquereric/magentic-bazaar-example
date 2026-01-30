import React from 'react'
import MdxRenderer from '../../components/MdxRenderer'

function MetadataRow({ label, value, mono = false }) {
  return (
    <div className="px-6 py-3">
      <dt className="text-xs font-medium text-gray-500 uppercase">{label}</dt>
      <dd className={`mt-1 text-sm text-gray-900 ${mono ? 'font-mono' : ''} ${label === 'Content Hash' ? 'text-xs break-all' : ''} ${label === 'Source Path' ? 'break-all' : ''}`}>
        {value || 'N/A'}
      </dd>
    </div>
  )
}

function StatusBadge({ status }) {
  const colors = {
    pending: 'bg-yellow-100 text-yellow-800',
    ingested: 'bg-green-100 text-green-800',
    undone: 'bg-gray-100 text-gray-800',
  }
  return (
    <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${colors[status] || 'bg-gray-100 text-gray-800'}`}>
      {status}
    </span>
  )
}

function FileTypeBadge({ fileType }) {
  const colors = {
    'Markdown': 'bg-purple-100 text-purple-800',
    'PDF': 'bg-red-100 text-red-800',
    'Image (OCR)': 'bg-teal-100 text-teal-800',
    'HTML': 'bg-orange-100 text-orange-800',
  }
  return (
    <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${colors[fileType] || 'bg-gray-100 text-gray-800'}`}>
      {fileType}
    </span>
  )
}

function CopyButton({ text, label = 'Copy' }) {
  const [copied, setCopied] = React.useState(false)

  const handleCopy = () => {
    navigator.clipboard.writeText(text)
    setCopied(true)
    setTimeout(() => setCopied(false), 2000)
  }

  return (
    <button onClick={handleCopy} className="text-xs text-indigo-600 hover:text-indigo-900">
      {copied ? 'Copied!' : label}
    </button>
  )
}

export default function DocumentsShow({ document, skill, uml_diagram, mdx }) {
  const hasRendered = mdx && mdx.compiled_source
  const [tab, setTab] = React.useState(hasRendered ? 'rendered' : 'raw')

  const wordCount = document.word_count ? document.word_count.toLocaleString() : '0'
  const createdAt = new Date(document.created_at).toLocaleDateString('en-US', {
    year: 'numeric', month: 'long', day: 'numeric', hour: 'numeric', minute: '2-digit'
  })

  return (
    <>
      <div className="mb-6">
        <a href="/documents" className="text-sm text-indigo-600 hover:text-indigo-900">
          &larr; Back to Documents
        </a>
      </div>

      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">{document.title}</h1>
        <div className="mt-2 flex items-center gap-3">
          <FileTypeBadge fileType={document.file_type} />
          <StatusBadge status={document.status} />
          <span className="text-sm text-gray-500">{wordCount} words</span>
          {skill && (
            <a href={`/skills/${skill.id}`} className="text-sm text-indigo-600 hover:text-indigo-900">Skill</a>
          )}
          {uml_diagram && (
            <a href={`/uml_diagrams/${uml_diagram.id}`} className="text-sm text-indigo-600 hover:text-indigo-900">UML</a>
          )}
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
        {/* Sidebar */}
        <div className="bg-white shadow rounded-lg">
          <div className="px-6 py-4 border-b border-gray-200">
            <h2 className="text-lg font-medium text-gray-900">Metadata</h2>
          </div>
          <dl className="divide-y divide-gray-200">
            <MetadataRow label="Filename" value={document.original_filename} />
            <MetadataRow label="UUID" value={document.uuid7} mono />
            <MetadataRow label="Git SHA" value={document.git_sha} mono />
            <MetadataRow label="Content Hash" value={document.content_hash} mono />
            <MetadataRow label="Source Path" value={document.source_path} />
            <MetadataRow label="Created" value={createdAt} />
          </dl>
        </div>

        {/* Content */}
        <div className="lg:col-span-3 bg-white shadow rounded-lg">
          <div className="border-b border-gray-200">
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
          </div>
          <div className="p-6">
            {tab === 'rendered' ? (
              hasRendered ? (
                <MdxRenderer compiledSource={mdx.compiled_source} frontmatter={mdx.frontmatter} />
              ) : (
                <p className="text-sm text-gray-500 text-center py-4">No rendered content available.</p>
              )
            ) : (
              document.raw_content ? (
                <pre className="bg-gray-50 rounded-md p-6 text-sm overflow-x-auto whitespace-pre-wrap font-mono">
                  {document.raw_content}
                </pre>
              ) : (
                <p className="text-sm text-gray-500 text-center py-4">No content available.</p>
              )
            )}
          </div>
        </div>
      </div>
    </>
  )
}
