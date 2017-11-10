lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dgidb/rdf/version'

Gem::Specification.new do |spec|
  spec.name    = 'dgidb-rdf'
  spec.version = Dgidb::RDF::VERSION
  spec.authors = ['Daisuke Satoh']
  spec.email   = ['daisuke.satoh@level-five.jp']

  spec.description = 'RDF Converter for DGIdb'
  spec.summary     = spec.description
  spec.homepage    = "TODO: Put your gem's website or public repo URL here."
  spec.license     = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'awesome_print', '~> 1.8'
  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'activerecord', '~> 5.1'
  spec.add_dependency 'linkeddata', '~> 2.2', '>= 2.2.3'
  spec.add_dependency 'pg', '~> 0.21.0'
end
