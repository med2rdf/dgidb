module Dgidb
  module RDF
    module Models
      class InteractionAttribute < Base
        belongs_to :interaction
        has_and_belongs_to_many :sources
      end
    end
  end
end
