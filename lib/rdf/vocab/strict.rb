require 'rdf/vocab'

module RDF
  def self.StrictVocabulary(prefix)
    StrictVocabulary.create(prefix)
  end

  class StrictVocabulary < Vocabulary
    class << self
      begin
        define_method(:method_missing, BasicObject.instance_method(:method_missing))
      rescue NameError
        define_method(:method_missing, Kernel.instance_method(:method_missing))
      end

      def graph
        graph = RDF::Graph.new
        yield graph
        from_graph(graph)
      end

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

      @@labels = {}
      @@comments = {}

      def label_for(name)
        @@labels[self[name]]
      end

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
