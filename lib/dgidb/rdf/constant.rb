module Dgidb
  module RDF
    module Constant
      DATA_SQL_URL = 'http://dgidb.org/data/data.sql'.freeze

      PREFIXES = {
        # identifiers.org
        dgidb_interaction: 'http://identifiers.org/dgidb/interaction/',
        dgidb_drug:        'http://identifiers.org/dgidb/drug/',
        dgidb_gene:        'http://identifiers.org/dgidb/gene/',
        dgidb_evidence:    'http://identifiers.org/dgidb/evidence/',
        ncbi_gene:         'http://identifiers.org/ncbigene/',
        pubmed:            'http://identifiers.org/pubmed/',
        dgio:              'http://purl.jp/bio/10/dgidb/ontology#',
        dct:               'http://purl.org/dc/terms/',

        # others
        chembl_molecule: 'http://rdf.ebi.ac.uk/resource/chembl/molecule/'
      }.freeze
    end
  end
end
