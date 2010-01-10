require 'spec'

module RDF
  ##
  # RDF extensions for RSpec.
  #
  # @see http://rspec.info/
  module Spec
    ##
    # RDF matchers for RSpec.
    #
    # @see http://rspec.rubyforge.org/rspec/1.2.9/classes/Spec/Matchers.html
    module Matchers
      ##
      # Defines a new RSpec matcher.
      #
      # @param  [Symbol] name
      # @return [void]
      def self.define(name, &declarations)
        define_method name do |*expected|
          ::Spec::Matchers::Matcher.new(name, *expected, &declarations)
        end
      end

      define :be_a_statement do
        match do |statement|
          statement.should be_instance_of(RDF::Statement)
          statement.subject.should be_a_kind_of(RDF::Resource)
          statement.predicate.should be_a_kind_of(RDF::URI)
          statement.object.should be_a_kind_of(RDF::Value) unless statement.object.is_a?(String) # FIXME
          true
        end
      end

      define :be_a_triple do
        match do |triple|
          triple.should be_instance_of(Array)
          triple.size.should == 3
          triple[0].should be_a_kind_of(RDF::Resource)
          triple[1].should be_a_kind_of(RDF::URI)
          triple[2].should be_a_kind_of(RDF::Value) unless triple[2].is_a?(String) # FIXME
          true
        end
      end

      define :be_a_quad do
        match do |quad|
          quad.should be_instance_of(Array)
          quad.size.should == 4
          quad[0].should be_a_kind_of(RDF::Resource)
          quad[1].should be_a_kind_of(RDF::URI)
          quad[2].should be_a_kind_of(RDF::Value) unless quad[2].is_a?(String) # FIXME
          quad[3].should be_a_kind_of(RDF::Resource) unless quad[3].nil?
          true
        end
      end

      define :be_a_resource do
        match do |value|
          value.should be_a_kind_of(RDF::Resource)
          true
        end
      end

      define :be_a_uri do
        match do |value|
          value.should be_a_kind_of(RDF::URI)
          true
        end
      end

      define :be_a_value do
        match do |value|
          value.should be_a_kind_of(RDF::Value) unless value.is_a?(String) # FIXME
          true
        end
      end

      define :be_a_vocabulary do |base_uri|
        match do |vocabulary|
          vocabulary.should be_a_kind_of(Module)
          vocabulary.should respond_to(:to_uri)
          vocabulary.to_uri.to_s.should == base_uri
          vocabulary.should respond_to(:[])
          true
        end
      end

      define :have_properties do |base_uri, properties|
        match do |vocabulary|
          properties.map(&:to_sym).each do |property|
            vocabulary[property].should be_a_uri
            vocabulary[property].to_s.should == "#{base_uri}#{property}"
            #vocabulary.should respond_to(property) # FIXME
            lambda { vocabulary.send(property) }.should_not raise_error
            vocabulary.send(property).should be_a_uri
            vocabulary.send(property.to_s).should be_a_uri
            vocabulary.send(property).to_s.should == "#{base_uri}#{property}"
          end
          true
        end
      end

      define :have_subclasses do |base_uri, klasses|
        match do |vocabulary|
          klasses.map(&:to_sym).each do |klass|
            # TODO
          end
          true
        end
      end

      define :be_a_repository do
        match do |repository|
          repository.should be_a_kind_of(RDF::Repository)
          true
        end
      end

      define :be_a_repository_of_size do |size|
        match do |repository|
          repository.should be_a_repository
          repository.size == size
        end
      end

      define :have_predicate do |predicate, count|
        match do |queryable|
          if count.nil?
            queryable.has_predicate?(predicate)
          else
            queryable.query([nil, predicate, nil]).size == count
          end
        end
      end
    end # module Matchers
  end # module Spec
end # module RDF
