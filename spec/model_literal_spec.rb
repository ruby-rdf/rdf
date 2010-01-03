require 'rdf'

describe RDF::Literal do
  XSD = RDF::XSD

  context "plain literals" do
    before :each do
      @empty = RDF::Literal.new('')
      @hello = RDF::Literal.new('Hello')
      @all   = [@empty, @hello]
    end

    it "should be instantiable" do
      lambda { RDF::Literal.new('') }.should_not raise_error
      @all.each do |literal|
        literal.plain?.should be_true
      end
    end

    it "should not have a language" do
      @all.each do |literal|
        literal.language.should be_nil
      end
    end

    it "should not have a datatype" do
      @all.each do |literal|
        literal.typed?.should be_false
        literal.datatype.should be_nil
      end
    end

    it "should support equality comparisons" do
      @all.each do |literal|
        copy = RDF::Literal.new(literal.value)
        literal.should eql(copy)
        literal.should == copy

        literal.should_not eql(literal.value)
        literal.should == literal.value # FIXME
      end
    end

    it "should have a string representation" do
      @empty.to_s.should eql('""')
      @hello.to_s.should eql('"Hello"')
    end
  end

  context "languaged-tagged literals" do
    before :each do
      @empty = RDF::Literal.new('', :language => :en)
      @hello = RDF::Literal.new('Hello', :language => :en)
      @all   = [@empty, @hello]
    end

    it "should be instantiable" do
      lambda { RDF::Literal.new('', :language => :en) }.should_not raise_error
    end

    it "should have a language" do
      @all.each do |literal|
        literal.language.should_not be_nil
        literal.language.should == :en
      end
    end

    it "should not have a datatype" do
      @all.each do |literal|
        literal.typed?.should be_false
        literal.datatype.should be_nil
      end
    end

    it "should support equality comparisons" do
      @all.each do |literal|
        copy = RDF::Literal.new(literal.value, :language => literal.language)
        literal.should eql(copy)
        literal.should == copy
      end
    end

    it "should have a string representation" do
      @empty.to_s.should eql('""@en')
      @hello.to_s.should eql('"Hello"@en')
    end
  end

  context "datatyped literals" do
    require 'date'

    before :each do
      @string   = RDF::Literal.new('')
      @false    = RDF::Literal.new(false)
      @true     = RDF::Literal.new(true)
      @int      = RDF::Literal.new(123)
      @long     = RDF::Literal.new(9223372036854775807)
      @double   = RDF::Literal.new(3.1415)
      @time     = RDF::Literal.new(Time.now)
      @date     = RDF::Literal.new(Date.new(2010))
      @datetime = RDF::Literal.new(DateTime.new(2010))
      @all      = [@false, @true, @int, @long, @double, @time, @date, @datetime]
    end

    it "should be instantiable" do
      lambda { RDF::Literal.new(123) }.should_not raise_error
      lambda { RDF::Literal.new(123, :datatype => XSD.int) }.should_not raise_error
    end

    it "should not have a language" do
      @all.each do |literal|
        literal.language.should be_nil
      end
    end

    it "should have a datatype" do
      @all.each do |literal|
        literal.typed?.should be_true
        literal.datatype.should_not be_nil
      end
    end

    it "should support implicit datatyping" do
      @string.datatype.should == nil
      @false.datatype.should == XSD.boolean
      @true.datatype.should == XSD.boolean
      @int.datatype.should == XSD.int
      @long.datatype.should == XSD.long
      @double.datatype.should == XSD.double
      @time.datatype.should == XSD.dateTime
      @date.datatype.should == XSD.date
      @datetime.datatype.should == XSD.dateTime
    end

    it "should support equality comparisons" do
      @all.each do |literal|
        copy = RDF::Literal.new(literal.value, :datatype => literal.datatype)
        literal.should eql(copy)
        literal.should == copy
      end
    end

    it "should have a string representation" do
      @false.to_s.should eql('"false"^^<http://www.w3.org/2001/XMLSchema#boolean>')
      @true.to_s.should eql('"true"^^<http://www.w3.org/2001/XMLSchema#boolean>')
      @int.to_s.should eql('"123"^^<http://www.w3.org/2001/XMLSchema#int>')
      @long.to_s.should eql('"9223372036854775807"^^<http://www.w3.org/2001/XMLSchema#long>')
      @double.to_s.should eql('"3.1415"^^<http://www.w3.org/2001/XMLSchema#double>')
      @date.to_s.should eql('"2010-01-01"^^<http://www.w3.org/2001/XMLSchema#date>')
      @datetime.to_s.should eql('"2010-01-01T00:00:00+00:00"^^<http://www.w3.org/2001/XMLSchema#dateTime>') # FIXME
    end
  end
end
