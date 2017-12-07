require 'dgidb/rdf/ontology'
require 'linkeddata'

module Dgidb
  module RDF
    module Constant
      PREFIXES = {
        # well-known vocabulary
        dcterms: ::RDF::Vocab::DC.to_uri.freeze,
        foaf:    ::RDF::Vocab::FOAF.to_uri,
        rdf:     ::RDF.to_uri.freeze,
        rdfs:    ::RDF::Vocab::RDFS.to_uri.freeze,
        skos:    ::RDF::Vocab::SKOS.to_uri.freeze,
        xsd:     ::RDF::Vocab::XSD.to_uri.freeze,

        # for this domain
        dgio: DGIO.to_uri.freeze,

        # identifiers.org
        dgidb_interaction: 'http://identifiers.org/dgidb/interaction/',
        dgidb_drug:        'http://identifiers.org/dgidb/drug/',
        dgidb_gene:        'http://identifiers.org/dgidb/gene/',
        ncbi_gene:         'http://identifiers.org/ncbigene/',
        pubmed:            'http://identifiers.org/pubmed/',

        # others
        chembl_molecule: 'http://rdf.ebi.ac.uk/resource/chembl/molecule/'
      }.freeze
    end
  end
end
