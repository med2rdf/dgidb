module Dgidb
  module RDF
    module Models
      class Drug < Base
        has_many :drug_claims,
                 before_add:    :update_anti_neoplastic_add,
                 before_remove: :update_anti_neoplastic_remove
        has_many :interactions
        has_many :drug_aliases
        has_many :drug_attributes
        belongs_to :chembl_molecule

        PREFIX_KEYS = %i[rdf rdfs dcterms xsd dgio dgidb_drug chembl_molecule].freeze

        def as_rdf
          triples = []

          subject = ::RDF::URI.new(Constant::PREFIXES[:dgidb_drug] + self[:id])
          triples << [subject, ::RDF.type, DGIO.Drug]
          triples << [subject, ::RDF::Vocab::DC.identifier, self[:id]]
          triples << [subject, ::RDF::Vocab::RDFS.label, self[:name]]
          if (v = self[:chembl_id])
            triples << [subject, ::RDF::Vocab::RDFS.seeAlso, ::RDF::URI.new(Constant::PREFIXES[:chembl_molecule] + v)]
          end

          triples
        end
      end
    end
  end
end
