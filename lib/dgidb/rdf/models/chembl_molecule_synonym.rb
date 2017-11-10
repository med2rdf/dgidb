module Dgidb
  module RDF
    module Models
      class ChemblMoleculeSynonym < Base
        belongs_to :chembl_molecule
      end
    end
  end
end
