require 'rdfs'

module RDF
  module Inferable
    include RDF::Queryable
    
    def pairs_of_statements
      Enumerator.new(self, :combination, 2)
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
      rules = RDFS::Semantics.constants.select {|c| Object.module_eval("RDFS::Semantics::#{c}").is_a? Class}
      rules = rules.collect {|c| Object.module_eval("RDFS::Semantics::#{c}")}
      inferred_statements = []
      rules.each { |rule| inferred_statements += rule[statement] }
    end
    
    def pairwise_inferences_from(pair)
      rules = RDFS::Semantics.constants.select {|c| Object.module_eval("RDFS::Semantics::#{c}").is_a? Class}
      rules = rules.collect {|c| Object.module_eval("RDFS::Semantics::#{c}")}
      inferred_statements = []
      rules.each { |rule| inferred_statements += rule[*pair] }
    end
  end
end
