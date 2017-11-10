module Dgidb
  module RDF
    module Models
      class DrugClaimAlias < Base
        belongs_to :drug_claim,
                   inverse_of: :drug_claim_aliases
      end
    end
  end
end
