module RDF; class Query
  ##
  # An RDF basic graph pattern (BGP) query solution sequence.
  # This mixin extends `Enumerator`.
  #
  # @example Filtering solutions using a hash
  #   solutions.filter(:author  => RDF::URI("http://ar.to/#self"))
  #   solutions.filter(:author  => "Gregg Kellogg")
  #   solutions.filter(:author  => [RDF::URI("http://ar.to/#self"), "Gregg Kellogg"])
  #   solutions.filter(:updated => RDF::Literal(Date.today))
  #
  # @example Filtering solutions using a block
  #   solutions.filter { |solution| solution.author.literal? }
  #   solutions.filter { |solution| solution.title.to_s =~ /^SPARQL/ }
  #   solutions.filter { |solution| solution.price < 30.5 }
  #   solutions.filter { |solution| solution.bound?(:date) }
  #   solutions.filter { |solution| solution.age.datatype == RDF::XSD.integer }
  #   solutions.filter { |solution| solution.name.language == :es }
  #
  # @example Reordering solutions based on a variable or proc
  #   solutions.order_by(:updated)
  #   solutions.order_by(:updated, :created)
  #   solutions.order_by(:updated, lambda {|a, b| b <=> a})
  #
  # @example Selecting/Projecting particular variables only
  #   solutions.select(:title)
  #   solutions.select(:title, :description)
  #   solutions.project(:title)
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
  module Solutions
    extend RDF::Util::Aliasing::LateBound

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
    # Returns hash of bindings from each solution. Each bound variable will have
    # an array of bound values representing those from each solution, where a given
    # solution will have just a single value for each bound variable
    # @return [Hash{Symbol => Array<RDF::Term>}]
    def bindings
      bindings = {}
      each do |solution|
        solution.each do |key, value|
          bindings[key] ||= []
          bindings[key] << value
        end
      end
      bindings
    end
    
    ##
    # Filters this solution sequence by the given `criteria`, returning
    # an Enumerator extended with Solutions
    #
    # @param  [Hash{Symbol => Object}] criteria
    # @yield  [solution]
    # @yieldparam  [RDF::Query::Solution] solution
    # @yieldreturn [Boolean]
    # @return [Enumerator] extended with {RDF::Query::Solutions}
    def filter(criteria = {}, &block)
      if block_given?
        self.reject do |solution|
          !block.call(solution.is_a?(Solution) ? solution : Solution.new(solution))
        end.to_enum.extend(RDF::Query::Solutions)
      else
        self.reject do |solution|
          solution = solution.is_a?(Solution) ? solution : Solution.new(solution)
          results = criteria.map do |name, value|
            case value
            when Array then value.any? {|v| solution[name] == v}
            when Regexp then solution[name].to_s.match(value)
            else solution[name] == value
            end
          end
          !results.all?
        end.to_enum.extend(RDF::Query::Solutions)
      end
    end

    ##
    # Difference between solution sets, from SPARQL 1.1.
    #
    # The `minus` operation on solutions returns those solutions which either have no compatible solution in `other`, or the solution domains are disjoint.
    #
    # @param [RDF::Query::Solutions] other
    # @return [Enumerator] a new solution set
    # @see http://www.w3.org/TR/2013/REC-sparql11-query-20130321/#defn_algMinus
    def minus(other)
      self.filter do |soln|
        !other.any? {|soln2| soln.compatible?(soln2) && !soln.disjoint?(soln2)}
      end
    end

    ##
    # Reorders this solution sequence by the given `variables`
    # returning a new Enumerator.
    #
    # Variables may be symbols or {Query::Variable} instances.
    # A variable may also be a Procedure/Lambda, compatible with `::Enumerable#sort`.
    # This takes two arguments (solutions) and returns -1, 0, or 1 equivalently to <=>.
    #
    # If called with a block, variables are ignored, and the block is invoked with
    # pairs of solutions. The block is expected to return -1, 0, or 1 equivalently to <=>.
    #
    # @param  [Array<Proc, Query::Variable, Symbol, #to_sym>] variables
    # @yield  [solution]
    # @yieldparam  [RDF::Query::Solution] q
    # @yieldparam  [RDF::Query::Solution] b
    # @yieldreturn [Integer] -1, 0, or 1 depending on value of comparator
    # @return [Enumerator] extended with {RDF::Query::Solutions}
    def order(*variables, &block)
      if variables.empty? && !block_given?
        raise ArgumentError, "wrong number of arguments (0 for 1)"
      else
        self.sort do |a, b|
          if block_given?
            block.call((a.is_a?(Solution) ? a : Solution.new(a)), (b.is_a?(Solution) ? b : Solution.new(b)))
          else
            # Try each variable until a difference is found.
            variables.inject(nil) do |memo, v|
              memo || begin
                comp = v.is_a?(Proc) ? v.call(a, b) : (v = v.to_sym; a[v] <=> b[v])
                comp == 0 ? false : comp
              end
            end || 0
          end
        end
      end.to_enum.extend(RDF::Query::Solutions)
    end
    alias_method :order_by, :order

    ##
    # Duplicate the object, re-applying this module
    #
    # @return [Enumerator] extended with {RDF::Query::Solutions}
    def dup
      super.extend(RDF::Query::Solutions)
    end

    ##
    # Returns a new solution sequence restricted to the given `variables` only.
    #
    # @param  [Array<Symbol, #to_sym>] variables
    # @return [Enumerator] extended with {RDF::Query::Solutions}
    def project(*variables)
      if variables.empty?
        raise ArgumentError, "wrong number of arguments (0 for 1)"
      else
        variables.map!(&:to_sym)
        self.map do |solution|
          bindings = solution.bindings.delete_if { |k, v| !variables.include?(k.to_sym) }
          RDF::Query::Solution.new(bindings)
        end.to_enum.extend(RDF::Query::Solutions)
      end
    end
    alias_method :select, :project

    ##
    # Returns a new solution sequence with unique solutions
    #
    # @return [Enumerator] extended with {RDF::Query::Solutions}
    def distinct
      self.to_a.uniq.to_enum.extend(RDF::Query::Solutions)
    end
    alias_method :reduced,   :distinct

    ##
    # Limits this solution sequence to bindings starting from the `start`
    # offset in the overall solution sequence.
    #
    # @param  [Integer, #to_i] start
    #   zero or a positive or negative integer
    # @return [Enumerator] extended with {RDF::Query::Solutions}
    def offset(start)
      case start = start.to_i
        when 0 then nil
        else Array(self.to_a[start, -1]).to_enum.extend(RDF::Query::Solutions)
      end
    end

    ##
    # Limits the number of solutions in this solution sequence to a maximum
    # of `length`.
    #
    # @param  [Integer, #to_i] length
    #   zero or a positive integer
    # @return [Enumerator] extended with {RDF::Query::Solutions}
    # @raise  [ArgumentError] if `length` is negative
    def limit(length)
      length = length.to_i
      raise ArgumentError, "expected zero or a positive integer, got #{length}" if length < 0
      if length == 0
        [].to_enum.extend(RDF::Query::Solutions)
      elsif length < self.count
        self.to_a[0, length].to_enum.extend(RDF::Query::Solutions)
      else
        dup
      end
    end

    ##
    # Determines if these solutions are empty
    # @return [Integer]
    def empty?
      self.count == 0
    end

    ##
    # Returns an array of the distinct variable names used in this solution
    # sequence.
    #
    # @return [Array<Symbol>]
    def variable_names
      variables = self.inject({}) do |result, solution|
        solution.each_name do |name|
          result[name] ||= true
        end
        result
      end
      variables.keys
    end

    ##
    # Returns `true` if this solution sequence contains bindings for any of
    # the given `variables`.
    #
    # @param  [Array<Symbol, #to_sym>] variables
    #   an array of variables to check
    # @return [Boolean] `true` or `false`
    # @see    RDF::Query::Solution#has_variables?
    # @see    RDF::Query#execute
    def have_variables?(variables)
      self.any? { |solution| solution.has_variables?(variables) }
    end
    alias_method :has_variables?, :have_variables?
  end # Solutions
end; end # RDF::Query
