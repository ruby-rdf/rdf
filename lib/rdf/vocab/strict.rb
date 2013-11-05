require 'rdf/vocab'

module RDF
  def self.StrictVocabulary(prefix)
    StrictVocabulary.create(prefix)
  end

  # Represents an RDF Vocabulary. The difference from {RDF::Vocabulary} is that
  # that every concept in the vocabulary is required to be declared. To assist
  # in this, an existing RDF representation of the vocabulary can be loaded as
  # the basis for concepts being available
  class StrictVocabulary < Vocabulary
    class << self
      begin
        # Redefines method_missing to the original definition
        # By remaining a subclass of Vocabulary, we remain available to
        # Vocabulary::each etc.
        define_method(:method_missing, BasicObject.instance_method(:method_missing))
      rescue NameError
        define_method(:method_missing, Kernel.instance_method(:method_missing))
      end

      def property(name)
        prop = RDF::URI.intern([to_s, name.to_s].join(''))
        @@properties[prop] = true
        (
          class << self; self; end).send(:define_method, name) { prop } # class method
      end

      def [](name)
        prop = RDF::URI.intern([to_s, name.to_s].join(''))
        @@properties.fetch(prop) #raises KeyError on missing value
        return prop
      end

      # Builds a graph of the vocabulary - properties are defined on the
      # completed graph
      def graph
        graph = RDF::Graph.new
        yield graph
        from_graph(graph)
      end

      # Uses a graph to define the vocabulary object
      def from_graph(graph)
        properties = RDF::Query.new do
          pattern [:resource, RDF.type, RDF.Property]
          pattern [:resource, RDFS.label, :label], :optional => true
          pattern [:resource, RDFS.comment, :comment], :optional => true
        end

        classes = RDF::Query.new do
          pattern [:resource, RDF.type, RDFS.Class]
          pattern [:resource, RDFS.label, :label], :optional => true
          pattern [:resource, RDFS.comment, :comment], :optional => true
        end

        graph.query(properties) do |prop|
          from_solution(prop)
        end

        graph.query(classes) do |klass|
          from_solution(klass)
        end
      end

      # @private
      def from_solution(solution)
        prefix_match = %r{\A#{self.to_s}(.*)}
        return if (match = prefix_match.match(solution.resource)).nil?
        name = match[1]

        property name

        begin
          @@labels[solution.resource] = solution.label
        rescue NoMethodError => nme
        end

        begin
          @@comments[solution.resource] = solution.comment
        rescue NoMethodError
        end
      end

      @@properties = {}
      @@labels = {}
      @@comments = {}

      # @return [String] The label for the named property
      def label_for(name)
        @@labels[self[name]]
      end

      # @return [String] The comment for the named property
      def comment_for(name)
        @@comments[self[name]]
      end
    end

    begin
      define_method(:method_missing, BasicObject.instance_method(:method_missing))
    rescue NameError
      define_method(:method_missing, Kernel.instance_method(:method_missing))
    end
  end
end
