require 'optparse'

module Dgidb
  module RDF
    module CLI
      class Convert

        DEFAULT_OPTIONS = {
          output_dir: ENV['DATA_DIR'] || ENV['PWD'],
          help:   false
        }.freeze

        def initialize
          @options = DEFAULT_OPTIONS.dup
        end

        def run
          option_parser.parse!

          if @options[:help]
            STDERR.puts option_parser.help
            exit 0
          end

          validate_options

          Models::Base.seed_if_needed

          Turtle::Generator.new(@options[:output_dir]).all
        rescue OptionParser::InvalidOption => e
          STDERR.puts e.message
          STDERR.puts
          STDERR.puts option_parser.help
          exit 1
        rescue OptionParser::InvalidArgument => e
          STDERR.puts e.message
          exit 2
        rescue StandardError => e
          STDERR.puts e.message
          STDERR.puts e.backtrace
          exit 99
        end

        private

        def option_parser
          OptionParser.new do |op|
            op.banner = "Usage: #{CLI::PROG_NAME} #{self.class.name.underscore}\n"
            op.banner = "Convert DGIdb data to RDF\n"

            op.separator("\nOptions:")
            op.on('-o', '--output DIRECTORY', 'the directory where converted data will be stored') do |v|
              @options[:output_dir] = v
            end
            op.on('-h', '--help', 'show help') do
              @options[:help] = true
            end
            op.separator('')
          end
        end

        def validate_options
          output_dir = @options[:output_dir]

          raise("Directory not found: #{output_dir}") unless File.exist?(output_dir)
          raise("#{output_dir} is not a directory.") unless File.directory?(output_dir)
          raise("#{output_dir} is not writable.") unless File.writable?(output_dir)
        end
      end
    end
  end
end
