module Dgidb
  module RDF
    module Models
      class Interaction < Base
        has_many :interaction_claims
        belongs_to :gene
        belongs_to :drug
        has_and_belongs_to_many :interaction_types,
                                join_table: 'interaction_types_interactions',
                                class_name: 'InteractionClaimType'
        has_many :interaction_attributes
        has_and_belongs_to_many :publications
        has_and_belongs_to_many :sources

        PREFIX_KEYS = %i[rdf rdfs dcterms xsd dgio dgidb_interaction dgidb_drug dgidb_gene pubmed].freeze

        def type_names
          self.interaction_types.pluck(:type).uniq
        end

        def pmids
          self.publications.pluck(:pmid).uniq
        end

        def triples
          triples = []

          subject = ::RDF::URI.new(Constant::PREFIXES[:dgidb_interaction] + self[:id])
          drug_id = ::RDF::URI.new(Constant::PREFIXES[:dgidb_drug] + self[:drug_id])
          gene_id = ::RDF::URI.new(Constant::PREFIXES[:dgidb_gene] + self[:gene_id])

          triples << [subject, ::RDF.type, DGIO.Interaction]
          triples << [subject, ::RDF::Vocab::DC.identifier, self[:id]]

          triples << [subject, DGIO.drug, drug_id]
          triples << [subject, DGIO.gene, gene_id]

          type_names.each do |name|
            triples << [subject, DGIO.interactionType, name]
          end

          pmids.each do |pmid|
            triples << [subject, ::RDF::Vocab::RDFS.seeAlso, ::RDF::URI.new(Constant::PREFIXES[:pubmed] + pmid.to_s)]
          end

          triples
        end
      end
    end
  end
end
