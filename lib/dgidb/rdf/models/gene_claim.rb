module Dgidb
  module RDF
    module Models
      class GeneClaim < Base
        belongs_to :gene
        has_and_belongs_to_many :gene_claim_categories,
                                join_table: 'gene_claim_categories_gene_claims'
        has_many :gene_claim_aliases,
                 inverse_of: :gene_claim,
                 dependent:  :delete_all
        has_many :gene_claim_attributes,
                 inverse_of: :gene_claim,
                 dependent:  :delete_all
        belongs_to :source,
                   inverse_of:    :gene_claims,
                   counter_cache: true
        has_many :interaction_claims,
                 inverse_of: :gene_claim
        has_many :drug_claims,
                 through: :interaction_claims
      end
    end
  end
end
