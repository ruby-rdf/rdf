require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/dataset'

describe RDF::Dataset do
  describe 'initializing' do
    it 'yields itself' do
      expect { |b| described_class.new(&b) }.to yield_control
    end

    context 'with statemens' do
      let(:statements) { RDF::Spec.quads }

      it 'accepts statements as array' do
        expect(described_class.new(statements: [*statements]))
          .to contain_exactly(*statements)
      end

      it 'accepts statements as RDF::Enumerable' do
        statements.extend(RDF::Enumerable)

        expect(described_class.new(statements: statements))
          .to contain_exactly(*statements)
      end
    end
  end
  
  context 'default empty dataset' do
    it { is_expected.to be_empty }

    describe '#each' do
      it 'is an empty enumerator' do
        expect(subject.each).to contain_exactly()
      end
    end

    describe '#supports?' do
      [:validity, :literal_equality, :graph_name].each do |key|
        it "supports #{key}" do
          expect(subject.supports?(key)).to be true
        end
      end

      [:inference, :skolemize].each do |key|
        it "does not support #{key}" do
          expect(subject.supports?(key)).to be false
        end
      end

      it 'does not support abitrary keys' do
        expect(subject.supports?(:moomin)).to be false
      end
    end
  end

  context 'with statements' do
    let(:statements) { RDF::Spec.quads }

    it_behaves_like 'an RDF::Dataset' do
      let(:dataset) { RDF::Dataset.new(statements: statements) }

      describe '#query_pattern' do
        let(:graph_name) { subject.singleton_class::DEFAULT_GRAPH }

        it "returns statements from unnamed graphs with default graph_name" do
          pattern = RDF::Query::Pattern.new(nil, nil, nil, graph_name: graph_name)
          solutions = []
          subject.send(:query_pattern, pattern) {|s| solutions << s}
          
          unnamed_statements = subject.statements
          unnamed_statements.reject! {|st| st.has_name?}

          expect(solutions.size).to eq unnamed_statements.size
        end
      end
    end
  end
end
