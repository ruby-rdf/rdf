require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Changeset do
  describe "#initialize" do
    it "accepts inserts" do
      g = double("inserts")
      this = described_class.new(insert: g)
      expect(this.inserts).to eq g
    end

    it "accepts deletes" do
      g = double("deletes")
      this = described_class.new(delete: g)
      expect(this.deletes).to eq g
    end

    it "accepts inserts & deletes" do
      ins = double("inserts")
      del = double("deletes")

      this = described_class.new(delete: del, insert: ins)

      expect(this.inserts).to eq ins
      expect(this.deletes).to eq del
    end
  end

  its(:deletes) { is_expected.to be_a(RDF::Enumerable) }
  its(:inserts) { is_expected.to be_a(RDF::Enumerable) }

  it { is_expected.to_not be_mutable }
  it { is_expected.to_not be_readable }

  it "does not respond to #load" do
    expect {subject.load("http://example/")}.to raise_error(NoMethodError)
  end

  it "does not respond to #update" do
    expect { subject.update(RDF::Statement.new) }.to raise_error(NoMethodError)
  end

  it "does not respond to #clear" do
    expect { subject.clear }.to raise_error(NoMethodError)
  end

  describe "#apply" do
    let(:st) { RDF::Statement.new(RDF::URI("s"), RDF::URI("p"), RDF::URI("o")) }
    
    context 'on repository' do
      let(:repo) { RDF::Repository.new }

      it "deletes statements" do
        repo << st
        subject.delete(st)

        expect { subject.apply(repo) }.to change { repo.statements }.to be_empty
      end

      it "inserts statements" do
        subject.insert(st)
        expect { subject.apply(repo) }
          .to change { repo.statements }.to contain_exactly(st)
      end

      it "inserts & deletes statements" do
        repo << st
        new_statement = RDF::Statement(RDF::URI('x'),
                                       RDF::URI('y'),
                                       RDF::URI('z'))
        subject.delete(st)
        subject.insert(new_statement)

        expect { subject.apply(repo) }
          .to change { repo.statements }.to contain_exactly(new_statement)
      end

      it "correctly applies a wildcard/pattern" do
        repo << st

        subject.delete RDF::Statement(nil, RDF::URI('p'), nil)

        expect { subject.apply(repo) }.to change { repo.statements }.to be_empty
      end
    end
  end

  describe '#empty?' do
    let(:s) {RDF::Statement.new(RDF::URI("s"), RDF::URI("p"), RDF::URI("o"))}

    it 'is empty when no deletes/inserts are present' do
      expect(subject).to be_empty
    end

    it 'is not empty when deletes are present' do
      subject.delete(s)
      expect(subject).not_to be_empty
    end

    it 'is not empty when inserts are present' do
      subject.insert(s)
      expect(subject).not_to be_empty
    end
  end

  describe '#delete' do
    let(:s) {RDF::Statement.new(RDF::URI("s"), RDF::URI("p"), RDF::URI("o"))}

    it 'adds statement to deletes' do
      expect { subject.delete(s) }
        .to change { subject.deletes }.to contain_exactly(s)
    end

    it 'adds multiple statements to #deletes' do
      statements = [].extend(RDF::Enumerable)
      statements << [s, RDF::Statement(:node, RDF.type, RDF::URI('x'))]

      expect { subject.delete(statements) }
        .to change { subject.deletes }.to contain_exactly(*statements)
    end
  end

  describe '#insert' do
    let(:s) {RDF::Statement.new(RDF::URI("s"), RDF::URI("p"), RDF::URI("o"))}

    it 'adds statement to inserts' do
      expect { subject.insert(s) }
        .to change { subject.inserts }.to contain_exactly(s)
    end

    it "adds multiple statements to #inserts" do
      statements = [].extend(RDF::Enumerable)
      statements << [s, RDF::Statement(:node, RDF.type, RDF::URI('x'))]

      expect { subject.insert(statements) }
        .to change { subject.inserts }.to contain_exactly(*statements)
    end
  end

end
