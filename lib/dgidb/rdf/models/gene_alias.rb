module Dgidb
  module RDF
    module Models
      class GeneAlias < Base
        belongs_to :gene
        has_and_belongs_to_many :sources
      end
    end
  end
end
