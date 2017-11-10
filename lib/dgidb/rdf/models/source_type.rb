module Dgidb
  module RDF
    module Models
      class SourceType < Base
        has_many :sources,
                 inverse_of: :source_type
      end
    end
  end
end
