require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/cli'
require 'rdf/ntriples'
require 'rdf/nquads'

describe RDF::CLI do
  before(:all) {ARGV.replace %w(help)}
  let(:triple) {'<http://example.com/subject> <http://example.com/predicate> "foo" .'}

  TEST_FILES = {
    nt: fixture_path('test.nt'),
    nq: fixture_path('test.nq'),
  }

  describe "options" do
    it "calls a block" do
      expect {|b| RDF::CLI.options(&b)}.to yield_control
    end

    it "sets debug logging with --debug" do
      ARGV.replace %w(help --debug)
      options = RDF::CLI.options
      expect(options.options[:logger].level).to eql Logger::DEBUG
    end

    describe "add_command" do
      around(:each) do |example|
        orig_commands = RDF::CLI::COMMANDS.dup
        example.run
        RDF::CLI::COMMANDS.clear
        RDF::CLI::COMMANDS.merge!(orig_commands)
      end

      it "adds a command" do
        RDF::CLI.add_command(:foo) do |argv, opts|
          $stdout.puts "Hello, World!"
        end
        expect {RDF::CLI.exec(["foo"])}.to write("Hello, World!").to(:output)
      end
    end

    describe "--input-format" do
      it "sets :format given a legitimate format" do
        ARGV.replace %w(help --format ntriples)
        options = RDF::CLI.options
        expect(options.options[:format]).to eql :ntriples
      end

      it "Calls options on selected reader" do
        ARGV.replace %w(help --format ntriples)
        expect(RDF::NTriples::Reader).to receive(:options).and_return({})
        RDF::CLI.options
      end

      #it "aborts given an illegitimate format" do
      #  ARGV.replace %w(help --format foo)
      #  options = RDF::CLI.options
      #  expect(RDF::CLI).to receive(:abort).and_return(nil)
      #  expect(options.options[:format]).not_to eql :foo
      #end
    end

    it "sets :output with --output" do
      ARGV.replace %w(help --output foo)
      mock = double("open")
      expect(File).to receive(:open).with("foo", "w").and_return(mock)
      options = RDF::CLI.options
      expect(options.options[:output]).to eql mock
    end

    describe "--output-format" do
      it "sets :output_format given a legitimate format" do
        ARGV.replace %w(help --output-format ntriples)
        options = RDF::CLI.options
        expect(options.options[:output_format]).to eql :ntriples
      end

      it "Calls options on selected writer" do
        ARGV.replace %w(help --output-format ntriples)
        expect(RDF::NTriples::Writer).to receive(:options).and_return({})
        RDF::CLI.options
      end

      #it "aborts given an illegitimate format" do
      #  ARGV.replace %w(help --output-format foo)
      #  options = RDF::CLI.options
      #  expect(RDF::CLI).to receive(:abort).and_return(nil)
      #  expect(options.options[::output_format]).not_to eql :foo
      #end
    end

    describe "--evaluate" do
      it "sets :evaluate" do
        ARGV.replace (%w(helpcount --format ntriples --evaluate) << triple)
        options = RDF::CLI.options
        expect(options.options[:evaluate]).to eql triple
      end
    end
  end

  describe "#serialize" do
    after(:each) do
      $stdin = STDIN
    end

    it "serializes to NTriples" do
      expect {RDF::CLI.exec(["serialize", TEST_FILES[:nt]])}.to write.to(:output)
    end

    it "serializes to NTriples from $stdin" do
      $stdin = File.open(TEST_FILES[:nt])
      expect {RDF::CLI.exec(["serialize"])}.to write.to(:output)
    end

    it "serializes to NTriples from evaluate" do
      expect {RDF::CLI.exec(["serialize"], evaluate: File.read(TEST_FILES[:nt]))}.to write.to(:output)
    end

    it "serializes to NQuads" do
      expect {
        RDF::CLI.exec(["serialize", TEST_FILES[:nt]], output_format: :nquads)
      }.to write.to(:output)
    end
  end

  it "#help" do
    expect {RDF::CLI.exec(["help", TEST_FILES[:nt]])}.to write(:anything)
  end

  describe "#count" do
    TEST_FILES.each do |fmt, file|
      it "counts #{fmt}" do
        g = RDF::Repository.load(file)
        expect {RDF::CLI.exec(["count", file])}.to write(/Parsed #{g.count} statements/)
      end
    end

    it "evaluates from argument" do
      expect {RDF::CLI.exec(["count"], format: :ntriples, evaluate: triple)}.to write(/Parsed 1 statements/)
    end
  end

  describe "#subjects" do
    TEST_FILES.each do |fmt, file|
      it "gets subjects #{fmt}" do
        expect {RDF::CLI.exec(["subjects", file])}.to write(:something)
      end
    end
  end

  describe "#objects" do
    TEST_FILES.each do |fmt, file|
      it "gets objects #{fmt}" do
        expect {RDF::CLI.exec(["objects", file])}.to write(:anything)
      end
    end
  end

  describe "#predicates" do
    TEST_FILES.each do |fmt, file|
      it "gets predicates #{fmt}" do
        expect {RDF::CLI.exec(["predicates", file])}.to write(:something)
      end
    end
  end

  describe "#lengths" do
    TEST_FILES.each do |fmt, file|
      it "gets lengths #{fmt}" do
        expect {RDF::CLI.exec(["lengths", file])}.to write(:something)
      end
    end
  end

  describe "#validate" do
    TEST_FILES.each do |fmt, file|
      it "validates #{fmt}" do
        expect {RDF::CLI.exec(["validate", file])}.to write(/Input is valid/)
      end
    end
  end

  context "chaining" do
    TEST_FILES.each do |fmt, file|
      it "chains subjects and objects #{fmt}" do
        expect {RDF::CLI.exec(["subjects", "objects", file])}.to write(:something)
      end
    end
  end
end