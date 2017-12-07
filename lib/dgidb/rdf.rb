require 'dgidb/rdf/version'

module Dgidb
  module RDF

    ROOT_DIR = File.expand_path('../../', File.dirname(__FILE__))

    require 'dgidb/rdf/ontology'
    require 'dgidb/rdf/constant'

    module CLI
      autoload :Convert, 'dgidb/rdf/cli/convert'
      autoload :Runner, 'dgidb/rdf/cli/runner'
    end

    module Models
      autoload :Base, 'dgidb/rdf/models/base'
      autoload :ChemblMolecule, 'dgidb/rdf/models/chembl_molecule'
      autoload :ChemblMoleculeSynonym, 'dgidb/rdf/models/chembl_molecule_synonym'
      autoload :Drug, 'dgidb/rdf/models/drug'
      autoload :DrugAlias, 'dgidb/rdf/models/drug_alias'
      autoload :DrugAliasBlacklist, 'dgidb/rdf/models/drug_alias_blacklist'
      autoload :DrugAttribute, 'dgidb/rdf/models/drug_attribute'
      autoload :DrugClaim, 'dgidb/rdf/models/drug_claim'
      autoload :DrugClaimAlias, 'dgidb/rdf/models/drug_claim_alias'
      autoload :DrugClaimAttribute, 'dgidb/rdf/models/drug_claim_attribute'
      autoload :DrugClaimType, 'dgidb/rdf/models/drug_claim_type'
      autoload :Gene, 'dgidb/rdf/models/gene'
      autoload :GeneAlias, 'dgidb/rdf/models/gene_alias'
      autoload :GeneAttribute, 'dgidb/rdf/models/gene_attribute'
      autoload :GeneClaim, 'dgidb/rdf/models/gene_claim'
      autoload :GeneClaimAlias, 'dgidb/rdf/models/gene_claim_alias'
      autoload :GeneClaimAttribute, 'dgidb/rdf/models/gene_claim_attribute'
      autoload :GeneClaimCategory, 'dgidb/rdf/models/gene_claim_category'
      autoload :GeneGeneInteractionClaim, 'dgidb/rdf/models/gene_gene_interaction_claim'
      autoload :GeneGeneInteractionClaimAttribute, 'dgidb/rdf/models/gene_gene_interaction_claim_attribute'
      autoload :Interaction, 'dgidb/rdf/models/interaction'
      autoload :InteractionAttribute, 'dgidb/rdf/models/interaction_attribute'
      autoload :InteractionClaim, 'dgidb/rdf/models/interaction_claim'
      autoload :InteractionClaimAttribute, 'dgidb/rdf/models/interaction_claim_attribute'
      autoload :InteractionClaimType, 'dgidb/rdf/models/interaction_claim_type'
      autoload :Publication, 'dgidb/rdf/models/publication'
      autoload :Source, 'dgidb/rdf/models/source'
      autoload :SourceTrustLevel, 'dgidb/rdf/models/source_trust_level'
      autoload :SourceType, 'dgidb/rdf/models/source_type'
    end

    autoload :Downloader, 'dgidb/rdf/downloader'
    autoload :Writer, 'dgidb/rdf/writer'
  end
end
