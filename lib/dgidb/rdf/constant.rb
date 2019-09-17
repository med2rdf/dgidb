module Dgidb
  module RDF
    module Constant
      DATA_SQL_URL = 'http://dgidb.org/data/data.sql'.freeze

      PREFIXES = {
        # identifiers.org
        dgidb_interaction: 'http://www.dgidb.org/interactions/',
        dgidb_drug:        'http://www.dgidb.org/drugs/',
        dgidb_gene:        'http://www.dgidb.org/genes/',
        dgidb_disease:     'http://identifiers.org/dgidb/disease/',
        dgidb_evidence:    'http://identifiers.org/dgidb/evidence/',
        ncbi_gene:         'http://identifiers.org/ncbigene/',
        pubmed:            'https://www.ncbi.nlm.nih.gov/pubmed/',
        dgio:              'http://purl.jp/bio/10/dgidb/ontology#',
        dct:               'http://purl.org/dc/terms/',

        # others
        chembl_molecule: 'http://rdf.ebi.ac.uk/resource/chembl/molecule/'
      }.freeze
    end
  end
end
