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

export default function DashboardShow({ puml, request_layers, response_layers, recent_ingestions }) {
  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
        <p className="mt-1 text-sm text-gray-500">Request flow overview — User to Provider and back</p>
      </div>

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
  )
}
