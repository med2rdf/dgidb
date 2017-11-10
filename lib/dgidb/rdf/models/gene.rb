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
      end
    end
  end
end
