module Dgidb
  module RDF
    module Models
      class InteractionClaimAttribute < Base
        belongs_to :interaction_claim,
                   inverse_of: :interaction_claim_attributes
      end
    end
  end
end
