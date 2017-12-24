require 'dgidb/rdf'
require 'dgidb/utils/progress_bar_wrapper'
require 'rdf'
require 'rdf/vocab'

module Dgidb
  module RDF
    module Turtle
      class Generator
        include ProgressBarWrapper

        def initialize(output_dir)
          @output_dir = output_dir || ENV['PWD']
        end

        def all
          ontology
          drug
          gene
          interaction
        end

        def ontology
          puts 'generating dgio.ttl...'
          file = File.join(@output_dir, 'dgio.ttl')
          File.open(file, 'w') do |f|
            f.write Dgidb::RDF::DGIO.to_ttl
          end
        end

        def interaction
          opt = { base:     Dgidb::RDF::Constant::PREFIXES[:dgidb_interaction],
                  prefixes: { rdf:        ::RDF::RDFV.to_s,
                              rdfs:       ::RDF::RDFS.to_s,
                              dcterms:    ::RDF::Vocab::DC.to_s,
                              xsd:        ::RDF::XSD.to_s,
                              dgio:       Dgidb::RDF::DGIO.to_s,
                              dgidb_drug: Dgidb::RDF::Constant::PREFIXES[:dgidb_drug],
                              dgidb_gene: Dgidb::RDF::Constant::PREFIXES[:dgidb_gene],
                              pubmed:     Dgidb::RDF::Constant::PREFIXES[:pubmed] } }

          puts 'generating interaction.ttl...'
          progress_bar do |bar|
            bar.total = Dgidb::RDF::Models::Interaction.count
            file      = File.join(@output_dir, 'interaction.ttl')
            TurtleStreamWriter.open(file, 'w', opt) do |writer|
              Dgidb::RDF::Models::Interaction.find_each do |interaction|
                writer << interaction
                bar.increment
              end
            end
          end
        end

        def drug
          opt = { base:     Dgidb::RDF::Constant::PREFIXES[:dgidb_drug],
                  prefixes: { rdf:             ::RDF::RDFV.to_s,
                              rdfs:            ::RDF::RDFS.to_s,
                              dcterms:         ::RDF::Vocab::DC.to_s,
                              xsd:             ::RDF::XSD.to_s,
                              dgio:            Dgidb::RDF::DGIO.to_s,
                              chembl_molecule: Dgidb::RDF::Constant::PREFIXES[:chembl_molecule] } }

          puts 'generating drug.ttl...'
          progress_bar do |bar|
            bar.total = Dgidb::RDF::Models::Drug.count
            file      = File.join(@output_dir, 'drug.ttl')
            TurtleStreamWriter.open(file, 'w', opt) do |writer|
              Dgidb::RDF::Models::Drug.find_each do |drug|
                writer << drug
                bar.increment
              end
            end
          end
        end

        def gene
          opt = { base:     Dgidb::RDF::Constant::PREFIXES[:dgidb_gene],
                  prefixes: { rdf:       ::RDF::RDFV.to_s,
                              rdfs:      ::RDF::RDFS.to_s,
                              dcterms:   ::RDF::Vocab::DC.to_s,
                              skos:      ::RDF::Vocab::SKOS.to_s,
                              xsd:       ::RDF::XSD.to_s,
                              dgio:      Dgidb::RDF::DGIO.to_s,
                              ncbi_gene: Dgidb::RDF::Constant::PREFIXES[:ncbi_gene] } }

          puts 'generating gene.ttl...'
          progress_bar do |bar|
            bar.total = Dgidb::RDF::Models::Gene.count
            file      = File.join(@output_dir, 'gene.ttl')
            TurtleStreamWriter.open(file, 'w', opt) do |writer|
              Dgidb::RDF::Models::Gene.find_each do |gene|
                writer << gene
                bar.increment
              end
            end
          end
        end
      end
    end
  end
end
