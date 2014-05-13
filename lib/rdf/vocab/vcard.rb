# This file generated automatically using vocab-fetch from http://www.w3.org/2006/vcard/ns#
require 'rdf'
module RDF
  class VCARD < StrictVocabulary("http://www.w3.org/2006/vcard/ns#")

    # Class definitions
    term :Acquaintance,
      label: "Acquaintance".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Address,
      comment: %(To specify the components of the delivery address for the  object).freeze,
      label: "Address".freeze,
      "owl:equivalentClass" => %(_:g2189369100).freeze,
      type: "owl:Class".freeze
    term :Agent,
      label: "Agent".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :BBS,
      comment: %(This class is deprecated).freeze,
      label: "BBS".freeze,
      "owl:deprecated" => %(true).freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :Car,
      comment: %(This class is deprecated).freeze,
      label: "Car".freeze,
      "owl:deprecated" => %(true).freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :Cell,
      comment: %(Also called mobile telephone).freeze,
      label: "Cell".freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :Child,
      label: "Child".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Colleague,
      label: "Colleague".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Contact,
      label: "Contact".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Coresident,
      label: "Coresident".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Coworker,
      label: "Coworker".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Crush,
      label: "Crush".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Date,
      label: "Date".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Dom,
      comment: %(This class is deprecated).freeze,
      label: "Dom".freeze,
      "owl:deprecated" => %(true).freeze,
      subClassOf: "vcard:Type".freeze,
      type: "owl:Class".freeze
    term :Email,
      comment: %(To specify the electronic mail address for communication with the object the vCard represents. Use the hasEmail object property.).freeze,
      label: "Email".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:Class".freeze
    term :Emergency,
      label: "Emergency".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Fax,
      label: "Fax".freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :Female,
      label: "Female".freeze,
      subClassOf: "vcard:Gender".freeze,
      type: "owl:Class".freeze
    term :Friend,
      label: "Friend".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Gender,
      comment: %(Used for gender codes. The URI of the gender code must be used as the value for Gender.).freeze,
      label: "Gender".freeze,
      type: "owl:Class".freeze
    term :Group,
      comment: %(Object representing a group of persons or entities.  A group object will usually contain hasMember properties to specify the members of the group.).freeze,
      label: "Group".freeze,
      "owl:disjointWith" => %(vcard:Individual).freeze,
      "owl:equivalentClass" => %(_:g2157572220).freeze,
      subClassOf: "vcard:Kind".freeze,
      type: "owl:Class".freeze
    term :Home,
      comment: %(This implies that the property is related to an individual's personal life).freeze,
      label: "Home".freeze,
      subClassOf: "vcard:Type".freeze,
      type: "owl:Class".freeze
    term :ISDN,
      comment: %(This class is deprecated).freeze,
      label: "ISDN".freeze,
      "owl:deprecated" => %(true).freeze,
      subClassOf: "vcard:Type".freeze,
      type: "owl:Class".freeze
    term :Individual,
      comment: %(An object representing a single person or entity).freeze,
      label: "Individual".freeze,
      "owl:disjointWith" => %(vcard:Location).freeze,
      subClassOf: "vcard:Kind".freeze,
      type: "owl:Class".freeze
    term :Internet,
      comment: %(This class is deprecated).freeze,
      label: "Internet".freeze,
      "owl:deprecated" => %(true).freeze,
      subClassOf: "vcard:Type".freeze,
      type: "owl:Class".freeze
    term :Intl,
      comment: %(This class is deprecated).freeze,
      label: "Intl".freeze,
      "owl:deprecated" => %(true).freeze,
      subClassOf: "vcard:Type".freeze,
      type: "owl:Class".freeze
    term :Kin,
      label: "Kin".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Kind,
      comment: %(The parent class for all objects).freeze,
      label: "Kind".freeze,
      "owl:equivalentClass" => %(vcard:VCard).freeze,
      type: "owl:Class".freeze
    term :Label,
      comment: %(This class is deprecated).freeze,
      label: "Label".freeze,
      "owl:deprecated" => %(true).freeze,
      subClassOf: "vcard:Type".freeze,
      type: "owl:Class".freeze
    term :Location,
      comment: %(An object representing a named geographical place).freeze,
      label: "Location".freeze,
      "owl:disjointWith" => %(vcard:Organization).freeze,
      subClassOf: "vcard:Kind".freeze,
      type: "owl:Class".freeze
    term :Male,
      label: "Male".freeze,
      subClassOf: "vcard:Gender".freeze,
      type: "owl:Class".freeze
    term :Me,
      label: "Me".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Met,
      label: "Met".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Modem,
      comment: %(This class is deprecated).freeze,
      label: "Modem".freeze,
      "owl:deprecated" => %(true).freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :Msg,
      comment: %(This class is deprecated).freeze,
      label: "Msg".freeze,
      "owl:deprecated" => %(true).freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :Muse,
      label: "Muse".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Name,
      comment: %(To specify the components of the name of the object).freeze,
      label: "Name".freeze,
      "owl:equivalentClass" => %(_:g2227687300).freeze,
      type: "owl:Class".freeze
    term :Neighbor,
      label: "Neighbor".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :None,
      label: "None".freeze,
      subClassOf: "vcard:Gender".freeze,
      type: "owl:Class".freeze
    term :Organization,
      comment: %(An object representing an organization.  An organization is a single entity, and might represent a business or government, a department or division within a business or government, a club, an association, or the like.
).freeze,
      label: "Organization".freeze,
      subClassOf: "vcard:Kind".freeze,
      type: "owl:Class".freeze
    term :Other,
      label: "Other".freeze,
      subClassOf: "vcard:Gender".freeze,
      type: "owl:Class".freeze
    term :PCS,
      comment: %(This class is deprecated).freeze,
      label: "PCS".freeze,
      "owl:deprecated" => %(true).freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :Pager,
      label: "Pager".freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :Parcel,
      comment: %(This class is deprecated).freeze,
      label: "Parcel".freeze,
      "owl:deprecated" => %(true).freeze,
      subClassOf: "vcard:Type".freeze,
      type: "owl:Class".freeze
    term :Parent,
      label: "Parent".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Postal,
      comment: %(This class is deprecated).freeze,
      label: "Postal".freeze,
      "owl:deprecated" => %(true).freeze,
      subClassOf: "vcard:Type".freeze,
      type: "owl:Class".freeze
    term :Pref,
      comment: %(This class is deprecated).freeze,
      label: "Pref".freeze,
      "owl:deprecated" => %(true).freeze,
      subClassOf: "vcard:Type".freeze,
      type: "owl:Class".freeze
    term :RelatedType,
      comment: %(Used for relation type codes. The URI of the relation type code must be used as the value for the Relation Type.).freeze,
      label: "Relation Type".freeze,
      type: "owl:Class".freeze
    term :Sibling,
      label: "Sibling".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Spouse,
      label: "Spouse".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Sweetheart,
      label: "Sweetheart".freeze,
      subClassOf: "vcard:RelatedType".freeze,
      type: "owl:Class".freeze
    term :Tel,
      comment: %(This class is deprecated. Use the hasTelephone object property.).freeze,
      label: "Tel".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:Class".freeze
    term :TelephoneType,
      comment: %(Used for telephone type codes. The URI of the telephone type code must be used as the value for the Telephone Type.).freeze,
      label: "Phone".freeze,
      type: "owl:Class".freeze
    term :Text,
      comment: %(Also called sms telephone).freeze,
      label: "Text".freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :TextPhone,
      label: "Text phone".freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :Type,
      comment: %(Used for type codes. The URI of the type code must be used as the value for Type.).freeze,
      label: "Type".freeze,
      type: "owl:Class".freeze
    term :Unknown,
      label: "Unknown".freeze,
      subClassOf: "vcard:Gender".freeze,
      type: "owl:Class".freeze
    term :VCard,
      comment: %(The vCard class is deprecated and equivalent to the new Kind class, which is the parent for the four explicit types of vCards (Individual, Organization, Location, Group)).freeze,
      label: "VCard".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:Class".freeze
    term :Video,
      label: "Video".freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :Voice,
      label: "Voice".freeze,
      subClassOf: "vcard:TelephoneType".freeze,
      type: "owl:Class".freeze
    term :Work,
      comment: %(This implies that the property is related to an individual's work place).freeze,
      label: "Work".freeze,
      subClassOf: "vcard:Type".freeze,
      type: "owl:Class".freeze
    term :X400,
      comment: %(This class is deprecated).freeze,
      label: "X400".freeze,
      "owl:deprecated" => %(true).freeze,
      subClassOf: "vcard:Type".freeze,
      type: "owl:Class".freeze

    # Property definitions
    property :"additional-name",
      comment: %(The additional name associated with the object).freeze,
      label: "additional name".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :adr,
      comment: %(This object property has been deprecated).freeze,
      label: "address".freeze,
      "owl:deprecated" => %(true).freeze,
      "owl:equivalentProperty" => %(vcard:hasAddress).freeze,
      type: "owl:ObjectProperty".freeze
    property :agent,
      comment: %(This object property has been deprecated).freeze,
      label: "agent".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:ObjectProperty".freeze
    property :anniversary,
      comment: %(The date of marriage, or equivalent, of the object).freeze,
      label: "anniversary".freeze,
      range: "xsd:dateTime".freeze,
      type: "owl:DatatypeProperty".freeze
    property :bday,
      comment: %(To specify the birth date of the object).freeze,
      label: "birth date".freeze,
      range: "xsd:dateTime".freeze,
      type: "owl:DatatypeProperty".freeze
    property :category,
      comment: %(The category information about the object, also known as tags).freeze,
      label: "category".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :class,
      comment: %(This data property has been deprecated).freeze,
      label: "class".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:DatatypeProperty".freeze
    property :"country-name",
      comment: %(The country name associated with the address of the object).freeze,
      label: "country name".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :email,
      comment: %(This object property has been deprecated).freeze,
      label: "email".freeze,
      "owl:deprecated" => %(true).freeze,
      "owl:equivalentProperty" => %(vcard:hasEmail).freeze,
      type: "owl:ObjectProperty".freeze
    property :"extended-address",
      comment: %(This data property has been deprecated).freeze,
      label: "extended address".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:DatatypeProperty".freeze
    property :"family-name",
      comment: %(The family name associated with the object).freeze,
      label: "family name".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :fn,
      comment: %(The formatted text corresponding to the name of the object).freeze,
      label: "formatted name".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :geo,
      comment: %(This object property has been deprecated).freeze,
      label: "geo".freeze,
      "owl:deprecated" => %(true).freeze,
      "owl:equivalentProperty" => %(vcard:hasGeo).freeze,
      type: "owl:ObjectProperty".freeze
    property :"given-name",
      comment: %(The given name associated with the object).freeze,
      label: "given name".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :hasAdditionalName,
      comment: %(Used to support property parameters for the additional name data property).freeze,
      label: "has additional name".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasAddress,
      comment: %(To specify the components of the delivery address for the object).freeze,
      label: "has address".freeze,
      range: "vcard:Address".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasCalendarBusy,
      comment: %(To specify the busy time associated with the object. (Was called FBURL in RFC6350)).freeze,
      label: "has calendar busy".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasCalendarLink,
      comment: %(To specify the calendar associated with the object. (Was called CALURI in RFC6350)).freeze,
      label: "has calendar link".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasCalendarRequest,
      comment: %(To specify the calendar user address to which a scheduling request be sent for the object. (Was called CALADRURI in RFC6350)).freeze,
      label: "has calendar request".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasCategory,
      comment: %(Used to support property parameters for the category data property).freeze,
      label: "has category".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasCountryName,
      comment: %(Used to support property parameters for the country name data property).freeze,
      label: "has country name".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasEmail,
      comment: %(To specify the electronic mail address for communication with the object).freeze,
      label: "has email".freeze,
      range: "vcard:Email".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasFN,
      comment: %(Used to support property parameters for the formatted name data property).freeze,
      label: "has formatted name".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasFamilyName,
      comment: %(Used to support property parameters for the family name data property).freeze,
      label: "has family name".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasGender,
      comment: %(To specify  the sex or gender identity of the object.
URIs are recommended to enable interoperable sex and gender codes to be used.).freeze,
      label: "has gender".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasGeo,
      comment: %(To specify information related to the global positioning of the object. May also be used as a property parameter.).freeze,
      label: "has geo".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasGivenName,
      comment: %(Used to support property parameters for the given name data property).freeze,
      label: "has given name".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasHonorificPrefix,
      comment: %(Used to support property parameters for the honorific prefix data property).freeze,
      label: "has honorific prefix".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasHonorificSuffix,
      comment: %(Used to support property parameters for the honorific suffix data property).freeze,
      label: "has honorific suffix".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasInstantMessage,
      comment: %(To specify the instant messaging and presence protocol communications with the object. (Was called IMPP in RFC6350)).freeze,
      label: "has messaging".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasKey,
      comment: %(To specify a public key or authentication certificate associated with the object).freeze,
      label: "has key".freeze,
      "owl:equivalentProperty" => %(vcard:key).freeze,
      type: "owl:ObjectProperty".freeze
    property :hasLanguage,
      comment: %(Used to support property parameters for the language data property).freeze,
      label: "has language".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasLocality,
      comment: %(Used to support property parameters for the locality data property).freeze,
      label: "has locality".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasLogo,
      comment: %(To specify a graphic image of a logo associated with the object ).freeze,
      label: "has logo".freeze,
      "owl:equivalentProperty" => %(vcard:logo).freeze,
      type: "owl:ObjectProperty".freeze
    property :hasMember,
      comment: %(To include a member in the group this object represents. (This property can only be used by Group individuals)).freeze,
      domain: "vcard:Group".freeze,
      label: "has member".freeze,
      range: "vcard:Kind".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasName,
      comment: %(To specify the components of the name of the object).freeze,
      label: "has name".freeze,
      "owl:equivalentProperty" => %(vcard:n).freeze,
      range: "vcard:Name".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasNickname,
      comment: %(Used to support property parameters for the nickname data property).freeze,
      label: "has nickname".freeze,
      "rdfs:seeAlso" => %( http://www.w3.org/2006/vcard/ns#nickname).freeze,
      type: "owl:ObjectProperty".freeze
    property :hasNote,
      comment: %(Used to support property parameters for the note data property).freeze,
      label: "has note".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasOrganizationName,
      comment: %(Used to support property parameters for the organization name data property).freeze,
      label: "has organization name".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasOrganizationUnit,
      comment: %(Used to support property parameters for the organization unit name data property).freeze,
      label: "has organization unit name".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasPhoto,
      comment: %(To specify an image or photograph information that annotates some aspect of the object).freeze,
      label: "has photo".freeze,
      "owl:equivalentProperty" => %(vcard:photo).freeze,
      type: "owl:ObjectProperty".freeze
    property :hasPostalCode,
      comment: %(Used to support property parameters for the postal code data property).freeze,
      label: "has postal code".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasRegion,
      comment: %(Used to support property parameters for the region data property).freeze,
      label: "has region".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasRelated,
      comment: %(To specify a relationship between another entity and the entity represented by this object).freeze,
      label: "has related".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasRole,
      comment: %(Used to support property parameters for the role data property).freeze,
      label: "has role".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasSound,
      comment: %(To specify a digital sound content information that annotates some aspect of the object).freeze,
      label: "has sound".freeze,
      "owl:equivalentProperty" => %(vcard:sound).freeze,
      type: "owl:ObjectProperty".freeze
    property :hasSource,
      comment: %(To identify the source of directory information of the object).freeze,
      label: "has source".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasStreetAddress,
      comment: %(Used to support property parameters for the street address data property).freeze,
      label: "has street address".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasTelephone,
      comment: %(To specify the telephone number for telephony communication with the object).freeze,
      label: "has telephone".freeze,
      "owl:equivalentProperty" => %(vcard:tel).freeze,
      type: "owl:ObjectProperty".freeze
    property :hasTitle,
      comment: %(Used to support property parameters for the title data property).freeze,
      label: "has title".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasUID,
      comment: %(To specify a value that represents a globally unique identifier corresponding to the object).freeze,
      label: "has uid".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasURL,
      comment: %(To specify a uniform resource locator associated with the object).freeze,
      label: "has url".freeze,
      "owl:equivalentProperty" => %(vcard:url).freeze,
      type: "owl:ObjectProperty".freeze
    property :hasValue,
      comment: %(Used to indicate the resource value of an object property that requires property parameters).freeze,
      label: "has value".freeze,
      type: "owl:ObjectProperty".freeze
    property :"honorific-prefix",
      comment: %(The honorific prefix of the name associated with the object).freeze,
      label: "honorific prefix".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :"honorific-suffix",
      comment: %(The honorific suffix of the name associated with the object).freeze,
      label: "honorific suffix".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :key,
      comment: %(This object property has been deprecated).freeze,
      label: "key".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:ObjectProperty".freeze
    property :label,
      comment: %(This data property has been deprecated).freeze,
      label: "label".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:DatatypeProperty".freeze
    property :language,
      comment: %(To specify the language that may be used for contacting the object. May also be used as a property parameter.).freeze,
      label: "language".freeze,
      type: "owl:DatatypeProperty".freeze
    property :latitude,
      comment: %(This data property has been deprecated).freeze,
      label: "latitude".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:DatatypeProperty".freeze
    property :locality,
      comment: %(The locality (e.g. city or town) associated with the address of the object).freeze,
      label: "locality".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :logo,
      comment: %(This object property has been deprecated).freeze,
      label: "logo".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:ObjectProperty".freeze
    property :longitude,
      comment: %(This data property has been deprecated).freeze,
      label: "longitude".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:DatatypeProperty".freeze
    property :mailer,
      comment: %(This data property has been deprecated).freeze,
      label: "mailer".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:DatatypeProperty".freeze
    property :n,
      comment: %(This object property has been deprecated).freeze,
      label: "name".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:ObjectProperty".freeze
    property :nickname,
      comment: %(The nick name associated with the object).freeze,
      label: "nickname".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :note,
      comment: %(A note associated with the object).freeze,
      label: "note".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :org,
      comment: %(This object property has been deprecated. Use the organization-name data property.).freeze,
      label: "organization".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:ObjectProperty".freeze
    property :"organization-name",
      comment: %(To specify the organizational name associated with the object).freeze,
      label: "organization name".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :"organization-unit",
      comment: %(To specify the organizational unit name associated with the object).freeze,
      label: "organizational unit name".freeze,
      range: "xsd:string".freeze,
      subPropertyOf: "vcard:organization-name".freeze,
      type: "owl:DatatypeProperty".freeze
    property :photo,
      comment: %(This object property has been deprecated).freeze,
      label: "photo".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:ObjectProperty".freeze
    property :"post-office-box",
      comment: %(This data property has been deprecated).freeze,
      label: "post office box".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:DatatypeProperty".freeze
    property :"postal-code",
      comment: %(The postal code associated with the address of the object).freeze,
      label: "postal code".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :prodid,
      comment: %(To specify the identifier for the product that created the object).freeze,
      label: "product id".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :region,
      comment: %(The region (e.g. state or province) associated with the address of the object).freeze,
      label: "region".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :rev,
      comment: %(To specify revision information about the object).freeze,
      label: "revision".freeze,
      range: "xsd:dateTime".freeze,
      type: "owl:DatatypeProperty".freeze
    property :role,
      comment: %(To specify the function or part played in a particular situation by the object).freeze,
      label: "role".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :"sort-string",
      comment: %(To specify the string to be used for national-language-specific sorting. Used as a property parameter only.).freeze,
      label: "sort as".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :sound,
      comment: %(This object property has been deprecated).freeze,
      label: "sound".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:ObjectProperty".freeze
    property :"street-address",
      comment: %(The street address associated with the address of the object).freeze,
      label: "street address".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :tel,
      comment: %(This object property has been deprecated).freeze,
      label: "telephone".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:ObjectProperty".freeze
    property :title,
      comment: %(To specify the position or job of the object).freeze,
      label: "title".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :tz,
      comment: %(To indicate time zone information that is specific to the object. May also be used as a property parameter.).freeze,
      label: "time zone".freeze,
      range: "xsd:string".freeze,
      type: "owl:DatatypeProperty".freeze
    property :url,
      comment: %(This object property has been deprecated).freeze,
      label: "url".freeze,
      "owl:deprecated" => %(true).freeze,
      type: "owl:ObjectProperty".freeze
    property :value,
      comment: %(Used to indicate the literal value of a data property that requires property parameters).freeze,
      label: "value".freeze,
      type: "owl:DatatypeProperty".freeze
  end
end
