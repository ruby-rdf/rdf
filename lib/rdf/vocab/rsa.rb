module RDF
  ##
  # W3 RSA Keys (RSA) vocabulary.
  #
  # @see   http://www.w3.org/ns/auth/rsa#
  # @since 0.2.0
  class RSA < Vocabulary("http://www.w3.org/ns/auth/rsa#")
    property :modulus
    property :private_exponent
    property :public_exponent
  end
end
