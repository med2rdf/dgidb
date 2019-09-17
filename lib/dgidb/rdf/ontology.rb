require 'rdf'
require 'rdf/vocab'

module Dgidb
  module RDF
    class M2R < ::RDF::StrictVocabulary('http://med2rdf.org/ontology/med2rdf#')

      # Ontology definition
      ontology to_uri.freeze,
               type:             ::RDF::OWL.Ontology,
               :'dc:title'       => 'DGIdb Ontology',
               :'dc:description' => 'DGIdb Ontology describes classes and properties which is used in DGIdb RDF',
               :'owl:imports'    => [::RDF::Vocab::DC.to_s,
                                     ::RDF::Vocab::SKOS.to_s].freeze

      # Class definitions
      term :DGIdb,
           type:  ::RDF::OWL.Class,
           label: 'DGIdb Base Class'.freeze

      term :Drug,
           type:       ::RDF::OWL.Class,
           label:      'Drug'.freeze

      term :Gene,
           type:       ::RDF::OWL.Class,
           label:      'Gene'.freeze

      term :Disease,
           type:       ::RDF::OWL.Class,
           label:      'Disease'.freeze
           
      term :Interaction,
           type:       ::RDF::OWL.Class,
           label:      'Interaction'.freeze

      term :Evidence,
           type:       ::RDF::OWL.Class,
           label:      'Evidence'.freeze

      # Property definitions
      property :drug,
               type:   ::RDF::OWL.ObjectProperty,
               label:  'drug'.freeze,
               domain: M2R.Interaction,
               range:  M2R.Drug

      property :gene,
               type:   ::RDF::OWL.ObjectProperty,
               label:  'gene'.freeze,
               domain: M2R.Interaction,
               range:  M2R.Gene

      property :interaction_type,
               type:   ::RDF::OWL.DatatypeProperty,
               label:  'interaction type'.freeze,
               domain: M2R.Interaction,
               range:  ::RDF::XSD.string

      property :interaction_mechanism,
               type:   ::RDF::OWL.DatatypeProperty,
               label:  'interaction mechanism'.freeze,
               domain: M2R.Interaction,
               range:  ::RDF::XSD.string

      property :evidence,
               type:   ::RDF::OWL.DatatypeProperty,
               label:  'evidence'.freeze,
               domain: M2R.Interaction,
               range:  M2R.Evidence

      property :disease,
               type:   ::RDF::OWL.DatatypeProperty,
               label:  'disease'.freeze,
               range:  M2R.Disease
               
      property :site_primary,
               type:   ::RDF::OWL.DatatypeProperty,
               label:  'primary site'.freeze,
               range:  ::RDF::XSD.string

      property :response_type,
               type:   ::RDF::OWL.DatatypeProperty,
               label:  'drug response type'.freeze,
               range:  ::RDF::XSD.string

      property :approval_status,
               type:   ::RDF::OWL.DatatypeProperty,
               label:  'theraphy approval status'.freeze,
               range:  ::RDF::XSD.string

      property :evidence_type,
               type:   ::RDF::OWL.DatatypeProperty,
               label:  'evidence_type'.freeze,
               domain: M2R.Evidence,
               range:  ::RDF::XSD.string

      property :drug_type,
               type:   ::RDF::OWL.DatatypeProperty,
               label:  'drug_type'.freeze,
               domain: M2R.Evidence,
               range:  ::RDF::XSD.string
    end
  end
end
