module Dgidb
  module RDF
    module Models
      class ChemblMolecule < Base
        has_one :drug
        has_many :chembl_molecule_synonyms
      end
    end
  end
end
