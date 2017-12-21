namespace :db do
  require 'active_record'
  require 'active_support/core_ext/hash/keys'
  require 'yaml'

  task :environment do
    @yaml   = File.join(Dgidb::RDF::ROOT_DIR, 'conf', 'database.yaml')
    @config = YAML.load_file(@yaml)['defaults'].symbolize_keys

    @admin_config = { database:           'postgres',
                      schema_search_path: 'public' }.freeze
  end

  desc <<-DESC.strip_heredoc
    Drop the database
  DESC
  task drop: [:environment] do
    ActiveRecord::Base.establish_connection(@config.merge(@admin_config))
    ActiveRecord::Base.connection.drop_database(@config[:database])
  end

  desc <<-DESC.strip_heredoc
    Create the database
  DESC
  task create: [:environment] do
    ActiveRecord::Base.establish_connection(@config.merge(@admin_config))
    ActiveRecord::Base.connection.create_database(@config[:database])
  end

  desc <<-DESC.strip_heredoc
    Migrate the database
  DESC
  task migrate: [:postprocess] do
    path = File.join(Dgidb::RDF::ROOT_DIR, 'db', 'migrate')

    ActiveRecord::Base.establish_connection(@config)
    ActiveRecord::Migrator.migrate(path)
    Rake::Task['db:schema'].invoke
  end

  desc <<-DESC.strip_heredoc
    Seed data into the database
  DESC
  task seed: [:environment] do
    raise('Not implemented yet.')
    # TODO: implement me!
  end

  desc <<-DESC.strip_heredoc
    Create a db/schema.rb file that is portable against any DB supported by AR'
  DESC
  task schema: [:environment] do
    require 'active_record/schema_dumper'

    schema = File.join(Dgidb::RDF::ROOT_DIR, 'db', 'schema.rb')

    ActiveRecord::Base.establish_connection(@config)
    File.open(schema, 'w:utf-8') do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
  end

  desc <<-DESC.strip_heredoc
    Reset the database
  DESC
  task reset: %i[environment drop create migrate]
end
