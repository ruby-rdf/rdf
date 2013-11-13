# This file generated automatically using vocab-fetch from http://xmlns.com/wot/0.1/index.rdf
require 'rdf'
module RDF
  class WOT < StrictVocabulary("http://xmlns.com/wot/0.1/")

    # Class definitions
    property :EncryptedDocument, :label => 'Encrypted Document', :comment =>
      %(An encrypted document intended for a set of recipients.)
    property :Endorsement, :label => 'Endorsement', :comment =>
      %(An endorsement resource containing a detached ascii signature.)
    property :SigEvent, :label => 'Key Signing Event', :comment =>
      %(An event describing the action of a public key being signed by
        some other public key.)
    property :User, :label => 'Key User', :comment =>
      %(A user \(agent, person, group or organization\) of a PGP/GPG
        public key.)
    property :PubKey, :label => 'Public Key', :comment =>
      %(A class used to represent a PGP/GPG public key for a user \(an
        agent, person, group or organization\).)

    # Property definitions
    property :fingerprint, :label => 'Fingerprint', :comment =>
      %(A public key hex fingerprint string \(40 digits, white space
        insignificant\).)
    property :hex_id, :label => 'Hex identifier', :comment =>
      %(A public key hex identifier string \(8 digits\).)
    property :length, :label => 'Length', :comment =>
      %(A numeric string representing the length, in bytes, of a
        public key.)
    property :sigdate, :label => 'Signature date', :comment =>
      %(The date of a public key signature event.)
    property :sigtime, :label => 'Signature time', :comment =>
      %(The time \(of day\) of a public key signature event.)
    property :pubkeyAddress, :label => 'Address', :comment =>
      %(The location of an ascii version of a public key.)
    property :assurance, :label => 'Assurance', :comment =>
      %(A property linking a document to an endorsement resource
        containing a detached ascii signature.)
    property :encrypter, :label => 'Encrypted by', :comment =>
      %(A property linking an encrypted document to the public key
        that was used to encrypt it.)
    property :encryptedTo, :label => 'Encrypted to', :comment =>
      %(A property linking an encrypted document to a recipient.)
    property :identity, :label => 'Identity', :comment =>
      %(A property linking a public key to the user of the key.)
    property :signed, :label => 'Signed', :comment =>
      %(A property linking a public key to a public key signature
        event.)
    property :signer, :label => 'Signer', :comment =>
      %(A property linking a public key signature event to the public
        key that was used to sign.)
    property :hasKey, :label => 'has Key', :comment =>
      %(A property to link a PubKey from a User)
  end
end
