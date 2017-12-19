require 'spec_helper'

module Dgidb::RDF
  RSpec.describe DGIO do
    it 'has a ontology URI' do
      expect(DGIO.to_s).to eq('http://purl.jp/bio/10/dgidb/')
    end

    it 'has base class' do
      expect(DGIO.DGIdb.type.map(&:to_s)).to contain_exactly('http://www.w3.org/2002/07/owl#Class')
    end

    it 'has drug class' do
      expect(DGIO.Drug.type.map(&:to_s)).to contain_exactly('http://www.w3.org/2002/07/owl#Class')
    end

    it 'has gene class' do
      expect(DGIO.Gene.type.map(&:to_s)).to contain_exactly('http://www.w3.org/2002/07/owl#Class')
    end

    it 'has interaction class' do
      expect(DGIO.Interaction.type.map(&:to_s)).to contain_exactly('http://www.w3.org/2002/07/owl#Class')
    end

    it 'has drug property' do
      expect(DGIO.drug.type.map(&:to_s)).to contain_exactly('http://www.w3.org/2002/07/owl#ObjectProperty')
    end

    it 'has gene property' do
      expect(DGIO.gene.type.map(&:to_s)).to contain_exactly('http://www.w3.org/2002/07/owl#ObjectProperty')
    end

    it 'has interactionType property' do
      expect(DGIO.interactionType.type.map(&:to_s)).to contain_exactly('http://www.w3.org/2002/07/owl#DatatypeProperty')
    end

  end
end
