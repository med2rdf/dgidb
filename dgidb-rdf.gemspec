lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dgidb/rdf/version'

Gem::Specification.new do |spec|
  spec.name    = 'dgidb-rdf'
  spec.version = Dgidb::RDF::VERSION
  spec.authors = ['Daisuke Satoh']
  spec.email   = ['med2rdf@googlegroups.com']

  spec.description = 'RDF Converter for DGIdb'
  spec.summary     = spec.description
  spec.homepage    = 'http://med2rdf.org'
  spec.license     = 'MIT'

  spec.files  = Dir['conf/*'] + Dir['db/*'] + Dir['exe/*']
  spec.files += Dir['lib/**/*.rb'] + Dir['lib/**/*.rake']
  spec.files += Dir['[A-Z]*']
  spec.files.reject! { |fn| fn.include? "CVS" }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'awesome_print', '~> 1.8'
  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'activerecord', '~> 5.1'
  spec.add_dependency 'pg', '~> 0.21.0'
  spec.add_dependency 'rdf-turtle', '~> 2.2', '>= 2.2.2'
  spec.add_dependency 'rdf-vocab', '~> 2.2', '>= 2.2.9'
  spec.add_dependency 'ruby-progressbar', '~> 1.9'
end
