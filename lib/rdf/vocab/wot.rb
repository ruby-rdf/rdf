module RDF
  ##
  # Web of Trust (WOT) vocabulary.
  #
  # @see http://xmlns.com/wot/0.1/
  class WOT < Vocabulary("http://xmlns.com/wot/0.1/")
    property :assurance
    property :encryptedTo
    property :encrypter
    property :fingerprint
    property :hasKey
    property :hex_id
    property :identity
    property :length
    property :pubkeyAddress
    property :sigdate
    property :signed
    property :signer
    property :sigtime
  end
end
