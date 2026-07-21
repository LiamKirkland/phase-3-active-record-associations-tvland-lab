ENV['RACK_ENV'] = 'test'
require_relative "../config/environment"
require "sinatra/activerecord/rake"

RSpec.configure do |config|
  # Database setup

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.order = :defined

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

def migrate!(direction, version)
  migrations_paths = ActiveRecord::Migrator.migrations_paths
  context = ActiveRecord::MigrationContext.new(migrations_paths)

  ActiveRecord::Migration.suppress_messages do
    if direction == :down
      if version == 0
        # Target 0 means roll back ALL migrations completely
        context.migrate(0)
      else
        # Roll back to the specific version state
        context.migrate(version)
      end
    elsif direction == :up
      # migrate(version) runs all migrations up to and including this version number
      context.migrate(version)
    end
  end
end


