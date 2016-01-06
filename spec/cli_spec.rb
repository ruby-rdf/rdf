require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/cli'

describe RDF::CLI do
  TEST_FILES = {
    nt: fixture_path('test.nt'),
    nq: fixture_path('test.nq'),
  }

  describe "#serialize" do
    it "serializes to NTriples" do
      expect {RDF::CLI.exec_command("serialize", [TEST_FILES[:nt]])}.to write.to(:output)
    end

    it "serializes to NQuads" do
      expect {
        RDF::CLI.exec_command("serialize", [TEST_FILES[:nt]], output_format: :nquads)
      }.to write.to(:output)
    end
  end

  describe "#count" do
    TEST_FILES.each do |fmt, file|
      it "counts #{fmt}" do
        g = RDF::Repository.load(file)
        expect {RDF::CLI.exec_command("count", [file])}.to write(/Parsed #{g.count} statements/)
      end
    end
  end

  describe "#subjects" do
    TEST_FILES.each do |fmt, file|
      it "gets subjects #{fmt}" do
        expect {RDF::CLI.exec_command("subjects", [file])}.to write(:something)
      end
    end
  end

  describe "#objects" do
    TEST_FILES.each do |fmt, file|
      it "gets objects #{fmt}" do
        expect {RDF::CLI.exec_command("objects", [file])}.to write(:anything)
      end
    end
  end

  describe "#predicates" do
    TEST_FILES.each do |fmt, file|
      it "gets predicates #{fmt}" do
        expect {RDF::CLI.exec_command("predicates", [file])}.to write(:something)
      end
    end
  end

  describe "#lenghts" do
    TEST_FILES.each do |fmt, file|
      it "gets lenghts #{fmt}" do
        expect {RDF::CLI.exec_command("lenghts", [file])}.to write(:something)
      end
    end
  end

  describe "#validate" do
    TEST_FILES.each do |fmt, file|
      it "validates #{fmt}" do
        g = RDF::Repository.load(file)
        expect {RDF::CLI.exec_command("validate", [file])}.to write(/Validated #{g.count} statements/)
      end
    end
  end
end