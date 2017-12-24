namespace :turtle do
  namespace :generate do
    require 'dgidb/rdf'
    require 'dgidb/utils/progress_bar_wrapper'
    require 'rdf'
    require 'rdf/vocab'
    require 'ruby-progressbar'

    include ProgressBarWrapper

    task :environment do
    end

    desc <<-DESC.strip_heredoc
      generate interaction.ttl
    DESC
    task :interaction, %i[output_dir] => [:environment] do |_, args|
      opt = { base:     Dgidb::RDF::Constant::PREFIXES[:dgidb_interaction],
              prefixes: { rdf:        RDF::RDFV.to_s,
                          rdfs:       RDF::RDFS.to_s,
                          dcterms:    RDF::Vocab::DC.to_s,
                          xsd:        RDF::XSD.to_s,
                          dgio:       Dgidb::RDF::DGIO.to_s,
                          dgidb_drug: Dgidb::RDF::Constant::PREFIXES[:dgidb_drug],
                          dgidb_gene: Dgidb::RDF::Constant::PREFIXES[:dgidb_gene],
                          pubmed:     Dgidb::RDF::Constant::PREFIXES[:pubmed] } }

      output_dir = args[:output_dir] || ENV['PWD']

      progress_bar do |bar|
        bar.total = Dgidb::RDF::Models::Interaction.count
        file      = File.join(output_dir, 'interaction.ttl')
        TurtleStreamWriter.open(file, 'w', opt) do |writer|
          Dgidb::RDF::Models::Interaction.find_each do |interaction|
            writer << interaction
            bar.increment
          end
        end
      end
    end

    desc <<-DESC.strip_heredoc
      generate drug.ttl
    DESC
    task :drug, %i[output_dir] => [:environment] do |_, args|
      opt = { base:     Dgidb::RDF::Constant::PREFIXES[:dgidb_drug],
              prefixes: { rdf:             RDF::RDFV.to_s,
                          rdfs:            RDF::RDFS.to_s,
                          dcterms:         RDF::Vocab::DC.to_s,
                          xsd:             RDF::XSD.to_s,
                          dgio:            Dgidb::RDF::DGIO.to_s,
                          chembl_molecule: Dgidb::RDF::Constant::PREFIXES[:chembl_molecule] } }

      output_dir = args[:output_dir] || ENV['PWD']

      progress_bar do |bar|
        bar.total = Dgidb::RDF::Models::Drug.count
        file      = File.join(output_dir, 'drug.ttl')
        TurtleStreamWriter.open(file, 'w', opt) do |writer|
          Dgidb::RDF::Models::Drug.find_each do |drug|
            writer << drug
            bar.increment
          end
        end
      end
    end

    desc <<-DESC.strip_heredoc
      generate gene.ttl
    DESC
    task :gene, %i[output_dir] => [:environment] do |_, args|
      opt = { base:     Dgidb::RDF::Constant::PREFIXES[:dgidb_gene],
              prefixes: { rdf:       RDF::RDFV.to_s,
                          rdfs:      RDF::RDFS.to_s,
                          dcterms:   RDF::Vocab::DC.to_s,
                          skos:      RDF::Vocab::SKOS.to_s,
                          xsd:       RDF::XSD.to_s,
                          dgio:      Dgidb::RDF::DGIO.to_s,
                          ncbi_gene: Dgidb::RDF::Constant::PREFIXES[:ncbi_gene] } }

      output_dir = args[:output_dir] || ENV['PWD']

      progress_bar do |bar|
        bar.total = Dgidb::RDF::Models::Gene.count
        file      = File.join(output_dir, 'gene.ttl')
        TurtleStreamWriter.open(file, 'w', opt) do |writer|
          Dgidb::RDF::Models::Gene.find_each do |gene|
            writer << gene
            bar.increment
          end
        end
      end
    end

    desc <<-DESC.strip_heredoc
      run all generate tasks
    DESC
    task :all, %i[output_dir] => %i[environment interaction drug gene]
  end
end
