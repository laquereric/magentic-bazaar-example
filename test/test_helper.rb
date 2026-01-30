ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require_relative "test_helpers/session_test_helper"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all

    set_fixture_class magentic_bazaar_ingestions: MagenticBazaar::Ingestion,
                      magentic_bazaar_documents: MagenticBazaar::Document,
                      magentic_bazaar_skills: MagenticBazaar::Skill,
                      magentic_bazaar_uml_diagrams: MagenticBazaar::UmlDiagram
  end
end
