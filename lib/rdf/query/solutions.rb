module RDF; class Query
  ##
  # An RDF basic graph pattern (BGP) query solution sequence.
  #
  # @example Filtering solutions using a hash
  #   solutions.filter(:author  => RDF::URI("http://ar.to/#self"))
  #   solutions.filter(:author  => "Arto Bendiken")
  #   solutions.filter(:author  => [RDF::URI("http://ar.to/#self"), "Arto Bendiken"])
  #   solutions.filter(:updated => RDF::Literal(Date.today))
  #
  # @example Filtering solutions using a block
  #   solutions.filter { |solution| solution.author.literal? }
  #   solutions.filter { |solution| solution.title =~ /^SPARQL/ }
  #   solutions.filter { |solution| solution.price < 30.5 }
  #   solutions.filter { |solution| solution.bound?(:date) }
  #   solutions.filter { |solution| solution.age.datatype == RDF::XSD.integer }
  #   solutions.filter { |solution| solution.name.language == :es }
  #
  # @example Reordering solutions based on a variable
  #   solutions.order_by(:updated)
  #   solutions.order_by(:updated, :created)
  #
  # @example Selecting particular variables only
  #   solutions.select(:title)
  #   solutions.select(:title, :description)
  #
  # @example Eliminating duplicate solutions
  #   solutions.distinct
  #
  # @example Limiting the number of solutions
  #   solutions.offset(20).limit(10)
  #
  # @example Counting the number of matching solutions
  #   solutions.count
  #   solutions.count { |solution| solution.price < 30.5 }
  #
  # @example Iterating over all found solutions
  #   solutions.each { |solution| puts solution.inspect }
  #
  # @since 0.3.0
  class Solutions < Array
    alias_method :each_solution, :each

    ##
    # Returns the number of matching query solutions.
    #
    # @overload count
    #   @return [Integer]
    #
    # @overload count { |solution| ... }
    #   @yield  [solution]
    #   @yieldparam  [RDF::Query::Solution] solution
    #   @yieldreturn [Boolean]
    #   @return [Integer]
    #
    # @return [Integer]
    def count(&block)
      super
    end

    ##
    # Filters this solution sequence by the given `criteria`.
    #
    # @param  [Hash{Symbol => Object}] criteria
    # @yield  [solution]
    # @yieldparam  [RDF::Query::Solution] solution
    # @yieldreturn [Boolean]
    # @return [void] `self`
    def filter(criteria = {}, &block)
      if block_given?
        self.reject! do |solution|
          !block.call(solution.is_a?(Solution) ? solution : Solution.new(solution))
        end
      else
        self.reject! do |solution|
          solution = solution.is_a?(Solution) ? solution : Solution.new(solution)
          results = criteria.map do |name, value|
            solution[name] == value
          end
          !results.all?
        end
      end
      self
    end
    alias_method :filter!, :filter

    ##
    # Reorders this solution sequence by the given `variables`.
    #
    # @param  [Array<Symbol, #to_sym>] variables
    # @return [void] `self`
    def order(*variables)
      if variables.empty?
        raise ArgumentError, "wrong number of arguments (0 for 1)"
      else
        # TODO: support for descending sort, e.g. `order(:s => :asc, :p => :desc)`
        variables.map!(&:to_sym)
        self.sort! do |a, b|
          a = variables.map { |variable| a[variable].to_s } # FIXME
          b = variables.map { |variable| b[variable].to_s } # FIXME
          a <=> b
        end
      end
      self
    end
    alias_method :order_by, :order

    ##
    # Restricts this solution sequence to the given `variables` only.
    #
    # @param  [Array<Symbol, #to_sym>] variables
    # @return [void] `self`
    def project(*variables)
      if variables.empty?
        raise ArgumentError, "wrong number of arguments (0 for 1)"
      else
        variables.map!(&:to_sym)
        self.each do |solution|
          solution.bindings.delete_if { |k, v| !variables.include?(k.to_sym) }
        end
      end
      self
    end
    alias_method :select, :project

    ##
    # Ensures that the solutions in this solution sequence are unique.
    #
    # @return [void] `self`
    def distinct
      self.uniq!
      self
    end
    alias_method :distinct!, :distinct
    alias_method :reduced,   :distinct
    alias_method :reduced!,  :distinct

    ##
    # Limits this solution sequence to bindings starting from the `start`
    # offset in the overall solution sequence.
    #
    # @param  [Integer, #to_i] start
    #   zero or a positive or negative integer
    # @return [void] `self`
    def offset(start)
      case start = start.to_i
        when 0 then nil
        else self.slice!(0...start)
      end
      self
    end
    alias_method :offset!, :offset

    ##
    # Limits the number of solutions in this solution sequence to a maximum
    # of `length`.
    #
    # @param  [Integer, #to_i] length
    #   zero or a positive integer
    # @return [void] `self`
    # @raise  [ArgumentError] if `length` is negative
    def limit(length)
      length = length.to_i
      raise ArgumentError, "expected zero or a positive integer, got #{length}" if length < 0
      case length
        when 0 then self.clear
        else self.slice!(length..-1) if length < self.size
      end
      self
    end
    alias_method :limit!, :limit
  end # Solutions
end; end # RDF::Query
