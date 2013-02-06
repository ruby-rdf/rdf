require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Query::HashPatternNormalizer do
  context "new" do
    it "is instantiable" do
      lambda { RDF::Query::HashPatternNormalizer.new }.should_not raise_error
    end
  end
  
  context ".normalize" do
    before :each do
      @hash_pattern_normalizer = RDF::Query::HashPatternNormalizer.new
    end
    
    it "should raise error if outer-most object is not a hash-pattern" do
      expect { @hash_pattern_normalizer.normalize(42) }.to raise_error(ArgumentError)
      expect { @hash_pattern_normalizer.normalize({}) }.to_not raise_error(ArgumentError)
    end
    
    it "should be idempotent" do
      hash_pattern = {
        :foo => {
          :bar => :baz
        }
      }
      
      @hash_pattern_normalizer.normalize(hash_pattern).should == hash_pattern
      @hash_pattern_normalizer.normalize(@hash_pattern_normalizer.normalize(hash_pattern)).should == hash_pattern
    end
    
    it "should affect nested hash-patterns" do
      hash_pattern = {
        :foo => {
          :bar => {
            :baz => :qux
          }
        }
      }
      
      expected_hash_pattern = {
        :foo => {
          :bar => :__1__
        }, 
        :__1__ => {
          :baz => :qux
        }
      }
      
      @hash_pattern_normalizer.normalize(hash_pattern).should == expected_hash_pattern
    end
    
    it "should affect nested array-patterns" do
      hash_pattern = {
        :foo => {
          :bar => [
            {
              :baz => :qux
            },
            {
              :quux => :corge
            }
          ]
        }
      }
      
      expected_hash_pattern = {
        :foo => {
          :bar => [:__1__, :__2__]
        }, 
        :__1__ => {
          :baz => :qux
        }, 
        :__2__ => {
          :quux => :corge
        }
      }
      
      @hash_pattern_normalizer.normalize(hash_pattern).should == expected_hash_pattern
    end
  end
end
