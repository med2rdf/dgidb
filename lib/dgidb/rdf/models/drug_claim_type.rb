module Dgidb
  module RDF
    module Models
      class DrugClaimType < Base
        has_and_belongs_to_many :drug_claims,
                                join_table: 'drug_claim_types_drug_claims'
      end
    end
  end
end
