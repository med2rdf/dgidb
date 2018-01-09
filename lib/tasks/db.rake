namespace :db do
  require 'active_record'
  require 'active_support/core_ext/hash/keys'
  require 'dgidb/rdf'
  require 'dgidb/utils/progress_bar_wrapper'
  require 'yaml'

  include ProgressBarWrapper

  task :environment do
    @yaml   = File.join(Dgidb::RDF::ROOT_DIR, 'conf', 'database.yaml')
    @config = YAML.load_file(@yaml)['defaults'].symbolize_keys

    @admin_config = { database:           'postgres',
                      schema_search_path: 'public' }.freeze

    ActiveRecord::Base.logger = Logger.new(File::NULL)
  end

  desc <<-DESC.strip_heredoc
    Drop the database
  DESC
  task drop: [:environment] do
    ActiveRecord::Base.establish_connection(@config.merge(@admin_config))
    ActiveRecord::Base.connection.drop_database(@config[:database])

    FileUtils.rm(File.join(Dgidb::RDF::ROOT_DIR, 'db', 'schema.rb'), force: true)
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
  task migrate: [:environment] do
    src_file = File.join(Dgidb::RDF::ROOT_DIR, 'db', 'structure.sql')

    ActiveRecord::Base.establish_connection(@config)
    sql = IO.read(src_file)
            .sub(/^(SET idle_in_transaction_session_timeout)/, '-- \1')
    ActiveRecord::Base.connection.execute(sql)

    Rake::Task['db:schema'].invoke
  end

  desc <<-DESC.strip_heredoc
    Seed data into the database
  DESC
  task seed: [:environment] do
    load File.join(Dgidb::RDF::ROOT_DIR, 'db', 'seed.rb')
    Seed.execute
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
