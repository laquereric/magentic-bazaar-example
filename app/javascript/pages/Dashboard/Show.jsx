import React from 'react'
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

function LayerCard({ layerKey, data, config }) {
  const layerConfig = config[layerKey]
  const colors = COLOR_CLASSES[layerConfig.color]

  return (
    <div className={`overflow-hidden rounded-lg bg-white shadow border ${colors.border}`}>
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

const LAYER_LABELS = [
  'User', 'Device', 'Service', 'Middleware', 'Provider',
  'Provider', 'Middleware', 'Service', 'Device', 'User',
]

const FLOW_STATUS_COLORS = {
  matched: 'bg-green-500',
  pending: 'bg-yellow-400',
  error:   'bg-red-500',
}

function FlowDocumentColumn({ flowDocuments }) {
  if (!flowDocuments || flowDocuments.length === 0) {
    return (
      <div className="bg-white shadow rounded-lg p-6 text-center text-sm text-gray-400">
        No JSON-LD documents ingested yet.
      </div>
    )
  }

  return (
    <div className="space-y-0">
      {flowDocuments.map((doc, idx) => {
        const pos = doc.traceable_type ? TRACEABLE_POSITION[doc.traceable_type] : null
        const layerLabel = pos !== null && pos !== undefined ? LAYER_LABELS[pos] : null
        const isRequest = pos !== null && pos <= 4
        const statusDot = FLOW_STATUS_COLORS[doc.status] || 'bg-gray-400'

        return (
          <div key={doc.id} className="relative">
            {/* Connector line between cards */}
            {idx > 0 && (
              <div className="absolute left-5 -top-0 w-0.5 h-0 bg-gray-300" />
            )}
            <div className="flex items-start gap-3 group">
              {/* Vertical flow indicator */}
              <div className="flex flex-col items-center flex-shrink-0 pt-3">
                <div className={`w-2.5 h-2.5 rounded-full ${statusDot} ring-2 ring-white`} />
                {idx < flowDocuments.length - 1 && (
                  <div className="w-0.5 flex-1 min-h-[2rem] bg-gray-200" />
                )}
              </div>

              {/* Document card */}
              <div className="flex-1 bg-white shadow-sm rounded-lg border border-gray-200 p-3 mb-2 hover:shadow-md transition-shadow">
                <div className="flex items-center justify-between mb-1">
                  <span className="text-sm font-medium text-gray-900 truncate max-w-[180px]" title={doc.document_title}>
                    {doc.document_title}
                  </span>
                  <StatusBadge status={doc.status} />
                </div>
                <div className="text-xs text-gray-500 font-mono mb-1.5">{doc.jsonld_type}</div>
                {layerLabel && (
                  <div className="flex items-center gap-1.5">
                    <span className={`inline-block w-1.5 h-1.5 rounded-full ${isRequest ? 'bg-indigo-400' : 'bg-violet-400'}`} />
                    <span className="text-xs text-gray-600">
                      {isRequest ? 'Req' : 'Res'} &rarr; {layerLabel}
                    </span>
                  </div>
                )}
                <div className="text-xs text-gray-400 mt-1">{timeAgo(doc.created_at)}</div>
              </div>
            </div>
          </div>
        )
      })}
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

export default function DashboardShow({ puml, flow_documents, request_layers, response_layers, recent_ingestions }) {
  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
        <p className="mt-1 text-sm text-gray-500">Request flow overview — User to Provider and back</p>
      </div>

      {/* Two-column layout: Document flow (left) + Flow layers (right) */}
      <div className="grid grid-cols-1 lg:grid-cols-[280px_1fr] gap-6">

        {/* Left column: Incoming JSON-LD documents flowing top-to-bottom */}
        <div>
          <h2 className="text-lg font-medium text-gray-900 mb-1">Incoming Documents</h2>
          <p className="text-sm text-gray-500 mb-4">JSON-LD ingestion flow</p>
          <FlowDocumentColumn flowDocuments={flow_documents || []} />
        </div>

        {/* Right column: Existing flow content */}
        <div className="space-y-8">

          {/* A. PlantUML Sequence Diagram */}
          <div className="bg-white shadow rounded-lg overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-200">
              <h2 className="text-lg font-medium text-gray-900">Request Flow Diagram</h2>
              <p className="text-sm text-gray-500 mt-0.5">Each step represents a potential point of delay, cost, or error</p>
            </div>
            <div className="p-6">
              <PlantUmlDiagram pumlContent={puml} />
            </div>
          </div>

          {/* B. Request Flow Layer Cards */}
          <div>
            <h2 className="text-lg font-medium text-gray-900 mb-1">Request Flow</h2>
            <p className="text-sm text-gray-500 mb-4">User &rarr; Device &rarr; Service &rarr; Middleware &rarr; Provider</p>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
              {Object.keys(REQUEST_LAYER_CONFIG).map(key => (
                <LayerCard key={key} layerKey={key} data={request_layers[key]} config={REQUEST_LAYER_CONFIG} />
              ))}
            </div>
          </div>

          {/* C. Response Flow Layer Cards */}
          <div>
            <h2 className="text-lg font-medium text-gray-900 mb-1">Response Flow</h2>
            <p className="text-sm text-gray-500 mb-4">Provider &rarr; Middleware &rarr; Service &rarr; Device &rarr; User</p>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
              {Object.keys(RESPONSE_LAYER_CONFIG).map(key => (
                <LayerCard key={`resp-${key}`} layerKey={key} data={response_layers[key]} config={RESPONSE_LAYER_CONFIG} />
              ))}
            </div>
          </div>

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
      </div>
    </div>
  )
}
