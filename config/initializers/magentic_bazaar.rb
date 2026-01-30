# frozen_string_literal: true

MagenticBazaar.configure do |config|
  config.ingest_dir   = Rails.root.join("doc/ingest").to_s
  config.ingested_dir = Rails.root.join("doc/ingested").to_s
  config.uml_dir      = Rails.root.join("doc/uml").to_s
  config.skills_dir   = Rails.root.join("doc/skills").to_s
  config.human_dir    = Rails.root.join("doc/human").to_s

  config.async      = true
  config.queue_name = :magentic_bazaar

  config.multistore_enabled = false
end
