module Dgidb
  module RDF
    module Models
      class Publication < Base
        has_and_belongs_to_many :interactions
        has_and_belongs_to_many :interaction_claims
      end
    end
  end
end
