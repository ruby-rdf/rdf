# This file generated automatically using vocab-fetch from http://www.w3.org/ns/ma-ont.rdf
require 'rdf'
module RDF
  class MA < StrictVocabulary("http://www.w3.org/ns/ma-ont#")

    # Class definitions
    property :Agent, :comment =>
      %(A person or organisation contributing to the media resource.)
    property :AudioTrack, :comment =>
      %(A specialisation of Track for Audio to provide a link to
        specific data properties such as sampleRate, etc.
        Specialisation is defined through object properties.)
    property :Collection, :comment =>
      %(Any group of media resource e.g. a series.)
    property :DataTrack, :comment =>
      %(Ancillary data track e.g. captioning in addition to video and
        audio tracks. Specialisation is made through the use of
        appropriate object properties.)
    property :Image, :comment =>
      %(A still image / thumbnail / key frame related to the media
        resource or being the media resource itself.)
    property :Location, :comment =>
      %(A location related to the media resource, e.g. depicted in the
        resource \(possibly fictional\) or where the resource was
        created \(shooting location\), etc.)
    property :MediaFragment, :comment =>
      %(A media fragment \(spatial, temporal, track...\) composing a
        media resource. In other ontologies fragment is sometimes
        referred to as a 'part' or 'segment'.)
    property :MediaResource, :comment =>
      %(An image or an audiovisual media resource, which can be
        composed of one or more fragment / track.)
    property :Organisation, :comment =>
      %(An organisation or moral agent.)
    property :Person, :comment =>
      %(A physical person.)
    property :Rating, :comment =>
      %(Information about the rating given to a media resource.)
    property :TargetAudience, :comment =>
      %(Information about The target audience \(target region, target
        audience category but also parental guidance recommendation\)
        for which a media resource is intended.)
    property :Track, :comment =>
      %(A specialisation of MediaFragment for audiovisual content.)
    property :VideoTrack, :comment =>
      %(A specialisation of Track for Video to provide a link to
        specific data properties such as frameRate, etc. Signing is
        another possible example of video track. Specialisation is
        defined through object properties.)

    # Property definitions
    property :alternativeTitle, :comment =>
      %(Corresponds to 'title.title' in the Ontology for Media
        Resources with a 'title.type' meaning "alternative".)
    property :averageBitRate, :comment =>
      %(Corresponds to 'averageBitRate' in the Ontology for Media
        Resources, expressed in kilobits/second.)
    property :collectionName, :comment =>
      %(The name by which a collection \(e.g. series\) is known.)
    property :copyright, :comment =>
      %(Corresponds to 'copyright.copyright' in the Ontology for Media
        Resources.)
    property :creationDate, :comment =>
      %(Corresponds to 'date.date' in the Ontology for Media Resources
        with a 'date.type' meaning "creationDate".)
    property :date, :comment =>
      %(Corresponds to date.date in the ontology for Media Resources.
        Subproperties can be used to distinguish different values of
        'date.type'. The recommended range is 'xsd:dateTime' \(for
        compliance with OWL2-QL and OWL2-RL\) but other time-related
        datatypes may be used \(e.g. 'xsd:gYear', 'xsd:date'...\).)
    property :description, :comment =>
      %(Corresponds to 'description' in the Ontology for Media
        Resources. This can be specialised by using sub-properties
        e.g. 'summary' or 'script'.)
    property :duration, :comment =>
      %(Corresponds to 'duration' in the Ontology for Media Resources.)
    property :editDate, :comment =>
      %(Corresponds to 'date.date' in the Ontology for Media Resources
        with a 'date.type' meaning "editDate".)
    property :fragmentName, :comment =>
      %(Corresponds to 'namedFragment.label' in the Ontology for Media
        Resources.)
    property :frameHeight, :comment =>
      %(Corresponds to 'frameSize.height' in the Ontology for Media
        Resources, measured in frameSizeUnit.)
    property :frameRate, :comment =>
      %(Corresponds to 'frameRate' in the Ontology for Media
        Resources, in frame per second.)
    property :frameSizeUnit, :comment =>
      %(Corresponds to 'frameSize.unit' in the Ontology for Media
        Resources.)
    property :frameWidth, :comment =>
      %(Corresponds to 'frameSize.width' in the Ontology for Media
        Resources measured in frameSizeUnit.)
    property :locationAltitude, :comment =>
      %(Corresponds to 'location.altitude' in the Ontology for Media
        Resources.)
    property :locationLatitude, :comment =>
      %(Corresponds to 'location.latitude' in the Ontology for Media
        Resources.)
    property :locationLongitude, :comment =>
      %(Corresponds to 'location.longitude' in the Ontology for Media
        Resources.)
    property :locationName, :comment =>
      %(Corresponds to 'location.name' in the Ontology for Media
        Resources.)
    property :locator, :comment =>
      %(Corresponds to 'locator' in the Ontology for Media Resources.)
    property :mainOriginalTitle, :comment =>
      %(Corresponds to 'title.title' in the Ontology for Media
        Resources with a 'title.type' meaning "original".)
    property :numberOfTracks, :comment =>
      %(Corresponds to 'numTracks.number' in the Ontology for Media
        Resources. Subproperties can be used to distinguish different
        values of 'numTracks.type'.)
    property :ratingScaleMax, :comment =>
      %(Corresponds to 'rating.max' in the Ontology for Media
        Resources.)
    property :ratingScaleMin, :comment =>
      %(Corresponds to 'rating.min' in the Ontology for Media
        Resources.)
    property :ratingValue, :comment =>
      %(Corresponds to 'rating.value' in the Ontology for Media
        Resources.)
    property :recordDate, :comment =>
      %(Corresponds to 'date.date' in the Ontology for Media Resources
        with a 'date.type' meaning "recordDate".)
    property :releaseDate, :comment =>
      %(Corresponds to 'date.date' in the Ontology for Media Resources
        with a 'date.type' meaning "releaseDate".)
    property :samplingRate, :comment =>
      %(Corresponds to 'samplingRate' in the Ontology for Media
        Resources, in samples per second.)
    property :title, :comment =>
      %(Corresponds to 'title.title' in the Ontology for Media
        Resources. Subproperties can be used to distinguish different
        values of 'title.type'.)
    property :trackName, :comment =>
      %(Corresponds to 'fragment.name' in the Ontology for Media
        Resources, for Track fragments.)
    property :createdIn, :comment =>
      %(A subproperty of 'hasRelatedLocation" used to specify where
        material shooting took place.)
    property :depictsFictionalLocation, :comment =>
      %(A subproperty of 'hasRelatedLocation' used to specify where
        the action depicted in the media is supposed to take place, as
        opposed to the location where shooting actually took place
        \(see 'createdIn'\).)
    property :features, :comment =>
      %(Corresponds to 'contributor.contributor' in the Ontology for
        Media Resources with a 'contributor.role' meaning "actor".)
    property :hasAccessConditions, :comment =>
      %(Corresponds to 'policy' in the Ontology for Media Resources
        with a 'policy.type' "access conditions".)
    property :hasAudioDescription, :comment =>
      %(Corresponds to 'fragment' in the Ontology for Media Resources
        with a 'fragment.role' meaning "audio-description".)
    property :hasCaptioning, :comment =>
      %(Corresponds to 'fragment' in the Ontology for Media Resources
        with a 'fragment.role' meaning "captioning". This property can
        for example point to a spatial fragment, a VideoTrack or a
        DataTrack. The language of the captioning track can be
        expressed by attaching a 'hasLanguage' property to the
        specific track.)
    property :hasChapter, :comment =>
      %(Corresponds to 'fragment' in the Ontology for Media Resources
        with a 'fragment.role' meaning "chapter".)
    property :hasClassification, :comment =>
      %(Corresponds to 'targetAudience.classification' in the Ontology
        for Media Resources. This property is used to provide a value
        characterising the target audience.)
    property :hasClassificationSystem, :comment =>
      %(Corresponds to 'targetAudience.identifier' in the Ontology for
        Media Resources. This is used to identify the reference sheme
        against which the target audience has been characterised.)
    property :hasCompression, :comment =>
      %(Corresponds to 'compression' in the Ontology for Media
        Resources.)
    property :hasContributedTo
    property :hasContributor, :comment =>
      %(Corresponds to 'contributor.contributor' in the Ontology for
        Media Resources. Subproperties can be used to distinguish
        different values of 'contributor.role'.)
    property :hasCopyrightOver
    property :hasCreated
    property :hasCreator, :comment =>
      %(Corresponds to 'creator.creator' in the Ontology for Media
        Resources. Subproperties can be used to distinguish different
        values of 'creator.role'. Note that this property is
        semantically a subproperty of 'hasContributor'.)
    property :hasFormat, :comment =>
      %(Corresponds to 'format' in the Ontology for Media Resources.)
    property :hasFragment, :comment =>
      %(Corresponds to 'fragment' in the Ontology for Media Resources.
        Subproperties can be used to distinguish different values of
        'fragment.role'.)
    property :hasGenre, :comment =>
      %(Corresponds to 'genre' in the Ontology for Media Resources.)
    property :hasKeyword, :comment =>
      %(Corresponds to 'keyword' in the Ontology for Media Resources.)
    property :hasLanguage, :comment =>
      %(Corresponds to 'language' in the Ontology for Media Resources.
        The language used in the resource. A controlled vocabulary
        such as defined in BCP 47 SHOULD be used. This property can
        also be used to identify the presence of sign language \(RFC
        5646\). By inheritance, the hasLanguage property applies
        indifferently at the media resource / fragment / track levels.
        Best practice recommends to use to best possible level of
        granularity fo describe the usage of language within a media
        resource including at fragment and track levels.)
    property :hasLocationCoordinateSystem, :comment =>
      %(Corresponds to 'location.coordinateSystem' in the Ontology for
        Media Resources.)
    property :hasMember
    property :hasNamedFragment, :comment =>
      %(Corresponds to 'namedFragment' in the Ontology for Media
        Resources.)
    property :hasPermissions, :comment =>
      %(Corresponds to 'policy' in the Ontology for Media Resources
        with a 'policy.type' meaning "permissions".)
    property :hasPolicy, :comment =>
      %(Corresponds to 'policy' in the Ontology for Media Resources.
        Subproperties can be used to distinguish different values of
        'policy.type'.)
    property :hasPublished
    property :hasPublisher, :comment =>
      %(Corresponds to 'publisher' in the Ontology for Media
        Resources.)
    property :hasRating, :comment =>
      %(Corresponds to 'rating' in the Ontology for Media Resources.)
    property :hasRatingSystem, :comment =>
      %(Corresponds to 'rating.type' in the Ontology for Media
        Resources.)
    property :hasRelatedImage, :comment =>
      %(Corresponds to 'relation' and in the Ontology for Media
        Resources with a 'relation.type' meaning "related image".)
    property :hasRelatedLocation, :comment =>
      %(Corresponds to 'location' in the Ontology for Media Resources.
        Subproperties are provided to specify, when possible, the
        relation between the media resource and the location.)
    property :hasRelatedResource, :comment =>
      %(Corresponds to 'relation' and in the Ontology for Media
        Resources. Subproperties can be used to distinguish different
        values of 'relation.type'.)
    property :hasSigning, :comment =>
      %(Corresponds to 'fragment' in the Ontology for Media Resources
        with a 'fragment.role' meaning "signing". This property can
        for example point to a spatial fragment or a VideoTrack. The
        sign language of the captioning track can be expressed by
        attaching a 'hasLanguage' property to the specific track.)
    property :hasSource, :comment =>
      %(Corresponds to 'relation' and in the Ontology for Media
        Resources with a 'relation.type' meaning "source".)
    property :hasSubtitling, :comment =>
      %(Corresponds to 'fragment' in the Ontology for Media Resources
        with a 'fragment.role' meaning "subtitling".)
    property :hasTargetAudience, :comment =>
      %(Corresponds to 'targetAudience' in the Ontology for Media
        Resources.)
    property :hasTrack, :comment =>
      %(Corresponds to 'fragment' in the Ontology for Media Resources
        with a 'fragment.role' meaning "track".)
    property :isCaptioningOf
    property :isChapterOf
    property :isCopyrightedBy, :comment =>
      %(Corresponds to 'copyright.identifier' in the Ontology for
        Media Resources.)
    property :isCreationLocationOf
    property :isFictionalLocationDepictedIn
    property :isFragmentOf
    property :isImageRelatedTo
    property :isLocationRelatedTo
    property :isMemberOf, :comment =>
      %(Corresponds to 'collection' in the Ontology for Media
        Resources.)
    property :isNamedFragmentOf
    property :isProvidedBy, :comment =>
      %(Corresponds to 'rating.identifier' in the Ontology for Media
        Resources.)
    property :isRatingOf
    property :isRelatedTo
    property :isSigningOf
    property :isSourceOf
    property :isTargetAudienceOf
    property :isTrackOf
    property :playsIn
    property :provides
  end
end
