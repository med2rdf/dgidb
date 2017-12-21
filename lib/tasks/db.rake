namespace :db do
  require 'active_record'
  require 'active_support/core_ext/hash/keys'
  require 'dgidb/rdf/constant'
  require 'dgidb/utils/downloader'
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
    path = File.join(Dgidb::RDF::ROOT_DIR, 'db')

    src_file = File.join(path, 'structure.sql')
    unless File.exist?(src_file)
      url = URI(ENV['structure_sql_url'] || Dgidb::RDF::Constant::STRUCTURE_SQL_URL)
      Downloader.new(url, path).download
    end
    raise("#{src_file} is not readable.") unless File.readable?(src_file)

    ActiveRecord::Base.establish_connection(@config)
    # ActiveRecord::Migrator.migrate(path)
    sql = IO.read(src_file).sub(/^(SET idle_in_transaction_session_timeout)/, '-- \1')
    ActiveRecord::Base.connection.execute(sql)

    Rake::Task['db:schema'].invoke
  end

  desc <<-DESC.strip_heredoc
    Seed data into the database
  DESC
  task seed: [:environment] do
    # download data if needed
    src_dir = ENV['data_dir'] || File.join(Dgidb::RDF::ROOT_DIR, 'db')
    raise("Directory not found: #{src_dir}") unless File.exist?(src_dir)
    raise("#{src_dir} is not a directory.") unless File.directory?(src_dir)

    src_file = File.join(src_dir, ENV['data_sql'] || 'data.sql')
    unless File.exist?(src_file)
      url = URI(ENV['data_sql_url'] || Dgidb::RDF::Constant::DATA_SQL_URL)
      puts "Downloading #{url}"
      Downloader.new(url, src_dir).download
    end
    raise("#{src_file} is not readable.") unless File.readable?(src_file)

    # seed data
    puts 'Seeding data...'
    ActiveRecord::Base.establish_connection(@config)
    con = ActiveRecord::Base.connection.raw_connection
    progress_bar do |bar|
      bar.total = File.open(src_file) do |f|
        while f.gets
        end
        f.lineno
      end

      File.open(src_file) do |f|
        while (line = f.gets)
          begin
            next if line.empty?
            next if line =~ /^--/
            next if line =~ /^SET idle_in_transaction_session_timeout/

            if line =~ /^COPY /
              con.copy_data line do
                while (data = f.gets)
                  break if data =~ /\\\./
                  con.put_copy_data data
                  bar.increment
                end
              end
            end
          ensure
            bar.increment
          end
        end
      end
    end
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
