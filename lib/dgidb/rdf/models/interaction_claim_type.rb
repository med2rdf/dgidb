module Dgidb
  module RDF
    module Models
      class InteractionClaimType < Base
        has_and_belongs_to_many :interaction_claims,
                                join_table: 'interaction_claim_types_interaction_claims'
      end
    end
  end
end
