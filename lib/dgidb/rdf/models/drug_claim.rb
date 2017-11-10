module Dgidb
  module RDF
    module Models
      class DrugClaim < Base
        belongs_to :drug
        has_many :drug_claim_aliases,
                 inverse_of: :drug_claim,
                 dependent:  :delete_all
        has_many :interaction_claims,
                 inverse_of: :drug_claim
        has_many :gene_claims,
                 through: :interaction_claims
        belongs_to :source,
                   inverse_of:    :drug_claims,
                   counter_cache: true
        has_many :drug_claim_attributes,
                 inverse_of: :drug_claim,
                 dependent:  :delete_all
        has_and_belongs_to_many :drug_claim_types,
                                join_table: 'drug_claim_types_drug_claims'
      end
    end
  end
end
