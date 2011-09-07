require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/cli'

describe RDF::CLI do
  def capture_stdout
    old, $stdout = $stdout, StringIO.new
    yield
    $stdout.rewind
    out = $stdout.read
    $stdout = old
    out
  end
  
  TEST_FILES = {
    :nt => File.expand_path(File.join(File.dirname(__FILE__), 'data', 'test.nt')),
    :nq => File.expand_path(File.join(File.dirname(__FILE__), 'data', 'test.nq')),
  }

  describe "#serialize" do
    it "serializes to NTriples" do
      out = capture_stdout do
        RDF::CLI.exec_command("serialize", [TEST_FILES[:nt]])
      end
      out.should_not be_empty
    end

    it "serializes to NQuads" do
      out = capture_stdout do
        RDF::CLI.exec_command("serialize", [TEST_FILES[:nt]], :output_format => :nquads)
      end
      out.should_not be_empty
    end
  end

  describe "#count" do
    TEST_FILES.each do |fmt, file|
      it "counts #{fmt}" do
        out = capture_stdout do
          RDF::CLI.exec_command("count", [file])
        end
        g = RDF::Repository.load(file)
        out.should =~ /Parsed #{g.count} statements/
      end
    end
  end

  describe "#subjects" do
    TEST_FILES.each do |fmt, file|
      it "gets subjects #{fmt}" do
        out = capture_stdout do
          RDF::CLI.exec_command("subjects", [file])
        end
        out.should_not be_empty
      end
    end
  end

  describe "#objects" do
    TEST_FILES.each do |fmt, file|
      it "gets objects #{fmt}" do
        out = capture_stdout do
          RDF::CLI.exec_command("objects", [file])
        end
        out.should_not be_empty
      end
    end
  end

  describe "#predicates" do
    TEST_FILES.each do |fmt, file|
      it "gets predicates #{fmt}" do
        out = capture_stdout do
          RDF::CLI.exec_command("predicates", [file])
        end
        out.should_not be_empty
      end
    end
  end

  describe "#lenghts" do
    TEST_FILES.each do |fmt, file|
      it "gets lenghts #{fmt}" do
        out = capture_stdout do
          RDF::CLI.exec_command("lenghts", [file])
        end
        out.should_not be_empty
      end
    end
  end
end