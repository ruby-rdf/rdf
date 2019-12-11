require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/cli'
require 'rdf/ntriples'
require 'rdf/nquads'

describe RDF::CLI do
  let(:triple) {'<http://example.com/subject> <http://example.com/predicate> "foo" .'}

  TEST_FILES = {
    nt: fixture_path('test.nt'),
    nq: fixture_path('test.nq'),
  }

  #before(:each) {expect(RDF::CLI).not_to receive(:abort)    }
  around(:each) do |example|
    orig_commands = RDF::CLI::COMMANDS.dup
    example.run
    RDF::CLI::COMMANDS.clear
    RDF::CLI::COMMANDS.merge!(orig_commands)
  end

  describe "options" do
    it "sets debug logging with --debug" do
      options = RDF::CLI.options(%w(help --debug))
      expect(options.options[:debug]).to be_truthy
    end

    it "extracts non-option arguments into options.args" do
      options = RDF::CLI.options(%w(help --debug along with other args))
      expect(options.args).to eql %w(help along with other args)
    end

    describe "--input-format" do
      it "sets :format given a legitimate format (using --format)" do
        options = RDF::CLI.options(%w(help --format ntriples))
        expect(options.options[:format]).to eql :ntriples
      end

      it "sets :format given a legitimate format" do
        options = RDF::CLI.options(%w(help --input-format ntriples))
        expect(options.options[:format]).to eql :ntriples
      end

      it "Calls options on selected reader" do
        expect(RDF::NTriples::Reader).to receive(:options).and_return({})
        RDF::CLI.options(%w(help --input-format ntriples))
      end

      it "aborts given an illegitimate format" do
        expect(RDF::CLI).to receive(:abort)
        RDF::CLI.options(%w(help --format foo))
      end
    end

    it "sets :output with --output" do
      mock = double("open")
      expect(File).to receive(:open).with("foo", "w").and_return(mock)
      options = RDF::CLI.options(%w(help --output foo))
      expect(options.options[:output]).to eql mock
    end

    describe "--output-format" do
      it "sets :output_format given a legitimate format" do
        options = RDF::CLI.options(%w(help --output-format ntriples))
        expect(options.options[:output_format]).to eql :ntriples
      end

      it "Calls options on selected writer" do
        expect(RDF::NTriples::Writer).to receive(:options).and_return({})
        RDF::CLI.options(%w(help --output-format ntriples))
      end

      it "aborts given an illegitimate format" do
        expect(RDF::CLI).to receive(:abort)
        RDF::CLI.options(%w(help --output-format foo))
      end
    end

    describe "--evaluate" do
      it "sets :evaluate" do
        options = RDF::CLI.options(%w(helpcount --format ntriples --evaluate) << triple)
        expect(options.options[:evaluate]).to eql triple
      end
    end

    describe "with commands" do
      it "adds options from specified commands" do
        foo_opt = RDF::CLI::Option.new(symbol: :foo, on: [])
        RDF::CLI.add_command(:foo, options: foo_opt)
        expect(RDF::CLI.options([:foo], format: :json)).to include(foo_opt.to_hash)
      end

      it "replaces equivalent options from command" do
        verbose_opt = RDF::CLI::Option.new(
          symbol: :verbose,
          on: ['-v', '--verbose'],
          description: 'Replaced option.')
        RDF::CLI.add_command(:foo, options: verbose_opt)
        expect(RDF::CLI.options([:foo], format: :json)).to include(verbose_opt.to_hash)
      end
    end

    it "returns an array of Option format: :json" do
      expect(RDF::CLI.options([], format: :json)).to all(be_a(Hash))
    end
  end

  describe ".commands" do
    it "returns an array of strings" do
      expect(RDF::CLI.commands).to all(be_a(String))
    end

    it "returns an array with format: :json" do
      expect(RDF::CLI.commands(format: :json)).to all(be_a(Hash))
    end
  end

  describe ".add_command" do
    it "adds a command" do
      RDF::CLI.add_command(:foo) do |argv, opts|
        $stdout.puts "Hello, World!"
      end
      expect {RDF::CLI.exec(["foo"])}.to write("Hello, World!").to(:output)
    end
  end

  context "commands" do
    describe "serialize" do
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

    it "help" do
      expect {RDF::CLI.exec(["help", TEST_FILES[:nt]])}.to write(:anything)
    end

    describe "count" do
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

    describe "subjects" do
      TEST_FILES.each do |fmt, file|
        it "gets subjects #{fmt}" do
          expect {RDF::CLI.exec(["subjects", file])}.to write(:something)
        end
      end
    end

    describe "objects" do
      TEST_FILES.each do |fmt, file|
        it "gets objects #{fmt}" do
          expect {RDF::CLI.exec(["objects", file])}.to write(:anything)
        end
      end
    end

    describe "predicates" do
      TEST_FILES.each do |fmt, file|
        it "gets predicates #{fmt}" do
          expect {RDF::CLI.exec(["predicates", file])}.to write(:something)
        end
      end
    end

    describe "lengths" do
      TEST_FILES.each do |fmt, file|
        it "gets lengths #{fmt}" do
          expect {RDF::CLI.exec(["lengths", file])}.to write(:something)
        end
      end
    end

    describe "validate" do
      TEST_FILES.each do |fmt, file|
        it "validates #{fmt}" do
          expect {RDF::CLI.exec(["validate", file])}.to write(/Input is valid/)
        end
      end
    end

    it "complains if filtered command is attempted" do
      RDF::CLI.add_command(:foo, filter: {output_format: :nquads})
      expect do
        expect do
          RDF::CLI.exec(["foo"], output_format: :ntriples)
        end.to raise_error(ArgumentError)
      end.to write(%(Command "foo" requires output_format: nquads, not ntriples)).to(:output)
    end

    context "chaining" do
      TEST_FILES.each do |fmt, file|
        it "chains subjects and objects #{fmt}" do
          expect {RDF::CLI.exec(["subjects", "objects", file])}.to write(:something)
        end
      end
    end
  end
end