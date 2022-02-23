# -*- encoding: utf-8 -*-
# frozen_string_literal: true
# This file generated automatically using rdf vocabulary format from http://www.w3.org/2001/XMLSchema#
require 'rdf'
module RDF
  # @!parse
  #   # Vocabulary for <http://www.w3.org/2001/XMLSchema#>
  #   #
  #   class XSD < RDF::Vocabulary
  #     #  `ENTITIES` represents the `ENTITIES` attribute type from [XML]. The _value space_ of `ENTITIES` is the set of finite, non-zero-length sequences of `ENTITY` values that have been declared as unparsed entities in a document type definition. The _lexical space_ of `ENTITIES` is the set of space-separated lists of tokens, of which each token is in the _lexical space_ of `ENTITY`. The _item type_ of `ENTITIES` is `ENTITY`. `ENTITIES` is derived from `anySimpleType` in two steps: an anonymous list type is defined, whose _item type_ is `ENTITY`; this is the _base type_ of `ENTITIES`, which restricts its value space to lists with at least one item. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :ENTITIES
  #
  #     #  `ENTITY` represents the `ENTITY` attribute type from [XML]. The _value space_ of `ENTITY` is the set of all strings that match the `NCName` production in [Namespaces in XML] and have been declared as an unparsed entity in a document type definition. The _lexical space_ of ENTITY is the set of all strings that match the NCName production in [Namespaces in XML]. The _base type_ of ENTITY is NCName. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :ENTITY
  #
  #     #  `ID` represents the `ID` attribute type from [XML]. The _value space_ of `ID` is the set of all strings that match the `NCName` production in [Namespaces in XML]. The _lexical space_ of `ID` is the set of all strings that match the `NCName` production in [Namespaces in XML]. The _base type_ of `ID` is `NCName`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :ID
  #
  #     #  `IDREF` represents the `IDREF` attribute type from [XML]. The _value space_ of `IDREF` is the set of all strings that match the `NCName` production in [Namespaces in XML]. The _lexical space_ of `IDREF` is the set of strings that match the `NCName` production in [Namespaces in XML]. The _base type_ of `IDREF` is `NCName`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :IDREF
  #
  #     #  `IDREFS` represents the `IDREFS` attribute type from [XML]. The _value space_ of `IDREFS` is the set of finite, non-zero-length sequences of `IDREF`s. The _lexical space_ of `IDREFS` is the set of space-separated lists of tokens, of which each token is in the _lexical space_ of `IDREF`. The _item type_ of `IDREFS` is `IDREF`. `IDREFS` is derived from `anySimpleType` in two steps: an anonymous list type is defined, whose _item type_ is `IDREF`; this is the _base type_ of `IDREFS`, which restricts its value space to lists with at least one item. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :IDREFS
  #
  #     #  `NCName` represents XML "non-colonized" Names. The _value space_ of `NCName` is the set of all strings which match the `NCName` production of [Namespaces in XML]. The _lexical space_ of `NCName` is the set of all strings which match the `NCName` production of [Namespaces in XML]. The _base type_ of `NCName` is `Name`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :NCName
  #
  #     #  `NMTOKEN` represents the `NMTOKEN` attribute type from [XML]. The _value space_ of `NMTOKEN` is the set of tokens that match the `Nmtoken` production in [XML]. The _lexical space_ of `NMTOKEN` is the set of strings that match the Nmtoken production in [XML]. The _base type_ of `NMTOKEN` is `token`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :NMTOKEN
  #
  #     #  `NMTOKENS` represents the `NMTOKENS` attribute type from [XML]. The _value space_ of `NMTOKENS` is the set of finite, non-zero-length sequences of `NMTOKEN`s. The _lexical space_ of `NMTOKENS` is the set of space-separated lists of tokens, of which each token is in the _lexical space_ of `NMTOKEN`. The _item type_ of `NMTOKENS` is `NMTOKEN`. `NMTOKENS` is derived from `anySimpleType` in two steps: an anonymous list type is defined, whose _item type_ is `NMTOKEN`; this is the _base type_ of `NMTOKENS`, which restricts its value space to lists with at least one item. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :NMTOKENS
  #
  #     #  `NOTATION` represents the `NOTATION` attribute type from [XML]. The _value space_ of `NOTATION` is the set of `QNames` of notations declared in the current schema. The _lexical space_ of `NOTATION` is the set of all names of notations declared in the current schema (in the form of `QNames`). 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :NOTATION
  #
  #     #  `Name` represents XML Names. The _value space_ of `Name` is the set of all strings which match the `Name` production of [XML]. The _lexical space_ of `Name` is the set of all strings which match the `Name` production of [XML]. The _base type_ of `Name` is `token`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :Name
  #
  #     #  `QName` represents XML qualified names. The _value space_ of `QName` is the set of tuples `{namespace name, local part}`, where namespace name is an `anyURI` and local part is an `NCName`. The _lexical space_ of `QName` is the set of strings that match the `QName` production of [Namespaces in XML]. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :QName
  #
  #     #  `anyAtomicType` is a special _restriction_ of `anySimpleType`. The _value_ and _lexical spaces_ of `anyAtomicType` are the unions of the _value_ and _lexical spaces_ of all the _primitive_ datatypes, and `anyAtomicType` is their _base type_. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :anyAtomicType
  #
  #     #  The definition of `anySimpleType` is a special _restriction_ of `anyType`. The _lexical space_ of a`nySimpleType` is the set of all sequences of Unicode characters, and its _value space_ includes all _atomic values_ and all finite-length lists of zero or more _atomic values_. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :anySimpleType
  #
  #     #  The root of the [XML Schema 1.1] datatype heirarchy. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :anyType
  #
  #     #  `anyURI` represents an Internationalized Resource Identifier Reference (IRI). An `anyURI` value can be absolute or relative, and may have an optional fragment identifier (i.e., it may be an IRI Reference). This type should be used when the value fulfills the role of an IRI, as defined in [RFC 3987] or its successor(s) in the IETF Standards Track. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :anyURI
  #
  #     #  `base64Binary` represents arbitrary Base64-encoded binary data. For `base64Binary` data the entire binary stream is encoded using the `Base64` Encoding defined in [RFC 3548], which is derived from the encoding described in [RFC 2045]. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :base64Binary
  #
  #     #  `boolean` represents the values of two-valued logic. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :boolean
  #
  #     #  `byte` is _derived_ from `short` by setting the value of `maxInclusive` to be `127` and `minInclusive` to be `-128`. The _base type_ of `byte` is `short`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :byte
  #
  #     #  `date` represents top-open intervals of exactly one day in length on the timelines of `dateTime`, beginning on the beginning moment of each day, up to but not including the beginning moment of the next day). For non-timezoned values, the top-open intervals disjointly cover the non-timezoned timeline, one per day. For timezoned values, the intervals begin at every minute and therefore overlap. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :date
  #
  #     #  `dateTime` represents instants of time, optionally marked with a particular time zone offset. Values representing the same instant but having different time zone offsets are equal but not identical. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :dateTime
  #
  #     #  The `dateTimeStamp` datatype is _derived_ from `dateTime` by giving the value required to its `explicitTimezone` facet. The result is that all values of `dateTimeStamp` are required to have explicit time zone offsets and the datatype is totally ordered. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :dateTimeStamp
  #
  #     #  `dayTimeDuration` is a datatype _derived_ from `duration` by restricting its _lexical representations_ to instances of `dayTimeDurationLexicalRep`. The _value space_ of `dayTimeDuration` is therefore that of `duration` restricted to those whose `months` property is `0`. This results in a `duration` datatype which is totally ordered. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :dayTimeDuration
  #
  #     #  `decimal` represents a subset of the real numbers, which can be represented by decimal numerals. The _value space_ of decimal is the set of numbers that can be obtained by dividing an integer by a non-negative power of ten, i.e., expressible as `i / 10n` where `i` and `n` are integers and `n ≥ 0`. Precision is not reflected in this value space; the number `2.0` is not distinct from the number `2.00`. The order relation on `decimal` is the order relation on real numbers, restricted to this subset. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :decimal
  #
  #     #  The `double` datatype is patterned after the IEEE double-precision 64-bit floating point datatype [IEEE 754-2008]. Each floating point datatype has a value space that is a subset of the rational numbers. Floating point numbers are often used to approximate arbitrary real numbers. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :double
  #
  #     #  `duration` is a datatype that represents durations of time. The concept of duration being captured is drawn from those of [ISO 8601], specifically durations without fixed endpoints. For example, "15 days" (whose most common lexical representation in duration is `"'P15D'"`) is a duration value; "15 days beginning 12 July 1995" and "15 days ending 12 July 1995" are not duration values. duration can provide addition and subtraction operations between duration values and between duration/dateTime value pairs, and can be the result of subtracting dateTime values. However, only addition to `dateTime` is required for XML Schema processing and is defined in the function `dateTimePlusDuration`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :duration
  #
  #     #  The `float` datatype is patterned after the IEEE single-precision 32-bit floating point datatype [IEEE 754-2008]. Its value space is a subset of the rational numbers. Floating point numbers are often used to approximate arbitrary real numbers. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :float
  #
  #     #  `gDay` represents whole days within an arbitrary month—days that recur at the same point in each (Gregorian) month. This datatype is used to represent a specific day of the month. To indicate, for example, that an employee gets a paycheck on the 15th of each month. (Obviously, days beyond 28 cannot occur in all months; they are nonetheless permitted, up to 31.) 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :gDay
  #
  #     #  `gMonth` represents whole (Gregorian) months within an arbitrary year—months that recur at the same point in each year. It might be used, for example, to say what month annual Thanksgiving celebrations fall in different countries (`--11` in the United States, `--10` in Canada, and possibly other months in other countries). 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :gMonth
  #
  #     #  `gMonthDay` represents whole calendar days that recur at the same point in each calendar year, or that occur in some arbitrary calendar year. (Obviously, days beyond 28 cannot occur in all Februaries; 29 is nonetheless permitted.) 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :gMonthDay
  #
  #     #  `gYear` represents Gregorian calendar years. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :gYear
  #
  #     #  `gYearMonth` represents specific whole Gregorian months in specific Gregorian years. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :gYearMonth
  #
  #     #  hexBinary` represents arbitrary hex-encoded binary data. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :hexBinary
  #
  #     #  `int` is _derived_ from `long` by setting the value of `maxInclusive` to be `2147483647` and `minInclusive` to be `-2147483648`. The _base type_ of `int` is `long`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :int
  #
  #     #  `integer` is _derived_ from `decimal` by fixing the value of `fractionDigits` to be `0` and disallowing the trailing decimal point. This results in the standard mathematical concept of the integer numbers. The _value space_ of `integer` is the infinite set `{...,-2,-1,0,1,2,...}`. The _base type_ of `integer` is `decimal`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :integer
  #
  #     #  `language` represents formal natural language identifiers, as defined by [BCP 47] (currently represented by [RFC 4646] and [RFC 4647]) or its successor(s). The _value space_ and _lexical space_ of `language` are the set of all strings that conform to the pattern `[a-zA-Z]{1,8}(-[a-zA-Z0-9]{1,8})*`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :language
  #
  #     #  `long` is _derived_ from `integer` by setting the value of `maxInclusive` to be `9223372036854775807` and `minInclusive` to be `-9223372036854775808`. The _base type_ of `long` is `integer`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :long
  #
  #     #  `negativeInteger` is _derived_ from `nonPositiveInteger` by setting the value of `maxInclusive` to be `-1`. This results in the standard mathematical concept of the negative integers. The _value space_ of `negativeInteger` is the infinite set `{...,-2,-1}`. The _base type_ of `negativeInteger` is `nonPositiveInteger`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :negativeInteger
  #
  #     #  `nonNegativeInteger` is _derived_ from `integer` by setting the value of `minInclusive` to be `0`. This results in the standard mathematical concept of the non-negative integers. The _value space_ of `nonNegativeInteger` is the infinite set `{0,1,2,...}`. The _base type_ of `nonNegativeInteger` is `integer`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :nonNegativeInteger
  #
  #     #  `nonPositiveInteger` is _derived_ from `integer` by setting the value of `maxInclusive` to be `0`. This results in the standard mathematical concept of the non-positive integers. The _value space_ of `nonPositiveInteger` is the infinite set `{...,-2,-1,0}`. The _base type_ of `nonPositiveInteger` is `integer`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :nonPositiveInteger
  #
  #     #  `normalizedString` represents white space normalized strings. The _value space_ of `normalizedString` is the set of strings that do not contain the carriage return (`#xD`), line feed (`#xA`) nor tab (`#x9`) characters. The _lexical space_ of `normalizedString` is the set of strings that do not contain the carriage return (`#xD`), line feed (`#xA`) nor tab (`#x9`) characters. The _base type_ of `normalizedString` is `string`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :normalizedString
  #
  #     #  `positiveInteger` is _derived_ from `nonNegativeInteger` by setting the value of `minInclusive` to be `1`. This results in the standard mathematical concept of the positive integer numbers. The _value space_ of `positiveInteger` is the infinite set `{1,2,...}`. The _base type_ of `positiveInteger` is `nonNegativeInteger`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :positiveInteger
  #
  #     #  `short` is _derived_ from `int` by setting the value of `maxInclusive` to be `32767` and `minInclusive` to be `-32768`. The _base type_ of `short` is `int`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :short
  #
  #     #  The `string` datatype represents character strings in XML. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :string
  #
  #     #  `time` represents instants of time that recur at the same point in each calendar day, or that occur in some arbitrary calendar day. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :time
  #
  #     #  `token` represents tokenized strings. The _value space_ of `token` is the set of strings that do not contain the carriage return (`#xD`), line feed (`#xA`) nor tab (`#x9`) characters, that have no leading or trailing spaces (`#x20`) and that have no internal sequences of two or more spaces. The _lexical space_ of `token` is the set of strings that do not contain the carriage return (`#xD`), line feed (`#xA`) nor tab (`#x9`) characters, that have no leading or trailing spaces (`#x20`) and that have no internal sequences of two or more spaces. The _base type_ of `token` is `normalizedString`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :token
  #
  #     #  `unsignedByte` is _derived_ from `unsignedShort` by setting the value of `maxInclusive` to be `255`. The _base type_ of `unsignedByte` is `unsignedShort`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :unsignedByte
  #
  #     #  `unsignedInt` is _derived_ from `unsignedLong` by setting the value of `maxInclusive` to be `4294967295`. The _base type_ of `unsignedInt` is `unsignedLong`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :unsignedInt
  #
  #     #  `unsignedLong` is _derived_ from `nonNegativeInteger` by setting the value of `maxInclusive` to be `18446744073709551615`. The _base type_ of `unsignedLong` is `nonNegativeInteger`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :unsignedLong
  #
  #     #  `unsignedShort` is _derived_ from `unsignedInt` by setting the value of `maxInclusive` to be `65535`. The _base type_ of `unsignedShort` is `unsignedInt`. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :unsignedShort
  #
  #     #  `yearMonthDuration` is a datatype _derived_ from `duration` by restricting its _lexical representations_ to instances of `yearMonthDurationLexicalRep`. The _value space_ of `yearMonthDuration` is therefore that of `duration` restricted to those whose `seconds` property is `0`. This results in a `duration` datatype which is totally ordered. 
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :yearMonthDuration
  #
  #   end
  XSD = Class.new(RDF::Vocabulary("http://www.w3.org/2001/XMLSchema#")) do

    # Datatype definitions
    term :ENTITIES,
      comment: "\n    `ENTITIES` represents the `ENTITIES` attribute type from [XML]. The _value\n    space_ of `ENTITIES` is the set of finite, non-zero-length sequences of\n    `ENTITY` values that have been declared as unparsed entities in a document\n    type definition. The _lexical space_ of `ENTITIES` is the set of\n    space-separated lists of tokens, of which each token is in the _lexical\n    space_ of `ENTITY`. The _item type_ of `ENTITIES` is `ENTITY`. `ENTITIES` is\n    derived from `anySimpleType` in two steps: an anonymous list type is\n    defined, whose _item type_ is `ENTITY`; this is the _base type_ of `ENTITIES`,\n    which restricts its value space to lists with at least one item.\n  ",
      label: "ENTITIES",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anySimpleType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :ENTITY,
      comment: "\n     `ENTITY` represents the `ENTITY` attribute type from [XML]. The _value space_\n     of `ENTITY` is the set of all strings that match the `NCName` production in\n     [Namespaces in XML] and have been declared as an unparsed entity in a\n     document type definition. The _lexical space_ of ENTITY is the set of all\n     strings that match the NCName production in [Namespaces in XML]. The\n     _base type_ of ENTITY is NCName.\n  ",
      label: "ENTITY",
      subClassOf: "http://www.w3.org/2001/XMLSchema#NCName",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :ID,
      comment: "\n     `ID` represents the `ID` attribute type from [XML]. The _value space_ of `ID` is\n     the set of all strings that match the `NCName` production in [Namespaces\n     in XML]. The _lexical space_ of `ID` is the set of all strings that match\n     the `NCName` production in [Namespaces in XML]. The _base type_ of `ID` is\n     `NCName`.\n  ",
      label: "ID",
      subClassOf: "http://www.w3.org/2001/XMLSchema#NCName",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :IDREF,
      comment: "\n    `IDREF` represents the `IDREF` attribute type from [XML]. The _value space_ of\n    `IDREF` is the set of all strings that match the `NCName` production in\n    [Namespaces in XML]. The _lexical space_ of `IDREF` is the set of strings\n    that match the `NCName` production in [Namespaces in XML]. The _base type_\n    of `IDREF` is `NCName`.\n  ",
      label: "IDREF",
      subClassOf: "http://www.w3.org/2001/XMLSchema#NCName",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :IDREFS,
      comment: "\n    `IDREFS` represents the `IDREFS` attribute type from [XML]. The _value space_\n    of `IDREFS` is the set of finite, non-zero-length sequences of `IDREF`s. The\n    _lexical space_ of `IDREFS` is the set of space-separated lists of tokens, of\n    which each token is in the _lexical space_ of `IDREF`. The _item type_ of\n    `IDREFS` is `IDREF`. `IDREFS` is derived from `anySimpleType` in two steps: an\n    anonymous list type is defined, whose _item type_ is `IDREF`; this is the\n    _base type_ of `IDREFS`, which restricts its value space to lists with at\n    least one item.\n  ",
      label: "IDREFS",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anySimpleType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :NCName,
      comment: "\n     `NCName` represents XML \"non-colonized\" Names. The _value space_ of `NCName`\n     is the set of all strings which match the `NCName` production of\n     [Namespaces in XML]. The _lexical space_ of `NCName` is the set of all\n     strings which match the `NCName` production of [Namespaces in XML]. The\n     _base type_ of `NCName` is `Name`.\n  ",
      label: "NCName",
      subClassOf: "http://www.w3.org/2001/XMLSchema#Name",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :NMTOKEN,
      comment: "\n     `NMTOKEN` represents the `NMTOKEN` attribute type from [XML]. The _value\n     space_ of `NMTOKEN` is the set of tokens that match the `Nmtoken` production\n     in [XML]. The _lexical space_ of `NMTOKEN` is the set of strings that\n     match the Nmtoken production in [XML]. The _base type_ of `NMTOKEN` is\n     `token`.\n  ",
      label: "NMTOKEN",
      subClassOf: "http://www.w3.org/2001/XMLSchema#token",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :NMTOKENS,
      comment: "\n    `NMTOKENS` represents the `NMTOKENS` attribute type from [XML]. The _value\n    space_ of `NMTOKENS` is the set of finite, non-zero-length sequences of\n    `NMTOKEN`s. The _lexical space_ of `NMTOKENS` is the set of space-separated\n    lists of tokens, of which each token is in the _lexical space_ of `NMTOKEN`.\n    The _item type_ of `NMTOKENS` is `NMTOKEN`. `NMTOKENS` is derived from\n    `anySimpleType` in two steps: an anonymous list type is defined, whose\n    _item type_ is `NMTOKEN`; this is the _base type_ of `NMTOKENS`, which\n    restricts its value space to lists with at least one item.\n  ",
      label: "NMTOKENS",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anySimpleType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :NOTATION,
      comment: "\n    `NOTATION` represents the `NOTATION` attribute type from [XML]. The _value\n    space_ of `NOTATION` is the set of `QNames` of notations declared in the\n    current schema. The _lexical space_ of `NOTATION` is the set of all names of\n    notations declared in the current schema (in the form of `QNames`).\n  ",
      label: "NOTATION",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :Name,
      comment: "\n    `Name` represents XML Names. The _value space_ of `Name` is the set of all\n    strings which match the `Name` production of [XML]. The _lexical space_ of\n    `Name` is the set of all strings which match the `Name` production of [XML].\n    The _base type_ of `Name` is `token`.\n  ",
      label: "Name",
      subClassOf: "http://www.w3.org/2001/XMLSchema#token",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :QName,
      comment: "\n    `QName` represents XML qualified names. The _value space_ of `QName` is the set\n    of tuples `{namespace name, local part}`, where namespace name is an `anyURI`\n    and local part is an `NCName`. The _lexical space_ of `QName` is the set of\n    strings that match the `QName` production of [Namespaces in XML].\n  ",
      label: "QName",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :anyAtomicType,
      comment: "\n    `anyAtomicType` is a special _restriction_ of `anySimpleType`. The _value_ and\n    _lexical spaces_ of `anyAtomicType` are the unions of the _value_ and\n    _lexical spaces_ of all the _primitive_ datatypes, and `anyAtomicType` is\n    their _base type_.\n  ",
      label: "anySimpleType",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :anySimpleType,
      comment: "\n    The definition of `anySimpleType` is a special _restriction_ of `anyType`. The\n    _lexical space_ of a`nySimpleType` is the set of all sequences of Unicode\n    characters, and its _value space_ includes all _atomic values_ and all\n    finite-length lists of zero or more _atomic values_.\n  ",
      label: "anySimpleType",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :anyType,
      comment: "\n    The root of the [XML Schema 1.1] datatype heirarchy.\n  ",
      label: "anyType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :anyURI,
      comment: "\n    `anyURI` represents an Internationalized Resource Identifier Reference\n    (IRI). An `anyURI` value can be absolute or relative, and may have an\n    optional fragment identifier (i.e., it may be an IRI Reference). This\n    type should be used when the value fulfills the role of an IRI, as\n    defined in [RFC 3987] or its successor(s) in the IETF Standards Track.\n  ",
      label: "anyURI",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :base64Binary,
      comment: "\n    `base64Binary` represents arbitrary Base64-encoded binary data. For\n    `base64Binary` data the entire binary stream is encoded using the `Base64`\n    Encoding defined in [RFC 3548], which is derived from the encoding\n    described in [RFC 2045].\n  ",
      label: "base64Binary",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :boolean,
      comment: "\n    `boolean` represents the values of two-valued logic.\n  ",
      label: "boolean",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :byte,
      comment: "\n    `byte` is _derived_ from `short` by setting the value of `maxInclusive` to be\n    `127` and `minInclusive` to be `-128`. The _base type_ of `byte` is `short`.\n  ",
      label: "byte",
      subClassOf: "http://www.w3.org/2001/XMLSchema#short",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :date,
      comment: "\n    `date` represents top-open intervals of exactly one day in length on the\n    timelines of `dateTime`, beginning on the beginning moment of each day, up to\n    but not including the beginning moment of the next day). For non-timezoned\n    values, the top-open intervals disjointly cover the non-timezoned timeline,\n    one per day. For timezoned values, the intervals begin at every minute and\n    therefore overlap.\n  ",
      label: "date",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :dateTime,
      comment: "\n    `dateTime` represents instants of time, optionally marked with a particular\n    time zone offset. Values representing the same instant but having different\n    time zone offsets are equal but not identical.\n  ",
      label: "dateTime",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :dateTimeStamp,
      comment: "\n    The `dateTimeStamp` datatype is _derived_ from `dateTime` by giving the value\n    required to its `explicitTimezone` facet. The result is that all values of\n    `dateTimeStamp` are required to have explicit time zone offsets and the\n    datatype is totally ordered.\n  ",
      label: "dateTimeStamp",
      subClassOf: "http://www.w3.org/2001/XMLSchema#dateTime",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :dayTimeDuration,
      comment: "\n     `dayTimeDuration` is a datatype _derived_ from `duration` by restricting its\n     _lexical representations_ to instances of `dayTimeDurationLexicalRep`. The\n     _value space_ of `dayTimeDuration` is therefore that of `duration` restricted\n     to those whose `months` property is `0`. This results in a `duration` datatype\n     which is totally ordered.\n  ",
      label: "dayTimeDuration",
      subClassOf: "http://www.w3.org/2001/XMLSchema#duration",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :decimal,
      comment: "\n    `decimal` represents a subset of the real numbers, which can be represented\n    by decimal numerals. The _value space_ of decimal is the set of numbers\n    that can be obtained by dividing an integer by a non-negative power of ten,\n    i.e., expressible as `i / 10n` where `i` and `n` are integers and `n ≥ 0`.\n    Precision is not reflected in this value space; the number `2.0` is not\n    distinct from the number `2.00`. The order relation on `decimal` is the order\n    relation on real numbers, restricted to this subset.\n  ",
      label: "decimal",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :double,
      comment: "\n    The `double` datatype is patterned after the IEEE double-precision 64-bit\n    floating point datatype [IEEE 754-2008]. Each floating point datatype has a\n    value space that is a subset of the rational numbers. Floating point\n    numbers are often used to approximate arbitrary real numbers.\n  ",
      label: "double",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :duration,
      comment: "\n    `duration` is a datatype that represents durations of time. The concept of\n    duration being captured is drawn from those of [ISO 8601], specifically\n    durations without fixed endpoints. For example, \"15 days\" (whose most\n    common lexical representation in duration is `\"'P15D'\"`) is a duration value;\n    \"15 days beginning 12 July 1995\" and \"15 days ending 12 July 1995\" are not\n    duration values. duration can provide addition and subtraction operations\n    between duration values and between duration/dateTime value pairs, and can\n    be the result of subtracting dateTime values. However, only addition to\n    `dateTime` is required for XML Schema processing and is defined in the\n    function `dateTimePlusDuration`.\n  ",
      label: "duration",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :float,
      comment: "\n    The `float` datatype is patterned after the IEEE single-precision 32-bit\n    floating point datatype [IEEE 754-2008]. Its value space is a subset of the\n    rational numbers. Floating point numbers are often used to approximate\n    arbitrary real numbers.\n  ",
      label: "float",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :gDay,
      comment: "\n    `gDay` represents whole days within an arbitrary month—days that recur at the\n    same point in each (Gregorian) month. This datatype is used to represent a\n    specific day of the month. To indicate, for example, that an employee gets\n    a paycheck on the 15th of each month. (Obviously, days beyond 28 cannot\n    occur in all months; they are nonetheless permitted, up to 31.)\n  ",
      label: "gDay",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :gMonth,
      comment: "\n    `gMonth` represents whole (Gregorian) months within an arbitrary year—months\n    that recur at the same point in each year. It might be used, for example,\n    to say what month annual Thanksgiving celebrations fall in different\n    countries (`--11` in the United States, `--10` in Canada, and possibly other\n    months in other countries).\n  ",
      label: "gMonth",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :gMonthDay,
      comment: "\n    `gMonthDay` represents whole calendar days that recur at the same point in\n    each calendar year, or that occur in some arbitrary calendar year.\n    (Obviously, days beyond 28 cannot occur in all Februaries; 29 is\n    nonetheless permitted.)\n  ",
      label: "gMonthDay",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :gYear,
      comment: "\n    `gYear` represents Gregorian calendar years.\n  ",
      label: "gYear",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :gYearMonth,
      comment: "\n    `gYearMonth` represents specific whole Gregorian months in specific Gregorian years.\n  ",
      label: "gYearMonth",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :hexBinary,
      comment: "\n    hexBinary` represents arbitrary hex-encoded binary data. \n  ",
      label: "hexBinary",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :int,
      comment: "\n      `int` is _derived_ from `long` by setting the value of `maxInclusive` to be\n      `2147483647` and `minInclusive` to be `-2147483648`. The _base type_ of `int`\n      is `long`.\n  ",
      label: "int",
      subClassOf: "http://www.w3.org/2001/XMLSchema#long",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :integer,
      comment: "\n     `integer` is _derived_ from `decimal` by fixing the value of `fractionDigits`\n     to be `0` and disallowing the trailing decimal point. This results in the\n     standard mathematical concept of the integer numbers. The _value space_ of\n     `integer` is the infinite set `{...,-2,-1,0,1,2,...}`. The _base type_ of\n     `integer` is `decimal`.\n  ",
      label: "integer",
      subClassOf: "http://www.w3.org/2001/XMLSchema#decimal",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :language,
      comment: "\n    `language` represents formal natural language identifiers, as defined by [BCP\n    47] (currently represented by [RFC 4646] and [RFC 4647]) or its\n    successor(s). The _value space_ and _lexical space_ of `language` are the set\n    of all strings that conform to the pattern `[a-zA-Z]{1,8}(-[a-zA-Z0-9]{1,8})*`.\n  ",
      label: "language",
      subClassOf: "http://www.w3.org/2001/XMLSchema#token",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :long,
      comment: "\n     `long` is _derived_ from `integer` by setting the value of `maxInclusive` to\n     be `9223372036854775807` and `minInclusive` to be `-9223372036854775808`. The\n     _base type_ of `long` is `integer`.\n  ",
      label: "long",
      subClassOf: "http://www.w3.org/2001/XMLSchema#integer",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :negativeInteger,
      comment: "\n     `negativeInteger` is _derived_ from `nonPositiveInteger` by setting the value\n     of `maxInclusive` to be `-1`. This results in the standard mathematical\n     concept of the negative integers. The _value space_ of `negativeInteger` is\n     the infinite set `{...,-2,-1}`. The _base type_ of `negativeInteger` is\n     `nonPositiveInteger`.\n  ",
      label: "negativeInteger",
      subClassOf: "http://www.w3.org/2001/XMLSchema#nonPositiveInteger",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :nonNegativeInteger,
      comment: "\n     `nonNegativeInteger` is _derived_ from `integer` by setting the value of\n     `minInclusive` to be `0`. This results in the standard mathematical concept\n     of the non-negative integers. The _value space_ of `nonNegativeInteger` is\n     the infinite set `{0,1,2,...}`. The _base type_ of `nonNegativeInteger` is\n     `integer`.\n  ",
      label: "nonNegativeInteger",
      subClassOf: "http://www.w3.org/2001/XMLSchema#integer",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :nonPositiveInteger,
      comment: "\n    `nonPositiveInteger` is _derived_ from `integer` by setting the value of\n    `maxInclusive` to be `0`. This results in the standard mathematical concept\n    of the non-positive integers. The _value space_ of `nonPositiveInteger` is\n    the infinite set `{...,-2,-1,0}`. The _base type_ of `nonPositiveInteger` is\n    `integer`.\n  ",
      label: "nonPositiveInteger",
      subClassOf: "http://www.w3.org/2001/XMLSchema#integer",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :normalizedString,
      comment: "\n    `normalizedString` represents white space normalized strings. The _value\n    space_ of `normalizedString` is the set of strings that do not contain the\n    carriage return (`#xD`), line feed (`#xA`) nor tab (`#x9`) characters. The\n    _lexical space_ of `normalizedString` is the set of strings that do not\n    contain the carriage return (`#xD`), line feed (`#xA`) nor tab (`#x9`)\n    characters. The _base type_ of `normalizedString` is `string`.\n  ",
      label: "normalizedString",
      subClassOf: "http://www.w3.org/2001/XMLSchema#string",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :positiveInteger,
      comment: "\n     `positiveInteger` is _derived_ from `nonNegativeInteger` by setting the value\n     of `minInclusive` to be `1`. This results in the standard mathematical\n     concept of the positive integer numbers. The _value space_ of\n     `positiveInteger` is the infinite set `{1,2,...}`. The _base type_ of\n     `positiveInteger` is `nonNegativeInteger`.\n  ",
      label: "positiveInteger",
      subClassOf: "http://www.w3.org/2001/XMLSchema#nonNegativeInteger",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :short,
      comment: "\n    `short` is _derived_ from `int` by setting the value of `maxInclusive` to be\n    `32767` and `minInclusive` to be `-32768`. The _base type_ of `short` is `int`.\n  ",
      label: "short",
      subClassOf: "http://www.w3.org/2001/XMLSchema#int",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :string,
      comment: "\n    The `string` datatype represents character strings in XML.\n  ",
      label: "string",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :time,
      comment: "\n    `time` represents instants of time that recur at the same point in each\n    calendar day, or that occur in some arbitrary calendar day.\n  ",
      label: "time",
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :token,
      comment: "\n     `token` represents tokenized strings. The _value space_ of `token` is the set\n     of strings that do not contain the carriage return (`#xD`), line feed (`#xA`)\n     nor tab (`#x9`) characters, that have no leading or trailing spaces (`#x20`)\n     and that have no internal sequences of two or more spaces. The _lexical\n     space_ of `token` is the set of strings that do not contain the carriage\n     return (`#xD`), line feed (`#xA`) nor tab (`#x9`) characters, that have no\n     leading or trailing spaces (`#x20`) and that have no internal sequences of\n     two or more spaces. The _base type_ of `token` is `normalizedString`.\n  ",
      label: "token",
      subClassOf: "http://www.w3.org/2001/XMLSchema#normalizedString",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :unsignedByte,
      comment: "\n      `unsignedByte` is _derived_ from `unsignedShort` by setting the value of\n      `maxInclusive` to be `255`. The _base type_ of `unsignedByte` is\n      `unsignedShort`.\n    ",
      label: "unsignedByte",
      subClassOf: "http://www.w3.org/2001/XMLSchema#unsignedShort",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :unsignedInt,
      comment: "\n    `unsignedInt` is _derived_ from `unsignedLong` by setting the value of\n    `maxInclusive` to be `4294967295`. The _base type_ of `unsignedInt` is\n    `unsignedLong`.\n  ",
      label: "unsignedInt",
      subClassOf: "http://www.w3.org/2001/XMLSchema#unsignedLong",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :unsignedLong,
      comment: "\n     `unsignedLong` is _derived_ from `nonNegativeInteger` by setting the value of\n     `maxInclusive` to be `18446744073709551615`. The _base type_ of `unsignedLong`\n     is `nonNegativeInteger`.\n  ",
      label: "unsignedLong",
      subClassOf: "http://www.w3.org/2001/XMLSchema#nonNegativeInteger",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :unsignedShort,
      comment: "\n       `unsignedShort` is _derived_ from `unsignedInt` by setting the value of\n       `maxInclusive` to be `65535`. The _base type_ of `unsignedShort` is\n       `unsignedInt`.\n    ",
      label: "unsignedShort",
      subClassOf: "http://www.w3.org/2001/XMLSchema#unsignedInt",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
    term :yearMonthDuration,
      comment: "\n     `yearMonthDuration` is a datatype _derived_ from `duration` by restricting its\n     _lexical representations_ to instances of `yearMonthDurationLexicalRep`. The\n     _value space_ of `yearMonthDuration` is therefore that of `duration`\n     restricted to those whose `seconds` property is `0`. This results in a\n     `duration` datatype which is totally ordered.\n  ",
      label: "yearMonthDuration",
      subClassOf: "http://www.w3.org/2001/XMLSchema#duration",
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype"
  end
end
