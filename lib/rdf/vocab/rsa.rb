# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://www.w3.org/ns/auth/rsa#
require 'rdf'
module RDF
  # @deprecated Please use `RDF::Vocab::RSA` from the rdf-vocab gem instead
  class RSA < RDF::StrictVocabulary("http://www.w3.org/ns/auth/rsa#")

    # Class definitions
    term :RSAKey,
      comment: %(
    The union of the public and private components of an RSAKey.
    Usually those pieces are not kept together
    ).freeze,
      label: "RSA Key".freeze,
      subClassOf: "cert:Key".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :RSAPrivateKey,
      comment: %(
    A Private Key in the RSA framework 
    ).freeze,
      label: "RSA Private Key".freeze,
      "rdfs:seeAlso" => %(http://en.wikipedia.org/wiki/RSA).freeze,
      subClassOf: ["cert:PrivateKey".freeze, "rsa:RSAKey".freeze],
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :RSAPublicKey,
      comment: %(
    The RSA public key.  Padded message m are encrypted by applying the function
      modulus\(power\(m,exponent\),modulus\)
    ).freeze,
      label: "RSA Public Key".freeze,
      "rdfs:seeAlso" => %(http://en.wikipedia.org/wiki/RSA).freeze,
      subClassOf: ["cert:PublicKey".freeze, "rsa:RSAKey".freeze],
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze

    # Property definitions
    property :modulus,
      comment: %(    
   The modulus of an RSA public and private key. 
   This is defined as n = p*q
   ).freeze,
      domain: "rsa:RSAKey".freeze,
      label: "modulus".freeze,
      range: ["xsd:base64Binary".freeze, "xsd:hexBinary".freeze],
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :private_exponent,
      comment: %(
       The exponent used to decrypt the message
       calculated as 
          public_exponent*private_exponent = 1 modulo totient\(p*q\)
       The private exponent is often named 'd'
    ).freeze,
      domain: "rsa:RSAPrivateKey".freeze,
      label: "private".freeze,
      range: "xsd:nonNegativeInteger".freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :public_exponent,
      comment: %(
       The exponent used to encrypt the message. Number chosen between
       1 and the totient\(p*q\). Often named 'e' .
    ).freeze,
      domain: "rsa:RSAPublicKey".freeze,
      label: "public_exponent".freeze,
      range: "xsd:nonNegativeInteger".freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(unstable).freeze
  end
end
