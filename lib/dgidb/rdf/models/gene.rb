module Dgidb
  module RDF
    module Models
      class Gene < Base
        has_many :gene_claims
        has_many :gene_gene_interaction_claims,
                 inverse_of: :gene
        has_many :interactions
        has_many :gene_aliases
        has_many :gene_attributes
        has_and_belongs_to_many :gene_categories,
                                join_table: 'gene_categories_genes',
                                class_name: 'GeneClaimCategory'

        PREFIX_KEYS = %i[rdf rdfs dcterms skos xsd dgio dgidb_gene ncbi_gene].freeze

        def triples
          triples = []

          subject = ::RDF::URI.new(Constant::PREFIXES[:dgidb_gene] + self[:id])
          triples << [subject, ::RDF.type, DGIO.Gene]
          triples << [subject, ::RDF::Vocab::DC.identifier, self[:id]]
          triples << [subject, ::RDF::Vocab::RDFS.label, self[:name]]
          triples << [subject, ::RDF::Vocab::SKOS.altLabel, self[:long_name]]
          if (v = self[:entrez_id])
            triples << [subject, ::RDF::Vocab::RDFS.seeAlso, ::RDF::URI.new(Constant::PREFIXES[:ncbi_gene] + v.to_s)]
          end

          triples
        end
      end
    end
  end
end
