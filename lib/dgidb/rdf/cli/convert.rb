require 'optparse'
require 'ruby-progressbar'

module Dgidb
  module RDF
    module CLI
      class Convert

        DEFAULT_OPTIONS = {
          input:  nil,
          output: nil,
          format: :turtle,
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

          fmt, ext = case (f = @options[:format])
                     when /turtle/i
                       [:turtle, 'ttl']
                     else
                       raise("Unsupported format: #{f}")
                     end

          output = @options[:output]

          model_convert(Models::Drug, fmt, File.join(output, "drug.#{ext}"))
          model_convert(Models::Gene, fmt, File.join(output, "gene.#{ext}"))
          model_convert(Models::Interaction, fmt, File.join(output, "interaction.#{ext}"))

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
            op.banner = "Usage: #{Dgidb::RDF::CLI::PROG_NAME} #{self.class.name.underscore}\n"
            op.banner = "Convert DGIdb data to RDF\n"

            op.separator("\nOptions:")
            op.on('-i', '--input DIRECTORY', 'the directory where input data were stored') do |v|
              @options[:input] = v
            end
            op.on('-o', '--output DIRECTORY', 'the directory where converted data will be stored') do |v|
              @options[:output] = v
            end
            op.on('-f', '--format FORMAT', 'the type of RDF serialization') do |v|
              @options[:format] = v
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

        def model_convert(model, format, path)
          progress_bar = if STDOUT.tty?
                           ProgressBar.create(format: '|%B| %J%% %a (%E)',
                                              total:  model.count)
                         end

          RDF::Writer.open(path, 'w', prefixes: model::PREFIX_KEYS, format: format) do |file|
            model.limit(10).find_each do |drug|
              file << drug
              progress_bar.increment if progress_bar
            end
          end

          progress_bar.finish
        end
      end
    end
  end
end
