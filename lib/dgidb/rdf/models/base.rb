require 'active_record'
require 'rdf'
require 'rdf/vocab'

module Dgidb
  module RDF
    module Models
      class Base < ActiveRecord::Base #:nodoc:
        DB_YAML = File.join(Dgidb::RDF::ROOT_DIR, 'conf', 'database.yaml').freeze

        class << self
          attr_accessor :conf
        end

        self.abstract_class = true

        DB_CONF   = if ENV['ENV'] =~ /test/i
                      'test'
                    else
                      'defaults'
                    end
        self.conf = YAML.load_file(DB_YAML)[DB_CONF]

        establish_connection(conf)

        def self.seed_if_needed
          models = [Dgidb::RDF::Models::Drug,
                    Dgidb::RDF::Models::Gene,
                    Dgidb::RDF::Models::Interaction]

          return unless models.map(&:count).map(&:zero?).all?

          load File.join(Dgidb::RDF::ROOT_DIR, 'db', 'seed.rb')
          Seed.execute
        end
      end
    end
  end
end
