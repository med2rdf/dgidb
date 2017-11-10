module Dgidb
  module RDF
    module Models
      class GeneClaimCategory < Base
        has_and_belongs_to_many :gene_claims,
                                join_table: :gene_claim_categories_gene_claims
        has_and_belongs_to_many :genes,
                                join_table: 'gene_categories_genes',
                                class_name: 'Gene'
      end
    end
  end
end
