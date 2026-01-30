import React from 'react'
import MdxRenderer from '../../components/MdxRenderer'

export default function SkillsShow({ skill, document, mdx }) {
  return (
    <>
      <div className="mb-6">
        <a href="/skills" className="text-sm text-indigo-600 hover:text-indigo-900">
          &larr; Back to Skills
        </a>
      </div>

      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">{skill.name}</h1>
        <div className="mt-2 flex flex-wrap items-center gap-3">
          <span className="inline-flex items-center rounded-full bg-purple-100 text-purple-800 px-2.5 py-0.5 text-xs font-medium">
            {skill.category}
          </span>
          {skill.uml_type && (
            <span className="inline-flex items-center rounded-full bg-indigo-100 text-indigo-800 px-2.5 py-0.5 text-xs font-medium">
              {skill.uml_type}
            </span>
          )}
          <span className="text-sm text-gray-500">v{skill.version}</span>
          {document && (
            <span className="text-sm text-gray-500">
              From: <a href={`/documents/${document.id}`} className="text-indigo-600 hover:text-indigo-900">{document.title}</a>
            </span>
          )}
        </div>
      </div>

      {mdx && mdx.compiled_source ? (
        <div className="bg-white shadow rounded-lg p-6">
          <MdxRenderer compiledSource={mdx.compiled_source} frontmatter={mdx.frontmatter} />
        </div>
      ) : (
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
          {/* Sidebar */}
          <div className="bg-white shadow rounded-lg">
            <div className="px-6 py-4 border-b border-gray-200">
              <h2 className="text-lg font-medium text-gray-900">Details</h2>
            </div>
            <dl className="divide-y divide-gray-200">
              <div className="px-6 py-3">
                <dt className="text-xs font-medium text-gray-500 uppercase">Sections</dt>
                <dd className="mt-1 text-sm text-gray-900">{skill.section_count}</dd>
              </div>
              <div className="px-6 py-3">
                <dt className="text-xs font-medium text-gray-500 uppercase">Key Points</dt>
                <dd className="mt-1 text-sm text-gray-900">{skill.key_point_count}</dd>
              </div>
              <div className="px-6 py-3">
                <dt className="text-xs font-medium text-gray-500 uppercase">Has Code</dt>
                <dd className="mt-1 text-sm text-gray-900">{skill.has_code ? 'Yes' : 'No'}</dd>
              </div>
              <div className="px-6 py-3">
                <dt className="text-xs font-medium text-gray-500 uppercase">Has Diagrams</dt>
                <dd className="mt-1 text-sm text-gray-900">{skill.has_diagrams ? 'Yes' : 'No'}</dd>
              </div>
              {skill.output_path && (
                <div className="px-6 py-3">
                  <dt className="text-xs font-medium text-gray-500 uppercase">Output Path</dt>
                  <dd className="mt-1 text-sm text-gray-900 break-all">{skill.output_path}</dd>
                </div>
              )}
            </dl>
          </div>

          {/* Content */}
          <div className="lg:col-span-3 bg-white shadow rounded-lg">
            <div className="px-6 py-4 border-b border-gray-200">
              <h2 className="text-lg font-medium text-gray-900">Content</h2>
            </div>
            <div className="p-6">
              {skill.content ? (
                <pre className="bg-gray-50 rounded-md p-6 text-sm overflow-x-auto whitespace-pre-wrap font-mono">
                  {skill.content}
                </pre>
              ) : (
                <p className="text-sm text-gray-500 text-center py-4">No content available.</p>
              )}
            </div>
          </div>
        </div>
      )}
    </>
  )
}
