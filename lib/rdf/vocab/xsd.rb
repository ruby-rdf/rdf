module RDF
  ##
  # XML Schema (XSD) vocabulary.
  #
  # @see http://www.w3.org/XML/Schema
  # @see http://www.w3.org/TR/xmlschema-2/#built-in-datatypes
  class XSD < Vocabulary("http://www.w3.org/2001/XMLSchema#")
    # XML Schema built-in primitive types
    # @see http://www.w3.org/TR/xmlschema-2/#built-in-primitive-datatypes
    property :NOTATION
    property :QName
    property :anyURI
    property :base64Binary
    property :boolean
    property :date
    property :dateTime
    property :decimal
    property :double
    property :duration
    property :float
    property :gDay
    property :gMonth
    property :gMonthDay
    property :gYear
    property :gYearMonth
    property :hexBinary
    property :string
    property :time

    # XML Schema built-in derived types
    # @see http://www.w3.org/TR/xmlschema-2/#built-in-derived
    property :ENTITIES
    property :ENTITY
    property :ID
    property :IDREF
    property :IDREFS
    property :NCName
    property :NMTOKEN
    property :NMTOKENS
    property :Name
    property :byte
    property :int
    property :integer
    property :language
    property :long
    property :negativeInteger
    property :nonNegativeInteger
    property :nonPositiveInteger
    property :normalizedString
    property :positiveInteger
    property :short
    property :token
    property :unsignedByte
    property :unsignedInt
    property :unsignedLong
    property :unsignedShort
  end
end
