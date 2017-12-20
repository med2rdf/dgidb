require 'dgidb/rdf'
require 'rdf'
require 'rdf/vocab'
require 'ruby-progressbar'

namespace :turtle do
  namespace :generate do
    # initialization
    task :environment do
    end

    def progress_bar(**options)
      opt = { format: '|%B| %J%% %a (%E)' }.merge(options)

      opt[:output] = STDOUT.tty? ? STDOUT : File.open('/dev/null', 'w')

      progress_bar = ProgressBar.create(opt)

      yield progress_bar
    ensure
      progress_bar.finish
    end

    desc <<-DESC.strip_heredoc
      generate interaction.ttl
    DESC
    task :interaction, %i[dest_dir] => [:environment] do |_, args|
      opt = { base:     Dgidb::RDF::Constant::PREFIXES[:dgidb_interaction],
              prefixes: { rdf:        RDF::RDFV.to_s,
                          rdfs:       RDF::RDFS.to_s,
                          dcterms:    RDF::Vocab::DC.to_s,
                          xsd:        RDF::XSD.to_s,
                          dgio:       Dgidb::RDF::DGIO.to_s,
                          dgidb_drug: Dgidb::RDF::Constant::PREFIXES[:dgidb_drug],
                          dgidb_gene: Dgidb::RDF::Constant::PREFIXES[:dgidb_gene],
                          pubmed:     Dgidb::RDF::Constant::PREFIXES[:pubmed] } }

      dest_dir = args[:dest_dir] || './'

      progress_bar do |bar|
        bar.total = Dgidb::RDF::Models::Interaction.count
        file      = File.join(dest_dir, 'interaction.ttl')
        TurtleStreamWriter.open(file, 'w', opt) do |writer|
          Dgidb::RDF::Models::Interaction.limit(10).find_each do |interaction|
            writer << interaction
            bar.increment
          end
        end
      end
    end

    desc <<-DESC.strip_heredoc
      generate drug.ttl
    DESC
    task :drug, %i[dest_dir] => [:environment] do |_, args|
      opt = { base:     Dgidb::RDF::Constant::PREFIXES[:dgidb_drug],
              prefixes: { rdf:             RDF::RDFV.to_s,
                          rdfs:            RDF::RDFS.to_s,
                          dcterms:         RDF::Vocab::DC.to_s,
                          xsd:             RDF::XSD.to_s,
                          dgio:            Dgidb::RDF::DGIO.to_s,
                          chembl_molecule: Dgidb::RDF::Constant::PREFIXES[:chembl_molecule] } }

      dest_dir = args[:dest_dir] || './'

      progress_bar do |bar|
        bar.total = Dgidb::RDF::Models::Drug.count
        file      = File.join(dest_dir, 'drug.ttl')
        TurtleStreamWriter.open(file, 'w', opt) do |writer|
          Dgidb::RDF::Models::Drug.limit(10).find_each do |drug|
            writer << drug
            bar.increment
          end
        end
      end
    end

    desc <<-DESC.strip_heredoc
      generate gene.ttl
    DESC
    task :gene, %i[dest_dir] => [:environment] do |_, args|
      opt = { base:     Dgidb::RDF::Constant::PREFIXES[:dgidb_gene],
              prefixes: { rdf:       RDF::RDFV.to_s,
                          rdfs:      RDF::RDFS.to_s,
                          dcterms:   RDF::Vocab::DC.to_s,
                          skos:      RDF::Vocab::SKOS.to_s,
                          xsd:       RDF::XSD.to_s,
                          dgio:      Dgidb::RDF::DGIO.to_s,
                          ncbi_gene: Dgidb::RDF::Constant::PREFIXES[:ncbi_gene] } }

      dest_dir = args[:dest_dir] || './'

      progress_bar do |bar|
        bar.total = Dgidb::RDF::Models::Gene.count
        file      = File.join(dest_dir, 'gene.ttl')
        TurtleStreamWriter.open(file, 'w', opt) do |writer|
          Dgidb::RDF::Models::Gene.limit(10).find_each do |gene|
            writer << gene
            bar.increment
          end
        end
      end
    end

    desc <<-DESC.strip_heredoc
      run all generate tasks
    DESC
    task :all, %i[dest_dir] => %i[environment interaction drug gene]
  end
end
