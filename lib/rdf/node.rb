module RDF
  class Node

    def anonymous?
      true
    end

    alias :unlabeled? :anonymous?

  end
end
