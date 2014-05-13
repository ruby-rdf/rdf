# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://www.w3.org/ns/ma-ont.rdf
require 'rdf'
module RDF
  class MA < StrictVocabulary("http://www.w3.org/ns/ma-ont#")

    # Class definitions
    term :Agent,
      comment: %(A person or organisation contributing to the media resource.).freeze,
      "owl:disjointWith" => %(ma:Collection).freeze,
      type: "owl:Class".freeze
    term :AudioTrack,
      comment: %(A specialisation of Track for Audio to provide a link to specific data properties such as sampleRate, etc. Specialisation is defined through object properties.).freeze,
      "owl:disjointWith" => %(ma:DataTrack).freeze,
      subClassOf: "ma:Track".freeze,
      type: "owl:Class".freeze
    term :Collection,
      comment: %(Any group of media resource e.g. a series.).freeze,
      "owl:disjointWith" => %(ma:Location).freeze,
      type: "owl:Class".freeze
    term :DataTrack,
      comment: %(Ancillary data track e.g. captioning  in addition to video and audio tracks. Specialisation is made through the use of appropriate object properties.).freeze,
      "owl:disjointWith" => %(ma:VideoTrack).freeze,
      subClassOf: "ma:Track".freeze,
      type: "owl:Class".freeze
    term :Image,
      comment: %(A still image / thumbnail / key frame related to the media resource or being the media resource itself.).freeze,
      subClassOf: "ma:MediaResource".freeze,
      type: "owl:Class".freeze
    term :Location,
      comment: %(A location related to the media resource, e.g. depicted in the resource (possibly fictional) or where the resource was created (shooting location), etc.).freeze,
      "owl:disjointWith" => %(ma:MediaResource).freeze,
      type: "owl:Class".freeze
    term :MediaFragment,
      comment: %(A media fragment (spatial, temporal, track...) composing a media resource. In other ontologies fragment is sometimes referred to as a 'part' or 'segment'.).freeze,
      subClassOf: "ma:MediaResource".freeze,
      type: "owl:Class".freeze
    term :MediaResource,
      comment: %(An image or an audiovisual media resource, which can be composed of one or more fragment / track.).freeze,
      "owl:disjointWith" => %(ma:Rating).freeze,
      type: "owl:Class".freeze
    term :Organisation,
      comment: %(An organisation or moral agent.).freeze,
      "owl:disjointWith" => %(ma:Person).freeze,
      subClassOf: "ma:Agent".freeze,
      type: "owl:Class".freeze
    term :Person,
      comment: %(A physical person.).freeze,
      subClassOf: "ma:Agent".freeze,
      type: "owl:Class".freeze
    term :Rating,
      comment: %(Information about the rating given to a media resource.).freeze,
      "owl:disjointWith" => %(ma:TargetAudience).freeze,
      type: "owl:Class".freeze
    term :TargetAudience,
      comment: %(Information about The target audience (target region, target audience category but also parental guidance recommendation) for which a media resource is intended.).freeze,
      type: "owl:Class".freeze
    term :Track,
      comment: %(A specialisation of MediaFragment for audiovisual content.).freeze,
      subClassOf: "ma:MediaFragment".freeze,
      type: "owl:Class".freeze
    term :VideoTrack,
      comment: %(A specialisation of Track for Video to provide a link to specific data properties such as frameRate, etc. Signing is another possible example of video track. Specialisation is defined through object properties.).freeze,
      subClassOf: "ma:Track".freeze,
      type: "owl:Class".freeze

    # Property definitions
    property :alternativeTitle,
      comment: %(Corresponds to 'title.title' in the Ontology for Media Resources with a 'title.type' meaning "alternative".).freeze,
      subPropertyOf: "ma:title".freeze,
      type: "owl:DatatypeProperty".freeze
    property :averageBitRate,
      comment: %(Corresponds to 'averageBitRate' in the Ontology for Media Resources, expressed in kilobits/second.).freeze,
      domain: "_:g2180057780".freeze,
      range: "xsd:decimal".freeze,
      type: "owl:DatatypeProperty".freeze
    property :collectionName,
      comment: %(The name by which a collection (e.g. series) is known.).freeze,
      domain: "ma:Collection".freeze,
      type: "owl:DatatypeProperty".freeze
    property :copyright,
      comment: %(Corresponds to 'copyright.copyright' in the Ontology for Media Resources.).freeze,
      domain: "ma:MediaResource".freeze,
      type: "owl:DatatypeProperty".freeze
    property :createdIn,
      comment: %(A subproperty of 'hasRelatedLocation" used to specify where material shooting took place.).freeze,
      "owl:inverseOf" => %(ma:isCreationLocationOf).freeze,
      subPropertyOf: "ma:hasRelatedLocation".freeze,
      type: "owl:ObjectProperty".freeze
    property :creationDate,
      comment: %(Corresponds to 'date.date' in the Ontology for Media Resources with a 'date.type' meaning "creationDate".).freeze,
      subPropertyOf: "ma:date".freeze,
      type: "owl:DatatypeProperty".freeze
    property :date,
      comment: %(Corresponds to date.date in the ontology for Media Resources. Subproperties can be used to distinguish different values of 'date.type'. The recommended range is 'xsd:dateTime' (for compliance with OWL2-QL and OWL2-RL) but other time-related datatypes may be used (e.g. 'xsd:gYear', 'xsd:date'...).).freeze,
      domain: "ma:MediaResource".freeze,
      type: "owl:DatatypeProperty".freeze
    property :depictsFictionalLocation,
      comment: %(A subproperty of 'hasRelatedLocation' used to specify where the action depicted in the media is supposed to take place, as opposed to the location where shooting actually took place (see 'createdIn').).freeze,
      "owl:inverseOf" => %(ma:isFictionalLocationDepictedIn).freeze,
      subPropertyOf: "ma:hasRelatedLocation".freeze,
      type: "owl:ObjectProperty".freeze
    property :description,
      comment: %(Corresponds to 'description' in the Ontology for Media Resources. This can be specialised by using sub-properties e.g. 'summary' or 'script'.).freeze,
      domain: "ma:MediaResource".freeze,
      type: "owl:DatatypeProperty".freeze
    property :duration,
      comment: %(Corresponds to 'duration' in the Ontology for Media Resources.).freeze,
      domain: "_:g2179005900".freeze,
      range: "xsd:decimal".freeze,
      type: "owl:DatatypeProperty".freeze
    property :editDate,
      comment: %(Corresponds to 'date.date' in the Ontology for Media Resources with a 'date.type' meaning "editDate".).freeze,
      subPropertyOf: "ma:date".freeze,
      type: "owl:DatatypeProperty".freeze
    property :features,
      comment: %(Corresponds to 'contributor.contributor' in the Ontology for Media Resources with a 'contributor.role' meaning "actor".).freeze,
      "owl:inverseOf" => %(ma:playsIn).freeze,
      range: "ma:Person".freeze,
      subPropertyOf: "ma:hasContributor".freeze,
      type: "owl:ObjectProperty".freeze
    property :fragmentName,
      comment: %(Corresponds to 'namedFragment.label' in the Ontology for Media Resources.).freeze,
      domain: "ma:MediaFragment".freeze,
      type: "owl:DatatypeProperty".freeze
    property :frameHeight,
      comment: %(Corresponds to 'frameSize.height' in the Ontology for Media Resources, measured in frameSizeUnit.).freeze,
      domain: "ma:MediaResource".freeze,
      range: "xsd:integer".freeze,
      type: "owl:DatatypeProperty".freeze
    property :frameRate,
      comment: %(Corresponds to 'frameRate' in the Ontology for Media Resources, in frame per second.).freeze,
      domain: "ma:MediaResource".freeze,
      range: "xsd:decimal".freeze,
      type: "owl:DatatypeProperty".freeze
    property :frameSizeUnit,
      comment: %(Corresponds to 'frameSize.unit' in the Ontology for Media Resources.).freeze,
      domain: "ma:MediaResource".freeze,
      type: "owl:DatatypeProperty".freeze
    property :frameWidth,
      comment: %(Corresponds to 'frameSize.width' in the Ontology for Media Resources measured in frameSizeUnit.).freeze,
      domain: "ma:MediaResource".freeze,
      range: "xsd:integer".freeze,
      type: "owl:DatatypeProperty".freeze
    property :hasAccessConditions,
      comment: %(Corresponds to 'policy' in the Ontology for Media Resources with a 'policy.type' "access conditions".).freeze,
      subPropertyOf: "ma:hasPolicy".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasAudioDescription,
      comment: %(Corresponds to 'fragment' in the Ontology for Media Resources with a 'fragment.role' meaning "audio-description".).freeze,
      subPropertyOf: "ma:hasCaptioning".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasCaptioning,
      comment: %(Corresponds to 'fragment' in the Ontology for Media Resources with a 'fragment.role' meaning "captioning". This property can for example point to a spatial fragment, a VideoTrack or a DataTrack. The language of the captioning track can be expressed by attaching a 'hasLanguage' property to the specific track.).freeze,
      "owl:inverseOf" => %(ma:isCaptioningOf).freeze,
      subPropertyOf: "ma:hasFragment".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasChapter,
      comment: %(Corresponds to 'fragment' in the Ontology for Media Resources with a 'fragment.role' meaning "chapter".).freeze,
      "owl:inverseOf" => %(ma:isChapterOf).freeze,
      subPropertyOf: "ma:hasFragment".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasClassification,
      comment: %(Corresponds to 'targetAudience.classification' in the Ontology for Media Resources. This property is used to provide a value characterising the target audience.).freeze,
      domain: "ma:TargetAudience".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasClassificationSystem,
      comment: %(Corresponds to 'targetAudience.identifier' in the Ontology for Media Resources. This is used to identify the reference sheme against which the target audience has been characterised.).freeze,
      domain: "ma:TargetAudience".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasCompression,
      comment: %(Corresponds to 'compression' in the Ontology for Media Resources.).freeze,
      domain: "ma:MediaResource".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasContributedTo,
      type: "owl:ObjectProperty".freeze
    property :hasContributor,
      comment: %(Corresponds to 'contributor.contributor' in the Ontology for Media Resources. Subproperties can be used to distinguish different values of 'contributor.role'.).freeze,
      domain: "ma:MediaResource".freeze,
      "owl:inverseOf" => %(ma:hasContributedTo).freeze,
      range: "ma:Agent".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasCopyrightOver,
      type: "owl:ObjectProperty".freeze
    property :hasCreated,
      type: "owl:ObjectProperty".freeze
    property :hasCreator,
      comment: %(Corresponds to 'creator.creator' in the Ontology for Media Resources. Subproperties can be used to distinguish different values of 'creator.role'. Note that this property is semantically a subproperty of 'hasContributor'.).freeze,
      "owl:inverseOf" => %(ma:hasCreated).freeze,
      subPropertyOf: "ma:hasContributor".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasFormat,
      comment: %(Corresponds to 'format' in the Ontology for Media Resources.).freeze,
      domain: "ma:MediaResource".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasFragment,
      comment: %(Corresponds to 'fragment' in the Ontology for Media Resources. Subproperties can be used to distinguish different values of 'fragment.role'.).freeze,
      domain: "ma:MediaResource".freeze,
      "owl:inverseOf" => %(ma:isFragmentOf).freeze,
      range: "ma:MediaFragment".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasGenre,
      comment: %(Corresponds to 'genre' in the Ontology for Media Resources.).freeze,
      domain: "ma:MediaResource".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasKeyword,
      comment: %(Corresponds to 'keyword' in the Ontology for Media Resources.).freeze,
      domain: "ma:MediaResource".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasLanguage,
      comment: %(Corresponds to 'language' in the Ontology for Media Resources. The language used in the resource. A controlled vocabulary such as defined in BCP 47 SHOULD be used. This property can also be used to identify the presence of sign language (RFC 5646). By inheritance, the hasLanguage property applies indifferently at the media resource / fragment / track levels.  Best practice recommends to use to best possible level of granularity fo describe the usage of language within a media resource including at fragment and track levels.).freeze,
      domain: "ma:MediaResource".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasLocationCoordinateSystem,
      comment: %(Corresponds to 'location.coordinateSystem' in the Ontology for Media Resources.).freeze,
      domain: "ma:Location".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasMember,
      type: "owl:ObjectProperty".freeze
    property :hasNamedFragment,
      comment: %(Corresponds to 'namedFragment' in the Ontology for Media Resources.).freeze,
      "owl:inverseOf" => %(ma:isNamedFragmentOf).freeze,
      subPropertyOf: "ma:hasFragment".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasPermissions,
      comment: %(Corresponds to 'policy' in the Ontology for Media Resources with a  'policy.type' meaning "permissions".).freeze,
      subPropertyOf: "ma:hasPolicy".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasPolicy,
      comment: %(Corresponds to 'policy' in the Ontology for Media Resources. Subproperties can be used to distinguish different values of 'policy.type'.).freeze,
      domain: "ma:MediaResource".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasPublished,
      type: "owl:ObjectProperty".freeze
    property :hasPublisher,
      comment: %(Corresponds to 'publisher' in the Ontology for Media Resources.).freeze,
      "owl:inverseOf" => %(ma:hasPublished).freeze,
      subPropertyOf: "ma:hasContributor".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasRating,
      comment: %(Corresponds to 'rating' in the Ontology for Media Resources.).freeze,
      domain: "ma:MediaResource".freeze,
      "owl:inverseOf" => %(ma:isRatingOf).freeze,
      range: "ma:Rating".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasRatingSystem,
      comment: %(Corresponds to 'rating.type' in the Ontology for Media Resources.).freeze,
      domain: "ma:Rating".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasRelatedImage,
      comment: %(Corresponds to 'relation' and in the Ontology for Media Resources with a 'relation.type' meaning "related image".).freeze,
      "owl:inverseOf" => %(ma:isImageRelatedTo).freeze,
      range: "ma:Image".freeze,
      subPropertyOf: "ma:hasRelatedResource".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasRelatedLocation,
      comment: %(Corresponds to 'location' in the Ontology for Media Resources. Subproperties are provided to specify, when possible, the relation between the media resource and the location.).freeze,
      domain: "ma:MediaResource".freeze,
      "owl:inverseOf" => %(ma:isLocationRelatedTo).freeze,
      range: "ma:Location".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasRelatedResource,
      comment: %(Corresponds to 'relation' and in the Ontology for Media Resources. Subproperties can be used to distinguish different values of 'relation.type'.).freeze,
      domain: "ma:MediaResource".freeze,
      "owl:inverseOf" => %(ma:isRelatedTo).freeze,
      type: "owl:ObjectProperty".freeze
    property :hasSigning,
      comment: %(Corresponds to 'fragment' in the Ontology for Media Resources with a 'fragment.role' meaning "signing". This property can for example point to a spatial fragment or a VideoTrack. The sign language of the captioning track can be expressed by attaching a 'hasLanguage' property to the specific track.).freeze,
      "owl:inverseOf" => %(ma:isSigningOf).freeze,
      subPropertyOf: "ma:hasFragment".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasSource,
      comment: %(Corresponds to 'relation' and in the Ontology for Media Resources with a 'relation.type' meaning "source".).freeze,
      "owl:inverseOf" => %(ma:isSourceOf).freeze,
      subPropertyOf: "ma:hasRelatedResource".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasSubtitling,
      comment: %(Corresponds to 'fragment' in the Ontology for Media Resources with a 'fragment.role' meaning "subtitling".).freeze,
      subPropertyOf: "ma:hasCaptioning".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasTargetAudience,
      comment: %(Corresponds to 'targetAudience' in the Ontology for Media Resources.).freeze,
      domain: "ma:MediaResource".freeze,
      "owl:inverseOf" => %(ma:isTargetAudienceOf).freeze,
      range: "ma:TargetAudience".freeze,
      type: "owl:ObjectProperty".freeze
    property :hasTrack,
      comment: %(Corresponds to 'fragment' in the Ontology for Media Resources with a 'fragment.role' meaning "track".).freeze,
      "owl:inverseOf" => %(ma:isTrackOf).freeze,
      range: "ma:Track".freeze,
      subPropertyOf: "ma:hasFragment".freeze,
      type: "owl:ObjectProperty".freeze
    property :isCaptioningOf,
      type: "owl:ObjectProperty".freeze
    property :isChapterOf,
      type: "owl:ObjectProperty".freeze
    property :isCopyrightedBy,
      comment: %(Corresponds to 'copyright.identifier' in the Ontology for Media Resources.).freeze,
      domain: "ma:MediaResource".freeze,
      "owl:inverseOf" => %(ma:hasCopyrightOver).freeze,
      range: "ma:Agent".freeze,
      type: "owl:ObjectProperty".freeze
    property :isCreationLocationOf,
      type: "owl:ObjectProperty".freeze
    property :isFictionalLocationDepictedIn,
      type: "owl:ObjectProperty".freeze
    property :isFragmentOf,
      type: "owl:ObjectProperty".freeze
    property :isImageRelatedTo,
      subPropertyOf: "ma:isRelatedTo".freeze,
      type: "owl:ObjectProperty".freeze
    property :isLocationRelatedTo,
      type: "owl:ObjectProperty".freeze
    property :isMemberOf,
      comment: %(Corresponds to 'collection' in the Ontology for Media Resources.).freeze,
      domain: "ma:MediaResource".freeze,
      "owl:inverseOf" => %(ma:hasMember).freeze,
      range: "ma:Collection".freeze,
      type: "owl:ObjectProperty".freeze
    property :isNamedFragmentOf,
      type: "owl:ObjectProperty".freeze
    property :isProvidedBy,
      comment: %(Corresponds to 'rating.identifier' in the Ontology for Media Resources.).freeze,
      domain: "ma:Rating".freeze,
      "owl:inverseOf" => %(ma:provides).freeze,
      range: "ma:Agent".freeze,
      type: "owl:ObjectProperty".freeze
    property :isRatingOf,
      type: "owl:ObjectProperty".freeze
    property :isRelatedTo,
      type: "owl:ObjectProperty".freeze
    property :isSigningOf,
      type: "owl:ObjectProperty".freeze
    property :isSourceOf,
      type: "owl:ObjectProperty".freeze
    property :isTargetAudienceOf,
      type: "owl:ObjectProperty".freeze
    property :isTrackOf,
      type: "owl:ObjectProperty".freeze
    property :locationAltitude,
      comment: %(Corresponds to 'location.altitude' in the Ontology for Media Resources.).freeze,
      domain: "ma:Location".freeze,
      range: "xsd:decimal".freeze,
      type: "owl:DatatypeProperty".freeze
    property :locationLatitude,
      comment: %(Corresponds to 'location.latitude' in the Ontology for Media Resources.).freeze,
      domain: "ma:Location".freeze,
      range: "xsd:decimal".freeze,
      type: "owl:DatatypeProperty".freeze
    property :locationLongitude,
      comment: %(Corresponds to 'location.longitude' in the Ontology for Media Resources.).freeze,
      domain: "ma:Location".freeze,
      range: "xsd:decimal".freeze,
      type: "owl:DatatypeProperty".freeze
    property :locationName,
      comment: %(Corresponds to 'location.name' in the Ontology for Media Resources.).freeze,
      domain: "ma:Location".freeze,
      type: "owl:DatatypeProperty".freeze
    property :locator,
      comment: %(Corresponds to 'locator' in the Ontology for Media Resources.).freeze,
      domain: "ma:MediaResource".freeze,
      range: "xsd:anyURI".freeze,
      type: "owl:DatatypeProperty".freeze
    property :mainOriginalTitle,
      comment: %(Corresponds to 'title.title' in the Ontology for Media Resources with a 'title.type' meaning "original".).freeze,
      subPropertyOf: "ma:title".freeze,
      type: "owl:DatatypeProperty".freeze
    property :numberOfTracks,
      comment: %(Corresponds to 'numTracks.number' in the Ontology for Media Resources. Subproperties can be used to distinguish different values of 'numTracks.type'.).freeze,
      domain: "ma:MediaResource".freeze,
      range: "xsd:integer".freeze,
      type: "owl:DatatypeProperty".freeze
    property :playsIn,
      type: "owl:ObjectProperty".freeze
    property :provides,
      type: "owl:ObjectProperty".freeze
    property :ratingScaleMax,
      comment: %(Corresponds to 'rating.max' in the Ontology for Media Resources.).freeze,
      domain: "ma:Rating".freeze,
      range: "xsd:decimal".freeze,
      type: "owl:DatatypeProperty".freeze
    property :ratingScaleMin,
      comment: %(Corresponds to 'rating.min' in the Ontology for Media Resources.).freeze,
      domain: "ma:Rating".freeze,
      range: "xsd:decimal".freeze,
      type: "owl:DatatypeProperty".freeze
    property :ratingValue,
      comment: %(Corresponds to 'rating.value' in the Ontology for Media Resources.).freeze,
      domain: "ma:Rating".freeze,
      range: "xsd:decimal".freeze,
      type: "owl:DatatypeProperty".freeze
    property :recordDate,
      comment: %(Corresponds to 'date.date' in the Ontology for Media Resources with a 'date.type' meaning "recordDate".).freeze,
      subPropertyOf: "ma:date".freeze,
      type: "owl:DatatypeProperty".freeze
    property :releaseDate,
      comment: %(Corresponds to 'date.date' in the Ontology for Media Resources with a 'date.type' meaning "releaseDate".).freeze,
      subPropertyOf: "ma:date".freeze,
      type: "owl:DatatypeProperty".freeze
    property :samplingRate,
      comment: %(Corresponds to 'samplingRate' in the Ontology for Media Resources, in samples per second.).freeze,
      domain: "ma:MediaResource".freeze,
      range: "xsd:decimal".freeze,
      type: "owl:DatatypeProperty".freeze
    property :title,
      comment: %(Corresponds to 'title.title' in the Ontology for Media Resources. Subproperties can be used to distinguish different values of 'title.type'.).freeze,
      domain: "ma:MediaResource".freeze,
      type: "owl:DatatypeProperty".freeze
    property :trackName,
      comment: %(Corresponds to 'fragment.name' in the Ontology for Media Resources, for Track fragments.).freeze,
      domain: "ma:Track".freeze,
      subPropertyOf: "ma:fragmentName".freeze,
      type: "owl:DatatypeProperty".freeze
  end
end
