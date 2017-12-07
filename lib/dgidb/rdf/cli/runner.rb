require 'active_support/core_ext/string/strip'
require 'active_support/inflector'

module Dgidb
  module RDF
    module CLI

      PROG_NAME = 'dgidb'.freeze

      class Runner
        def run
          command = ARGV.shift || '--help'

          case command
          when '-v', '--version'
            STDERR.puts Dgidb::RDF::VERSION
          when '-h', '--help'
            STDERR.puts help
          when *commands
            target = Dgidb::RDF::CLI.const_get(command.capitalize).new
            target.run if target.respond_to?(:run)
          else
            STDERR.puts "Unknown command: '#{command}'"
            STDERR.puts
            STDERR.puts help
            exit 1
          end

          exit 0
        end

        private

        def commands
          klasses = Dgidb::RDF::CLI.constants.reject do |c|
            c == :Runner
          end
          klasses.map { |k| k.to_s.underscore }
        end

        def help
          <<-USAGE.strip_heredoc % commands.map { |c| "    #{c}" }.join("\n")
            Usage: #{PROG_NAME} [command] [options] [arguments]

            RDF Converter for DGIdb

            Commands:
            %s

            Options:
                -h, --help                       show help
                -v, --version                    print version

            Run '#{PROG_NAME} COMMAND --help' for more information on a command

          USAGE
        end
      end
    end
  end
end
