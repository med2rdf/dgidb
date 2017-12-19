require 'rdf'

module Dgidb
  module RDF
    class DGIO < ::RDF::StrictVocabulary('http://purl.jp/bio/10/dgidb/')

      # Ontology definition
      ontology 'http://purl.jp/bio/10/dgidb/'.freeze,
               type:               ::RDF::OWL.Ontology,
               :'dc11:title'       => 'DGIdb Ontology',
               :'dc11:description' => 'DGIdb Ontology describes classes and properties which is used in DGIdb-RDF',
               :'owl:imports'      => %w[http://purl.org/dc/terms/
                                         http://semanticscience.org/ontology/sio.owl
                                         http://www.w3.org/2004/02/skos/core
                                         http://xmlns.com/foaf/0.1/].freeze

      # Class definitions
      term :DGIdb,
           type:  ::RDF::OWL.Class,
           label: 'DGIdb Base Class'.freeze

      term :Drug,
           type:       ::RDF::OWL.Class,
           subClassOf: DGIO.DGIdb,
           label:      'DGIdb Drug'.freeze

      term :Gene,
           type:       ::RDF::OWL.Class,
           subClassOf: DGIO.DGIdb,
           label:      'DGIdb Gene'.freeze

      term :Interaction,
           type:       ::RDF::OWL.Class,
           subClassOf: DGIO.DGIdb,
           label:      'DGIdb Interaction'.freeze

      # Property definitions
      property :drug,
               type:   ::RDF::OWL.ObjectProperty,
               label:  'drug'.freeze,
               domain: DGIO.Interaction,
               range:  DGIO.Drug

      property :gene,
               type:   ::RDF::OWL.ObjectProperty,
               label: 'gene'.freeze,
               domain: DGIO.Interaction,
               range:  DGIO.Gene

      property :interactionType,
               type:   ::RDF::OWL.DatatypeProperty,
               label: 'interaction type'.freeze,
               domain: DGIO.Interaction,
               range:  ::RDF::XSD.string

    end
  end
end
