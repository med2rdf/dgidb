require 'active_support/core_ext/hash'
require 'rdf'
require 'rdf/turtle'

class TurtleStreamWriter
  extend Forwardable

  DEFAULT_OPTIONS = { prefixes: [],
                      base:     nil }.freeze

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
        writer = new(f, options)
      rescue StandardError
        f.close
        raise
      end

      if block_given?
        begin
          yield writer
        ensure
          writer.close
        end
      else
        writer
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
    raise(ArgumentError, 'Cannot parse nil') if data.nil?

    @options = DEFAULT_OPTIONS.merge(options)

    @io = data.is_a?(String) ? StringIO.new(data) : data

    @lineno         = 0
    @header_written = false
  end

  def write(model)
    unless model.respond_to?(:triples)
      raise(ArgumentError, "#{model.class} does not implement instance method #triples.")
    end
    write_header
    write_body(model)
  end

  alias << write

  private

  def prefixes
    @prefixes ||= begin
      raise('Prefixes should be a Hash.') unless @options[:prefixes].is_a?(Hash)
      @options[:prefixes]
    end
  end

  def base
    @base ||= @options[:base].to_s
  end

  def writer
    @writer ||= RDF::Writer.for(:turtle)
  end

  def header
    writer.buffer(base_uri: base, prefixes: prefixes, stream: true) do |_|
      # do nothing
    end
  end

  def body(model)
    writer.buffer(base_uri: base, prefixes: prefixes) do |writer|
      break unless model.respond_to?(:triples)
      model.triples.each { |triple| writer << triple }
    end
  end

  def write_header
    return if @header_written
    @io.write(header)
    @header_written = true
  end

  def write_body(model)
    # remove prefixes
    @io.write(body(model).gsub(/^@.*$\n/, ''))
  end

end
