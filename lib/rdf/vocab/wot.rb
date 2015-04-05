# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://xmlns.com/wot/0.1/index.rdf
require 'rdf'
module RDF
  # @deprecated Please use `RDF::Vocab::WOT` from the rdf-vocab gem instead
  class WOT < RDF::StrictVocabulary("http://xmlns.com/wot/0.1/")

    # Class definitions
    term :EncryptedDocument,
      comment: %(An encrypted document intended for a set of recipients.).freeze,
      label: "Encrypted Document".freeze,
      "owl:disjointWith" => [%(wot:Endorsement).freeze, %(wot:PubKey).freeze, %(wot:SigEvent).freeze, %(wot:User).freeze],
      "rdfs:isDefinedBy" => %(wot:).freeze,
      subClassOf: ["foaf:Document".freeze, "http://xmlns.com/wordnet/1.6/Endorsement-4".freeze],
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :Endorsement,
      comment: %(An endorsement resource containing a detached ascii signature.).freeze,
      label: "Endorsement".freeze,
      "owl:disjointWith" => [%(wot:EncryptedDocument).freeze, %(wot:PubKey).freeze, %(wot:SigEvent).freeze, %(wot:User).freeze],
      "rdfs:isDefinedBy" => %(wot:).freeze,
      subClassOf: ["foaf:Document".freeze, "http://xmlns.com/wordnet/1.6/Endorsement-4".freeze],
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :PubKey,
      comment: %(A class used to represent a PGP/GPG public key for a user \(an agent, person, group or organization\).).freeze,
      label: "Public Key".freeze,
      "owl:disjointWith" => [%(wot:EncryptedDocument).freeze, %(wot:Endorsement).freeze, %(wot:SigEvent).freeze, %(wot:User).freeze],
      "rdfs:isDefinedBy" => %(wot:).freeze,
      subClassOf: "http://xmlns.com/wordnet/1.6/Credential".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :SigEvent,
      comment: %(An event describing the action of a public key being signed by some other public key.).freeze,
      label: "Key Signing Event".freeze,
      "owl:disjointWith" => [%(wot:EncryptedDocument).freeze, %(wot:Endorsement).freeze, %(wot:PubKey).freeze, %(wot:User).freeze],
      "rdfs:isDefinedBy" => %(wot:).freeze,
      subClassOf: ["http://www.w3.org/2002/12/cal/ical#Vevent".freeze, "http://xmlns.com/wordnet/1.6/Event".freeze],
      type: "owl:Class".freeze,
      "vs:term_status" => %(testing).freeze
    term :User,
      comment: %(A user \(agent, person, group or organization\) of a PGP/GPG public key.).freeze,
      label: "Key User".freeze,
      "owl:disjointWith" => [%(wot:EncryptedDocument).freeze, %(wot:Endorsement).freeze, %(wot:PubKey).freeze, %(wot:SigEvent).freeze],
      "rdfs:isDefinedBy" => %(wot:).freeze,
      subClassOf: "foaf:Agent".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze

    # Property definitions
    property :assurance,
      comment: %(A property linking a document to an endorsement resource containing a detached ascii signature.).freeze,
      domain: "foaf:Document".freeze,
      label: "Assurance".freeze,
      range: "wot:Endorsement".freeze,
      "rdfs:isDefinedBy" => %(wot:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :encryptedTo,
      comment: %(A property linking an encrypted document to a recipient.).freeze,
      domain: "wot:EncryptedDocument".freeze,
      label: "Encrypted to".freeze,
      range: "wot:PubKey".freeze,
      "rdfs:isDefinedBy" => %(wot:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :encrypter,
      comment: %(A property linking an encrypted document to the public key that was used to encrypt it.).freeze,
      domain: "wot:EncryptedDocument".freeze,
      label: "Encrypted by".freeze,
      range: "wot:PubKey".freeze,
      "rdfs:isDefinedBy" => %(wot:).freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:ObjectProperty".freeze],
      "vs:term_status" => %(unstable).freeze
    property :fingerprint,
      comment: %(A public key hex fingerprint string \(40 digits, white space insignificant\).).freeze,
      domain: "wot:PubKey".freeze,
      label: "Fingerprint".freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(wot:).freeze,
      type: ["owl:DatatypeProperty".freeze, "owl:InverseFunctionalProperty".freeze],
      "vs:term_status" => %(testing).freeze
    property :hasKey,
      comment: %(A property to link a PubKey from a User).freeze,
      domain: "wot:User".freeze,
      label: "has Key".freeze,
      "owl:inverseOf" => %(wot:identity).freeze,
      range: "wot:PubKey".freeze,
      "rdfs:isDefinedBy" => %(wot:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :hex_id,
      comment: %(A public key hex identifier string \(8 digits\).).freeze,
      domain: "wot:PubKey".freeze,
      label: "Hex identifier".freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(wot:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :identity,
      comment: %(A property linking a public key to the user of the key.).freeze,
      domain: "wot:PubKey".freeze,
      label: "Identity".freeze,
      range: "wot:User".freeze,
      "rdfs:isDefinedBy" => %(wot:).freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:ObjectProperty".freeze],
      "vs:term_status" => %(testing).freeze
    property :length,
      comment: %(A numeric string representing the length, in bytes, of a public key.).freeze,
      domain: "wot:PubKey".freeze,
      label: "Length".freeze,
      range: "xsd:integer".freeze,
      "rdfs:isDefinedBy" => %(wot:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :pubkeyAddress,
      comment: %(The location of an ascii version of a public key.).freeze,
      domain: "wot:PubKey".freeze,
      label: "Address".freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(wot:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :sigdate,
      comment: %(The date of a public key signature event.).freeze,
      domain: "wot:SigEvent".freeze,
      label: "Signature date".freeze,
      range: "xsd:date".freeze,
      "rdfs:isDefinedBy" => %(wot:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :signed,
      comment: %(A property linking a public key to a public key signature event.).freeze,
      domain: "wot:PubKey".freeze,
      label: "Signed".freeze,
      range: "wot:SigEvent".freeze,
      "rdfs:isDefinedBy" => %(wot:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :signer,
      comment: %(A property linking a public key signature event to the public key that was used to sign.).freeze,
      domain: "wot:SigEvent".freeze,
      label: "Signer".freeze,
      range: "wot:PubKey".freeze,
      "rdfs:isDefinedBy" => %(wot:).freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:ObjectProperty".freeze],
      "vs:term_status" => %(unstable).freeze
    property :sigtime,
      comment: %(The time \(of day\) of a public key signature event.).freeze,
      domain: "wot:SigEvent".freeze,
      label: "Signature time".freeze,
      range: "xsd:time".freeze,
      "rdfs:isDefinedBy" => %(wot:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(unstable).freeze

    # Extra definitions
    term :"",
      "dc11:date" => %(2004-02-23).freeze,
      "dc11:description" => %(Web Of Trust \(wot\) RDF vocabulary, described using W3C RDF Schema and the Web Ontology Language.).freeze,
      "dc11:title" => %(Web Of Trust vocabulary).freeze,
      label: "".freeze,
      "owl:imports" => [%(http://www.w3.org/2000/01/rdf-schema).freeze, %(http://www.w3.org/2002/07/owl).freeze],
      "rdfs:seeAlso" => %(foaf:).freeze,
      type: "owl:Ontology".freeze
  end
end
