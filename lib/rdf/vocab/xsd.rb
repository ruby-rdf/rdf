# -*- encoding: utf-8 -*-
# frozen_string_literal: true
# This file generated automatically using rdf vocabulary format from http://www.w3.org/2001/XMLSchema#
require 'rdf'
module RDF
  # @!parse
  #   # Vocabulary for <http://www.w3.org/2001/XMLSchema#>
  #   #
  #   class XSD < RDF::Vocabulary
  #     #      ENTITIES represents the ENTITIES attribute type from [XML]. The ·value     space· of ENTITIES is the set of finite, non-zero-length sequences of     ·ENTITY· values that have been declared as unparsed entities in a document     type definition. The ·lexical space· of ENTITIES is the set of     space-separated lists of tokens, of which each token is in the ·lexical     space· of ENTITY. The ·item type· of ENTITIES is ENTITY. ENTITIES is     derived from ·anySimpleType· in two steps: an anonymous list type is     defined, whose ·item type· is ENTITY; this is the ·base type· of ENTITIES,     which restricts its value space to lists with at least one item.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :ENTITIES
  #
  #     #       ENTITY represents the ENTITY attribute type from [XML]. The ·value space·      of ENTITY is the set of all strings that ·match· the NCName production in      [Namespaces in XML] and have been declared as an unparsed entity in a      document type definition. The ·lexical space· of ENTITY is the set of all      strings that ·match· the NCName production in [Namespaces in XML]. The      ·base type· of ENTITY is NCName.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :ENTITY
  #
  #     #       ID represents the ID attribute type from [XML]. The ·value space· of ID is      the set of all strings that ·match· the NCName production in [Namespaces      in XML]. The ·lexical space· of ID is the set of all strings that ·match·      the NCName production in [Namespaces in XML]. The ·base type· of ID is      NCName.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :ID
  #
  #     #      IDREF represents the IDREF attribute type from [XML]. The ·value space· of     IDREF is the set of all strings that ·match· the NCName production in     [Namespaces in XML]. The ·lexical space· of IDREF is the set of strings     that ·match· the NCName production in [Namespaces in XML]. The ·base type·     of IDREF is NCName.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :IDREF
  #
  #     #      IDREFS represents the IDREFS attribute type from [XML]. The ·value space·     of IDREFS is the set of finite, non-zero-length sequences of IDREFs. The     ·lexical space· of IDREFS is the set of space-separated lists of tokens, of     which each token is in the ·lexical space· of IDREF. The ·item type· of     IDREFS is IDREF. IDREFS is derived from ·anySimpleType· in two steps: an     anonymous list type is defined, whose ·item type· is IDREF; this is the     ·base type· of IDREFS, which restricts its value space to lists with at     least one item.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :IDREFS
  #
  #     #       NCName represents XML "non-colonized" Names. The ·value space· of NCName      is the set of all strings which ·match· the NCName production of      [Namespaces in XML]. The ·lexical space· of NCName is the set of all      strings which ·match· the NCName production of [Namespaces in XML]. The      ·base type· of NCName is Name.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :NCName
  #
  #     #       NMTOKEN represents the NMTOKEN attribute type from [XML]. The ·value      space· of NMTOKEN is the set of tokens that ·match· the Nmtoken production      in [XML]. The ·lexical space· of NMTOKEN is the set of strings that      ·match· the Nmtoken production in [XML]. The ·base type· of NMTOKEN is      token.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :NMTOKEN
  #
  #     #      NMTOKENS represents the NMTOKENS attribute type from [XML]. The ·value     space· of NMTOKENS is the set of finite, non-zero-length sequences of     ·NMTOKEN·s. The ·lexical space· of NMTOKENS is the set of space-separated     lists of tokens, of which each token is in the ·lexical space· of NMTOKEN.     The ·item type· of NMTOKENS is NMTOKEN. NMTOKENS is derived from     ·anySimpleType· in two steps: an anonymous list type is defined, whose     ·item type· is NMTOKEN; this is the ·base type· of NMTOKENS, which     restricts its value space to lists with at least one item.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :NMTOKENS
  #
  #     #      NOTATION represents the NOTATION attribute type from [XML]. The ·value     space· of NOTATION is the set of QNames of notations declared in the     current schema. The ·lexical space· of NOTATION is the set of all names of     notations declared in the current schema (in the form of QNames).   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :NOTATION
  #
  #     #      Name represents XML Names. The ·value space· of Name is the set of all     strings which ·match· the Name production of [XML]. The ·lexical space· of     Name is the set of all strings which ·match· the Name production of [XML].     The ·base type· of Name is token.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :Name
  #
  #     #      QName represents XML qualified names. The ·value space· of QName is the set     of tuples `{namespace name, local part}`, where namespace name is an anyURI     and local part is an NCName. The ·lexical space· of QName is the set of     strings that ·match· the QName production of [Namespaces in XML].   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :QName
  #
  #     #      anyAtomicType is a special ·restriction· of anySimpleType. The ·value· and     ·lexical spaces· of anyAtomicType are the unions of the ·value· and     ·lexical spaces· of all the ·primitive· datatypes, and anyAtomicType is     their ·base type·.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :anyAtomicType
  #
  #     #      The definition of anySimpleType is a special ·restriction· of anyType. The     ·lexical space· of anySimpleType is the set of all sequences of Unicode     characters, and its ·value space· includes all ·atomic values· and all     finite-length lists of zero or more ·atomic values·.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :anySimpleType
  #
  #     #      The root of the [XML Schema 1.1] datatype heirarchy.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :anyType
  #
  #     #      anyURI represents an Internationalized Resource Identifier Reference     (IRI). An anyURI value can be absolute or relative, and may have an     optional fragment identifier (i.e., it may be an IRI Reference). This     type should be used when the value fulfills the role of an IRI, as     defined in [RFC 3987] or its successor(s) in the IETF Standards Track.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :anyURI
  #
  #     #      base64Binary represents arbitrary Base64-encoded binary data. For     base64Binary data the entire binary stream is encoded using the Base64     Encoding defined in [RFC 3548], which is derived from the encoding     described in [RFC 2045].   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :base64Binary
  #
  #     #      boolean represents the values of two-valued logic.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :boolean
  #
  #     #      byte is ·derived· from short by setting the value of ·maxInclusive· to be     127 and ·minInclusive· to be -128. The ·base type· of byte is short.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :byte
  #
  #     #      date represents top-open intervals of exactly one day in length on the     timelines of dateTime, beginning on the beginning moment of each day, up to     but not including the beginning moment of the next day). For non-timezoned     values, the top-open intervals disjointly cover the non-timezoned timeline,     one per day. For timezoned values, the intervals begin at every minute and     therefore overlap.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :date
  #
  #     #      dateTime represents instants of time, optionally marked with a particular     time zone offset. Values representing the same instant but having different     time zone offsets are equal but not identical.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :dateTime
  #
  #     #      The dateTimeStamp datatype is ·derived· from dateTime by giving the value     required to its explicitTimezone facet. The result is that all values of     dateTimeStamp are required to have explicit time zone offsets and the     datatype is totally ordered.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :dateTimeStamp
  #
  #     #       dayTimeDuration is a datatype ·derived· from duration by restricting its      ·lexical representations· to instances of dayTimeDurationLexicalRep. The      ·value space· of dayTimeDuration is therefore that of duration restricted      to those whose ·months· property is 0. This results in a duration datatype      which is totally ordered.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :dayTimeDuration
  #
  #     #      decimal represents a subset of the real numbers, which can be represented     by decimal numerals. The ·value space· of decimal is the set of numbers     that can be obtained by dividing an integer by a non-negative power of ten,     i.e., expressible as i / 10n where i and n are integers and n ≥ 0.     Precision is not reflected in this value space; the number 2.0 is not     distinct from the number 2.00. The order relation on decimal is the order     relation on real numbers, restricted to this subset.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :decimal
  #
  #     #      The double datatype is patterned after the IEEE double-precision 64-bit     floating point datatype [IEEE 754-2008]. Each floating point datatype has a     value space that is a subset of the rational numbers. Floating point     numbers are often used to approximate arbitrary real numbers.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :double
  #
  #     #      duration is a datatype that represents durations of time. The concept of     duration being captured is drawn from those of [ISO 8601], specifically     durations without fixed endpoints. For example, "15 days" (whose most     common lexical representation in duration is "'P15D'") is a duration value;     "15 days beginning 12 July 1995" and "15 days ending 12 July 1995" are not     duration values. duration can provide addition and subtraction operations     between duration values and between duration/dateTime value pairs, and can     be the result of subtracting dateTime values. However, only addition to     dateTime is required for XML Schema processing and is defined in the     function ·dateTimePlusDuration·.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :duration
  #
  #     #      The float datatype is patterned after the IEEE single-precision 32-bit     floating point datatype [IEEE 754-2008]. Its value space is a subset of the     rational numbers. Floating point numbers are often used to approximate     arbitrary real numbers.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :float
  #
  #     #      gDay represents whole days within an arbitrary month—days that recur at the     same point in each (Gregorian) month. This datatype is used to represent a     specific day of the month. To indicate, for example, that an employee gets     a paycheck on the 15th of each month. (Obviously, days beyond 28 cannot     occur in all months; they are nonetheless permitted, up to 31.)   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :gDay
  #
  #     #      gMonth represents whole (Gregorian) months within an arbitrary year—months     that recur at the same point in each year. It might be used, for example,     to say what month annual Thanksgiving celebrations fall in different     countries (--11 in the United States, --10 in Canada, and possibly other     months in other countries).   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :gMonth
  #
  #     #      gMonthDay represents whole calendar days that recur at the same point in     each calendar year, or that occur in some arbitrary calendar year.     (Obviously, days beyond 28 cannot occur in all Februaries; 29 is     nonetheless permitted.)   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :gMonthDay
  #
  #     #      gYear represents Gregorian calendar years.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :gYear
  #
  #     #      gYearMonth represents specific whole Gregorian months in specific Gregorian years.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :gYearMonth
  #
  #     #      hexBinary represents arbitrary hex-encoded binary data.    
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :hexBinary
  #
  #     #        int is ·derived· from long by setting the value of ·maxInclusive· to be       2147483647 and ·minInclusive· to be -2147483648. The ·base type· of int       is long.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :int
  #
  #     #       integer is ·derived· from decimal by fixing the value of ·fractionDigits·      to be 0 and disallowing the trailing decimal point. This results in the      standard mathematical concept of the integer numbers. The ·value space· of      integer is the infinite set `{...,-2,-1,0,1,2,...}`. The ·base type· of      integer is decimal.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :integer
  #
  #     #      language represents formal natural language identifiers, as defined by [BCP     47] (currently represented by [RFC 4646] and [RFC 4647]) or its     successor(s). The ·value space· and ·lexical space· of language are the set     of all strings that conform to the pattern `[a-zA-Z]{1,8}(-[a-zA-Z0-9]{1,8})*`   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :language
  #
  #     #       long is ·derived· from integer by setting the value of ·maxInclusive· to      be 9223372036854775807 and ·minInclusive· to be -9223372036854775808. The      ·base type· of long is integer.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :long
  #
  #     #       negativeInteger is ·derived· from nonPositiveInteger by setting the value      of ·maxInclusive· to be -1. This results in the standard mathematical      concept of the negative integers. The ·value space· of negativeInteger is      the infinite set `{...,-2,-1}`. The ·base type· of negativeInteger is      nonPositiveInteger.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :negativeInteger
  #
  #     #       nonNegativeInteger is ·derived· from integer by setting the value of      ·minInclusive· to be 0. This results in the standard mathematical concept      of the non-negative integers. The ·value space· of nonNegativeInteger is      the infinite set `{0,1,2,...}`. The ·base type· of nonNegativeInteger is      integer.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :nonNegativeInteger
  #
  #     #      nonPositiveInteger is ·derived· from integer by setting the value of     ·maxInclusive· to be 0. This results in the standard mathematical concept     of the non-positive integers. The ·value space· of nonPositiveInteger is     the infinite set `{...,-2,-1,0}`. The ·base type· of nonPositiveInteger is     integer.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :nonPositiveInteger
  #
  #     #      normalizedString represents white space normalized strings. The ·value     space· of normalizedString is the set of strings that do not contain the     carriage return (#xD), line feed (#xA) nor tab (#x9) characters. The     ·lexical space· of normalizedString is the set of strings that do not     contain the carriage return (#xD), line feed (#xA) nor tab (#x9)     characters. The ·base type· of normalizedString is string.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :normalizedString
  #
  #     #       positiveInteger is ·derived· from nonNegativeInteger by setting the value      of ·minInclusive· to be 1. This results in the standard mathematical      concept of the positive integer numbers. The ·value space· of      positiveInteger is the infinite set `{1,2,...}`. The ·base type· of      positiveInteger is nonNegativeInteger.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :positiveInteger
  #
  #     #      short is ·derived· from int by setting the value of ·maxInclusive· to be     32767 and ·minInclusive· to be -32768. The ·base type· of short is int.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :short
  #
  #     #      The string datatype represents character strings in XML.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :string
  #
  #     #      time represents instants of time that recur at the same point in each     calendar day, or that occur in some arbitrary calendar day.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :time
  #
  #     #       token represents tokenized strings. The ·value space· of token is the set      of strings that do not contain the carriage return (#xD), line feed (#xA)      nor tab (#x9) characters, that have no leading or trailing spaces (#x20)      and that have no internal sequences of two or more spaces. The ·lexical      space· of token is the set of strings that do not contain the carriage      return (#xD), line feed (#xA) nor tab (#x9) characters, that have no      leading or trailing spaces (#x20) and that have no internal sequences of      two or more spaces. The ·base type· of token is normalizedString.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :token
  #
  #     #        nsignedByte is ·derived· from unsignedShort by setting the value of       ·maxInclusive· to be 255. The ·base type· of unsignedByte is       unsignedShort.     
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :unsignedByte
  #
  #     #      unsignedInt is ·derived· from unsignedLong by setting the value of     ·maxInclusive· to be 4294967295. The ·base type· of unsignedInt is     unsignedLong.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :unsignedInt
  #
  #     #       unsignedLong is ·derived· from nonNegativeInteger by setting the value of      ·maxInclusive· to be 18446744073709551615. The ·base type· of unsignedLong      is nonNegativeInteger.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :unsignedLong
  #
  #     #         unsignedShort is ·derived· from unsignedInt by setting the value of        ·maxInclusive· to be 65535. The ·base type· of unsignedShort is        unsignedInt.     
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :unsignedShort
  #
  #     #       yearMonthDuration is a datatype ·derived· from duration by restricting its      ·lexical representations· to instances of yearMonthDurationLexicalRep. The      ·value space· of yearMonthDuration is therefore that of duration      restricted to those whose ·seconds· property is 0. This results in a      duration datatype which is totally ordered.   
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :yearMonthDuration
  #
  #   end
  XSD = Class.new(RDF::Vocabulary("http://www.w3.org/2001/XMLSchema#")) do

    # Datatype definitions
    term :ENTITIES,
      comment: "\n    ENTITIES represents the ENTITIES attribute type from [XML]. The ·value\n    space· of ENTITIES is the set of finite, non-zero-length sequences of\n    ·ENTITY· values that have been declared as unparsed entities in a document\n    type definition. The ·lexical space· of ENTITIES is the set of\n    space-separated lists of tokens, of which each token is in the ·lexical\n    space· of ENTITY. The ·item type· of ENTITIES is ENTITY. ENTITIES is\n    derived from ·anySimpleType· in two steps: an anonymous list type is\n    defined, whose ·item type· is ENTITY; this is the ·base type· of ENTITIES,\n    which restricts its value space to lists with at least one item.\n  ".freeze,
      label: "ENTITIES".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anySimpleType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :ENTITY,
      comment: "\n     ENTITY represents the ENTITY attribute type from [XML]. The ·value space·\n     of ENTITY is the set of all strings that ·match· the NCName production in\n     [Namespaces in XML] and have been declared as an unparsed entity in a\n     document type definition. The ·lexical space· of ENTITY is the set of all\n     strings that ·match· the NCName production in [Namespaces in XML]. The\n     ·base type· of ENTITY is NCName.\n  ".freeze,
      label: "ENTITY".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#NCName".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :ID,
      comment: "\n     ID represents the ID attribute type from [XML]. The ·value space· of ID is\n     the set of all strings that ·match· the NCName production in [Namespaces\n     in XML]. The ·lexical space· of ID is the set of all strings that ·match·\n     the NCName production in [Namespaces in XML]. The ·base type· of ID is\n     NCName.\n  ".freeze,
      label: "ID".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#NCName".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :IDREF,
      comment: "\n    IDREF represents the IDREF attribute type from [XML]. The ·value space· of\n    IDREF is the set of all strings that ·match· the NCName production in\n    [Namespaces in XML]. The ·lexical space· of IDREF is the set of strings\n    that ·match· the NCName production in [Namespaces in XML]. The ·base type·\n    of IDREF is NCName.\n  ".freeze,
      label: "IDREF".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#NCName".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :IDREFS,
      comment: "\n    IDREFS represents the IDREFS attribute type from [XML]. The ·value space·\n    of IDREFS is the set of finite, non-zero-length sequences of IDREFs. The\n    ·lexical space· of IDREFS is the set of space-separated lists of tokens, of\n    which each token is in the ·lexical space· of IDREF. The ·item type· of\n    IDREFS is IDREF. IDREFS is derived from ·anySimpleType· in two steps: an\n    anonymous list type is defined, whose ·item type· is IDREF; this is the\n    ·base type· of IDREFS, which restricts its value space to lists with at\n    least one item.\n  ".freeze,
      label: "IDREFS".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anySimpleType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :NCName,
      comment: "\n     NCName represents XML \"non-colonized\" Names. The ·value space· of NCName\n     is the set of all strings which ·match· the NCName production of\n     [Namespaces in XML]. The ·lexical space· of NCName is the set of all\n     strings which ·match· the NCName production of [Namespaces in XML]. The\n     ·base type· of NCName is Name.\n  ".freeze,
      label: "NCName".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#Name".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :NMTOKEN,
      comment: "\n     NMTOKEN represents the NMTOKEN attribute type from [XML]. The ·value\n     space· of NMTOKEN is the set of tokens that ·match· the Nmtoken production\n     in [XML]. The ·lexical space· of NMTOKEN is the set of strings that\n     ·match· the Nmtoken production in [XML]. The ·base type· of NMTOKEN is\n     token.\n  ".freeze,
      label: "NMTOKEN".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#token".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :NMTOKENS,
      comment: "\n    NMTOKENS represents the NMTOKENS attribute type from [XML]. The ·value\n    space· of NMTOKENS is the set of finite, non-zero-length sequences of\n    ·NMTOKEN·s. The ·lexical space· of NMTOKENS is the set of space-separated\n    lists of tokens, of which each token is in the ·lexical space· of NMTOKEN.\n    The ·item type· of NMTOKENS is NMTOKEN. NMTOKENS is derived from\n    ·anySimpleType· in two steps: an anonymous list type is defined, whose\n    ·item type· is NMTOKEN; this is the ·base type· of NMTOKENS, which\n    restricts its value space to lists with at least one item.\n  ".freeze,
      label: "NMTOKENS".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anySimpleType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :NOTATION,
      comment: "\n    NOTATION represents the NOTATION attribute type from [XML]. The ·value\n    space· of NOTATION is the set of QNames of notations declared in the\n    current schema. The ·lexical space· of NOTATION is the set of all names of\n    notations declared in the current schema (in the form of QNames).\n  ".freeze,
      label: "NOTATION".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :Name,
      comment: "\n    Name represents XML Names. The ·value space· of Name is the set of all\n    strings which ·match· the Name production of [XML]. The ·lexical space· of\n    Name is the set of all strings which ·match· the Name production of [XML].\n    The ·base type· of Name is token.\n  ".freeze,
      label: "Name".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#token".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :QName,
      comment: "\n    QName represents XML qualified names. The ·value space· of QName is the set\n    of tuples {namespace name, local part}, where namespace name is an anyURI\n    and local part is an NCName. The ·lexical space· of QName is the set of\n    strings that ·match· the QName production of [Namespaces in XML].\n  ".freeze,
      label: "QName".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :anyAtomicType,
      comment: "\n    anyAtomicType is a special ·restriction· of anySimpleType. The ·value· and\n    ·lexical spaces· of anyAtomicType are the unions of the ·value· and\n    ·lexical spaces· of all the ·primitive· datatypes, and anyAtomicType is\n    their ·base type·.\n  ".freeze,
      label: "anySimpleType".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :anySimpleType,
      comment: "\n    The definition of anySimpleType is a special ·restriction· of anyType. The\n    ·lexical space· of anySimpleType is the set of all sequences of Unicode\n    characters, and its ·value space· includes all ·atomic values· and all\n    finite-length lists of zero or more ·atomic values·.\n  ".freeze,
      label: "anySimpleType".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :anyType,
      comment: "\n    The root of the [XML Schema 1.1] datatype heirarchy.\n  ".freeze,
      label: "anyType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :anyURI,
      comment: "\n    anyURI represents an Internationalized Resource Identifier Reference\n    (IRI). An anyURI value can be absolute or relative, and may have an\n    optional fragment identifier (i.e., it may be an IRI Reference). This\n    type should be used when the value fulfills the role of an IRI, as\n    defined in [RFC 3987] or its successor(s) in the IETF Standards Track.\n  ".freeze,
      label: "anyURI".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :base64Binary,
      comment: "\n    base64Binary represents arbitrary Base64-encoded binary data. For\n    base64Binary data the entire binary stream is encoded using the Base64\n    Encoding defined in [RFC 3548], which is derived from the encoding\n    described in [RFC 2045].\n  ".freeze,
      label: "base64Binary".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :boolean,
      comment: "\n    boolean represents the values of two-valued logic.\n  ".freeze,
      label: "boolean".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :byte,
      comment: "\n    byte is ·derived· from short by setting the value of ·maxInclusive· to be\n    127 and ·minInclusive· to be -128. The ·base type· of byte is short.\n  ".freeze,
      label: "byte".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#short".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :date,
      comment: "\n    date represents top-open intervals of exactly one day in length on the\n    timelines of dateTime, beginning on the beginning moment of each day, up to\n    but not including the beginning moment of the next day). For non-timezoned\n    values, the top-open intervals disjointly cover the non-timezoned timeline,\n    one per day. For timezoned values, the intervals begin at every minute and\n    therefore overlap.\n  ".freeze,
      label: "date".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :dateTime,
      comment: "\n    dateTime represents instants of time, optionally marked with a particular\n    time zone offset. Values representing the same instant but having different\n    time zone offsets are equal but not identical.\n  ".freeze,
      label: "dateTime".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :dateTimeStamp,
      comment: "\n    The dateTimeStamp datatype is ·derived· from dateTime by giving the value\n    required to its explicitTimezone facet. The result is that all values of\n    dateTimeStamp are required to have explicit time zone offsets and the\n    datatype is totally ordered.\n  ".freeze,
      label: "dateTimeStamp".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#dateTime".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :dayTimeDuration,
      comment: "\n     dayTimeDuration is a datatype ·derived· from duration by restricting its\n     ·lexical representations· to instances of dayTimeDurationLexicalRep. The\n     ·value space· of dayTimeDuration is therefore that of duration restricted\n     to those whose ·months· property is 0. This results in a duration datatype\n     which is totally ordered.\n  ".freeze,
      label: "dayTimeDuration".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#duration".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :decimal,
      comment: "\n    decimal represents a subset of the real numbers, which can be represented\n    by decimal numerals. The ·value space· of decimal is the set of numbers\n    that can be obtained by dividing an integer by a non-negative power of ten,\n    i.e., expressible as i / 10n where i and n are integers and n ≥ 0.\n    Precision is not reflected in this value space; the number 2.0 is not\n    distinct from the number 2.00. The order relation on decimal is the order\n    relation on real numbers, restricted to this subset.\n  ".freeze,
      label: "decimal".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :double,
      comment: "\n    The double datatype is patterned after the IEEE double-precision 64-bit\n    floating point datatype [IEEE 754-2008]. Each floating point datatype has a\n    value space that is a subset of the rational numbers. Floating point\n    numbers are often used to approximate arbitrary real numbers.\n  ".freeze,
      label: "double".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :duration,
      comment: "\n    duration is a datatype that represents durations of time. The concept of\n    duration being captured is drawn from those of [ISO 8601], specifically\n    durations without fixed endpoints. For example, \"15 days\" (whose most\n    common lexical representation in duration is \"'P15D'\") is a duration value;\n    \"15 days beginning 12 July 1995\" and \"15 days ending 12 July 1995\" are not\n    duration values. duration can provide addition and subtraction operations\n    between duration values and between duration/dateTime value pairs, and can\n    be the result of subtracting dateTime values. However, only addition to\n    dateTime is required for XML Schema processing and is defined in the\n    function ·dateTimePlusDuration·.\n  ".freeze,
      label: "duration".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :float,
      comment: "\n    The float datatype is patterned after the IEEE single-precision 32-bit\n    floating point datatype [IEEE 754-2008]. Its value space is a subset of the\n    rational numbers. Floating point numbers are often used to approximate\n    arbitrary real numbers.\n  ".freeze,
      label: "float".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :gDay,
      comment: "\n    gDay represents whole days within an arbitrary month—days that recur at the\n    same point in each (Gregorian) month. This datatype is used to represent a\n    specific day of the month. To indicate, for example, that an employee gets\n    a paycheck on the 15th of each month. (Obviously, days beyond 28 cannot\n    occur in all months; they are nonetheless permitted, up to 31.)\n  ".freeze,
      label: "gDay".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :gMonth,
      comment: "\n    gMonth represents whole (Gregorian) months within an arbitrary year—months\n    that recur at the same point in each year. It might be used, for example,\n    to say what month annual Thanksgiving celebrations fall in different\n    countries (--11 in the United States, --10 in Canada, and possibly other\n    months in other countries).\n  ".freeze,
      label: "gMonth".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :gMonthDay,
      comment: "\n    gMonthDay represents whole calendar days that recur at the same point in\n    each calendar year, or that occur in some arbitrary calendar year.\n    (Obviously, days beyond 28 cannot occur in all Februaries; 29 is\n    nonetheless permitted.)\n  ".freeze,
      label: "gMonthDay".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :gYear,
      comment: "\n    gYear represents Gregorian calendar years.\n  ".freeze,
      label: "gYear".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :gYearMonth,
      comment: "\n    gYearMonth represents specific whole Gregorian months in specific Gregorian years.\n  ".freeze,
      label: "gYearMonth".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :hexBinary,
      comment: "\n    hexBinary represents arbitrary hex-encoded binary data. \n  ".freeze,
      label: "hexBinary".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :int,
      comment: "\n      int is ·derived· from long by setting the value of ·maxInclusive· to be\n      2147483647 and ·minInclusive· to be -2147483648. The ·base type· of int\n      is long.\n  ".freeze,
      label: "int".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#long".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :integer,
      comment: "\n     integer is ·derived· from decimal by fixing the value of ·fractionDigits·\n     to be 0 and disallowing the trailing decimal point. This results in the\n     standard mathematical concept of the integer numbers. The ·value space· of\n     integer is the infinite set {...,-2,-1,0,1,2,...}. The ·base type· of\n     integer is decimal.\n  ".freeze,
      label: "integer".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#decimal".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :language,
      comment: "\n    language represents formal natural language identifiers, as defined by [BCP\n    47] (currently represented by [RFC 4646] and [RFC 4647]) or its\n    successor(s). The ·value space· and ·lexical space· of language are the set\n    of all strings that conform to the pattern [a-zA-Z]{1,8}(-[a-zA-Z0-9]{1,8})*\n  ".freeze,
      label: "language".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#token".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :long,
      comment: "\n     long is ·derived· from integer by setting the value of ·maxInclusive· to\n     be 9223372036854775807 and ·minInclusive· to be -9223372036854775808. The\n     ·base type· of long is integer.\n  ".freeze,
      label: "long".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#integer".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :negativeInteger,
      comment: "\n     negativeInteger is ·derived· from nonPositiveInteger by setting the value\n     of ·maxInclusive· to be -1. This results in the standard mathematical\n     concept of the negative integers. The ·value space· of negativeInteger is\n     the infinite set {...,-2,-1}. The ·base type· of negativeInteger is\n     nonPositiveInteger.\n  ".freeze,
      label: "negativeInteger".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#nonPositiveInteger".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :nonNegativeInteger,
      comment: "\n     nonNegativeInteger is ·derived· from integer by setting the value of\n     ·minInclusive· to be 0. This results in the standard mathematical concept\n     of the non-negative integers. The ·value space· of nonNegativeInteger is\n     the infinite set {0,1,2,...}. The ·base type· of nonNegativeInteger is\n     integer.\n  ".freeze,
      label: "nonNegativeInteger".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#integer".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :nonPositiveInteger,
      comment: "\n    nonPositiveInteger is ·derived· from integer by setting the value of\n    ·maxInclusive· to be 0. This results in the standard mathematical concept\n    of the non-positive integers. The ·value space· of nonPositiveInteger is\n    the infinite set {...,-2,-1,0}. The ·base type· of nonPositiveInteger is\n    integer.\n  ".freeze,
      label: "nonPositiveInteger".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#integer".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :normalizedString,
      comment: "\n    normalizedString represents white space normalized strings. The ·value\n    space· of normalizedString is the set of strings that do not contain the\n    carriage return (#xD), line feed (#xA) nor tab (#x9) characters. The\n    ·lexical space· of normalizedString is the set of strings that do not\n    contain the carriage return (#xD), line feed (#xA) nor tab (#x9)\n    characters. The ·base type· of normalizedString is string.\n  ".freeze,
      label: "normalizedString".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#string".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :positiveInteger,
      comment: "\n     positiveInteger is ·derived· from nonNegativeInteger by setting the value\n     of ·minInclusive· to be 1. This results in the standard mathematical\n     concept of the positive integer numbers. The ·value space· of\n     positiveInteger is the infinite set {1,2,...}. The ·base type· of\n     positiveInteger is nonNegativeInteger.\n  ".freeze,
      label: "positiveInteger".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#nonNegativeInteger".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :short,
      comment: "\n    short is ·derived· from int by setting the value of ·maxInclusive· to be\n    32767 and ·minInclusive· to be -32768. The ·base type· of short is int.\n  ".freeze,
      label: "short".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#int".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :string,
      comment: "\n    The string datatype represents character strings in XML.\n  ".freeze,
      label: "string".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :time,
      comment: "\n    time represents instants of time that recur at the same point in each\n    calendar day, or that occur in some arbitrary calendar day.\n  ".freeze,
      label: "time".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#anyAtomicType".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :token,
      comment: "\n     token represents tokenized strings. The ·value space· of token is the set\n     of strings that do not contain the carriage return (#xD), line feed (#xA)\n     nor tab (#x9) characters, that have no leading or trailing spaces (#x20)\n     and that have no internal sequences of two or more spaces. The ·lexical\n     space· of token is the set of strings that do not contain the carriage\n     return (#xD), line feed (#xA) nor tab (#x9) characters, that have no\n     leading or trailing spaces (#x20) and that have no internal sequences of\n     two or more spaces. The ·base type· of token is normalizedString.\n  ".freeze,
      label: "token".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#normalizedString".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :unsignedByte,
      comment: "\n      nsignedByte is ·derived· from unsignedShort by setting the value of\n      ·maxInclusive· to be 255. The ·base type· of unsignedByte is\n      unsignedShort.\n    ".freeze,
      label: "unsignedByte".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#unsignedShort".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :unsignedInt,
      comment: "\n    unsignedInt is ·derived· from unsignedLong by setting the value of\n    ·maxInclusive· to be 4294967295. The ·base type· of unsignedInt is\n    unsignedLong.\n  ".freeze,
      label: "unsignedInt".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#unsignedLong".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :unsignedLong,
      comment: "\n     unsignedLong is ·derived· from nonNegativeInteger by setting the value of\n     ·maxInclusive· to be 18446744073709551615. The ·base type· of unsignedLong\n     is nonNegativeInteger.\n  ".freeze,
      label: "unsignedLong".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#nonNegativeInteger".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :unsignedShort,
      comment: "\n       unsignedShort is ·derived· from unsignedInt by setting the value of\n       ·maxInclusive· to be 65535. The ·base type· of unsignedShort is\n       unsignedInt.\n    ".freeze,
      label: "unsignedShort".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#unsignedInt".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
    term :yearMonthDuration,
      comment: "\n     yearMonthDuration is a datatype ·derived· from duration by restricting its\n     ·lexical representations· to instances of yearMonthDurationLexicalRep. The\n     ·value space· of yearMonthDuration is therefore that of duration\n     restricted to those whose ·seconds· property is 0. This results in a\n     duration datatype which is totally ordered.\n  ".freeze,
      label: "yearMonthDuration".freeze,
      subClassOf: "http://www.w3.org/2001/XMLSchema#duration".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze
  end
end
