require_relative 'spec_helper'
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

    describe "--ordered" do
      it "sets :ordered" do
        options = RDF::CLI.options(%w(help --ordered) << triple)
        expect(options.options[:ordered]).to be_truthy
      end
    end

    describe "--evaluate" do
      it "sets :evaluate" do
        options = RDF::CLI.options(%w(help count --format ntriples --evaluate) << triple)
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
    after {RDF::CLI::COMMANDS.delete(:foo)}

    it "adds a command with block" do
      RDF::CLI.add_command(:foo) do |argv, opts|
        $stdout.puts "Hello, World!"
      end
      expect {RDF::CLI.exec(["foo"])}.to write("Hello, World!").to(:output)
    end

    it "adds a command with lambda option" do
      lambda = ->(argv, opts) do
        $stdout.puts "Hello, World!"
      end
      RDF::CLI.add_command(:foo, lambda: lambda)
      expect {RDF::CLI.exec(["foo"])}.to write("Hello, World!").to(:output)
    end

    it "calls command with repository" do
      RDF::CLI.add_command(:foo) do |argv, opts|
        expect(opts).to include(repository: kind_of(RDF::Enumerable))
      end
      RDF::CLI.exec(["foo"])
    end

    it "calls command with specified repository" do
      repo = double(:repo)
      RDF::CLI.add_command(:foo, repository: repo) do |argv, opts|
        expect(opts).to include(repository: repo)
      end
      RDF::CLI.exec(["foo"])
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

      it "passes parsed prefixes to writer" do
        allow_any_instance_of(RDF::NTriples::Reader).to receive(:prefixes).and_return(foo: :bar)

        writer_mock = double("writer")
        expect(RDF::Writer).to receive(:for).and_return(writer_mock)
        expect(writer_mock).to receive(:new).with(anything, hash_including(prefixes: {foo: :bar}))
        RDF::CLI.exec(["serialize", TEST_FILES[:nt]], output_format: :nquads)
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

    describe "filter" do
      context "complains if filtered command is attempted" do
        before(:each) {RDF::CLI::COMMANDS.delete(:filtered)}

        it "single value" do
          RDF::CLI.add_command(:filtered, filter: {output_format: :nquads})
          expect do
            expect do
              RDF::CLI.exec(["filtered"], output_format: :ntriples)
            end.to raise_error(ArgumentError)
          end.to write(%(Command "filtered" requires compatible value for output_format, not ntriples)).to(:output)
        end

        it "Array of values" do
          RDF::CLI.add_command(:filtered, filter: {output_format: %i{nquads turtle}})
          expect do
            expect do
              RDF::CLI.exec(["filtered"], output_format: :ntriples)
            end.to raise_error(ArgumentError)
          end.to write(%(Command "filtered" requires output_format in ["nquads", "turtle"], not ntriples)).to(:output)
        end

        it "Proc" do
          RDF::CLI.add_command(:filtered, filter: {output_format: ->(v) {v == :nquads}})
          expect do
            expect do
              RDF::CLI.exec(["filtered"], output_format: :ntriples)
            end.to raise_error(ArgumentError)
          end.to write(%(Command "filtered" output_format inconsistent with ntriples)).to(:output)
        end
      end
    end

    it "uses repository specified in command" do
      RDF::CLI.add_command(:with_repo, repository: double(:repo))
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