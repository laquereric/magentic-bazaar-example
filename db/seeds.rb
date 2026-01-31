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
