module Dgidb
  module RDF
    module Models
      class InteractionClaim < Base
        has_many :interaction_claim_attributes,
                 inverse_of: :interaction_claim
        belongs_to :gene_claim,
                   inverse_of: :interaction_claims
        belongs_to :drug_claim,
                   inverse_of: :interaction_claims
        belongs_to :source,
                   inverse_of: :interaction_claims, counter_cache: true
        has_and_belongs_to_many :interaction_claim_types,
                                join_table: 'interaction_claim_types_interaction_claims'
        belongs_to :interaction
        has_and_belongs_to_many :publications
      end
    end
  end
end
