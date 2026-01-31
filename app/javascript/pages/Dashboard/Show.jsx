import React, { useState } from 'react'
import PlantUmlDiagram from '../../components/PlantUmlDiagram'

const REQUEST_LAYER_CONFIG = {
  users:       { label: 'Users',      color: 'indigo', icon: 'U' },
  devices:     { label: 'Devices',    color: 'blue',   icon: 'D' },
  services:    { label: 'Services',   color: 'emerald', icon: 'S' },
  middlewares: { label: 'Middleware',  color: 'amber',  icon: 'M' },
  providers:   { label: 'Providers',  color: 'rose',   icon: 'P' },
}

const RESPONSE_LAYER_CONFIG = {
  providers:   { label: 'Providers',  color: 'rose',   icon: 'P' },
  middlewares: { label: 'Middleware',  color: 'amber',  icon: 'M' },
  services:    { label: 'Services',   color: 'emerald', icon: 'S' },
  devices:     { label: 'Devices',    color: 'blue',   icon: 'D' },
  users:       { label: 'Users',      color: 'indigo', icon: 'U' },
}

const COLOR_CLASSES = {
  indigo:  { bg: 'bg-indigo-50',  text: 'text-indigo-700',  badge: 'bg-indigo-100 text-indigo-800', border: 'border-indigo-200' },
  blue:    { bg: 'bg-blue-50',    text: 'text-blue-700',    badge: 'bg-blue-100 text-blue-800',     border: 'border-blue-200' },
  emerald: { bg: 'bg-emerald-50', text: 'text-emerald-700', badge: 'bg-emerald-100 text-emerald-800', border: 'border-emerald-200' },
  amber:   { bg: 'bg-amber-50',   text: 'text-amber-700',   badge: 'bg-amber-100 text-amber-800',   border: 'border-amber-200' },
  rose:    { bg: 'bg-rose-50',    text: 'text-rose-700',    badge: 'bg-rose-100 text-rose-800',     border: 'border-rose-200' },
}

function StatusBadge({ status }) {
  const colors = {
    completed: 'bg-green-100 text-green-800',
    pending:   'bg-yellow-100 text-yellow-800',
    error:     'bg-red-100 text-red-800',
  }
  return (
    <span className={`inline-flex items-center rounded-full px-2 py-0.5 text-xs font-medium ${colors[status] || 'bg-gray-100 text-gray-800'}`}>
      {status}
    </span>
  )
}

function LayerCard({ layerKey, data, config, highlighted }) {
  const layerConfig = config[layerKey]
  const colors = COLOR_CLASSES[layerConfig.color]

  return (
    <div className={`overflow-hidden rounded-lg bg-white shadow border transition-all duration-200 ${highlighted ? 'ring-2 ring-indigo-500 border-indigo-400 scale-[1.03] shadow-lg' : colors.border}`}>
      <div className={`px-4 py-3 ${colors.bg} border-b ${colors.border}`}>
        <div className="flex items-center gap-2">
          <span className={`inline-flex items-center justify-center w-7 h-7 rounded-full text-xs font-bold ${colors.badge}`}>
            {layerConfig.icon}
          </span>
          <h3 className={`text-sm font-semibold ${colors.text}`}>{layerConfig.label}</h3>
        </div>
      </div>
      <div className="p-4">
        <div className="flex items-baseline gap-2 mb-3">
          <span className="text-2xl font-bold text-gray-900">{data.total}</span>
          <span className="text-sm text-gray-500">total</span>
          <span className="text-sm text-green-600 ml-auto">{data.active} active</span>
        </div>
        <div className="space-y-1.5">
          {Object.entries(data.by_type).map(([type, count]) => (
            <div key={type} className="flex items-center justify-between text-sm">
              <span className="text-gray-600 capitalize">{type}</span>
              <span className={`inline-flex items-center rounded-full px-2 py-0.5 text-xs font-medium ${colors.badge}`}>
                {count}
              </span>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}

// Maps traceable_type to the layer position (0-9) in the flow
const TRACEABLE_POSITION = {
  RequestUser: 0,
  RequestDevice: 1,
  RequestService: 2,
  RequestMiddleware: 3,
  RequestProvider: 4,
  ResponseProvider: 5,
  ResponseMiddleware: 6,
  ResponseService: 7,
  ResponseDevice: 8,
  ResponseUser: 9,
}

// Maps traceable_type to PlantUML participant label
const TRACEABLE_TO_PARTICIPANT = {
  RequestUser: 'User',
  RequestDevice: 'Device',
  RequestService: 'Service',
  RequestMiddleware: 'Middleware',
  RequestProvider: 'Provider',
  ResponseProvider: 'Provider',
  ResponseMiddleware: 'Middleware',
  ResponseService: 'Service',
  ResponseDevice: 'Device',
  ResponseUser: 'User',
}

// Maps traceable_type to { section: 'request'|'response', key: layerKey }
const TRACEABLE_TO_LAYER = {
  RequestUser:        { section: 'request',  key: 'users' },
  RequestDevice:      { section: 'request',  key: 'devices' },
  RequestService:     { section: 'request',  key: 'services' },
  RequestMiddleware:  { section: 'request',  key: 'middlewares' },
  RequestProvider:    { section: 'request',  key: 'providers' },
  ResponseProvider:   { section: 'response', key: 'providers' },
  ResponseMiddleware: { section: 'response', key: 'middlewares' },
  ResponseService:    { section: 'response', key: 'services' },
  ResponseDevice:     { section: 'response', key: 'devices' },
  ResponseUser:       { section: 'response', key: 'users' },
}

const LAYER_LABELS = [
  'User', 'Device', 'Service', 'Middleware', 'Provider',
  'Provider', 'Middleware', 'Service', 'Device', 'User',
]

const BLOCK_STATUS_COLORS = {
  matched: { bg: 'bg-green-200', selectedBg: 'bg-green-600', ring: 'ring-green-400', hover: 'hover:bg-green-300', text: 'text-green-800', selectedText: 'text-white' },
  pending: { bg: 'bg-yellow-100', selectedBg: 'bg-yellow-500', ring: 'ring-yellow-400', hover: 'hover:bg-yellow-200', text: 'text-yellow-800', selectedText: 'text-white' },
  error:   { bg: 'bg-red-200', selectedBg: 'bg-red-600', ring: 'ring-red-400', hover: 'hover:bg-red-300', text: 'text-red-800', selectedText: 'text-white' },
}

function FlowDocumentStrip({ flowDocuments, selected, onSelect }) {
  if (!flowDocuments || flowDocuments.length === 0) {
    return (
      <div className="bg-white shadow rounded-lg p-6 text-center text-sm text-gray-400">
        No JSON-LD documents ingested yet.
      </div>
    )
  }

  return (
    <div className="space-y-3">
      {/* Row 1: 10 narrow blocks */}
      <div className="bg-white shadow rounded-lg border border-gray-200 p-3">
        <div className="flex gap-2">
          {flowDocuments.map((doc, idx) => {
            const colors = BLOCK_STATUS_COLORS[doc.status] || { bg: 'bg-gray-400', ring: 'ring-gray-200', hover: 'hover:bg-gray-300' }
            const isSelected = selected === idx
            const pos = doc.traceable_type ? TRACEABLE_POSITION[doc.traceable_type] : null
            const label = pos !== null && pos !== undefined ? LAYER_LABELS[pos] : '?'

            return (
              <button
                key={doc.id}
                onClick={() => onSelect(idx)}
                title={doc.document_title}
                className={`
                  flex-1 min-w-0 h-14 rounded-lg transition-all cursor-pointer
                  flex flex-col items-center justify-center gap-0.5
                  ${isSelected
                    ? `${colors.selectedBg} ring-2 ${colors.ring} scale-[1.08] shadow-lg z-10`
                    : `${colors.bg} ${colors.hover} shadow`}
                `}
              >
                <span className={`text-xs font-bold leading-none ${isSelected ? colors.selectedText : colors.text}`}>
                  {label}
                </span>
                <span className={`text-[9px] leading-none ${isSelected ? 'text-white/70' : `${colors.text} opacity-50`}`}>
                  {idx + 1}
                </span>
              </button>
            )
          })}
        </div>
      </div>

      {/* Row 2: Detail bar for selected document */}
      {selected !== null && flowDocuments[selected] && (
        <FlowDocumentDetail doc={flowDocuments[selected]} />
      )}
    </div>
  )
}

function FlowDocumentDetail({ doc }) {
  const pos = doc.traceable_type ? TRACEABLE_POSITION[doc.traceable_type] : null
  const layerLabel = pos !== null && pos !== undefined ? LAYER_LABELS[pos] : null
  const isRequest = pos !== null && pos <= 4
  const colors = BLOCK_STATUS_COLORS[doc.status] || { bg: 'bg-gray-400' }

  return (
    <div className="bg-white shadow rounded-lg border border-gray-200 px-4 py-3 flex items-center gap-4">
      <div className={`w-3 h-3 rounded-full flex-shrink-0 ${colors.bg}`} />
      <div className="min-w-0 flex-1">
        <div className="flex items-center gap-2 mb-0.5">
          <span className="text-sm font-semibold text-gray-900 truncate">{doc.document_title}</span>
          <StatusBadge status={doc.status} />
        </div>
        <div className="text-xs text-gray-500 font-mono">{doc.jsonld_type}</div>
      </div>
      {layerLabel ? (
        <div className="flex items-center gap-1.5 flex-shrink-0">
          <span className={`inline-block w-2 h-2 rounded-full ${isRequest ? 'bg-indigo-400' : 'bg-violet-400'}`} />
          <span className="text-xs font-medium text-gray-700">
            {isRequest ? 'Req' : 'Res'} &rarr; {layerLabel}
          </span>
        </div>
      ) : (
        <span className="text-xs text-gray-400 flex-shrink-0">Unmatched</span>
      )}
      <span className="text-xs text-gray-400 flex-shrink-0">{timeAgo(doc.created_at)}</span>
    </div>
  )
}

function timeAgo(dateStr) {
  const seconds = Math.floor((new Date() - new Date(dateStr)) / 1000)
  if (seconds < 60) return 'just now'
  const minutes = Math.floor(seconds / 60)
  if (minutes < 60) return `${minutes}m ago`
  const hours = Math.floor(minutes / 60)
  if (hours < 24) return `${hours}h ago`
  const days = Math.floor(hours / 24)
  return `${days}d ago`
}

export default function DashboardShow({ puml_request, puml_response, flow_documents, request_layers, response_layers, recent_ingestions }) {
  const [selectedDoc, setSelectedDoc] = useState(null)
  const [docsExpanded, setDocsExpanded] = useState(false)

  const docs = flow_documents || []
  const hasSelection = docsExpanded && selectedDoc !== null
  const selectedTraceableType = hasSelection ? docs[selectedDoc]?.traceable_type : null
  const highlightedLayer = selectedTraceableType ? TRACEABLE_TO_LAYER[selectedTraceableType] : null
  const highlightedParticipant = selectedTraceableType ? TRACEABLE_TO_PARTICIPANT[selectedTraceableType] : null
  const selectedFlow = highlightedLayer?.section || null

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
        <p className="mt-1 text-sm text-gray-500">Request flow overview — User to Provider and back</p>
      </div>

      {/* Incoming Documents: collapsed title button / expanded strip + detail */}
      <div>
        <button
          onClick={() => { setDocsExpanded(prev => !prev); setSelectedDoc(null) }}
          className="flex items-center gap-2 group cursor-pointer"
        >
          <svg
            className={`w-4 h-4 text-gray-400 transition-transform duration-200 ${docsExpanded ? 'rotate-90' : ''}`}
            fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}
          >
            <path strokeLinecap="round" strokeLinejoin="round" d="M9 5l7 7-7 7" />
          </svg>
          <h2 className="text-lg font-medium text-gray-900 group-hover:text-indigo-600 transition-colors">
            Incoming Documents
          </h2>
          <span className="text-sm text-gray-400 ml-1">({docs.length})</span>
        </button>
        {docsExpanded && (
          <>
            <p className="text-sm text-gray-500 mt-1 mb-3 ml-6">JSON-LD ingestion flow — click a block to inspect</p>
            <FlowDocumentStrip
              flowDocuments={docs}
              selected={selectedDoc}
              onSelect={setSelectedDoc}
            />
          </>
        )}
      </div>

      {/* A. PlantUML Sequence Diagram — show request or response based on selected document */}
      {hasSelection && selectedFlow === 'request' && (
        <div className="bg-white shadow rounded-lg overflow-hidden">
          <div className="px-6 py-4 border-b border-gray-200">
            <h2 className="text-lg font-medium text-gray-900">Request Flow Diagram</h2>
            <p className="text-sm text-gray-500 mt-0.5">User &rarr; Device &rarr; Service &rarr; Middleware &rarr; Provider</p>
          </div>
          <div className="p-6">
            <PlantUmlDiagram pumlContent={puml_request} highlightParticipant={highlightedParticipant} />
          </div>
        </div>
      )}
      {hasSelection && selectedFlow === 'response' && (
        <div className="bg-white shadow rounded-lg overflow-hidden">
          <div className="px-6 py-4 border-b border-gray-200">
            <h2 className="text-lg font-medium text-gray-900">Response Flow Diagram</h2>
            <p className="text-sm text-gray-500 mt-0.5">Provider &rarr; Middleware &rarr; Service &rarr; Device &rarr; User</p>
          </div>
          <div className="p-6">
            <PlantUmlDiagram pumlContent={puml_response} highlightParticipant={highlightedParticipant} />
          </div>
        </div>
      )}

      {/* B. Layer Cards — show only the matching flow when a document is selected */}
      {hasSelection && selectedFlow === 'request' && (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
          {Object.keys(REQUEST_LAYER_CONFIG).map(key => (
            <LayerCard key={key} layerKey={key} data={request_layers[key]} config={REQUEST_LAYER_CONFIG}
              highlighted={highlightedLayer?.section === 'request' && highlightedLayer?.key === key} />
          ))}
        </div>
      )}
      {hasSelection && selectedFlow === 'response' && (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
          {Object.keys(RESPONSE_LAYER_CONFIG).map(key => (
            <LayerCard key={`resp-${key}`} layerKey={key} data={response_layers[key]} config={RESPONSE_LAYER_CONFIG}
              highlighted={highlightedLayer?.section === 'response' && highlightedLayer?.key === key} />
          ))}
        </div>
      )}

      {/* D. Recent Activity */}
      <div className="bg-white shadow rounded-lg">
        <div className="px-6 py-4 border-b border-gray-200">
          <h2 className="text-lg font-medium text-gray-900">Recent Ingestions</h2>
        </div>
        <div className="divide-y divide-gray-200">
          {recent_ingestions.length > 0 ? (
            recent_ingestions.map(ing => (
              <div key={ing.id} className="px-6 py-4 flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <span className="text-sm font-medium text-gray-900 capitalize">{ing.direction}</span>
                  <StatusBadge status={ing.status} />
                </div>
                <div className="text-sm text-gray-500">
                  {ing.documents_processed}/{ing.documents_count} docs
                  <span className="ml-3 text-gray-400">{timeAgo(ing.created_at)}</span>
                </div>
              </div>
            ))
          ) : (
            <div className="px-6 py-8 text-center text-sm text-gray-500">
              No ingestions yet. Upload files and trigger an ingestion to get started.
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
