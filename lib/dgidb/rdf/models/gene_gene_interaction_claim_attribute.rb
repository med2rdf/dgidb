module Dgidb
  module RDF
    module Models
      class GeneGeneInteractionClaimAttribute < Base
        belongs_to :gene_gene_interaction_claim,
                   inverse_of: :attributes
      end
    end
  end
end
