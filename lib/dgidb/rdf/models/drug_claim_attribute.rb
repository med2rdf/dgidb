module Dgidb
  module RDF
    module Models
      class DrugClaimAttribute < Base
        belongs_to :drug_claim,
                   inverse_of: :drug_claim_attributes
      end
    end
  end
end
