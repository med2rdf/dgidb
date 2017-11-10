module Dgidb
  module RDF
    module Models
      class Interaction < Base
        has_many :interaction_claims
        belongs_to :gene
        belongs_to :drug
        has_and_belongs_to_many :interaction_types,
                                join_table: 'interaction_types_interactions',
                                class_name: 'InteractionClaimType'
        has_many :interaction_attributes
        has_and_belongs_to_many :publications
        has_and_belongs_to_many :sources
      end
    end
  end
end
