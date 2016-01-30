module RDF
  ##
  # An RDF Dataset
  #
  # Datasets are immutable by default. {RDF::Repository} provides an interface 
  # for mutable Datasets.
  # 
  # @see https://www.w3.org/TR/rdf11-concepts/#section-dataset
  # @see https://www.w3.org/TR/rdf11-datasets/
  class Dataset
    include RDF::Countable
    include RDF::Enumerable
    include RDF::Queryable

    ISOLATION_LEVELS = [ :read_uncommitted, 
                         :read_committed, 
                         :repeatable_read, 
                         :snapshot, 
                         :serializable].freeze

    ##
    # Returns a developer-friendly representation of this object.
    #
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(%s)>", self.class.name, __id__, uri.to_s)
    end

    ##
    # Outputs a developer-friendly representation of this object to
    # `stderr`.
    #
    # @return [void]
    def inspect!
      each_statement { |statement| statement.inspect! }
      nil
    end
    
    ##
    # @return [Symbol] a representation of the isolation level for reads of this
    #   Dataset. One of `:read_uncommitted`, `:read_committed`, `:repeatable_read`, 
    #  `:snapshot`, or `:serializable`.
    def isolation_level
      :read_committed
    end
  end
end
