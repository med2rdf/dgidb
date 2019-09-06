module Dgidb
  module RDF
    module Models
      class Interaction < Base
        has_many :interaction_claims
        belongs_to :gene
        belongs_to :drug
        has_and_belongs_to_many :interaction_types,
                                join_table: 'interaction_types_interactions',
                                class_name: 'InteractionClaimType'
        has_many :interaction_attributes
        has_and_belongs_to_many :publications
        has_and_belongs_to_many :sources

        def type_names
          self.interaction_types.pluck(:type).uniq
        end

        def pmids
          self.publications.pluck(:pmid).uniq
        end

        def triples
          triples = []

          subject = ::RDF::URI.new(Constant::PREFIXES[:dgidb_interaction] + self[:id])
          drug_id = ::RDF::URI.new(Constant::PREFIXES[:dgidb_drug] + self[:drug_id])
          gene_id = ::RDF::URI.new(Constant::PREFIXES[:dgidb_gene] + self[:gene_id])

          triples << [subject, ::RDF.type, M2R.Interaction]
          triples << [subject, ::RDF::Vocab::DC.identifier, self[:id]]

          triples << [subject, M2R.drug, drug_id]
          triples << [subject, M2R.gene, gene_id]

          type_names.each do |name|
            triples << [subject, M2R.interactionType, name]
          end

          self.interaction_claims.each do |claim|
            evinode = ::RDF::Node.new()
 #           triples << [subject, M2R.evidence, ::RDF::URI.new(Constant::PREFIXES[:dgidb_evidence] + claim.id.to_s)]
            claim.interaction_claim_attributes.each do |attributes|
              value = attributes.value.gsub(/<[0-9a-z]{2}>/,"").gsub("  "," ")
              case attributes.name
              when "Reported Cancer Type" then
                triples << [subject, M2R.evidence, evinode]
                value.split(/\s*,\s*/).each do |v|
                  triples << [evinode, M2R.site_primary, ::RDF::Literal.new(v)]
                end
              when "Response Type" then
                triples << [subject, M2R.evidence, evinode]
                triples << [evinode, M2R.response_type, ::RDF::Literal.new(value)]
              when "Approval Status" then
                triples << [subject, M2R.evidence, evinode]
                triples << [evinode, M2R.approval_status, ::RDF::Literal.new(value)]
              when "Evidence Type" then
                triples << [subject, M2R.evidence, evinode]
                triples << [evinode, M2R.evidence_type, ::RDF::Literal.new(value)]
              end
            end
          end

#
#Indication/Tumor Type
#combination therapy
#Specific Action of the Ligand
#Endogenous Drug?
#Direct Interaction?
#Clinical Status
#Pathway
#Variant Effect
#Details of the Assay for Interaction
#Details of Interaction
#Interaction Context
#Trial Name
#Novel drug target
#Mechanism of Interaction
#Direct Interaction
#Specific Binding Site for Interaction
#Notes
#Combination therapy
#Fusion protein
#Alteration
#Drug family

          pmids.each do |pmid|
            triples << [subject, ::RDF::URI.new(Constant::PREFIXES[:dct]+"references"), ::RDF::URI.new(Constant::PREFIXES[:pubmed] + pmid.to_s)]
          end

          triples
        end
      end
    end
  end
end
