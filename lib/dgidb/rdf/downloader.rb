require 'net/ftp'
require 'open-uri'
require 'ruby-progressbar'

module Dgidb
  module RDF
    class Downloader

      def initialize(uri, dest_dir)
        raise(ArgumentError, "#{uri.class} is not a URI.") unless uri.is_a?(URI)
        raise("No such file or directory: #{dest_dir}") unless File.exist?(dest_dir)
        raise("#{dest_dir} is not a directory.") unless File.directory?(dest_dir)

        @uri      = uri
        @dest_dir = dest_dir
      end

      def download
        file = case @uri.scheme
               when /https?/
                 download_http(@uri, @dest_dir)
               when /ftp/
                 download_ftp(@uri, @dest_dir)
               else
                 raise("Unknown scheme: #{@uri.scheme}")
               end

        yield file if block_given?
      end

      private

      def progress_bar
        @progress_bar ||= begin
          pgbar        = ProgressBar.create(format: '|%B| %J%% %a (%E)')
          pgbar.output = File.open('/dev/null', 'w') unless STDOUT.tty?
          pgbar
        end
      end

      def download_http(uri, dir)
        f = lambda do |content_length|
          progress_bar.total = content_length if content_length
        end
        g = lambda do |transferred_bytes|
          progress_bar.progress = transferred_bytes
        end

        file_name = uri.path.split('/').last
        open(uri, content_length_proc: f, progress_proc: g) do |data|
          open(File.join(dir, file_name), 'w') do |file|
            file.write(data.read)
          end
        end
      end

      def download_ftp(uri, dir)
        file_name = uri.path.split('/').last

        Net::FTP.open(uri.host) do |ftp|
          ftp.login('anonymous', nil, nil)
          progress_bar.total = ftp.size(uri.path)

          ftp.get(uri.path, File.join(dir, file_name), 1024) do |data|
            progress_bar.progress += data.size
          end
        end
      end
    end
  end
end
