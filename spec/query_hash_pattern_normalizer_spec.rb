require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Query::HashPatternNormalizer do
  context "new" do
    it "is instantiable" do
      expect { RDF::Query::HashPatternNormalizer.new }.not_to raise_error
    end
  end
  
  context ".normalize!" do
    subject {RDF::Query::HashPatternNormalizer.new}
    
    it "should raise an error if outer-most object is not a hash-pattern" do
      expect { subject.normalize!(42) }.to raise_error(ArgumentError)
      expect { subject.normalize!({}) }.to_not raise_error
    end
    
    it "should be idempotent" do
      hash_pattern = {
        foo: {
          bar: :baz
        }
      }
      
      expect(subject.normalize!(hash_pattern)).to eq hash_pattern
      expect(subject.normalize!(subject.normalize!(hash_pattern))).to eq hash_pattern
    end
    
    it "should normalize nested hash-patterns" do
      hash_pattern = {
        foo: {
          bar: {
            baz: :qux
          }
        }
      }
      
      expected_hash_pattern = {
        foo: {
          bar: :__1__
        }, 
        __1__: {
          baz: :qux
        }
      }
      
      expect(subject.normalize!(hash_pattern)).to eq expected_hash_pattern
    end
    
    it "should normalize nested array-patterns" do
      hash_pattern = {
        foo: {
          bar: [
            {
              baz: :qux
            },
            {
              quux: :corge
            }
          ]
        }
      }
      
      expected_hash_pattern = {
        foo: {
          bar: [:__1__, :__2__]
        }, 
        __1__: {
          baz: :qux
        }, 
        __2__: {
          quux: :corge
        }
      }
      
      expect(subject.normalize!(hash_pattern)).to eq expected_hash_pattern
    end
  end
end
