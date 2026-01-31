# Create default admin user
admin = User.find_or_initialize_by(email_address: "admin@example.com")
admin.update!(
  name: "Admin",
  password: "password123",
  password_confirmation: "password123",
  admin: true
)
puts "Admin user created: admin@example.com / password123"

# --- Request Flow seed data ---

# Users
[
  { name: "Developer", user_type: "individual" },
  { name: "QA Tester", user_type: "individual" },
  { name: "DevOps Team", user_type: "group" },
  { name: "Product Team", user_type: "group" }
].each do |attrs|
  RequestUser.find_or_create_by!(name: attrs[:name]) do |r|
    r.user_type = attrs[:user_type]
  end
end
puts "Seeded #{RequestUser.count} request users"

# Devices
[
  { name: "MacBook Pro", device_type: "laptop" },
  { name: "iPhone 15", device_type: "phone" },
  { name: "CI Server", device_type: "server" },
  { name: "iPad Pro", device_type: "phone" }
].each do |attrs|
  RequestDevice.find_or_create_by!(name: attrs[:name]) do |r|
    r.device_type = attrs[:device_type]
  end
end
puts "Seeded #{RequestDevice.count} request devices"

# Services
[
  { name: "Claude LLM", service_type: "llm" },
  { name: "Filesystem MCP", service_type: "mcp" },
  { name: "Code Review Skill", service_type: "skill" },
  { name: "GPT-4 LLM", service_type: "llm" }
].each do |attrs|
  RequestService.find_or_create_by!(name: attrs[:name]) do |r|
    r.service_type = attrs[:service_type]
  end
end
puts "Seeded #{RequestService.count} request services"

# Middlewares
[
  { name: "API Key Auth", middleware_type: "authentication", position: 1 },
  { name: "Schema Validator", middleware_type: "validation", position: 2 },
  { name: "Context Enrichment", middleware_type: "enrichment", position: 3 },
  { name: "Rate Limiter", middleware_type: "validation", position: 4 }
].each do |attrs|
  RequestMiddleware.find_or_create_by!(name: attrs[:name]) do |r|
    r.middleware_type = attrs[:middleware_type]
    r.position = attrs[:position]
  end
end
puts "Seeded #{RequestMiddleware.count} request middlewares"

# Providers
[
  { name: "Chrome Browser", provider_type: "browser" },
  { name: "Dev Workstation", provider_type: "workstation" },
  { name: "Anthropic API", provider_type: "api" },
  { name: "OpenAI API", provider_type: "api" }
].each do |attrs|
  RequestProvider.find_or_create_by!(name: attrs[:name]) do |r|
    r.provider_type = attrs[:provider_type]
  end
end
puts "Seeded #{RequestProvider.count} request providers"

# --- Response Flow seed data ---

# Response Providers (first in reverse flow)
[
  { name: "Anthropic Response", provider_type: "api" },
  { name: "OpenAI Response", provider_type: "api" },
  { name: "Browser Render", provider_type: "browser" },
  { name: "Workstation Output", provider_type: "workstation" }
].each do |attrs|
  ResponseProvider.find_or_create_by!(name: attrs[:name]) do |r|
    r.provider_type = attrs[:provider_type]
  end
end
puts "Seeded #{ResponseProvider.count} response providers"

# Response Middlewares
[
  { name: "Response Validator", middleware_type: "validation", position: 1 },
  { name: "Token Counter", middleware_type: "enrichment", position: 2 },
  { name: "Auth Verification", middleware_type: "authentication", position: 3 },
  { name: "Output Sanitizer", middleware_type: "validation", position: 4 }
].each do |attrs|
  ResponseMiddleware.find_or_create_by!(name: attrs[:name]) do |r|
    r.middleware_type = attrs[:middleware_type]
    r.position = attrs[:position]
  end
end
puts "Seeded #{ResponseMiddleware.count} response middlewares"

# Response Services
[
  { name: "LLM Response Parser", service_type: "llm" },
  { name: "MCP Result Handler", service_type: "mcp" },
  { name: "Skill Output Mapper", service_type: "skill" }
].each do |attrs|
  ResponseService.find_or_create_by!(name: attrs[:name]) do |r|
    r.service_type = attrs[:service_type]
  end
end
puts "Seeded #{ResponseService.count} response services"

# Response Devices
[
  { name: "Laptop Display", device_type: "laptop" },
  { name: "Phone Notification", device_type: "phone" },
  { name: "Server Log", device_type: "server" }
].each do |attrs|
  ResponseDevice.find_or_create_by!(name: attrs[:name]) do |r|
    r.device_type = attrs[:device_type]
  end
end
puts "Seeded #{ResponseDevice.count} response devices"

# Response Users
[
  { name: "Developer Inbox", user_type: "individual" },
  { name: "Team Dashboard", user_type: "group" },
  { name: "Alert Channel", user_type: "group" }
].each do |attrs|
  ResponseUser.find_or_create_by!(name: attrs[:name]) do |r|
    r.user_type = attrs[:user_type]
  end
end
puts "Seeded #{ResponseUser.count} response users"

# --- JSON-LD Flow Documents ---
# Each document arrives, gets ingested, and is matched 1:1 to a flow model record.

# 7 matched — 5 request flow + 2 response flow
JSONLD_MATCHED = [
  {
    uuid7: "fld0001",
    title: "Developer User Trace",
    jsonld_type: "schema:RequestUser",
    payload: {
      "@context" => "https://magentic-bazaar.example/schema",
      "@type"    => "schema:RequestUser",
      "name"     => "Developer",
      "user_type"=> "individual",
      "description" => "Primary developer initiating LLM requests"
    },
    model: -> { RequestUser.find_by!(name: "Developer") }
  },
  {
    uuid7: "fld0002",
    title: "MacBook Pro Device Trace",
    jsonld_type: "schema:RequestDevice",
    payload: {
      "@context" => "https://magentic-bazaar.example/schema",
      "@type"    => "schema:RequestDevice",
      "name"     => "MacBook Pro",
      "device_type" => "laptop",
      "description" => "Development laptop routing requests to services"
    },
    model: -> { RequestDevice.find_by!(name: "MacBook Pro") }
  },
  {
    uuid7: "fld0003",
    title: "Claude LLM Service Trace",
    jsonld_type: "schema:RequestService",
    payload: {
      "@context" => "https://magentic-bazaar.example/schema",
      "@type"    => "schema:RequestService",
      "name"     => "Claude LLM",
      "service_type" => "llm",
      "description" => "Anthropic Claude large language model service"
    },
    model: -> { RequestService.find_by!(name: "Claude LLM") }
  },
  {
    uuid7: "fld0004",
    title: "API Key Auth Middleware Trace",
    jsonld_type: "schema:RequestMiddleware",
    payload: {
      "@context" => "https://magentic-bazaar.example/schema",
      "@type"    => "schema:RequestMiddleware",
      "name"     => "API Key Auth",
      "middleware_type" => "authentication",
      "description" => "Validates API key before forwarding to provider"
    },
    model: -> { RequestMiddleware.find_by!(name: "API Key Auth") }
  },
  {
    uuid7: "fld0005",
    title: "Anthropic API Provider Trace",
    jsonld_type: "schema:RequestProvider",
    payload: {
      "@context" => "https://magentic-bazaar.example/schema",
      "@type"    => "schema:RequestProvider",
      "name"     => "Anthropic API",
      "provider_type" => "api",
      "description" => "Anthropic API endpoint fulfilling the LLM request"
    },
    model: -> { RequestProvider.find_by!(name: "Anthropic API") }
  },
  {
    uuid7: "fld0006",
    title: "Anthropic Response Provider Trace",
    jsonld_type: "schema:ResponseProvider",
    payload: {
      "@context" => "https://magentic-bazaar.example/schema",
      "@type"    => "schema:ResponseProvider",
      "name"     => "Anthropic Response",
      "provider_type" => "api",
      "description" => "Response payload from Anthropic API"
    },
    model: -> { ResponseProvider.find_by!(name: "Anthropic Response") }
  },
  {
    uuid7: "fld0007",
    title: "Response Validator Middleware Trace",
    jsonld_type: "schema:ResponseMiddleware",
    payload: {
      "@context" => "https://magentic-bazaar.example/schema",
      "@type"    => "schema:ResponseMiddleware",
      "name"     => "Response Validator",
      "middleware_type" => "validation",
      "description" => "Validates response schema and content safety"
    },
    model: -> { ResponseMiddleware.find_by!(name: "Response Validator") }
  }
].freeze

# 3 pending — arrived but not yet matched (unknown types, missing models, awaiting processing)
JSONLD_PENDING = [
  {
    uuid7: "fld0008",
    title: "Billing Metric Trace",
    jsonld_type: "schema:BillingMetric",
    payload: {
      "@context" => "https://magentic-bazaar.example/schema",
      "@type"    => "schema:BillingMetric",
      "name"     => "Token Usage Report",
      "metric_type" => "cost",
      "description" => "Cost tracking document awaiting model assignment"
    }
  },
  {
    uuid7: "fld0009",
    title: "Guardrail Policy Trace",
    jsonld_type: "schema:GuardrailPolicy",
    payload: {
      "@context" => "https://magentic-bazaar.example/schema",
      "@type"    => "schema:GuardrailPolicy",
      "name"     => "Content Safety Filter",
      "policy_type" => "safety",
      "description" => "Safety policy document pending middleware match"
    }
  },
  {
    uuid7: "fld0010",
    title: "Telemetry Snapshot Trace",
    jsonld_type: "schema:TelemetrySnapshot",
    payload: {
      "@context" => "https://magentic-bazaar.example/schema",
      "@type"    => "schema:TelemetrySnapshot",
      "name"     => "Latency Percentiles",
      "snapshot_type" => "latency",
      "description" => "OTEL telemetry export with no target model"
    }
  }
].freeze

# Seed matched documents
JSONLD_MATCHED.each_with_index do |seed, idx|
  doc = MagenticBazaar::Document.find_or_initialize_by(uuid7: seed[:uuid7])
  doc.update!(
    title: seed[:title],
    original_filename: "#{seed[:title].parameterize}__#{seed[:uuid7]}.jsonld",
    file_type: "JSON-LD",
    content_hash: Digest::SHA256.hexdigest(seed[:payload].to_json),
    raw_content: JSON.pretty_generate(seed[:payload]),
    word_count: seed[:payload].to_json.split(/\s+/).length,
    status: "ingested"
  )

  fd = FlowDocument.find_or_initialize_by(document: doc)
  traceable = seed[:model].call
  fd.update!(
    jsonld_type: seed[:jsonld_type],
    jsonld_payload: JSON.pretty_generate(seed[:payload]),
    traceable: traceable,
    status: "matched",
    matched_at: Time.current - (10 - idx).minutes
  )
end

# Seed pending (unmatched) documents
JSONLD_PENDING.each_with_index do |seed, idx|
  doc = MagenticBazaar::Document.find_or_initialize_by(uuid7: seed[:uuid7])
  doc.update!(
    title: seed[:title],
    original_filename: "#{seed[:title].parameterize}__#{seed[:uuid7]}.jsonld",
    file_type: "JSON-LD",
    content_hash: Digest::SHA256.hexdigest(seed[:payload].to_json),
    raw_content: JSON.pretty_generate(seed[:payload]),
    word_count: seed[:payload].to_json.split(/\s+/).length,
    status: "ingested"
  )

  fd = FlowDocument.find_or_initialize_by(document: doc)
  fd.update!(
    jsonld_type: seed[:jsonld_type],
    jsonld_payload: JSON.pretty_generate(seed[:payload]),
    traceable: nil,
    status: "pending",
    matched_at: nil
  )
end

puts "Seeded #{FlowDocument.matched.count} matched + #{FlowDocument.pending.count} pending flow documents"
