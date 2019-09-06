require 'spec_helper'

module Dgidb::RDF
  RSpec.describe M2R do
    it 'has a ontology URI' do
      expect(M2R.to_s).to eq('http://med2rdf.org/ontology/med2rdf#')
    end

    it 'has base class' do
      expect(M2R.DGIdb.type.map(&:to_s)).to contain_exactly('http://www.w3.org/2002/07/owl#Class')
    end

    it 'has drug class' do
      expect(M2R.Drug.type.map(&:to_s)).to contain_exactly('http://www.w3.org/2002/07/owl#Class')
    end

    it 'has gene class' do
      expect(M2R.Gene.type.map(&:to_s)).to contain_exactly('http://www.w3.org/2002/07/owl#Class')
    end

    it 'has interaction class' do
      expect(M2R.Interaction.type.map(&:to_s)).to contain_exactly('http://www.w3.org/2002/07/owl#Class')
    end

    it 'has drug property' do
      expect(M2R.drug.type.map(&:to_s)).to contain_exactly('http://www.w3.org/2002/07/owl#ObjectProperty')
    end

    it 'has gene property' do
      expect(M2R.gene.type.map(&:to_s)).to contain_exactly('http://www.w3.org/2002/07/owl#ObjectProperty')
    end

    it 'has interactionType property' do
      expect(M2R.interactionType.type.map(&:to_s)).to contain_exactly('http://www.w3.org/2002/07/owl#DatatypeProperty')
    end

  end
end
