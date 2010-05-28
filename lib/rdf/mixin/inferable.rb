require 'rdfs'

module RDF
  module Inferable
    include RDF::Queryable
    include RDF::Enumerable
    include ::Enumerable
    include ::RDFS
    
    def pairs_of_statements
      Enumerator.new(self, :combination)
    end
    
    def combination
      statements.combination(2)
    end
    
    def draw_inferences(rule_set = :rdfs_entailment)
      case rule_set
      when :rdfs_entailment
        @learned_statements = []
        each_statement {|statement| @learned_statements += unitary_inferences_from(statement)}
        pairs_of_statements.each do |pair|
          @learned_statements += pairwise_inferences_from pair
        end
      else
        #todo
      end
      return @learned_statements
    end

    private
    
    def unitary_inferences_from(statement)
      rules = Semantics.constants.select {|c| Object.module_eval("RDFS::Semantics::#{c}").is_a? Class}
      rules = rules.collect {|c| Object.module_eval("RDFS::Semantics::#{c}")}
      inferred_statements = []
      arr = rules.each { |rule| inferred_statements += ((o = rule.new.match(statement)).nil? ? [] : o) }
      arr.collect {|r| r.new.match(statement)}.compact
    end
    
    def pairwise_inferences_from(pair)
      rules = Semantics.constants.select {|c| Object.module_eval("RDFS::Semantics::#{c}").is_a? Class}
      rules = rules.collect {|c| Object.module_eval("RDFS::Semantics::#{c}")}
      inferred_statements = []
      arr = rules.each { |rule| inferred_statements += (o = rule.new.match(*pair)).nil? ? [] : o }
      arr.collect {|r| r.new.match(*pair)}.compact
    end
  end
end
