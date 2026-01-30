import React from 'react'

export default function TableOfContents({ sections = [] }) {
  if (sections.length === 0) return null

  return (
    <nav className="not-prose my-4 bg-gray-50 border border-gray-200 rounded-lg p-4">
      <h3 className="text-sm font-medium text-gray-900 mb-2">Table of Contents</h3>
      <ul className="space-y-1">
        {sections.map((section, index) => (
          <li key={section.id || index}>
            <a
              href={`#${section.id || section.title.toLowerCase().replace(/\s+/g, '-')}`}
              className="text-sm text-indigo-600 hover:text-indigo-900 hover:underline"
            >
              {section.title}
            </a>
          </li>
        ))}
      </ul>
    </nav>
  )
}
