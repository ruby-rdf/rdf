# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from etc/xsd.ttl
require 'rdf'
module RDF
  class XSD < RDF::Vocabulary("http://www.w3.org/2001/XMLSchema#")

    # Datatype definitions
    term :NCName,
      comment: %(
      NCName represents XML "non-colonized" Names. The ·value space· of NCName
      is the set of all strings which ·match· the NCName production of
      [Namespaces in XML]. The ·lexical space· of NCName is the set of all
      strings which ·match· the NCName production of [Namespaces in XML]. The
      ·base type· of NCName is Name.
    ).freeze,
      label: "NCName".freeze,
      subClassOf: "xsd:name".freeze,
      type: "rdfs:Datatype".freeze
    term :NMTOKEN,
      comment: %(
      NMTOKEN represents the NMTOKEN attribute type from [XML 1.0 \(Second
      Edition\)]. The ·value space· of NMTOKEN is the set of tokens that ·match·
      the Nmtoken production in [XML 1.0 \(Second Edition\)]. The ·lexical space·
      of NMTOKEN is the set of strings that ·match· the Nmtoken production in
      [XML 1.0 \(Second Edition\)]. The ·base type· of NMTOKEN is token.
    ).freeze,
      label: "NMTOKEN".freeze,
      subClassOf: "xsd:token".freeze,
      type: "rdfs:Datatype".freeze
    term :Name,
      comment: %(
      Name represents XML Names. The ·value space· of Name is the set of all
      strings which ·match· the Name production of [XML 1.0 \(Second Edition\)].
      The ·lexical space· of Name is the set of all strings which ·match· the
      Name production of [XML 1.0 \(Second Edition\)]. The ·base type· of Name is
      token.
    ).freeze,
      label: "Name".freeze,
      subClassOf: "xsd:token".freeze,
      type: "rdfs:Datatype".freeze
    term :anyURI,
      comment: %(
      anyURI represents a Uniform Resource Identifier Reference \(URI\). An
      anyURI value can be absolute or relative, and may have an optional
      fragment identifier \(i.e., it may be a URI Reference\). This type should
      be used to specify the intention that the value fulfills the role of a
      URI as defined by [RFC 2396], as amended by [RFC 2732].
    ).freeze,
      label: "anyURI".freeze,
      type: "rdfs:Datatype".freeze
    term :base64Binary,
      comment: %(
      base64Binary represents Base64-encoded arbitrary binary data. The ·value
      space· of base64Binary is the set of finite-length sequences of binary
      octets. For base64Binary data the entire binary stream is encoded using
      the Base64 Alphabet in [RFC 2045].
    ).freeze,
      label: "base64Binary".freeze,
      type: "rdfs:Datatype".freeze
    term :boolean,
      comment: %(
      boolean has the ·value space· required to support the mathematical
      concept of binary-valued logic: {true, false}.
    ).freeze,
      label: "boolean".freeze,
      type: "rdfs:Datatype".freeze
    term :byte,
      comment: %(
      byte is ·derived· from short by setting the value of ·maxInclusive· to be
      127 and ·minInclusive· to be -128. The ·base type· of byte is short.
    ).freeze,
      label: "byte".freeze,
      subClassOf: "xsd:short".freeze,
      type: "rdfs:Datatype".freeze
    term :date,
      comment: %(
      The ·value space· of date consists of top-open intervals of exactly one
      day in length on the timelines of dateTime, beginning on the beginning
      moment of each day \(in each timezone\), i.e. '00:00:00', up to but not
      including '24:00:00' \(which is identical with '00:00:00' of the next
      day\). For nontimezoned values, the top-open intervals disjointly cover
      the nontimezoned timeline, one per day. For timezoned values, the
      intervals begin at every minute and therefore overlap.
    ).freeze,
      label: "date".freeze,
      type: "rdfs:Datatype".freeze
    term :dateTime,
      comment: %(
      dateTime values may be viewed as objects with integer-valued year, month,
      day, hour and minute properties, a decimal-valued second property, and a
      boolean timezoned property. Each such object also has one decimal-valued
      method or computed property, timeOnTimeline, whose value is always a
      decimal number; the values are dimensioned in seconds, the integer 0 is
      0001-01-01T00:00:00 and the value of timeOnTimeline for other dateTime
      values is computed using the Gregorian algorithm as modified for
      leap-seconds. The timeOnTimeline values form two related "timelines", one
      for timezoned values and one for non-timezoned values. Each timeline is a
      copy of the ·value space· of decimal, with integers given units of seconds.
    ).freeze,
      label: "dateTime".freeze,
      type: "rdfs:Datatype".freeze
    term :decimal,
      comment: %(
      decimal represents a subset of the real numbers, which can be represented
      by decimal numerals. The ·value space· of decimal is the set of numbers
      that can be obtained by multiplying an integer by a non-positive power of
      ten, i.e., expressible as i × 10^-n where i and n are integers and n >=
      0. Precision is not reflected in this value space; the number 2.0 is not
      distinct from the number 2.00. The ·order-relation· on decimal is the
      order relation on real numbers, restricted to this subset.
    ).freeze,
      label: "decimal".freeze,
      type: "rdfs:Datatype".freeze
    term :double,
      comment: %(
      The double datatype is patterned after the IEEE double-precision 64-bit
      floating point type [IEEE 754-1985]. The basic ·value space· of double
      consists of the values m × 2^e, where m is an integer whose absolute
      value is less than 2^53, and e is an integer between -1075 and 970,
      inclusive. In addition to the basic ·value space· described above, the
      ·value space· of double also contains the following three special values:
      positive and negative infinity and not-a-number \(NaN\). The
      ·order-relation· on double is: x < y iff y - x is positive for x and y in
      the value space. Positive infinity is greater than all other non-NaN
      values. NaN equals itself but is ·incomparable· with \(neither greater
      than nor less than\) any other value in the ·value space·.
    ).freeze,
      label: "double".freeze,
      type: "rdfs:Datatype".freeze
    term :duration,
      comment: %(
      duration represents a duration of time. The ·value space· of duration is
      a six-dimensional space where the coordinates designate the Gregorian
      year, month, day, hour, minute, and second components defined in §
      5.5.3.2 of [ISO 8601], respectively. These components are ordered in
      their significance by their order of appearance i.e. as year, month, day,
      hour, minute, and second.
    ).freeze,
      label: "duration".freeze,
      type: "rdfs:Datatype".freeze
    term :float,
      comment: %(
    float is patterned after the IEEE single-precision 32-bit floating point
    type [IEEE 754-1985]. The basic ·value space· of float consists of the
    values m × 2^e, where m is an integer whose absolute value is less than
    2^24, and e is an integer between -149 and 104, inclusive. In addition to
    the basic ·value space· described above, the ·value space· of float also
    contains the following three special values: positive and negative infinity
    and not-a-number \(NaN\). The ·order-relation· on float is: x < y iff y - x
    is positive for x and y in the value space. Positive infinity is greater
    than all other non-NaN values. NaN equals itself but is ·incomparable· with
    \(neither greater than nor less than\) any other value in the ·value space·.
  ).freeze,
      label: "float".freeze,
      type: "rdfs:Datatype".freeze
    term :gDay,
      comment: %(
      gDay is a gregorian day that recurs, specifically a day of the month such
      as the 5th of the month. Arbitrary recurring days are not supported by
      this datatype. The ·value space· of gDay is the space of a set of
      calendar dates as defined in § 3 of [ISO 8601]. Specifically, it is a set
      of one-day long, monthly periodic instances.
    ).freeze,
      label: "gDay".freeze,
      type: "rdfs:Datatype".freeze
    term :gMonth,
      comment: %(
      gMonth is a gregorian month that recurs every year. The ·value space· of
      gMonth is the space of a set of calendar months as defined in § 3 of [ISO
      8601]. Specifically, it is a set of one-month long, yearly periodic
      instances.
    ).freeze,
      label: "gMonth".freeze,
      type: "rdfs:Datatype".freeze
    term :gMonthDay,
      comment: %(
      gMonthDay is a gregorian date that recurs, specifically a day of the year
      such as the third of May. Arbitrary recurring dates are not supported by
      this datatype. The ·value space· of gMonthDay is the set of calendar
      dates, as defined in § 3 of [ISO 8601]. Specifically, it is a set of
      one-day long, annually periodic instances.
    ).freeze,
      label: "gMonthDay".freeze,
      type: "rdfs:Datatype".freeze
    term :gYear,
      comment: %(
      gYear represents a gregorian calendar year. The ·value space· of gYear is
      the set of Gregorian calendar years as defined in § 5.2.1 of [ISO 8601].
      Specifically, it is a set of one-year long, non-periodic instances e.g.
      lexical 1999 to represent the whole year 1999, independent of how many
      months and days this year has.
    ).freeze,
      label: "gYear".freeze,
      type: "rdfs:Datatype".freeze
    term :gYearMonth,
      comment: %(
      gYearMonth represents a specific gregorian month in a specific gregorian
      year. The ·value space· of gYearMonth is the set of Gregorian calendar
      months as defined in § 5.2.1 of [ISO 8601]. Specifically, it is a set of
      one-month long, non-periodic instances e.g. 1999-10 to represent the
      whole month of 1999-10, independent of how many days this month has.
    ).freeze,
      label: "gYearMonth".freeze,
      type: "rdfs:Datatype".freeze
    term :hexBinary,
      comment: %(
      hexBinary represents arbitrary hex-encoded binary data. The ·value space·
      of hexBinary is the set of finite-length sequences of binary octets.
    ).freeze,
      label: "hexBinary".freeze,
      type: "rdfs:Datatype".freeze
    term :int,
      comment: %(
      int is ·derived· from long by setting the value of ·maxInclusive· to be
      2147483647 and ·minInclusive· to be -2147483648. The ·base type· of int
      is long.
    ).freeze,
      label: "int".freeze,
      subClassOf: "xsd:long".freeze,
      type: "rdfs:Datatype".freeze
    term :integer,
      comment: %(
      integer is ·derived· from decimal by fixing the value of ·fractionDigits·
      to be 0and disallowing the trailing decimal point. This results in the
      standard mathematical concept of the integer numbers. The ·value space·
      of integer is the infinite set {...,-2,-1,0,1,2,...}. The ·base type· of
      integer is decimal.
    ).freeze,
      label: "integer".freeze,
      subClassOf: "xsd:decimal".freeze,
      type: "rdfs:Datatype".freeze
    term :language,
      comment: %(
      language represents natural language identifiers as defined by by [RFC
      3066] . The ·value space· of language is the set of all strings that are
      valid language identifiers as defined [RFC 3066] . The ·lexical space· of
      language is the set of all strings that conform to the pattern
      [a-zA-Z]{1,8}\(-[a-zA-Z0-9]{1,8}\)* . The ·base type· of language is token.
    ).freeze,
      label: "language".freeze,
      subClassOf: "xsd:token".freeze,
      type: "rdfs:Datatype".freeze
    term :long,
      comment: %(
      long is ·derived· from integer by setting the value of ·maxInclusive· to
      be 9223372036854775807 and ·minInclusive· to be -9223372036854775808. The
      ·base type· of long is integer.
    ).freeze,
      label: "long".freeze,
      subClassOf: "xsd:integer".freeze,
      type: "rdfs:Datatype".freeze
    term :negativeInteger,
      comment: %(
      negativeInteger is ·derived· from nonPositiveInteger by setting the value
      of ·maxInclusive· to be -1. This results in the standard mathematical
      concept of the negative integers. The ·value space· of negativeInteger is
      the infinite set {...,-2,-1}. The ·base type· of negativeInteger is
      nonPositiveInteger.
    ).freeze,
      label: "negativeInteger".freeze,
      subClassOf: "xsd:nonPositiveInteger".freeze,
      type: "rdfs:Datatype".freeze
    term :nonNegativeInteger,
      comment: %(
      nonNegativeInteger is ·derived· from integer by setting the value of
      ·minInclusive· to be 0. This results in the standard mathematical concept
      of the non-negative integers. The ·value space· of nonNegativeInteger is
      the infinite set {0,1,2,...}. The ·base type· of nonNegativeInteger is
      integer.
    ).freeze,
      label: "nonNegativeInteger".freeze,
      subClassOf: "xsd:integer".freeze,
      type: "rdfs:Datatype".freeze
    term :nonPositiveInteger,
      comment: %(
      nonPositiveInteger is ·derived· from integer by setting the value of
      ·maxInclusive· to be 0. This results in the standard mathematical concept
      of the non-positive integers. The ·value space· of nonPositiveInteger is
      the infinite set {...,-2,-1,0}. The ·base type· of nonPositiveInteger is
      integer.
    ).freeze,
      label: "nonPositiveInteger".freeze,
      subClassOf: "xsd:integer".freeze,
      type: "rdfs:Datatype".freeze
    term :normalizedString,
      comment: %(
      normalizedString represents white space normalized strings. The ·value
      space· of normalizedString is the set of strings that do not contain the
      carriage return \(#xD\), line feed \(#xA\) nor tab \(#x9\) characters. The
      ·lexical space· of normalizedString is the set of strings that do not
      contain the carriage return \(#xD\), line feed \(#xA\) nor tab \(#x9\)
      characters. The ·base type· of normalizedString is string.
    ).freeze,
      label: "normalizedString".freeze,
      subClassOf: "xsd:string".freeze,
      type: "rdfs:Datatype".freeze
    term :positiveInteger,
      comment: %(
      positiveInteger is ·derived· from nonNegativeInteger by setting the value
      of ·minInclusive· to be 1. This results in the standard mathematical
      concept of the positive integer numbers. The ·value space· of
      positiveInteger is the infinite set {1,2,...}. The ·base type· of
      positiveInteger is nonNegativeInteger.
    ).freeze,
      label: "positiveInteger".freeze,
      subClassOf: "xsd:nonNegativeInteger".freeze,
      type: "rdfs:Datatype".freeze
    term :short,
      comment: %(
      short is ·derived· from int by setting the value of ·maxInclusive· to be
      32767 and ·minInclusive· to be -32768. The ·base type· of short is int.
    ).freeze,
      label: "short".freeze,
      subClassOf: "xsd:int".freeze,
      type: "rdfs:Datatype".freeze
    term :string,
      comment: %(
     The string datatype represents character strings in XML. The ·value space·
     of string is the set of finite-length sequences of characters \(as defined
     in [XML 1.0 \(Second Edition\)]\) that ·match· the Char production from [XML
     1.0 \(Second Edition\)]. A character is an atomic unit of communication; it
     is not further specified except to note that every character has a
     corresponding Universal Character Set code point, which is an integer.
    ).freeze,
      label: "string".freeze,
      type: "rdfs:Datatype".freeze
    term :time,
      comment: %(
      time represents an instant of time that recurs every day. The ·value
      space· of time is the space of time of day values as defined in § 5.3 of
      [ISO 8601]. Specifically, it is a set of zero-duration daily time
      instances.
    ).freeze,
      label: "time".freeze,
      type: "rdfs:Datatype".freeze
    term :token,
      comment: %(
      token represents tokenized strings. The ·value space· of token is the set
      of strings that do not contain the carriage return \(#xD\), line feed \(#xA\)
      nor tab \(#x9\) characters, that have no leading or trailing spaces \(#x20\)
      and that have no internal sequences of two or more spaces. The ·lexical
      space· of token is the set of strings that do not contain the carriage
      return \(#xD\), line feed \(#xA\) nor tab \(#x9\) characters, that have no
      leading or trailing spaces \(#x20\) and that have no internal sequences of
      two or more spaces. The ·base type· of token is normalizedString.
    ).freeze,
      label: "token".freeze,
      subClassOf: "xsd:normalizedString".freeze,
      type: "rdfs:Datatype".freeze
    term :unsignedByte,
      comment: %(
      unsignedByte is ·derived· from unsignedShort by setting the value of
      ·maxInclusive· to be 255. The ·base type· of unsignedByte is
      unsignedShort.
    ).freeze,
      label: "unsignedByte".freeze,
      subClassOf: "xsd:unsignedShort".freeze,
      type: "rdfs:Datatype".freeze
    term :unsignedInt,
      comment: %(
      unsignedInt is ·derived· from unsignedLong by setting the value of
      ·maxInclusive· to be 4294967295. The ·base type· of unsignedInt is
      unsignedLong.
    ).freeze,
      label: "unsignedInt".freeze,
      subClassOf: "xsd:unsignedLong".freeze,
      type: "rdfs:Datatype".freeze
    term :unsignedLong,
      comment: %(
      unsignedLong is ·derived· from nonNegativeInteger by setting the value of
      ·maxInclusive· to be 18446744073709551615. The ·base type· of
      unsignedLong is nonNegativeInteger.
    ).freeze,
      label: "unsignedLong".freeze,
      subClassOf: "xsd:nonNegativeInteger".freeze,
      type: "rdfs:Datatype".freeze
    term :unsignedShort,
      comment: %(
      unsignedShort is ·derived· from unsignedInt by setting the value of
      ·maxInclusive· to be 65535. The ·base type· of unsignedShort is
      unsignedInt.
    ).freeze,
      label: "unsignedShort".freeze,
      subClassOf: "xsd:unsignedInt".freeze,
      type: "rdfs:Datatype".freeze
  end
end
