require 'linkeddata'

module Dgidb
  module RDF
    class DGIO < ::RDF::StrictVocabulary('http://purl.jp/bio/10/dgidb/')
      property :drug,
               label: 'drug'.freeze
      property :gene,
               label: 'gene'.freeze
      property :interactionType,
               label: 'interaction type'.freeze

      term :Drug,
           label: 'Drug'.freeze
      term :Gene,
           label: 'Gene'.freeze
      term :Interaction,
           label: 'Interaction'.freeze
    end
  end
end
