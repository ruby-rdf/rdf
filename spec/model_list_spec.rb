require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::List do
  let(:empty) {RDF::List::NIL}
  let(:abc) {RDF::List[RDF::Literal.new('a'), RDF::Literal.new('b'), RDF::Literal.new('c')]}
  let(:ten) {RDF::List[*(1..10)]}

  ORDINALS = %w(first second third fourth fifth sixth seventh eighth ninth tenth)

  it "is comparable" do
    RDF::List.new.should be_a_kind_of(::Comparable)
  end

  it "is enumerable" do
    RDF::List.new.should be_a_kind_of(::Enumerable)
  end

  describe RDF::List, "[] without arguments" do
    it "constructs a new empty list" do
      RDF::List[].should be_an(RDF::List)
      RDF::List[].should be_empty
      RDF::List[].should == RDF::List::NIL
    end
  end

  describe RDF::List, "[] with arguments" do
    it "constructs a new non-empty list" do
      RDF::List[1, 2, 3].should be_an(RDF::List)
      RDF::List[1, 2, 3].should_not be_empty
    end

    it "accepts list arguments" do
      lambda { RDF::List[RDF::List[]] }.should_not raise_error
    end

    it "accepts array arguments" do
      lambda { RDF::List[[1]] }.should_not raise_error
      l1 = RDF::List[[1]]
      l1.size.should == 1
      l1.first.should be_a(RDF::Node)
      lambda { RDF::List.new(l1.first, l1.graph) }.should_not raise_error
      l2 = RDF::List.new(l1.first, l1.graph)
      l2.first.should == RDF::Literal(1)
    end

    it "accepts blank node arguments" do
      lambda { RDF::List[RDF::Node.new] }.should_not raise_error
    end

    it "accepts URI arguments" do
      lambda { RDF::List[RDF.nil] }.should_not raise_error
    end

    it "accepts nil arguments" do
      lambda { RDF::List[nil] }.should_not raise_error
    end

    it "accepts literal arguments" do
      lambda { RDF::List[RDF::Literal.new("Hello, world!", :language => :en)] }.should_not raise_error
    end

    it "accepts boolean arguments" do
      lambda { RDF::List[true, false] }.should_not raise_error
    end

    it "accepts string arguments" do
      lambda { RDF::List["foo", "bar"] }.should_not raise_error
    end

    it "accepts integer arguments" do
      lambda { RDF::List[1, 2, 3] }.should_not raise_error
    end

    it "accepts float arguments" do
      lambda { RDF::List[3.1415] }.should_not raise_error
    end

    it "accepts decimal arguments" do
      lambda { RDF::List[BigDecimal("3.1415")] }.should_not raise_error
    end

    it "accepts time arguments" do
      lambda { RDF::List[Time.now] }.should_not raise_error
    end

    it "accepts date arguments" do
      lambda { RDF::List[Date.new(2010)] }.should_not raise_error
    end

    it "accepts datetime arguments" do
      lambda { RDF::List[DateTime.new(2010)] }.should_not raise_error
    end
  end

  describe RDF::List, "#subject" do
    it "requires no arguments" do
      lambda { empty.subject }.should_not raise_error(ArgumentError)
    end

    it "returns a resource" do
      empty.subject.should be_a_resource
    end
  end

  describe RDF::List, "#graph" do
    it "requires no arguments" do
      lambda { empty.graph }.should_not raise_error(ArgumentError)
    end

    it "returns a graph" do
      empty.graph.should be_a_graph
    end
  end

  describe RDF::List, "#&" do
    it "accepts one argument" do
      lambda { empty & empty }.should_not raise_error(ArgumentError)
    end

    it "rejects fewer arguments" do
      lambda { empty.__send__(:&) }.should raise_error(ArgumentError)
    end

    it "returns the set intersection of self and the given argument" do
      (RDF::List[1, 2] & RDF::List[1, 2]).should == RDF::List[1, 2]
      (RDF::List[1, 2] & RDF::List[2, 3]).should == RDF::List[2]
      (RDF::List[1, 2] & RDF::List[3, 4]).should == RDF::List[]
    end
  end

  describe RDF::List, "#|" do
    it "accepts one argument" do
      lambda { empty | empty }.should_not raise_error(ArgumentError)
    end

    it "rejects fewer arguments" do
      lambda { empty.__send__(:|) }.should raise_error(ArgumentError)
    end

    it "returns the set union of self and the given argument" do
      (RDF::List[1, 2] | RDF::List[1, 2]).should == RDF::List[1, 2]
      (RDF::List[1, 2] | RDF::List[2, 3]).should == RDF::List[1, 2, 3]
      (RDF::List[1, 2] | RDF::List[3, 4]).should == RDF::List[1, 2, 3, 4]
    end
  end

  describe RDF::List, "#+" do
    it "accepts one argument" do
      lambda { empty + empty }.should_not raise_error(ArgumentError)
    end

    it "rejects fewer arguments" do
      lambda { empty.__send__(:+) }.should raise_error(ArgumentError)
    end

    it "returns the concatenation of self and the given argument" do
      (RDF::List[1, 2] + RDF::List[3, 4]).should == RDF::List[1, 2, 3, 4]
    end
  end

  describe RDF::List, "#-" do
    it "accepts one argument" do
      lambda { @nil - empty }.should_not raise_error(ArgumentError)
    end

    it "rejects fewer arguments" do
      lambda { empty.__send__(:-) }.should raise_error(ArgumentError)
    end

    it "returns the difference between self and the given argument" do
      (RDF::List[1, 2, 2, 3] - RDF::List[2]).should == RDF::List[1, 3]
    end
  end

  describe RDF::List, "#*" do
    it "accepts one argument" do
      lambda { empty * 1 }.should_not raise_error(ArgumentError)
    end

    it "rejects fewer arguments" do
      lambda { empty.__send__(:*) }.should raise_error(ArgumentError)
    end
  end

  describe RDF::List, "#* with an integer argument" do
    it "returns a repetition of self" do
      (RDF::List[1, 2, 3] * 2).should == RDF::List[1, 2, 3, 1, 2, 3]
    end
  end

  describe RDF::List, "#* with a string argument" do
    it "returns the string concatenation of all elements" do
      (RDF::List[1, 2, 3] * ",").should == "1,2,3"
    end
  end

  describe RDF::List, "#[]" do
    it "accepts one argument" do
      lambda { empty[0] }.should_not raise_error(ArgumentError)
    end

    it "rejects fewer arguments" do
      lambda { empty.__send__(:[]) }.should raise_error(ArgumentError)
    end

    it "returns a value for valid indexes" do
      ten[0].should be_a_value
    end

    it "returns nil for invalid indexes" do
      empty[0].should be_nil
      ten[20].should be_nil
    end
  end

  describe RDF::List, "#[]=" do
    it "needs work"
  end

  describe RDF::List, "#<<" do
    it "accepts one argument" do
      lambda { ten << 11 }.should_not raise_error(ArgumentError)
    end

    it "rejects fewer arguments" do
      lambda { ten.__send__(:<<) }.should raise_error(ArgumentError)
    end

    it "appends the new value at the tail of the list" do
      ten << 11
      ten.last.should == RDF::Literal.new(11)
    end

    it "increments the length of the list by one" do
      ten << 11
      ten.length.should == 11
    end

    it "returns self" do
      (ten << 11).should equal(ten)
    end
  end

  describe RDF::List, "#shift" do
    it "returns the first element from the list" do
      ten.shift.should == RDF::Literal.new(1)
    end

    it "removes the first element from the list" do
      ten.shift
      ten.should == RDF::List[2, 3, 4, 5, 6, 7, 8, 9, 10]
    end

    it "should return nil from an empty list" do
      empty.shift.should be_nil
    end
  end

  describe RDF::List, "#unshift" do
    it "adds element to beginning of list" do
      ten.unshift(0)
      ten.should == RDF::List[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    end

    it "should return the new list" do
      ten.unshift(0).should == RDF::List[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    end
  end

  describe RDF::List, "#clear" do
    it "empties list" do
      ten.clear.should == RDF::List[]
    end
  end

  describe RDF::List, "#eql?" do
    it "requires an argument" do
      lambda { empty.send(:eql?) }.should raise_error(ArgumentError)
    end

    it "returns true when given the same list" do
      ten.should eql(ten)
    end

    it "needs work"
  end

  describe RDF::List, "#<=>" do
    it "requires an argument" do
      lambda { empty.send(:<=>) }.should raise_error(ArgumentError)
    end

    it "returns 0 when given the same list" do
      ten.should == ten
    end
  end

  describe RDF::List, "#==" do
    it "requires an argument" do
      lambda { empty.send(:==) }.should raise_error(ArgumentError)
    end

    it "returns true when given the same list" do
      ten.should == ten
    end
  end

  describe RDF::List, "#===" do
    it "requires an argument" do
      lambda { empty.send(:===) }.should raise_error(ArgumentError)
    end

    it "returns true when given the same list" do
      ten.should == ten
    end

    it "needs work"
  end

  describe RDF::List, "#empty?" do
    it "requires no arguments" do
      lambda { empty.empty? }.should_not raise_error(ArgumentError)
    end

    it "returns a boolean" do
      empty.empty?.should be_true
      abc.empty?.should be_false
      ten.empty?.should be_false
    end
  end

  describe RDF::List, "#length" do
    it "requires no arguments" do
      lambda { empty.length }.should_not raise_error(ArgumentError)
    end

    it "returns an integer" do
      empty.length.should be_an(Integer)
    end

    it "returns the length of the list" do
      empty.length.should == 0
      abc.length.should == 3
      ten.length.should == 10
    end
  end

  describe RDF::List, "#size" do
    it "aliases #length" do
      empty.size.should == empty.length
      ten.size.should == ten.length
    end
  end

  describe RDF::List, "#index" do
    it "accepts one argument" do
      lambda { ten.index(nil) }.should_not raise_error(ArgumentError)
    end
  end

  describe RDF::List, "#slice using an element index" do
    it "accepts one argument" do
      lambda { ten.slice(0) }.should_not raise_error(ArgumentError)
    end

    it "returns a value" do
      ten.slice(0).should be_a_value
    end
  end

  describe RDF::List, "#slice using a start index and a length" do
    it "accepts two arguments" do
      lambda { ten.slice(0, 9) }.should_not raise_error(ArgumentError)
    end

    it "returns a value" do
      ten.slice(0, 9).should be_a_value
    end
  end

  describe RDF::List, "#slice using a range" do
    it "accepts one argument" do
      lambda { ten.slice(0..9) }.should_not raise_error(ArgumentError)
    end
  end

  describe RDF::List, "#fetch" do
    it "requires one argument" do
      lambda { ten.fetch }.should raise_error(ArgumentError)
      lambda { ten.fetch(0) }.should_not raise_error(ArgumentError)
    end

    it "returns a value" do
      ten.fetch(0).should be_a_value
    end

    it "returns the value at the given index" do
      ten.fetch(0).should == RDF::Literal.new(1)
      ten.fetch(9).should == RDF::Literal.new(10)
    end

    it "raises IndexError for invalid indexes" do
      lambda { ten.fetch(20) }.should raise_error(IndexError)
    end
  end

  describe RDF::List, "#fetch with a default value" do
    it "accepts two arguments" do
      lambda { ten.fetch(0, nil) }.should_not raise_error(ArgumentError)
    end

    it "returns the second argument for invalid indexes" do
      lambda { ten.fetch(20, nil) }.should_not raise_error(IndexError)
      ten.fetch(20, true).should == true
    end
  end

  describe RDF::List, "#fetch with a block" do
    it "yields to the given block for invalid indexes" do
      lambda { ten.fetch(20) { |index| } }.should_not raise_error(IndexError)
      ten.fetch(20) { |index| true }.should == true
    end
  end

  describe RDF::List, "#at" do
    it "accepts one argument" do
      lambda { ten.at(0) }.should_not raise_error(ArgumentError)
    end
  end

  describe RDF::List, "#nth" do
    it "aliases #at" do
      (1..10).each do |n|
        ten.nth(n).should == ten.at(n)
      end
    end
  end

  ORDINALS.each_with_index do |ordinal, index|
    describe RDF::List, "##{ordinal}" do
      it "requires no arguments" do
        lambda { ten.__send__(ordinal.to_sym) }.should_not raise_error(ArgumentError)
      end

      it "returns a value" do
        ten.__send__(ordinal.to_sym).should be_a_value
      end

      it "returns the #{ordinal} value in the list" do
        ten.__send__(ordinal.to_sym).should == RDF::Literal.new(index + 1)
      end
    end
  end

  describe RDF::List, "#last" do
    it "requires no arguments" do
      lambda { ten.last }.should_not raise_error(ArgumentError)
    end
  end

  describe RDF::List, "#rest" do
    it "requires no arguments" do
      lambda { ten.rest }.should_not raise_error(ArgumentError)
    end
  end

  describe RDF::List, "#tail" do
    it "requires no arguments" do
      lambda { ten.tail }.should_not raise_error(ArgumentError)
    end
  end

  describe RDF::List, "#first_subject" do
    it "requires no arguments" do
      lambda { ten.first_subject }.should_not raise_error(ArgumentError)
    end
  end

  describe RDF::List, "#rest_subject" do
    it "requires no arguments" do
      lambda { ten.rest_subject }.should_not raise_error(ArgumentError)
    end
  end

  describe RDF::List, "#last_subject" do
    it "requires no arguments" do
      lambda { ten.last_subject }.should_not raise_error(ArgumentError)
    end
  end

  describe RDF::List, "#each_subject without a block" do
    it "requires no arguments" do
      lambda { ten.each_subject }.should_not raise_error(ArgumentError)
    end

    it "returns an enumerator" do
      abc.each_subject.should be_an_enumerator
    end
  end

  describe RDF::List, "#each_subject with a block" do
    it "requires no arguments" do
      lambda { ten.each_subject { |subject| } }.should_not raise_error(ArgumentError)
    end

    it "yields all subject terms in the list" do
      count = 0
      ten.each_subject { |subject| count += 1 }
      count.should == 10
    end
  end

  describe RDF::List, "#each without a block" do
    it "requires no arguments" do
      lambda { ten.each }.should_not raise_error(ArgumentError)
    end

    it "returns an enumerator" do
      abc.each_subject.should be_an_enumerator
    end
  end

  describe RDF::List, "#each with a block" do
    it "requires no arguments" do
      lambda { ten.each { |value| } }.should_not raise_error(ArgumentError)
    end

    it "yields the correct number of times" do
      abc.each.count.should == 3
      ten.each.count.should == 10
    end
  end

  describe RDF::List, "#each_statement without a block" do
    it "requires no arguments" do
      lambda { ten.each_statement }.should_not raise_error(ArgumentError)
    end

    it "returns an enumerator" do
      abc.each_subject.should be_an_enumerator
    end
  end

  describe RDF::List, "#each_statement with a block" do
    it "requires no arguments" do
      lambda { ten.each_statement { |statement| } }.should_not raise_error(ArgumentError)
    end

    it "yields the correct number of times" do
      abc.each_statement.count.should == 3 * 2
      ten.each_statement.count.should == 10 * 2
    end

    it "yields statements" do
      ten.each_statement do |statement|
        statement.should be_a_statement
      end
    end
  end

  describe RDF::List, "#join" do
    it "requires no arguments" do
      lambda { empty.join }.should_not raise_error(ArgumentError)
    end

    it "accepts one argument" do
      lambda { empty.join(', ') }.should_not raise_error(ArgumentError)
    end

    it "returns a string" do
      ten.join.should be_a(String)
    end

    it "returns a particular string" do
      ten.join.should == '12345678910'
      ten.join(',').should == '1,2,3,4,5,6,7,8,9,10'
    end
  end

  describe RDF::List, "#reverse" do
    it "requires no arguments" do
      lambda { empty.reverse }.should_not raise_error(ArgumentError)
    end

    it "returns a list" do
      ten.reverse.should be_a_list
    end

    it "returns the values reversed" do
      ten.reverse.first.should == RDF::Literal.new(10)
    end
  end

  describe RDF::List, "#sort without a block" do
    it "requires no arguments" do
      lambda { empty.sort }.should_not raise_error(ArgumentError)
    end

    it "returns a list" do
      ten.sort.should be_a_list
    end
  end

  describe RDF::List, "#sort with a block" do
    it "requires no arguments" do
      lambda { empty.sort { |a, b| } }.should_not raise_error(ArgumentError)
    end

    it "returns a list" do
      ten.sort { |a, b| a <=> b }.should be_a_list
    end
  end

  describe RDF::List, "#sort_by with a block" do
    it "requires no arguments" do
      lambda { empty.sort_by { |value| } }.should_not raise_error(ArgumentError)
    end

    it "returns a list" do
      ten.sort_by(&:to_i).should be_a_list
    end
  end

  describe RDF::List, "#uniq" do
    it "requires no arguments" do
      lambda { empty.uniq }.should_not raise_error(ArgumentError)
    end

    it "returns a list" do
      ten.uniq.should be_a_list
    end

    it "returns a list with duplicate values removed" do
      RDF::List[1, 2, 2, 3].uniq.should == RDF::List[1, 2, 3]
    end
  end

  describe RDF::List, "#to_a" do
    it "requires no arguments" do
      lambda { empty.to_a }.should_not raise_error(ArgumentError)
    end

    it "returns an array" do
      empty.to_a.should be_an(Array)
    end

    it "returns an array of the correct size" do
      empty.to_a.size.should == empty.length
      abc.to_a.size.should == abc.length
      ten.to_a.size.should == ten.length
    end
  end

  describe RDF::List, "#to_set" do
    it "requires no arguments" do
      lambda { empty.to_set }.should_not raise_error(ArgumentError)
    end

    it "returns a set" do
      empty.to_set.should be_a(Set)
    end

    it "returns a set of the correct size" do
      empty.to_set.size.should == empty.length
      abc.to_set.size.should == abc.length
      ten.to_set.size.should == ten.length
    end

    it "returns a set without duplicates" do
      RDF::List[1, 2, 2, 3].to_set.map(&:to_i).sort.should == [1, 2, 3]
    end
  end

  describe RDF::List, "#to_s" do
    it "requires no arguments" do
      lambda { empty.to_s }.should_not raise_error(ArgumentError)
    end

    it "returns a string" do
      empty.to_s.should be_a(String)
    end
  end

  describe RDF::List, "#inspect" do
    it "requires no arguments" do
      lambda { empty.inspect }.should_not raise_error(ArgumentError)
    end

    it "returns a string" do
      empty.inspect.should be_a(String)
    end
  end

  describe RDF::List::NIL do
    it "#subject returns rdf:nil" do
      RDF::List::NIL.subject.should == RDF.nil
    end

    it "#frozen? returns true" do
      RDF::List::NIL.frozen?.should be_true
    end

    it "#empty? returns true" do
      RDF::List::NIL.empty?.should be_true
    end

    it "#[] returns an empty array" do
      RDF::List::NIL.to_a.should == []
    end

    it "#inspect returns the constant name" do
      RDF::List::NIL.inspect.should == 'RDF::List::NIL'
    end
  end

  context "Error cases" do
    context "RDFa List construction" do
      let(:list) {RDF::List.new}
      before(:each) do
        list << RDF::Literal("Foo")
      end
      subject {list}
      its(:statements) do
        list.each_statement do |s|
          s.subject.should be_a_node
          s.should be_valid
        end
      end
    end

    context "Turtle List construction" do
      subject {RDF::List.new(RDF::Node("n"), nil, %w(a))}
      its(:length) {should == 1}
    end
  end

  context "Examples" do
    subject {RDF::List[1, 2, 3]}
    it "Constructing a new list" do
      subject.should be_a_list
      RDF::List[].should be_a_list
      RDF::List[*(1..10)].should be_a_list
      subject.should be_a_list
      RDF::List["foo", "bar"].should be_a_list
      RDF::List["a", 1, "b", 2, "c", 3].should be_a_list
    end

    describe(:&) do
      it "conjunction of lists" do
        {
          (RDF::List[1, 2] & RDF::List[1, 2])       => RDF::List[1, 2],
          (RDF::List[1, 2] & RDF::List[2, 3])       => RDF::List[2],
          (RDF::List[1, 2] & RDF::List[3, 4])       => RDF::List[],
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:|) do
      it "union of lists" do
        {
          (RDF::List[1, 2] | RDF::List[1, 2])       => RDF::List[1, 2],
          (RDF::List[1, 2] | RDF::List[2, 3])       => RDF::List[1, 2, 3],
          (RDF::List[1, 2] | RDF::List[3, 4])       => RDF::List[1, 2, 3, 4],
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:+) do
      it "sum of lists" do
        {
          (RDF::List[1, 2] + RDF::List[3, 4])       => RDF::List[1, 2, 3, 4],
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:-) do
      it "difference of lists" do
        {
          (RDF::List[1, 2, 2, 3] - RDF::List[2])       => RDF::List[1, 3],
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:*) do
      it "multiplicity of lists" do
        {
          (subject * 2)       => RDF::List[1, 2, 3, 1, 2, 3],
          (subject * "," )    => "1,2,3",
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:[]) do
      it "index of lists" do
        {
          subject[0] => RDF::Literal(1)
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:<<) do
      it "append to list" do
        {
          (RDF::List[] << 1 << 2 << 3) => subject
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:<=>) do
      it "compare lists" do
        {
          (RDF::List[1] <=> RDF::List[1]) => 0,
          (RDF::List[1] <=> RDF::List[2]) => -1,
          (RDF::List[2] <=> RDF::List[1]) => 1,
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:empty?) do
      it "is empty" do
        {
          RDF::List[].empty?        => true,
          subject.empty? => false,
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:length) do
      it "is what it is" do
        {
          RDF::List[].length        => 0,
          subject.length => 3,
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:index) do
      it "is what it is" do
        {
          RDF::List['a', 'b', 'c'].index('a') => 0,
          RDF::List['a', 'b', 'c'].index('d') => nil,
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:slice) do
      it "slices lists" do
        {
          subject.slice(0)    => RDF::Literal(1),
          subject.slice(0, 2) => RDF::List[1, 2],
          subject.slice(0..2) => RDF::List[1, 2, 3]
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:fetch) do
      it "fetches lists" do
        {
          subject.fetch(0)             => RDF::Literal(1),
          subject.fetch(4, nil)        => nil,
          subject.fetch(4) { |n| n*n } => 16,
        }.each do |input, output|
          input.should == output
        end
        lambda {subject.fetch(4).should raise_error(IndexError)}
      end
    end

    describe(:at) do
      it "returns element" do
        {
          subject.at(0)             => RDF::Literal(1),
          subject.at(4)             => nil,
        }.each do |input, output|
          input.should == output
        end
      end
    end

    context "offsets" do
      {
        :first => 1,
        :second => 2,
        :third => 3,
        :fourth => 4,
        :fifth => 5,
        :sixth => 6,
        :seventh => 7,
        :eighth => 8,
        :ninth => 9,
        :tenth => 10,
        :last => 10,
        :rest => RDF::List[2, 3, 4, 5, 6, 7, 8, 9, 10],
        :tail => RDF::List[10],
      }.each do |method, value|
        describe "##{method}" do
          it do
            v = value.is_a?(RDF::Value) ? value : RDF::Literal(value)
            ten.send(method).should == v
          end
        end
      end
    end

    describe(:first_subject) do
      it "BNode of first subject" do
        r = subject.first_subject
        r.should be_a_node
        subject.graph.first_object(:subject => r, :predicate => RDF.first).should == RDF::Literal(1)
      end
    end

    describe(:rest_subject) do
      it "BNode of rest subject" do
        r = subject.rest_subject
        r.should be_a_node
        subject.graph.first_object(:subject => r, :predicate => RDF.first).should == RDF::Literal(2)
      end
    end

    describe(:last_subject) do
      it "BNode of last subject" do
        r = subject.last_subject
        r.should be_a_node
        subject.graph.first_object(:subject => r, :predicate => RDF.rest).should == RDF.nil
      end
    end

    describe(:each_subject) do
      it "yields nodes" do
        expect {|b| subject.each_subject(&b)}.to yield_successive_args(RDF::Node, RDF::Node, RDF::Node)
      end
    end

    describe(:each) do
      it "yields values" do
        expect {|b| subject.each(&b)}.to yield_successive_args(*subject.to_a)
      end
    end

    describe(:each_statement) do
      it "yields statements" do
        expect {|b| subject.each_statement(&b)}.to yield_successive_args(*([RDF::Statement] * 6))
      end
    end

    describe(:join) do
      it "joins elements" do
        {
          subject.join       => subject.to_a.join,
          subject.join(", ") => subject.to_a.join(", "),
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:reverse) do
      it "reverses elements" do
        {
          subject.reverse       => RDF::List[*subject.to_a.reverse],
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:sort) do
      it "sorts elements" do
        {
          RDF::List[2, 3, 1].sort => RDF::List[1, 2, 3]
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:sort_by) do
      it "sorts elements" do
        {
          RDF::List[2, 3, 1].sort_by(&:to_i) => RDF::List[1, 2, 3]
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:uniq) do
      it "uniquifies elements" do
        {
          RDF::List[1, 2, 2, 3].uniq => RDF::List[1, 2, 3]
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:to_a) do
      it "de-lists elements" do
        {
          RDF::List[].to_a        => [],
          RDF::List[1, 2, 3].to_a => [RDF::Literal(1), RDF::Literal(2), RDF::Literal(3)],
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:to_set) do
      it "de-lists elements" do
        {
          RDF::List[1, 2, 3].to_set               => Set[RDF::Literal(1), RDF::Literal(2), RDF::Literal(3)]
        }.each do |input, output|
          input.should == output
        end
      end
    end

    describe(:to_s) do
      it "serializes elements" do
        {
          RDF::List[].to_s        => "RDF::List[]",
          RDF::List[1, 2, 3].to_s => "RDF::List[1, 2, 3]",
        }.each do |input, output|
          input.should == output
        end
      end
    end
  end
end
