class AddLastTestedAtToLlmEngineLlmProviders < ActiveRecord::Migration[8.1]
  def change
    add_column :llm_engine_llm_providers, :last_tested_at, :datetime
  end
end
