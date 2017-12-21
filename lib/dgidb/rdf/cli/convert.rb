require 'optparse'

module Dgidb
  module RDF
    module CLI
      class Convert

        DEFAULT_OPTIONS = {
          input:  nil,
          output: nil,
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

          load File.join(ROOT_DIR, 'Rakefile')
          Rake::Task['turtle:generate:all'].invoke(@options[:output])
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
              @options[:output] = v
            end
            op.on('-h', '--help', 'show help') do
              @options[:help] = true
            end
            op.separator('')
          end
        end

        def validate_options
          @options[:output] ||= './'

          output = @options[:output]

          raise("Directory not found: #{output}") unless File.exist?(output)
          raise("#{output} is not a directory.") unless File.directory?(output)
          raise("#{output} is not writable.") unless File.writable?(output)
        end
      end
    end
  end
end
