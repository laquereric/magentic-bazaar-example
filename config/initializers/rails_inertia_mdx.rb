RailsInertiaMdx.configure do |config|
  config.mdx_root = "doc/human"
  config.cache_compiled = Rails.env.production?
  config.cache_dir = Rails.root.join("tmp/cache/mdx").to_s
end
