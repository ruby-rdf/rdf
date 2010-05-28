module RDF
  ##
  # W3 RSA Keys (RSA) vocabulary.
  #
  # @see http://www.w3.org/ns/auth/rsa#
  class RSA < Vocabulary("http://www.w3.org/ns/auth/rsa#")
    property :modulus
    property :private_exponent
    property :public_exponent
  end
end
