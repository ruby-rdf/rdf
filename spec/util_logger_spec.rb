require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Util::Logger do
  class LogTester
    attr_reader :options
    include RDF::Util::Logger
    def initialize(logger = nil)
      @logger = logger
      @options = {}
    end
  end

  context "with Spec Logger" do
    subject {LogTester.new(RDF::Spec.logger)}

    describe "#logger" do
      it "retrieves logger from @logger" do
        expect(subject.logger).to eql subject.instance_variable_get(:@logger)
      end

      it "prefers logger from options" do
        l = RDF::Spec.logger
        expect(subject.logger(logger: l)).to eql l
      end

      it "prefers @logger to @options[:logger]" do
        subject.options[:logger] = RDF::Spec.logger
        expect(subject.logger).to eql subject.instance_variable_get(:@logger)
      end

      it "will use @options[:logger]" do
        subject.instance_variable_set(:@logger, nil)
        subject.options[:logger] = RDF::Spec.logger
        expect(subject.logger).to eql subject.options[:logger]
      end

      it "applies LoggerBehavior to logger" do
        expect(subject.logger).to be_a(RDF::Util::Logger::LoggerBehavior)
      end
    end

    describe "#log_fatal" do
      specify {expect {subject.log_fatal("foo", "bar")}.to raise_error(StandardError, "foo")}

      it "raises provided exception" do
        expect {subject.log_fatal("foo", exception: RDF::ReaderError)}.to raise_error(RDF::ReaderError, "foo")
      end

      it "adds locaton to log message" do
        expect {subject.log_fatal("foo")}.to raise_error(StandardError)
        expect(subject.logger.to_s).to match /Called from #{File.expand_path("", __FILE__)}:#{__LINE__-1}/
      end

      it "logs to $stderr if logger not configured" do
        logger = LogTester.new
        expect {logger.log_fatal("foo") rescue nil}.to write(:something).to(:error)
      end

      it "increments log_statistics" do
        subject.log_fatal("foo") rescue nil
        expect(subject.log_statistics[:fatal]).to eql 1
      end
    end

    describe "#log_error" do
      specify {expect {subject.log_error("foo")}.not_to raise_error}
      it "raises provided exception" do
        expect {subject.log_error("foo", exception: RDF::ReaderError)}.to raise_error(RDF::ReaderError, "foo")
      end

      it "Logs messages, and yield return" do
        subject.log_error("a", "b") {"c"}
        expect(subject.logger.to_s).to eql "ERROR a: b: c\n"
      end

      it "Does not log errors while recovering" do
        subject.log_error("a")
        subject.log_error("b")
        subject.log_recover
        subject.log_error("c")
        expect(subject.logger.to_s).to eql "ERROR a\nERROR c\n"
      end

      it "Indicates recovering" do
        subject.log_error("a")
        expect(subject).to be_log_recovering
      end

      it "logs to $stderr if logger not configured" do
        logger = LogTester.new
        expect {logger.log_error("foo") rescue nil}.to write(:something).to(:error)
      end

      it "increments log_statistics" do
        subject.log_error("foo") rescue nil
        expect(subject.log_statistics[:error]).to eql 1
      end
    end

    describe "#log_info" do
      it "Logs messages, and yield return" do
        subject.log_info("a", "b") {"c"}
        expect(subject.logger.to_s).to eql "INFO a: b: c\n"
      end

      it "adds lineno" do
        subject.log_info("a", lineno: 10)
        expect(subject.logger.to_s).to eql "INFO [line 10] a\n"
      end

      it "adds depth with option" do
        subject.log_info("a", depth: 2)
        expect(subject.logger.to_s).to eql "INFO   a\n"
      end

      it "adds depth with option" do
        subject.log_info("a", depth: 2)
        expect(subject.logger.to_s).to eql "INFO   a\n"
      end

      it "uses logger from @options" do
        logger = LogTester.new
        logger.options[:logger] = RDF::Spec.logger
        logger.log_info("a")
        expect(logger.instance_variable_get(:@logger).to_s).to be_empty
        expect(logger.options[:logger].to_s).to eql "INFO a\n"
      end

      it "uses logger from options" do
        logger = LogTester.new
        l = RDF::Spec.logger
        logger.log_info("a", logger: l)
        expect(logger.instance_variable_get(:@logger).to_s).to be_empty
        expect(l.to_s).to eql "INFO a\n"
      end

      it "increments log_statistics" do
        subject.log_info("foo") rescue nil
        expect(subject.log_statistics[:info]).to eql 1
      end
    end

    describe "#log_debug" do
      it "Logs messages, and yield return" do
        subject.log_debug("a", "b") {"c"}
        expect(subject.logger.to_s).to eql "DEBUG a: b: c\n"
      end

      it "adds lineno" do
        subject.log_debug("a", lineno: 10)
        expect(subject.logger.to_s).to eql "DEBUG [line 10] a\n"
      end

      it "adds depth with option" do
        subject.log_debug("a", depth: 2)
        expect(subject.logger.to_s).to eql "DEBUG   a\n"
      end

      it "adds depth with option" do
        subject.log_debug("a", depth: 2)
        expect(subject.logger.to_s).to eql "DEBUG   a\n"
      end

      it "uses logger from @options" do
        logger = LogTester.new
        logger.options[:logger] = RDF::Spec.logger
        logger.log_debug("a")
        expect(logger.instance_variable_get(:@logger).to_s).to be_empty
        expect(logger.options[:logger].to_s).to eql "DEBUG a\n"
      end

      it "uses logger from options" do
        logger = LogTester.new
        l = RDF::Spec.logger
        logger.log_debug("a", logger: l)
        expect(logger.instance_variable_get(:@logger).to_s).to be_empty
        expect(l.to_s).to eql "DEBUG a\n"
      end

      it "increments log_statistics" do
        subject.log_debug("foo") rescue nil
        expect(subject.log_statistics[:debug]).to eql 1
      end
    end

    describe "#log_depth" do
      specify {expect {|b| subject.log_depth(&b)}.to yield_with_no_args}

      it "returns result of block" do
        expect(subject.log_depth {"foo"}).to eql "foo"
      end

      it "increments log_depth in block" do
        subject.log_depth do
          expect(subject.log_depth).to eql 1
        end
      end
    end
  end

  context "with $stderr" do
    subject {LogTester.new}

    it "sets logger to $stderr" do
      expect(subject.logger).to eq $stderr
    end

    it "forgets log_statistics between instances" do
      expect {subject.log_error "An error"}.to write("An error").to(:error)

      new_tester = LogTester.new
      expect(new_tester.log_statistics).to be_empty
      expect(subject.log_statistics).not_to be_empty
    end
  end

  context "with StringIO" do
    subject {LogTester.new(StringIO.new)}

    it "appends to StringIO" do
      subject.log_error("a")
      subject.logger.rewind
      expect(subject.logger.read).to eql "ERROR a\n"
    end
  end

  context "with Array" do
    subject {LogTester.new([])}

    it "appends to Array" do
      subject.log_error("a")
      expect(subject.logger).to eql ["ERROR a"]
    end
  end

  context "with false" do
    subject {LogTester.new(false)}

    it "Creates an Object logger" do
      subject.log_error("a")
      expect(subject.options).to have_key(:logger)
    end
  end
end
