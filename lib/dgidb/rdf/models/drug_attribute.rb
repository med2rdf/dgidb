module Dgidb
  module RDF
    module Models
      class DrugAttribute < Base
        belongs_to :drug
        has_and_belongs_to_many :sources
      end
    end
  end
end
