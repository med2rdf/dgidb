module Dgidb
  module RDF
    module Models
      class SourceTrustLevel < Base
        has_many :sources,
                 inverse_of: :source_trust_level
      end
    end
  end
end
