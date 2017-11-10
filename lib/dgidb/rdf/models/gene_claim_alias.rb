module Dgidb
  module RDF
    module Models
      class GeneClaimAlias < Base
        belongs_to :gene_claim
      end
    end
  end
end
