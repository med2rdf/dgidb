module Dgidb
  module RDF
    module Models
      class Drug < Base
        has_many :drug_claims,
                 before_add:    :update_anti_neoplastic_add,
                 before_remove: :update_anti_neoplastic_remove
        has_many :interactions
        has_many :drug_aliases
        has_many :drug_attributes
        belongs_to :chembl_molecule
      end
    end
  end
end
