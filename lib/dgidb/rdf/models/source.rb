module Dgidb
  module RDF
    module Models
      class Source < Base
        has_many :gene_claims,
                 inverse_of: :source,
                 dependent: :delete_all
        has_many :drug_claims,
                 inverse_of: :source,
                 dependent: :delete_all
        has_many :interaction_claims,
                 inverse_of: :source,
                 dependent: :delete_all
        has_many :gene_gene_interaction_claims,
                 inverse_of: :source,
                 dependent: :delete_all
        has_and_belongs_to_many :drug_aliases
        has_and_belongs_to_many :drug_attributes
        has_and_belongs_to_many :gene_aliases
        has_and_belongs_to_many :gene_attributes
        has_and_belongs_to_many :interaction_attributes
        belongs_to :source_type,
                   inverse_of: :sources
        belongs_to :source_trust_level,
                   inverse_of: :sources
      end
    end
  end
end
