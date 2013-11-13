# This file generated automatically using vocab-fetch from http://www.w3.org/2006/vcard/ns#
require 'rdf'
module RDF
  class VCARD < StrictVocabulary("http://www.w3.org/2006/vcard/ns#")

    # Class definitions
    property :Acquaintance, :label => 'Acquaintance'
    property :Address, :label => 'Address', :comment =>
      %(To specify the components of the delivery address for the
        object)
    property :Agent, :label => 'Agent'
    property :BBS, :label => 'BBS', :comment =>
      %(This class is deprecated)
    property :Car, :label => 'Car', :comment =>
      %(This class is deprecated)
    property :Cell, :label => 'Cell', :comment =>
      %(Also called mobile telephone)
    property :Child, :label => 'Child'
    property :Colleague, :label => 'Colleague'
    property :Contact, :label => 'Contact'
    property :Coresident, :label => 'Coresident'
    property :Coworker, :label => 'Coworker'
    property :Crush, :label => 'Crush'
    property :Date, :label => 'Date'
    property :Dom, :label => 'Dom', :comment =>
      %(This class is deprecated)
    property :Email, :label => 'Email', :comment =>
      %(To specify the electronic mail address for communication with
        the object the vCard represents. Use the hasEmail object
        property.)
    property :Emergency, :label => 'Emergency'
    property :Fax, :label => 'Fax'
    property :Female, :label => 'Female'
    property :Friend, :label => 'Friend'
    property :Gender, :label => 'Gender', :comment =>
      %(Used for gender codes. The URI of the gender code must be used
        as the value for Gender.)
    property :Group, :label => 'Group', :comment =>
      %(Object representing a group of persons or entities. A group
        object will usually contain hasMember properties to specify
        the members of the group.)
    property :Home, :label => 'Home', :comment =>
      %(This implies that the property is related to an individual's
        personal life)
    property :ISDN, :label => 'ISDN', :comment =>
      %(This class is deprecated)
    property :Individual, :label => 'Individual', :comment =>
      %(An object representing a single person or entity)
    property :Internet, :label => 'Internet', :comment =>
      %(This class is deprecated)
    property :Intl, :label => 'Intl', :comment =>
      %(This class is deprecated)
    property :Kin, :label => 'Kin'
    property :Kind, :label => 'Kind', :comment =>
      %(The parent class for all objects)
    property :Label, :label => 'Label', :comment =>
      %(This class is deprecated)
    property :Location, :label => 'Location', :comment =>
      %(An object representing a named geographical place)
    property :Male, :label => 'Male'
    property :Me, :label => 'Me'
    property :Met, :label => 'Met'
    property :Modem, :label => 'Modem', :comment =>
      %(This class is deprecated)
    property :Msg, :label => 'Msg', :comment =>
      %(This class is deprecated)
    property :Muse, :label => 'Muse'
    property :Name, :label => 'Name', :comment =>
      %(To specify the components of the name of the object)
    property :Neighbor, :label => 'Neighbor'
    property :None, :label => 'None'
    property :Organization, :label => 'Organization', :comment =>
      %(An object representing an organization. An organization is a
        single entity, and might represent a business or government, a
        department or division within a business or government, a
        club, an association, or the like.)
    property :Other, :label => 'Other'
    property :PCS, :label => 'PCS', :comment =>
      %(This class is deprecated)
    property :Pager, :label => 'Pager'
    property :Parcel, :label => 'Parcel', :comment =>
      %(This class is deprecated)
    property :Parent, :label => 'Parent'
    property :TelephoneType, :label => 'Phone', :comment =>
      %(Used for telephone type codes. The URI of the telephone type
        code must be used as the value for the Telephone Type.)
    property :Postal, :label => 'Postal', :comment =>
      %(This class is deprecated)
    property :Pref, :label => 'Pref', :comment =>
      %(This class is deprecated)
    property :RelatedType, :label => 'Relation Type', :comment =>
      %(Used for relation type codes. The URI of the relation type
        code must be used as the value for the Relation Type.)
    property :Sibling, :label => 'Sibling'
    property :Spouse, :label => 'Spouse'
    property :Sweetheart, :label => 'Sweetheart'
    property :Tel, :label => 'Tel', :comment =>
      %(This class is deprecated. Use the hasTelephone object
        property.)
    property :Text, :label => 'Text', :comment =>
      %(Also called sms telephone)
    property :TextPhone, :label => 'Text phone'
    property :Type, :label => 'Type', :comment =>
      %(Used for type codes. The URI of the type code must be used as
        the value for Type.)
    property :Unknown, :label => 'Unknown'
    property :VCard, :label => 'VCard', :comment =>
      %(The vCard class is deprecated and equivalent to the new Kind
        class, which is the parent for the four explicit types of
        vCards \(Individual, Organization, Location, Group\))
    property :Video, :label => 'Video'
    property :Voice, :label => 'Voice'
    property :Work, :label => 'Work', :comment =>
      %(This implies that the property is related to an individual's
        work place)
    property :X400, :label => 'X400', :comment =>
      %(This class is deprecated)

    # Property definitions
    property :"additional-name", :label => 'additional name', :comment =>
      %(The additional name associated with the object)
    property :anniversary, :label => 'anniversary', :comment =>
      %(The date of marriage, or equivalent, of the object)
    property :bday, :label => 'birth date', :comment =>
      %(To specify the birth date of the object)
    property :category, :label => 'category', :comment =>
      %(The category information about the object, also known as tags)
    property :class, :label => 'class', :comment =>
      %(This data property has been deprecated)
    property :"country-name", :label => 'country name', :comment =>
      %(The country name associated with the address of the object)
    property :"extended-address", :label => 'extended address', :comment =>
      %(This data property has been deprecated)
    property :"family-name", :label => 'family name', :comment =>
      %(The family name associated with the object)
    property :fn, :label => 'formatted name', :comment =>
      %(The formatted text corresponding to the name of the object)
    property :"given-name", :label => 'given name', :comment =>
      %(The given name associated with the object)
    property :"honorific-prefix", :label => 'honorific prefix', :comment =>
      %(The honorific prefix of the name associated with the object)
    property :"honorific-suffix", :label => 'honorific suffix', :comment =>
      %(The honorific suffix of the name associated with the object)
    property :label, :label => 'label', :comment =>
      %(This data property has been deprecated)
    property :language, :label => 'language', :comment =>
      %(To specify the language that may be used for contacting the
        object. May also be used as a property parameter.)
    property :latitude, :label => 'latitude', :comment =>
      %(This data property has been deprecated)
    property :locality, :label => 'locality', :comment =>
      %(The locality \(e.g. city or town\) associated with the address
        of the object)
    property :longitude, :label => 'longitude', :comment =>
      %(This data property has been deprecated)
    property :mailer, :label => 'mailer', :comment =>
      %(This data property has been deprecated)
    property :nickname, :label => 'nickname', :comment =>
      %(The nick name associated with the object)
    property :note, :label => 'note', :comment =>
      %(A note associated with the object)
    property :"organization-name", :label => 'organization name', :comment =>
      %(To specify the organizational name associated with the object)
    property :"organization-unit", :label => 'organizational unit name', :comment =>
      %(To specify the organizational unit name associated with the
        object)
    property :"post-office-box", :label => 'post office box', :comment =>
      %(This data property has been deprecated)
    property :"postal-code", :label => 'postal code', :comment =>
      %(The postal code associated with the address of the object)
    property :prodid, :label => 'product id', :comment =>
      %(To specify the identifier for the product that created the
        object)
    property :region, :label => 'region', :comment =>
      %(The region \(e.g. state or province\) associated with the
        address of the object)
    property :rev, :label => 'revision', :comment =>
      %(To specify revision information about the object)
    property :role, :label => 'role', :comment =>
      %(To specify the function or part played in a particular
        situation by the object)
    property :"sort-string", :label => 'sort as', :comment =>
      %(To specify the string to be used for
        national-language-specific sorting. Used as a property
        parameter only.)
    property :"street-address", :label => 'street address', :comment =>
      %(The street address associated with the address of the object)
    property :tz, :label => 'time zone', :comment =>
      %(To indicate time zone information that is specific to the
        object. May also be used as a property parameter.)
    property :title, :label => 'title', :comment =>
      %(To specify the position or job of the object)
    property :value, :label => 'value', :comment =>
      %(Used to indicate the literal value of a data property that
        requires property parameters)
    property :adr, :label => 'address', :comment =>
      %(This object property has been deprecated)
    property :agent, :label => 'agent', :comment =>
      %(This object property has been deprecated)
    property :email, :label => 'email', :comment =>
      %(This object property has been deprecated)
    property :geo, :label => 'geo', :comment =>
      %(This object property has been deprecated)
    property :hasAdditionalName, :label => 'has additional name', :comment =>
      %(Used to support property parameters for the additional name
        data property)
    property :hasAddress, :label => 'has address', :comment =>
      %(To specify the components of the delivery address for the
        object)
    property :hasCalendarBusy, :label => 'has calendar busy', :comment =>
      %(To specify the busy time associated with the object. \(Was
        called FBURL in RFC6350\))
    property :hasCalendarLink, :label => 'has calendar link', :comment =>
      %(To specify the calendar associated with the object. \(Was
        called CALURI in RFC6350\))
    property :hasCalendarRequest, :label => 'has calendar request', :comment =>
      %(To specify the calendar user address to which a scheduling
        request be sent for the object. \(Was called CALADRURI in
        RFC6350\))
    property :hasCategory, :label => 'has category', :comment =>
      %(Used to support property parameters for the category data
        property)
    property :hasCountryName, :label => 'has country name', :comment =>
      %(Used to support property parameters for the country name data
        property)
    property :hasEmail, :label => 'has email', :comment =>
      %(To specify the electronic mail address for communication with
        the object)
    property :hasFamilyName, :label => 'has family name', :comment =>
      %(Used to support property parameters for the family name data
        property)
    property :hasFN, :label => 'has formatted name', :comment =>
      %(Used to support property parameters for the formatted name
        data property)
    property :hasGender, :label => 'has gender', :comment =>
      %(To specify the sex or gender identity of the object. URIs are
        recommended to enable interoperable sex and gender codes to be
        used.)
    property :hasGeo, :label => 'has geo', :comment =>
      %(To specify information related to the global positioning of
        the object. May also be used as a property parameter.)
    property :hasGivenName, :label => 'has given name', :comment =>
      %(Used to support property parameters for the given name data
        property)
    property :hasHonorificPrefix, :label => 'has honorific prefix', :comment =>
      %(Used to support property parameters for the honorific prefix
        data property)
    property :hasHonorificSuffix, :label => 'has honorific suffix', :comment =>
      %(Used to support property parameters for the honorific suffix
        data property)
    property :hasKey, :label => 'has key', :comment =>
      %(To specify a public key or authentication certificate
        associated with the object)
    property :hasLanguage, :label => 'has language', :comment =>
      %(Used to support property parameters for the language data
        property)
    property :hasLocality, :label => 'has locality', :comment =>
      %(Used to support property parameters for the locality data
        property)
    property :hasLogo, :label => 'has logo', :comment =>
      %(To specify a graphic image of a logo associated with the
        object)
    property :hasMember, :label => 'has member', :comment =>
      %(To include a member in the group this object represents.
        \(This property can only be used by Group individuals\))
    property :hasInstantMessage, :label => 'has messaging', :comment =>
      %(To specify the instant messaging and presence protocol
        communications with the object. \(Was called IMPP in RFC6350\))
    property :hasName, :label => 'has name', :comment =>
      %(To specify the components of the name of the object)
    property :hasNickname, :label => 'has nickname', :comment =>
      %(Used to support property parameters for the nickname data
        property)
    property :hasNote, :label => 'has note', :comment =>
      %(Used to support property parameters for the note data property)
    property :hasOrganizationName, :label => 'has organization name', :comment =>
      %(Used to support property parameters for the organization name
        data property)
    property :hasOrganizationUnit, :label => 'has organization unit name', :comment =>
      %(Used to support property parameters for the organization unit
        name data property)
    property :hasPhoto, :label => 'has photo', :comment =>
      %(To specify an image or photograph information that annotates
        some aspect of the object)
    property :hasPostalCode, :label => 'has postal code', :comment =>
      %(Used to support property parameters for the postal code data
        property)
    property :hasRegion, :label => 'has region', :comment =>
      %(Used to support property parameters for the region data
        property)
    property :hasRelated, :label => 'has related', :comment =>
      %(To specify a relationship between another entity and the
        entity represented by this object)
    property :hasRole, :label => 'has role', :comment =>
      %(Used to support property parameters for the role data property)
    property :hasSound, :label => 'has sound', :comment =>
      %(To specify a digital sound content information that annotates
        some aspect of the object)
    property :hasSource, :label => 'has source', :comment =>
      %(To identify the source of directory information of the object)
    property :hasStreetAddress, :label => 'has street address', :comment =>
      %(Used to support property parameters for the street address
        data property)
    property :hasTelephone, :label => 'has telephone', :comment =>
      %(To specify the telephone number for telephony communication
        with the object)
    property :hasTitle, :label => 'has title', :comment =>
      %(Used to support property parameters for the title data
        property)
    property :hasUID, :label => 'has uid', :comment =>
      %(To specify a value that represents a globally unique
        identifier corresponding to the object)
    property :hasURL, :label => 'has url', :comment =>
      %(To specify a uniform resource locator associated with the
        object)
    property :hasValue, :label => 'has value', :comment =>
      %(Used to indicate the resource value of an object property that
        requires property parameters)
    property :key, :label => 'key', :comment =>
      %(This object property has been deprecated)
    property :logo, :label => 'logo', :comment =>
      %(This object property has been deprecated)
    property :n, :label => 'name', :comment =>
      %(This object property has been deprecated)
    property :org, :label => 'organization', :comment =>
      %(This object property has been deprecated. Use the
        organization-name data property.)
    property :photo, :label => 'photo', :comment =>
      %(This object property has been deprecated)
    property :sound, :label => 'sound', :comment =>
      %(This object property has been deprecated)
    property :tel, :label => 'telephone', :comment =>
      %(This object property has been deprecated)
    property :url, :label => 'url', :comment =>
      %(This object property has been deprecated)
  end
end
