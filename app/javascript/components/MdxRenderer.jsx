import React, { useMemo } from 'react'
import * as jsxRuntime from 'react/jsx-runtime'
import UMLPreview from './mdx/UMLPreview'
import CollapsibleSection from './mdx/CollapsibleSection'
import TableOfContents from './mdx/TableOfContents'
import Callout from './mdx/Callout'

const mdxComponents = {
  UMLPreview,
  CollapsibleSection,
  TableOfContents,
  Callout,
}

export default function MdxRenderer({ compiledSource, frontmatter = {} }) {
  const Component = useMemo(() => {
    if (!compiledSource) return null
    try {
      const fn = new Function(compiledSource)
      const { default: MDXContent } = fn(jsxRuntime)
      return MDXContent
    } catch (error) {
      console.error('Failed to render MDX:', error)
      return null
    }
  }, [compiledSource])

  if (!Component) {
    return (
      <div className="text-sm text-gray-500 text-center py-4">
        Unable to render MDX content.
      </div>
    )
  }

  return (
    <ErrorBoundary>
      <div className="prose prose-sm max-w-none prose-indigo">
        <Component components={mdxComponents} />
      </div>
    </ErrorBoundary>
  )
}

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props)
    this.state = { hasError: false, error: null }
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error }
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="bg-red-50 border border-red-200 rounded-md p-4">
          <p className="text-sm text-red-800">
            Failed to render MDX content. The raw content may be available below.
          </p>
          <pre className="mt-2 text-xs text-red-600 overflow-x-auto">
            {this.state.error?.message}
          </pre>
        </div>
      )
    }

    return this.props.children
  }
}
