module RDF; class Query
  ##
  # An RDF basic graph pattern (BGP) query solution sequence.
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
    autoload :Enumerator, 'rdf/mixin/enumerator'
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
    rescue
      0
    end

    def size
      (super rescue nil) || to_a.size
    end

    ##
    # Determines if these solutions are empty
    # @return [Integer]
    def empty?
      each {return false}
      true
    rescue StopIteration
      true
    end

    ##
    # Returns an array of the distinct variable names used in this solution
    # sequence.
    #
    # @return [Array<Symbol>]
    def variable_names
      variables = Array(self).inject({}) do |result, solution|
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
    #
    # @param  [Hash{Symbol => Object}] criteria
    # @yield  [solution]
    # @yieldparam  [RDF::Query::Solution] solution
    # @yieldreturn [Boolean]
    # @return [RDF::Query::Solutions::Enumerator]
    def filter(criteria = {})
      Solutions::Enumerator.new do |yielder|
        if block_given?
          self.each do |solution|
            solution = Solution.new(solution) unless solution.is_a?(Solution)
            yielder << solution if yield solution
          end
        else
          self.each do |solution|
            solution = solution.is_a?(Solution) ? solution : Solution.new(solution)
            yielder << solution if criteria.all? do |name, value|
              case value
              when Array then value.any? {|v| solution[name] == v}
              when Regexp then solution[name].to_s.match(value)
              else solution[name] == value
              end
            end
          end
        end
      end
    end
    alias_method :filter!, :filter

    ##
    # Difference between solution sets, from SPARQL 1.1.
    #
    # The `minus` operation on solutions returns those solutions which either have no compatible solution in `other`, or the solution domains are disjoint.
    #
    # @param [RDF::Query::Solutions] other
    # @return [RDF::Query::Solutions] a new solution set
    # @see http://www.w3.org/TR/2013/REC-sparql11-query-20130321/#defn_algMinus
    def minus(other)
      self.filter do |soln|
        !other.any? {|soln2| soln.compatible?(soln2) && !soln.disjoint?(soln2)}
      end
    end

    ##
    # Reorders this solution sequence by the given `variables`.
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
    # @return [self]
    def order(*variables)
      raise ArgumentError, "wrong number of arguments (0 for 1)" if variables.empty? && !block_given?
      Solutions::Enumerator.new do |yielder|
        Array(self).sort do |a, b|
          if block_given?
            yield((a.is_a?(Solution) ? a : Solution.new(a)), (b.is_a?(Solution) ? b : Solution.new(b)))
          else
            # Try each variable until a difference is found.
            variables.inject(nil) do |memo, v|
              memo || begin
                comp = v.is_a?(Proc) ? v.call(a, b) : (v = v.to_sym; a[v] <=> b[v])
                comp == 0 ? false : comp
              end
            end || 0
          end
        end.each do |solution|
          yielder << solution
        end
      end
    end
    alias_method :order_by, :order

    ##
    # Restricts this solution sequence to the given `variables` only.
    #
    # @param  [Array<Symbol, #to_sym>] variables
    # @yield solution
    # @yieldparam [Solution] solution
    # @return [RDF::Query::Solutions::Enumerator]
    def project(*variables)
      raise ArgumentError, "wrong number of arguments (0 for 1)" if variables.empty?
      return Solutions::Enumerator.new do |yielder|
        self.project(*variables) {|y| yielder << y}
      end unless block_given?

      variables.map!(&:to_sym)
      self.each do |solution|
        bindings = solution.bindings.delete_if { |k, v| !variables.include?(k.to_sym) }
        yield RDF::Query::Solution.new(bindings)
      end
    end

    ##
    # Either project the solution set or perform select as implemented
    # by a superclass
    # @yield solution
    # @yieldparam [Solution] solution
    # @return [RDF::Query::Solutions]
    def select(*variables, &block)
      if block_given?
        super
      else
        project(*variables, &block)
      end
    end

    ##
    # Ensures that the solutions in this solution sequence are unique.
    #
    # @yield solution
    # @yieldparam [Solution] solution
    # @return [RDF::Query::Solutions]
    def distinct(&block)
      return Solutions::Enumerator.new do |yielder|
        self.distinct {|y| yielder << y}
      end unless block_given?

      Array(self).uniq.each(&block)
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
    # @return [RDF::Query::Solutions]
    def offset(start, &block)
      start = start.to_i
      raise ArgumentError, "expected zero or a positive integer, got #{start}" if start < 0
      return Solutions::Enumerator.new do |yielder|
        self.offset(start) {|y| yielder << y}
      end unless block_given?

      (Array(self)[start..-1] || []).each(&block)
    end
    alias_method :offset!, :offset

    ##
    # Limits the number of solutions in this solution sequence to a maximum
    # of `length`.
    #
    # @param  [Integer, #to_i] length
    #   zero or a positive integer
    # @return [RDF::Query::Solutions]
    # @raise  [ArgumentError] if `length` is negative
    def limit(length, &block)
      length = length.to_i
      raise ArgumentError, "expected zero or a positive integer, got #{length}" if length < 0
      return Solutions::Enumerator.new do |yielder|
        self.limit(length) {|y| yielder << y}
      end unless block_given?

      (Array(self)[0, length] || []).each(&block)
    end
    alias_method :limit!, :limit

    ##
    # Duplicate the object, re-applying this module
    #
    # @return [RDF::Query::Solutions::Enumerator]
    def dup
      case self
      when Solutions::Enumerator then self
      else
        Solutions::Enumerator.new {|yielder| Array(self).each {|e| yielder << e}}
      end
    end
  end # Solutions
end; end # RDF::Query
