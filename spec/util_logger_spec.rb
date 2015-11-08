require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Util::Logger do
  class LogTester
    include RDF::Util::Logger
    attr_accessor :logger, :options

    def initialize(logger = nil)
      @logger = logger
      @options = {}
    end
  end

  context "with Spec Logger" do
    subject {LogTester.new(RDF::Spec.logger)}

    describe "#log_fatal" do
      specify {expect {subject.log_fatal("foo", "bar")}.to raise_error(StandardError, "foo")}

      it "raises provided exception" do
        expect {subject.log_fatal("foo", exception: RDF::ReaderError)}.to raise_error(RDF::ReaderError, "foo")
      end

      it "adds locaton to log message" do
        expect {subject.log_fatal("foo")}.to raise_error(StandardError)
        expect(subject.logger.to_s).to match /Called from #{File.expand_path("", __FILE__)}:#{__LINE__-1}/
      end
    end

    describe "#log_error" do
      specify {expect {subject.log_error("foo")}.not_to raise_error}
      it "raises provided exception" do
        expect {subject.log_error("foo", exception: RDF::ReaderError)}.to raise_error(RDF::ReaderError, "foo")
      end

      it "Logs messages, and yield return" do
        subject.log_error("a", "b") {"c"}
        expect(subject.logger.to_s).to eql "a: b: c\n"
      end

      it "Does not log errors while recovering" do
        subject.log_error("a")
        subject.log_error("b")
        subject.log_recover
        subject.log_error("c")
        expect(subject.logger.to_s).to eql "a\nc\n"
      end
    end

    describe "#log_info" do
      it "Logs messages, and yield return" do
        subject.log_info("a", "b") {"c"}
        expect(subject.logger.to_s).to eql "a: b: c\n"
      end

      it "adds lineno" do
        subject.log_info("a", lineno: 10)
        expect(subject.logger.to_s).to eql "[10] a\n"
      end

      it "adds depth with option" do
        subject.log_info("a", log_depth: 2)
        expect(subject.logger.to_s).to eql "  a\n"
      end

      it "adds depth with @option" do
        subject.options[:log_depth] = 2
        subject.log_info("a")
        expect(subject.logger.to_s).to eql "  a\n"
      end

      it "uses logger from @options" do
        logger = LogTester.new
        logger.options[:logger] = RDF::Spec.logger
        logger.log_info("a")
        expect(logger.logger.to_s).to be_empty
        expect(logger.options[:logger].to_s).to eql "a\n"
      end

      it "uses logger from options" do
        logger = LogTester.new
        l = RDF::Spec.logger
        logger.log_info("a", logger: l)
        expect(logger.logger.to_s).to be_empty
        expect(l.to_s).to eql "a\n"
      end
    end

    describe "#log_depth" do
      it "sets @options[:log_depth]" do
        expect{subject.log_depth {}}.to change{subject.options[:log_depth]}.from(nil).to(0)
      end

      it "sets options[:log_depth]" do
        options = {}
        expect{subject.log_depth(options) {}}.to change{options[:log_depth]}.from(nil).to(0)
      end

      specify {expect {|b| subject.log_depth(&b)}.to yield_with_no_args}

      it "returns result of block" do
        expect(subject.log_depth {"foo"}).to eql "foo"
      end

      it "increments @options[:log_depth] in block" do
        subject.log_depth do
          expect(subject.options[:log_depth]).to eql 1
        end
      end
    end
  end

  context "with StringIO" do
    subject {LogTester.new(StringIO.new)}

    it "appends to StringIO" do
      subject.log_info("a")
      subject.logger.rewind
      expect(subject.logger.read).to eql "a"
    end
  end

  context "with Array" do
    subject {LogTester.new([])}

    it "appends to Array" do
      subject.log_info("a")
      expect(subject.logger).to eql ["a"]
    end
  end
end
