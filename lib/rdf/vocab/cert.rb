# This file generated automatically using vocab-fetch from http://www.w3.org/ns/auth/cert#
require 'rdf'
module RDF
  class CERT < StrictVocabulary("http://www.w3.org/ns/auth/cert#")

    # Class definitions
    property :Certificate, :label => 'Certificate', :comment =>
      %(A certificate is a Document that is signed. As explained here
        http://www.pgpi.org/doc/pgpintro/#p16 'A digital certificate
        consists of three things: * A public key. * Certificate
        information. \('Identity' information about the user, such as
        name, user ID, and so on.\) * One or more digital signatures.')
    property :PGPCertificate, :label => 'PGPCertificate', :comment =>
      %(the class of PGP Certificates)
    property :PrivateKey, :label => 'PrivateKey', :comment =>
      %(Private Key)
    property :PublicKey, :label => 'PublicKey', :comment =>
      %(Public Key)
    property :RSAKey, :label => 'RSA Key', :comment =>
      %(The union of the public and private components of an RSAKey.
        Usually those pieces are not kept together)
    property :RSAPublicKey, :label => 'RSA Public Key', :comment =>
      %(The RSA public key. Padded message m are encrypted by applying
        the function modulus\(power\(m,exponent\),modulus\))
    property :Signature, :label => 'Signature', :comment =>
      %(the class of signtatures)
    property :X509Certificate, :label => 'X509Certificate', :comment =>
      %(the class of X509 Certificates)

    # Property definitions
    property :identity, :label => 'identity', :comment =>
      %(the identity of the public key. This is the entity that knows
        the private key and so can decrypt messages encrypted with the
        public key, or encrypt messages that can be decrypted with the
        public key.)
    property :key, :label => 'key', :comment =>
      %(relates an agent to a key - most often the public key.)
    property :exponent, :label => 'exponent', :comment =>
      %(The exponent used to encrypt the message. Number chosen
        between 1 and the totient\(p*q\). Often named 'e' .)
    property :modulus, :label => 'modulus', :comment =>
      %(<p xmlns="http://www.w3.org/1999/xhtml"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:vs="http://www.w3.org/2003/06/sw-vocab-status/ns#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:owl="http://www.w3.org/2002/07/owl#"
        xmlns:dc="http://purl.org/dc/terms/"
        xmlns:rsa="http://www.w3.org/ns/auth/rsa#"
        xmlns:cert="http://www.w3.org/ns/auth/cert#"
        xmlns:foaf="http://xmlns.com/foaf/0.1/"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#">The modulus
        of an RSA public and private key. Or the modulus of a DSA Key.
        The modulus is encoded as a hex binary. The binary is the same
        as the one encoded in the <a
        href="http://www.w3.org/TR/xmldsig-core/#sec-CryptoBinary">XML
        DSIG CryptoBinary</a> </p> <blockquote
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:vs="http://www.w3.org/2003/06/sw-vocab-status/ns#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:owl="http://www.w3.org/2002/07/owl#"
        xmlns:dc="http://purl.org/dc/terms/"
        xmlns:rsa="http://www.w3.org/ns/auth/rsa#"
        xmlns:cert="http://www.w3.org/ns/auth/cert#"
        xmlns:foaf="http://xmlns.com/foaf/0.1/"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#"> This
        specification defines the ds:CryptoBinary simple type for
        representing arbitrary-length integers \(e.g. "bignums"\) in
        XML as octet strings. The integer value is first converted to
        a "big endian" bitstring. The bitstring is then padded with
        leading zero bits so that the total number of bits == 0 mod 8
        \(so that there are an integral number of octets\). If the
        bitstring contains entire leading octets that are zero, these
        are removed \(so the high-order octet is always non-zero\).
        </blockquote> <p xmlns="http://www.w3.org/1999/xhtml"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:vs="http://www.w3.org/2003/06/sw-vocab-status/ns#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:owl="http://www.w3.org/2002/07/owl#"
        xmlns:dc="http://purl.org/dc/terms/"
        xmlns:rsa="http://www.w3.org/ns/auth/rsa#"
        xmlns:cert="http://www.w3.org/ns/auth/cert#"
        xmlns:foaf="http://xmlns.com/foaf/0.1/"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#">The only
        difference is that the octet string is then encoded using
        either xsd:base64Binary or xsd:hexBinary. Currently for all
        usages of this relation, the xsd:hexBinary datatype should be
        used until the SPARQL working group specifies specifies in its
        <a
        href="http://www.w3.org/TR/sparql11-entailment/#DEntRegime">D-Entailment</a>
        that those two types are equivalent.</p> <p
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:vs="http://www.w3.org/2003/06/sw-vocab-status/ns#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:owl="http://www.w3.org/2002/07/owl#"
        xmlns:dc="http://purl.org/dc/terms/"
        xmlns:rsa="http://www.w3.org/ns/auth/rsa#"
        xmlns:cert="http://www.w3.org/ns/auth/cert#"
        xmlns:foaf="http://xmlns.com/foaf/0.1/"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#">It would
        have been better had there been a hexInteger datatype that was
        standard and supported by all tools.</p>)
    property :privateExponent, :label => 'private', :comment =>
      %(The exponent used to decrypt the message calculated as
        public_exponent*private_exponent = 1 modulo totient\(p*q\) The
        private exponent is often named 'd')
    property :identity, :label => 'identity', :comment =>
      %(the identity of the public key. This is the entity that knows
        the private key and so can decrypt messages encrypted with the
        public key, or encrypt messages that can be decrypted with the
        public key.)
    property :key, :label => 'key', :comment =>
      %(relates an agent to a key - most often the public key.)

    # Extra definitions
    property :hex
  end
end
