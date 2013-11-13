# This file generated automatically using vocab-fetch from http://www.w3.org/ns/auth/rsa#
require 'rdf'
module RDF
  class RSA < StrictVocabulary("http://www.w3.org/ns/auth/rsa#")

    # Class definitions
    property :RSAKey, :label => 'RSA Key', :comment =>
      %(The union of the public and private components of an RSAKey.
        Usually those pieces are not kept together)
    property :RSAPrivateKey, :label => 'RSA Private Key', :comment =>
      %(A Private Key in the RSA framework)
    property :RSAPublicKey, :label => 'RSA Public Key', :comment =>
      %(The RSA public key. Padded message m are encrypted by applying
        the function modulus\(power\(m,exponent\),modulus\))

    # Property definitions
    property :modulus, :label => 'modulus', :comment =>
      %(The modulus of an RSA public and private key. This is defined
        as n = p*q)
    property :private_exponent, :label => 'private', :comment =>
      %(The exponent used to decrypt the message calculated as
        public_exponent*private_exponent = 1 modulo totient\(p*q\) The
        private exponent is often named 'd')
    property :public_exponent, :label => 'public_exponent', :comment =>
      %(The exponent used to encrypt the message. Number chosen
        between 1 and the totient\(p*q\). Often named 'e' .)
  end
end
