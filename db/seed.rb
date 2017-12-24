require 'active_record'
require 'dgidb/rdf/constant'
require 'dgidb/utils/downloader'
require 'dgidb/utils/progress_bar_wrapper'

class Seed

  include ProgressBarWrapper

  def self.execute
    s = new
    s.prepare
    s.seed
  end

  def initialize
    @src_dir = ENV['DATA_DIR'] || ENV['PWD']
    @src_file = File.join(@src_dir, 'data.sql')
    ActiveRecord::Base.logger = Logger.new(File::NULL)
  end

  def prepare
    # download data if needed
    raise("Not found: #{@src_dir}") unless File.exist?(@src_dir)
    raise("#{@src_dir} is not a directory.") unless File.directory?(@src_dir)

    if File.exist?(@src_file)
      puts "Skip download, use existing #{@src_file}"
    else
      url = URI(Dgidb::RDF::Constant::DATA_SQL_URL)
      puts "Downloading #{url}"
      Downloader.new(url, @src_dir).download
    end
    raise("#{@src_file} is not readable.") unless File.readable?(@src_file)
  end

  def seed
    puts 'Seeding data...'
    con = ActiveRecord::Base.connection.raw_connection
    progress_bar do |bar|
      bar.total = count_lines

      File.open(@src_file) do |f|
        while (line = f.gets)
          begin
            next unless line =~ /^COPY /
            con.copy_data(line) do
              while (data = f.gets)
                break if data =~ /\\\./
                con.put_copy_data data
                bar.increment
              end
            end
          ensure
            bar.increment
          end
        end
      end
    end
  end

  private

  def count_lines
    File.open(@src_file) do |f|
      while f.gets
      end
      f.lineno
    end
  end

end