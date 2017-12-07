require 'active_support/core_ext/hash'
require 'linkeddata'

module Dgidb
  module RDF
    class Writer
      extend Forwardable

      DEFAULT_OPTIONS = { prefixes: [],
                          format:   :turtle }.freeze

      ACCEPTABLE_FORMAT = %i[turtle].freeze

      class << self
        def open(*args)
          options = args.last.is_a?(Hash) ? args.pop : {}

          file_opts = { universal_newline: false }.merge(options)
          begin
            f = File.open(*args, file_opts)
          rescue StandardError
            raise if args.include?('w')
            args << 'w'
            retry
          end

          begin
            rdf = new(f, options)
          rescue StandardError
            f.close
            raise
          end

          if block_given?
            begin
              yield rdf
            ensure
              rdf.close
            end
          else
            rdf
          end
        end
      end

      def_delegators :@io, :binmode, :binmode?, :close, :close_read, :close_write,
                     :closed?, :eof, :eof?, :external_encoding, :fcntl,
                     :fileno, :flock, :flush, :fsync, :internal_encoding,
                     :ioctl, :isatty, :path, :pid, :pos, :pos=, :reopen,
                     :seek, :stat, :string, :sync, :sync=, :tell, :to_i,
                     :to_io, :truncate, :tty?

      def initialize(data, options = Hash.new)
        raise(ArgumentError, 'Cannot parse nil as CSV') if data.nil?

        @options = DEFAULT_OPTIONS.merge(options)

        @io = data.is_a?(String) ? StringIO.new(data) : data

        @lineno         = 0
        @header_written = false
      end

      def write(model)
        unless model.is_a?(Dgidb::RDF::Models::Base)
          raise(ArgumentError, "#{model.class} is not applicable.")
        end
        write_header
        write_body(model)
      end

      alias << write

      private

      def write_header
        return if @header_written
        @io.write(header)
        @header_written = true
      end

      def write_body(model)
        # remove prefixes
        @io.write(body(model).gsub(/^@.*$\n/, ''))
      end

      def prefixes
        @prefixes ||= Dgidb::RDF::Constant::PREFIXES.slice(*@options[:prefixes])
      end

      def writer
        return @writer if @writer
        format = @options[:format]
        raise("Unacceptable format for writer: #{format}") unless ACCEPTABLE_FORMAT.include?(format)
        @writer = ::RDF::Writer.for(format)
      end

      def header
        writer.buffer(prefixes: prefixes, stream: true) do |_|
          # do nothing
        end
      end

      def body(model)
        writer.buffer(prefixes: prefixes) do |writer|
          break unless model.respond_to?(:as_rdf)
          model.as_rdf.each do |triple|
            writer << triple
          end
        end
      end
    end
  end
end
