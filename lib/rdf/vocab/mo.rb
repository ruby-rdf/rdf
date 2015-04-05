# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://purl.org/ontology/mo/
require 'rdf'
module RDF
  # @deprecated Please use `RDF::Vocab::MO` from the rdf-vocab gem instead
  class MO < RDF::StrictVocabulary("http://purl.org/ontology/mo/")

    # Class definitions
    term :Activity,
      comment: %(
        An activity period, defining when an artist was musically active.
    ).freeze,
      label: "activity".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "http://purl.org/NET/c4dm/event.owl#Event".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(testing).freeze
    term :AnalogSignal,
      comment: %(
        An analog signal.
    ).freeze,
      label: "analogue signal".freeze,
      "mo:level" => %(2).freeze,
      "owl:disjointWith" => %(mo:DigitalSignal).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:Signal".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Arrangement,
      comment: %(
        An arrangement event.
        Takes as agent the arranger, and produces a score \(informational object, not the actually published score\).
    ).freeze,
      label: "arrangement".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "http://purl.org/NET/c4dm/event.owl#Event".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Arranger,
      label: "arranger".freeze,
      "mo:level" => %(2).freeze,
      subClassOf: "foaf:Agent".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :AudioFile,
      comment: %(An audio file, which may be available on a local file system or through http, ftp, etc.).freeze,
      label: "audio file".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: ["mo:Medium".freeze, "foaf:Document".freeze],
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :CD,
      comment: %(Compact Disc used as medium to record a musical manifestation.).freeze,
      label: "CD".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:Medium".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :Composer,
      label: "composer".freeze,
      "mo:level" => %(2).freeze,
      subClassOf: "foaf:Agent".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :Composition,
      comment: %(
        A composition event.
        Takes as agent the composer himself.
        It produces a MusicalWork, or a MusicalExpression \(when the initial "product" is a score, for example\), or both...
    ).freeze,
      label: "composition".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "http://purl.org/NET/c4dm/event.owl#Event".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Conductor,
      label: "conductor".freeze,
      "mo:level" => %(2).freeze,
      subClassOf: "foaf:Agent".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :CorporateBody,
      comment: %(Organization or group of individuals and/or other organizations involved in the music market.).freeze,
      label: "corporate body".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "foaf:Organization".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :DAT,
      comment: %(Digital Audio Tape used as medium to record a musical manifestation.).freeze,
      label: "DAT".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:Medium".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :DCC,
      comment: %(Digital Compact Cassette used as medium to record a musical manifestation.).freeze,
      label: "DCC".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:Medium".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :DVDA,
      comment: %(DVD-Audio used as medium to record a musical manifestation.).freeze,
      label: "DVDA".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:Medium".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :DigitalSignal,
      comment: %(
        A digital signal
    ).freeze,
      label: "digital signal".freeze,
      "mo:level" => %(2).freeze,
      "owl:disjointWith" => %(mo:AnalogSignal).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:Signal".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :ED2K,
      comment: %(Something available on the E-Donkey peer-2-peer filesharing network).freeze,
      label: "ED2K".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:Medium".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :Festival,
      comment: %(
        A festival - musical/artistic event lasting several days, like Glastonbury, Rock Am Ring...
        We migth decompose this event \(which is in fact just a classification of the space/time region related to 
        a particular festival\) using hasSubEvent in several performances at different space/time.
    ).freeze,
      label: "Festival".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "http://purl.org/NET/c4dm/event.owl#Event".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Genre,
      comment: %(
        An expressive style of music.
        
        Any taxonomy can be plug-in here. You can either define a genre by yourself, like this:

        :mygenre a mo:Genre; dc:title "electro rock".

        Or you can refer to a DBPedia genre \(such as http://dbpedia.org/resource/Baroque_music\), allowing semantic web
        clients to access easily really detailed structured information about the genre you are refering to.
    ).freeze,
      label: "Genre".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Instrument,
      comment: %(
        Any of various devices or contrivances that can be used to produce musical tones or sound.
        
        Any taxonomy can be used to subsume this concept. The default one is one extracted by Ivan Herman
        from the Musicbrainz instrument taxonomy, conforming to SKOS. This concept holds a seeAlso link 
        towards this taxonomy.
    ).freeze,
      label: "Instrument".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      "rdfs:seeAlso" => %(http://purl.org/ontology/mo/mit#).freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Instrumentation,
      comment: %(
        Instrumentation deals with the techniques of writing music for a specific instrument, 
        including the limitations of the instrument, playing techniques and idiomatic handling of the instrument.
    ).freeze,
      label: "instrumentation".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:Arrangement".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Label,
      comment: %(Trade name of a company that produces musical works or expression of musical works.).freeze,
      label: "label".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:CorporateBody".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Libretto,
      comment: %(
                Libretto
        ).freeze,
      label: "libretto".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:MusicalExpression".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Listener,
      label: "listened".freeze,
      "mo:level" => %(2).freeze,
      subClassOf: "foaf:Agent".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :Lyrics,
      comment: %(
        Lyrics
    ).freeze,
      label: "lyrics".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:MusicalExpression".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :MD,
      comment: %(Mini Disc used as medium to record a musical manifestation.).freeze,
      label: "MD".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:Medium".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :MagneticTape,
      comment: %(Magnetic analogue tape used as medium to record a musical manifestation.).freeze,
      label: "MagneticTape".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:Medium".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :Medium,
      comment: %(A means or instrumentality for storing or communicating musical manifestation.).freeze,
      label: "Medium".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:MusicalItem".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :Membership,
      comment: %(A membership event, where one or several people belongs to a group during a particular time period.).freeze,
      label: "membership".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "http://purl.org/NET/c4dm/event.owl#Event".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(testing).freeze
    term :Movement,
      comment: %(A movement is a self-contained part of a musical work. While individual or selected movements from a composition are sometimes performed separately, a performance of the complete work requires all the movements to be performed in succession.

Often a composer attempts to interrelate the movements thematically, or sometimes in more subtle ways, in order that the individual
movements exert a cumulative effect. In some forms, composers sometimes link the movements, or ask for them to be played without a
pause between them.
    ).freeze,
      label: "movement".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:MusicalWork".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :MusicArtist,
      comment: %(
        A person or a group of people \(or a computer :-\) \), whose musical 
        creative work shows sensitivity and imagination 
    ).freeze,
      label: "music artist".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "foaf:Agent".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :MusicGroup,
      comment: %(Group of musicians, or musical ensemble, usually popular or folk, playing parts of or improvising off of a musical arrangement. ).freeze,
      label: "music group".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: ["foaf:Group".freeze, "mo:MusicArtist".freeze],
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :MusicalExpression,
      comment: %(
The intellectual or artistic realization of a work in the form of alpha-numeric, musical, or choreographic notation, sound, etc., or any combination of such forms.    


For example:

Work #1 Franz Schubert's Trout quintet

    * Expression #1 the composer's score
    * Expression #2 sound issued from the performance by the Amadeus Quartet and Hephzibah Menuhin on piano
    * Expression #3 sound issued from the performance by the Cleveland Quartet and Yo-Yo Ma on the cello
    * . . . . 

The Music Ontology defines the following sub-concepts of a MusicalExpression, which should be used instead of MusicalExpression itself: Score \(the
result of an arrangement\), Sound \(produced during a performance\), Signal. However, it is possible to stick to FRBR and bypass the worflow
mechanism this ontology defines by using the core FRBR properties on such objects. But it is often better to use events to interconnect such 
expressions \(allowing to go deeply into the production process - `this performer was playing this particular instrument at that
particular time'\).
    
    ).freeze,
      label: "musical expression".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "http://purl.org/vocab/frbr/core#Expression".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :MusicalItem,
      comment: %(A single exemplar of a musical expression.
    
For example, it could be a single exemplar of a CD. This is normally an single object \(a CD\) possessed by somebody.

From the FRBR final report: The entity defined as item is a concrete entity. It is in many instances a single physical object \(e.g., a copy of a one-volume monograph, a single audio cassette, etc.\). There are instances, however, where the entity defined as item comprises more than one physical object \(e.g., a monograph issued as two separately bound volumes, a recording issued on three separate compact discs, etc.\).

In terms of intellectual content and physical form, an item exemplifying a manifestation is normally the same as the manifestation itself. However, variations may occur from one item to another, even when the items exemplify the same manifestation, where those variations are the result of actions external to the intent of the producer of the manifestation \(e.g., damage occurring after the item was produced, binding performed by a library, etc.\). 
    ).freeze,
      label: "MusicalItem".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :MusicalManifestation,
      comment: %(

This entity is related to the edition/production/publication of a musical expression \(musical manifestation are closely related with the music industry \(their terms, concepts, definitions, methods \(production, publication, etc.\), etc.\)
    
From the FRBR final report: The entity defined as manifestation encompasses a wide range of materials, including manuscripts, books, periodicals, maps, posters, sound recordings, films, video recordings, CD-ROMs, multimedia kits, etc. As an entity, manifestation represents all the physical objects that bear the same characteristics, in respect to both intellectual content and physical form.


Work #1 J. S. Bach's Six suites for unaccompanied cello

    * Expression #1 sound issued during the performance by Janos Starker recorded in 1963 and 1965
          o Manifestation #1 recordings released on 33 1/3 rpm sound discs in 1965 by Mercury
          o Manifestation #2 recordings re-released on compact disc in 1991 by Mercury 
    * Expression #2 sound issued during the performances by Yo-Yo Ma recorded in 1983
          o Manifestation #1 recordings released on 33 1/3 rpm sound discs in 1983 by CBS Records
          o Manifestation #2 recordings re-released on compact disc in 1992 by CBS Records 

          
Changes that occur deliberately or even inadvertently in the production process that affect the copies result, strictly speaking, in a new manifestation. A manifestation resulting from such a change may be identified as a particular "state" or "issue" of the publication.

Changes that occur to an individual copy after the production process is complete \(e.g., the loss of a page, rebinding, etc.\) are not considered to result in a new manifestation. That copy is simply considered to be an exemplar \(or item\) of the manifestation that deviates from the copy as produced.

With the entity defined as manifestation we can describe the physical characteristics of a set of items and the characteristics associated with the production and distribution of that set of items that may be important factors in enabling users to choose a manifestation appropriate to their physical needs and constraints, and to identify and acquire a copy of that manifestation.

Defining manifestation as an entity also enables us to draw relationships between specific manifestations of a work. We can use the relationships between manifestations to identify, for example, the specific publication that was used to create a microreproduction.          

).freeze,
      label: "musical manifestation".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "http://purl.org/vocab/frbr/core#Manifestation".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :MusicalWork,
      comment: %(
    Distinct intellectual or artistic musical creation.
    
From the FRBR final report: A work is an abstract entity; there is no single material object one can point to as the work. We recognize the work through individual realizations or expressions of the work, but the work itself exists only in the commonality of
content between and among the various expressions of the work. When we speak of Homer's Iliad as a work, our point of reference is not a particular recitation or text of the work, but the intellectual creation that lies behind all the various expressions of the work.     

For example:

work #1 J. S. Bach's The art of the fugue

    
    ).freeze,
      label: "musical work".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "http://purl.org/vocab/frbr/core#Work".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Orchestration,
      comment: %(
            Orchestration includes, in addition to instrumentation, the handling of groups of instruments and their balance and interaction.
    ).freeze,
      label: "orchestration".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:Arrangement".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Performance,
      comment: %(
        A performance event. 
        It might include as agents performers, engineers, conductors, or even listeners.
        It might include as factors a score, a MusicalWork, musical instruments. 
        It might produce a sound:-\)
    ).freeze,
      label: "performance".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "http://purl.org/NET/c4dm/event.owl#Event".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Performer,
      label: "performer".freeze,
      "mo:level" => %(2).freeze,
      subClassOf: "foaf:Agent".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :PublishedLibretto,
      comment: %(A published libretto).freeze,
      label: "published libretto".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:MusicalManifestation".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :PublishedLyrics,
      comment: %(Published lyrics, as a book or as a text file, for example).freeze,
      label: "published lyrics".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:MusicalManifestation".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :PublishedScore,
      comment: %(A published score \(subclass of MusicalManifestation\)).freeze,
      label: "published score".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:MusicalManifestation".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Record,
      comment: %(A published record \(manifestation which first aim is to render the product of a recording\)).freeze,
      label: "record".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:MusicalManifestation".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Recording,
      comment: %(
        A recording event.
        Takes a sound as a factor to produce a signal \(analog or digital\).
        The location of such events \(if any\) is the actual location of the corresponding
        microphone or the "recording device".
    ).freeze,
      label: "recording".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "http://purl.org/NET/c4dm/event.owl#Event".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :RecordingSession,
      comment: %(A set of performances/recordings/mastering events. This event can be decomposed in its constituent events using event:sub_event).freeze,
      label: "recording session".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "http://purl.org/NET/c4dm/event.owl#Event".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(testing).freeze
    term :Release,
      comment: %(A specific release, with barcode, box, liner notes, cover art, and a number of records).freeze,
      label: "release".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:MusicalManifestation".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(testing).freeze
    term :ReleaseEvent,
      comment: %(A release event, in a particular place \(e.g. a country\) at a particular time. Other factors of this event might include cover art, liner notes, box, etc. or a release grouping all these.).freeze,
      label: "release event".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "http://purl.org/NET/c4dm/event.owl#Event".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(testing).freeze
    term :ReleaseStatus,
      comment: %(Musical manifestation release status.).freeze,
      label: "release status".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :ReleaseType,
      comment: %(
        Release type of a particular manifestation, such as "album" or "interview"...
    ).freeze,
      label: "Release type".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :SACD,
      comment: %(Super Audio Compact Disc used as medium to record a musical manifestation.).freeze,
      label: "SACD".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:Medium".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :Score,
      comment: %(
        Here, we are dealing with the informational object \(the MusicalExpression\), not the actually "published" score.
        This may be, for example, the product of an arrangement process.
    ).freeze,
      label: "score".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:MusicalExpression".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Show,
      comment: %(
        A show - a musical event lasting several days, in a particular venue. Examples can be
        "The Magic Flute" at the Opera Bastille, August 2005, or a musical in the west end...
    ).freeze,
      label: "Show".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "http://purl.org/NET/c4dm/event.owl#Event".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Signal,
      comment: %(
        A subclass of MusicalExpression, representing a signal, for example a master signal produced by a performance and a recording.
    ).freeze,
      label: "signal".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:MusicalExpression".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :SignalGroup,
      comment: %(
        A musical expression representing a group of signals, for example a set of masters resulting from a whole recording/mastering session.
    ).freeze,
      label: "signal group".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:MusicalExpression".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(testing).freeze
    term :SoloMusicArtist,
      comment: %(Single person whose musical creative work shows sensitivity and imagination.).freeze,
      label: "solo music artist".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: ["foaf:Person".freeze, "mo:MusicArtist".freeze],
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Sound,
      comment: %(
        A subclass of MusicalExpression, representing a sound. Realisation of a MusicalWork during a musical Performance.
    ).freeze,
      label: "sound".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: ["http://purl.org/NET/c4dm/event.owl#Event".freeze, "mo:MusicalExpression".freeze],
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :SoundEngineer,
      label: "sound engineer".freeze,
      "mo:level" => %(2).freeze,
      subClassOf: "foaf:Agent".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :Stream,
      comment: %(Transmission over a network  used as medium to broadcast a musical manifestation).freeze,
      label: "Stream".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:Medium".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :Torrent,
      comment: %(Something available on the Bittorrent peer-2-peer filesharing network).freeze,
      label: "Torrent".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:Medium".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze
    term :Track,
      comment: %(A track on a particular record).freeze,
      label: "track".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:MusicalManifestation".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(stable).freeze
    term :Transcription,
      comment: %(Transcription event).freeze,
      label: "transcription".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "http://purl.org/NET/c4dm/event.owl#Event".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(testing).freeze
    term :Vinyl,
      comment: %(Vinyl used as medium to record a musical manifestation).freeze,
      label: "Vinyl".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subClassOf: "mo:Medium".freeze,
      type: "owl:Class".freeze,
      "vs:term_status" => %(unstable).freeze

    # Property definitions
    property :activity,
      comment: %(Relates an artist to an activity period).freeze,
      domain: "mo:MusicArtist".freeze,
      label: "activity".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:Activity".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :activity_end,
      comment: %(Relates an artist to a date at which its activity ended).freeze,
      domain: "mo:MusicArtist".freeze,
      label: "activity end".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:date".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :activity_start,
      comment: %(Relates an artist to a date at which its activity started).freeze,
      domain: "mo:MusicArtist".freeze,
      label: "activity start".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:date".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :amazon_asin,
      comment: %(Used to link a work or the expression of a work to its corresponding Amazon ASINs page.).freeze,
      label: "amazon_asin".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:isPrimaryTopicOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :arranged_in,
      comment: %(
        Associates a work to an arrangement event where it was arranged
    ).freeze,
      domain: "mo:MusicalWork".freeze,
      label: "arranged in".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:arrangement_of).freeze,
      range: "mo:Arrangement".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#isFactorOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :arrangement_of,
      comment: %(
                Associates an arrangement event to a work
        ).freeze,
      domain: "mo:Arrangement".freeze,
      label: "arrangement of".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:arranged_in).freeze,
      range: "mo:MusicalWork".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#factor".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :artist,
      comment: %(Relates a membership event with the corresponding artist).freeze,
      domain: "mo:Membership".freeze,
      label: "artist".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Agent".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :availableAs,
      label: "availableAs".freeze,
      "owl:equivalentProperty" => %(mo:available_as).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :available_as,
      comment: %(
        Relates a musical manifestation to a musical item \(this album, and my particular cd\). By using
        this property, there is no assumption on wether the full content is available on the linked item.
        To be explicit about this, you can use a sub-property, such as mo:item \(the full manifestation
        is available on that item\) or mo:preview \(only a part of the manifestation is available on
        that item\).

        This is a subproperty of frbr:examplar.
    ).freeze,
      domain: "mo:MusicalManifestation".freeze,
      label: "available_as".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:MusicalItem".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/vocab/frbr/core#exemplar".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :biography,
      comment: %(Used to link an artist to their online biography.).freeze,
      domain: "mo:MusicArtist".freeze,
      label: "biography".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:isPrimaryTopicOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :bitsPerSample,
      comment: %(
        Associates a digital signal to the number a bits used to encode one sample. Range is xsd:int.
    ).freeze,
      domain: "mo:DigitalSignal".freeze,
      label: "bitsPerSample".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:int".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze],
      "vs:term_status" => %(stable).freeze
    property :bpm,
      comment: %(
        Indicates the BPM of a MusicalWork or a particular Performance 
        Beats per minute: the pace of music measured by the number of beats occurring in 60 seconds.
    ).freeze,
      label: "bpm".freeze,
      "mo:level" => %(2).freeze,
      range: "xsd:float".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :catalogue_number,
      comment: %(Links a release with the corresponding catalogue number).freeze,
      domain: "mo:Release".freeze,
      label: "catalogue number".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:uuid".freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :channels,
      comment: %(
        Associates a signal to the number of channels it holds \(mono --> 1, stereo --> 2\). Range is xsd:int.
    ).freeze,
      domain: "mo:Signal".freeze,
      label: "channels".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:int".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze],
      "vs:term_status" => %(stable).freeze
    property :collaborated_with,
      comment: %(Used to relate two collaborating people on a work.).freeze,
      domain: "foaf:Agent".freeze,
      label: "collaborated_with".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Agent".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: ["owl:SymmetricProperty".freeze, "owl:ObjectProperty".freeze],
      "vs:term_status" => %(unstable).freeze
    property :compilation_of,
      comment: %(Indicates that a musical manifestation is a compilation of several Signals.).freeze,
      domain: "mo:MusicalManifestation".freeze,
      label: "compilation_of".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:Signal".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :compiled,
      comment: %(Used to relate an person or a group of person who compiled the manifestation of a musical work.).freeze,
      domain: "mo:MusicArtist".freeze,
      label: "compiled".freeze,
      "mo:level" => %(1).freeze,
      "owl:inverseOf" => %(mo:compiler).freeze,
      range: "mo:MusicalManifestation".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :compiler,
      comment: %(Used to relate the manifestation of a musical work to a person or a group of person who compiled it.).freeze,
      domain: "mo:MusicalManifestation".freeze,
      label: "compiler".freeze,
      "mo:level" => %(1).freeze,
      "owl:inverseOf" => %(mo:compiled).freeze,
      range: "mo:MusicArtist".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :composed_in,
      comment: %(
        Associates a MusicalWork to the Composition event pertaining
        to its creation. For example, I might use this property to associate
        the Magic Flute to its composition event, occuring during 1782 and having as
        a mo:composer Mozart.
    ).freeze,
      domain: "mo:MusicalWork".freeze,
      label: "composed in".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:produced_work).freeze,
      range: "mo:Composition".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#producedIn".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :composer,
      comment: %(
        Associates a composition event to the actual composer. For example,
        this property could link the event corresponding to the composition of the
        Magic Flute in 1782 to Mozart himself \(who obviously has a FOAF profile:-\) \).
    ).freeze,
      domain: "mo:Composition".freeze,
      label: "composer".freeze,
      "mo:level" => %(2).freeze,
      range: "foaf:Agent".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#agent".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :conducted,
      comment: %(Relates agents to the performances they were conducting).freeze,
      domain: "foaf:Agent".freeze,
      label: "conducted".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:conductor).freeze,
      range: "mo:Performance".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: ["http://purl.org/vocab/bio/0.1/event".freeze, "http://purl.org/NET/c4dm/event.owl#isAgentIn".freeze],
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :conductor,
      comment: %(Relates a performance to the conductor involved).freeze,
      domain: "mo:Performance".freeze,
      label: "conductor".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:conducted).freeze,
      range: "foaf:Agent".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#agent".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :contains_sample_from,
      comment: %(
        Relates a signal to another signal, which has been sampled.
        ).freeze,
      label: "contains_sample_from".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:derived_from".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :derived_from,
      comment: %(A related signal from which the described signal is derived.).freeze,
      domain: "mo:Signal".freeze,
      label: "derived from".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:Signal".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "dc:source".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :discography,
      comment: %(Used to links an artist to an online discography of their musical works. The discography should provide a summary of each released musical work of the artist.).freeze,
      domain: "mo:MusicArtist".freeze,
      label: "discography".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:isPrimaryTopicOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :discogs,
      comment: %(Used to link a musical work or the expression of a musical work, an artist or a corporate body to to its corresponding Discogs page.).freeze,
      label: "discogs".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:isPrimaryTopicOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :djmix_of,
      comment: %(Indicates that all \(or most of\) the tracks of a musical work or the expression of a musical work were mixed together from all \(or most of\) the tracks from another musical work or the expression of a musical work to form a so called DJ-Mix. 
    
The tracks might have been altered by pitching \(so that the tempo of one track matches the tempo of the following track\) and fading \(so that one track blends in smoothly with the other\). If the tracks have been more substantially altered, the "mo:remix" relationship type is more appropriate. ).freeze,
      label: "djmix_of".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:derived_from".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :djmixed,
      comment: %(Used to relate an artist who djmixed a musical work or the expression of a musical work. 
    
The artist usually selected the tracks, chose their sequence, and slightly changed them by fading \(so that one track blends in smoothly with the other\) or pitching \(so that the tempo of one track matches the tempo of the following track\). This applies to a 'Mixtape' in which all tracks were DJ-mixed together into one single long track. ).freeze,
      domain: "mo:MusicArtist".freeze,
      label: "djmixed".freeze,
      "mo:level" => %(1).freeze,
      "owl:inverseOf" => %(mo:djmixed_by).freeze,
      range: "mo:Signal".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :djmixed_by,
      comment: %(Used to relate a work or the expression of a work to an artist who djmixed it. 
    
The artist usually selected the tracks, chose their sequence, and slightly changed them by fading \(so that one track blends in smoothly with the other\) or pitching \(so that the tempo of one track matches the tempo of the following track\). This applies to a 'Mixtape' in which all tracks were DJ-mixed together into one single long track. ).freeze,
      domain: "mo:Signal".freeze,
      label: "djmixed_by".freeze,
      "mo:level" => %(1).freeze,
      "owl:inverseOf" => %(mo:djmixed).freeze,
      range: "mo:MusicArtist".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :download,
      comment: %(
                This property can be used to link from a person to the website where they make their works available, or from
                a manifestation \(a track or an album, for example\) to a web page where it is available for
                download.
        
        It is better to use one of the three sub-properties instead of this one in order to specify wether the
        content can be accessed for free \(mo:freedownload\), if it is just free preview material \(mo:previewdownload\), or
        if it can be accessed for some money \(mo:paiddownload\) \(this includes links to the Amazon store, for example\).

                This property MUST be used only if the content is just available through a web page \(holding, for example
                a Flash application\) - it is better to link to actual content directly through the use of mo:available_as and
                mo:Stream, mo:Torrent or mo:ED2K, etc. Therefore, Semantic Web user agents that don't know how to read HTML and even
                less to rip streams from Flash applications can still access the audio content.
        ).freeze,
      label: "download".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:isPrimaryTopicOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :duration,
      comment: %(The duration of a track or a signal in ms).freeze,
      label: "duration".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:float".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :ean,
      comment: %(The European Article Number \(EAN\) is a universal identifier for products, commonly printed in form of barcodes on them. The numbers represented by those codes can either be 8 or 13 digits long, with the 13-digit-version being most common. EANs form a superset of the North American Universal Product Code \(UPC\) as every UPC can be made an EAN by adding a leading zero to it. Additionally every EAN is also a Japanese Article Number \(JAN\). The identifiers were formerly assigned by EAN International which merged with Uniform Code Council \(UCC, the guys behind the UPCs\) and Electronic Commerce Council of Canada \(ECCC\) to become GS1. ).freeze,
      domain: "mo:Release".freeze,
      label: "ean".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:gtin".freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :encodes,
      comment: %(
        Relates a MusicalItem \(a track on a particular CD, an audio file, a stream somewhere\) to the signal it encodes.

        This is usually a lower-resolution version of the master signal \(issued from a Recording event\).
    ).freeze,
      domain: "mo:MusicalItem".freeze,
      label: "encodes".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:Signal".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :encoding,
      comment: %(Method used to convert analog electronic signals into digital format such as "MP3 CBR @ 128kbps", "OGG @ 160kbps", "FLAC", etc.).freeze,
      domain: "mo:AudioFile".freeze,
      label: "encoding".freeze,
      "mo:level" => %(1).freeze,
      range: "rdfs:Literal".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :engineer,
      comment: %(Relates a performance or a recording to the engineer involved).freeze,
      label: "engineer".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:engineered).freeze,
      range: "foaf:Agent".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#agent".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :engineered,
      comment: %(Relates agents to the performances/recordings they were engineering in).freeze,
      domain: "foaf:Agent".freeze,
      label: "engineered".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:engineer).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: ["http://purl.org/vocab/bio/0.1/event".freeze, "http://purl.org/NET/c4dm/event.owl#isAgentIn".freeze],
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :eventHomePage,
      label: "eventHomePage".freeze,
      "owl:equivalentProperty" => %(mo:event_homepage).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :event_homepage,
      comment: %(Links a particular event to a web page).freeze,
      domain: "http://purl.org/NET/c4dm/event.owl#Event".freeze,
      label: "event homepage".freeze,
      "mo:level" => %(2).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:isPrimaryTopicOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :exchange_item,
      comment: %(A person, a group of person or an organization exchanging an exemplar of a single manifestation.).freeze,
      domain: "foaf:Agent".freeze,
      label: "exchange_item".freeze,
      "mo:level" => %(1).freeze,
      range: "http://purl.org/vocab/frbr/core#Item".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :fanpage,
      comment: %(Used to link an artist to a fan-created webpage devoted to that artist.).freeze,
      domain: "mo:MusicArtist".freeze,
      label: "fanpage".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:isPrimaryTopicOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :free_download,
      comment: %(
        This property can be used to link from a person to the website where they make their works available, or from
        a manifestation \(a track or an album, for example\) to a web page where it is available for free 
        download.

        This property MUST be used only if the content is just available through a web page \(holding, for example
        a Flash application\) - it is better to link to actual content directly through the use of mo:available_as and 
        mo:Stream, mo:Torrent or mo:ED2K, etc. Therefore, Semantic Web user agents that don't know how to read HTML and even
        less to rip streams from Flash applications can still access the audio content.
    ).freeze,
      label: "free download".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: ["mo:download".freeze, "foaf:isPrimaryTopicOf".freeze],
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :freedownload,
      label: "freedownload".freeze,
      "owl:equivalentProperty" => %(mo:free_download).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :genre,
      comment: %(
        Associates an event \(like a performance or a recording\) to a particular musical genre.
        Further version of this property may also include works and scores in the domain.
    ).freeze,
      label: "genre".freeze,
      "mo:level" => %(2).freeze,
      range: "mo:Genre".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/ontology/ao/core#genre".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :grid,
      comment: %(The Global Release Identifier \(GRid\) is a system for uniquely identifying Releases of music over electronic networks \(that is, online stores where you can buy music as digital files\). As that it can be seen as the equivalent of the BarCode \(or more correctly the GTIN\) as found on physical releases of music. Like the ISRC \(a code for identifying single recordings as found on releases\) it was developed by the IFPI but it does not appear to be a standard of the ISO.).freeze,
      domain: "mo:Release".freeze,
      label: "GRid".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:uuid".freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :group,
      comment: %(Relates a membership event with the corresponding group).freeze,
      domain: "mo:Membership".freeze,
      label: "group".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Group".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :gtin,
      comment: %(GTIN is a grouping term for EANs and UPCs. In common speech those are called barcodes although the barcodes are just a representation of those identifying numbers.).freeze,
      domain: "mo:Release".freeze,
      label: "gtin".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :has_track,
      label: "has_track".freeze,
      "owl:equivalentProperty" => %(mo:track).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :headliner,
      comment: %(Relates a performance to the headliner\(s\) involved).freeze,
      label: "headliner".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:performer".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :homepage,
      comment: %(Links an artist, a record, etc. to a corresponding web page).freeze,
      label: "homepage".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:isPrimaryTopicOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :image,
      comment: %(Indicates a pictorial image \(JPEG, GIF, PNG, Etc.\) of a musical work, the expression of a musical work, the manifestation of a work or the examplar of a manifestation.).freeze,
      label: "image".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Image".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:depiction".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :imdb,
      comment: %(Used to link an artist, a musical work or the expression of a musical work to their equivalent page on IMDb, the InternetMovieDatabase.).freeze,
      label: "imdb".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:isPrimaryTopicOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :instrument,
      comment: %(Relates a performance to a musical instrument involved).freeze,
      domain: "mo:Performance".freeze,
      label: "instrument".freeze,
      "mo:level" => %(2).freeze,
      range: "mo:Instrument".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#factor".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :interpreter,
      comment: %(Adds an involved music artist, who interpreted, remixed, or otherwise modified an existing signal, which resulted in the signal that is here the subject of this relation.).freeze,
      domain: "mo:Signal".freeze,
      label: "has interpeter".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:MusicArtist".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :ipi,
      comment: %(The Interested Parties Information Code \(IPI\) is an ISO standard similar to ISBNs for identifying the people or groups with some involvement with a particular musical work / compositions.).freeze,
      domain: "mo:MusicArtist".freeze,
      label: "ipi".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:uuid".freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :ismn,
      comment: %(The International Standard Music Number \(ISMN\) is an ISO standard similar to ISBNs for identifying printed music publications).freeze,
      label: "ismn".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:uuid".freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :isrc,
      comment: %(
    The ISRC \(International Standard Recording Code\) is the international identification system for sound recordings and music videorecordings. 
    Each ISRC is a unique and permanent identifier for a specific recording which can be permanently encoded into a product as its digital fingerprint. 
    Encoded ISRC provide the means to automatically identify recordings for royalty payments.
    ).freeze,
      domain: "mo:Signal".freeze,
      label: "isrc".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:uuid".freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :iswc,
      comment: %(Links a musical work to the corresponding ISWC number).freeze,
      domain: "mo:MusicalWork".freeze,
      label: "iswc".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:uuid".freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :item,
      comment: %(
                Relates a musical manifestation to a musical item \(this album, and my particular cd\) holding the
                entire manifestation, and not just a part of it.
        ).freeze,
      domain: "mo:MusicalManifestation".freeze,
      label: "item".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:MusicalItem".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:available_as".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :key,
      comment: %(
        Indicated the key used by the musicians during a performance, or the key of a MusicalWork.
        Any of 24 major or minor diatonic scales that provide the tonal framework for a piece of music.).freeze,
      label: "key".freeze,
      "mo:level" => %(2).freeze,
      range: "http://purl.org/NET/c4dm/keys.owl#Key".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :label,
      comment: %(Associates a release event with the label releasing the record).freeze,
      label: "label".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:Label".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :lc,
      comment: %(The Label Code \(LC\) was introduced in 1977 by the IFPI \(International Federation of Phonogram and Videogram Industries\) in order to unmistakably identify the different record labels \(see Introduction, Record labels\) for rights purposes. The Label Code consists historically of 4 figures, presently being extended to 5 figures, preceded by LC and a dash \(e.g. LC-0193 = Electrola; LC-0233 = His Master's Voice\). Note that the number of countries using the LC is limited, and that the code given on the item is not always accurate.).freeze,
      domain: "mo:Label".freeze,
      label: "lc".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:uuid".freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :level,
      comment: %(
        This annotation property associates to a particular Music Ontology term the corresponding
        expressiveness level. These levels can be:

            - 1: Only editorial/Musicbrainz type information
            - 2: Workflow information
            - 3: Even decomposition
        
        This property is mainly used for specification generation.
    ).freeze,
      label: "level".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:AnnotationProperty".freeze
    property :licence,
      comment: %(Used to link a work or the expression of a work to the license under which they can be manipulated \(downloaded, modified, etc\). 
    
This is usually used to link to a Creative Commons licence.).freeze,
      label: "licence".freeze,
      "mo:level" => %(1).freeze,
      range: "http://web.resource.org/cc/License".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :listened,
      comment: %(Relates agents to the performances they were listening in).freeze,
      domain: "foaf:Agent".freeze,
      label: "listened".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:listener).freeze,
      range: "mo:Performance".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: ["http://purl.org/vocab/bio/0.1/event".freeze, "http://purl.org/NET/c4dm/event.owl#isAgentIn".freeze],
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :listener,
      comment: %(Relates a performance to the listener involved).freeze,
      domain: "mo:Performance".freeze,
      label: "listener".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:listened).freeze,
      range: "foaf:Agent".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#agent".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :lyrics,
      comment: %(Associates lyrics with a musical work).freeze,
      domain: "mo:MusicalWork".freeze,
      label: "lyrics".freeze,
      "mo:level" => %(2).freeze,
      range: "mo:Lyrics".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :mailorder,
      comment: %(Used to link a musical work or the expression of a musical work to a website where people can buy a copy of the musical manifestation.).freeze,
      label: "mailorder".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:isPrimaryTopicOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :mashup_of,
      comment: %(Indicates that musical works or the expressions of a musical work were mashed up on this album or track. 
    
This means that two musical works or the expressions of a musical work by different artists are mixed together, over each other, or otherwise combined into a single musical work \(usually by a third artist, the remixer\).).freeze,
      label: "mashup_of".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:derived_from".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :media_type,
      comment: %(The mediatype \(file format or MIME type, or physical medium\) of a musical manifestation, e.g. a MP3, CD or vinyl.).freeze,
      domain: "mo:MusicalManifestation".freeze,
      label: "has media type".freeze,
      "mo:level" => %(1).freeze,
      range: "dc:MediaType".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "dc:format".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :medley_of,
      comment: %(Indicates that a musical expression is a medley of several other musical expressions. 
    
This means that the orignial musical expression were rearranged to create a new musical expression in the form of a medley. ).freeze,
      label: "medley_of".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:derived_from".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :member,
      comment: %(
        Indicates a member of a musical group
    ).freeze,
      domain: "mo:MusicGroup".freeze,
      label: "member".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Agent".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:member".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :member_of,
      comment: %(Inverse of the foaf:member property).freeze,
      domain: "foaf:Agent".freeze,
      label: "member_of".freeze,
      "mo:level" => %(1).freeze,
      "owl:inverseOf" => %(foaf:member).freeze,
      range: "foaf:Group".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :membership,
      comment: %(Relates an agent with related membership events).freeze,
      domain: "foaf:Agent".freeze,
      label: "membership".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:Membership".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :meter,
      comment: %(Associates a musical work or a score with its meter).freeze,
      label: "meter".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :movement,
      comment: %(Indicates that a musical work has movements).freeze,
      domain: "mo:MusicalWork".freeze,
      label: "has_movement".freeze,
      "mo:level" => %(2).freeze,
      range: "mo:Movement".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :movementNum,
      label: "movementNum".freeze,
      "owl:equivalentProperty" => %(mo:movement_number).freeze,
      type: "owl:DatatypeProperty".freeze
    property :movement_number,
      comment: %(Indicates the position of a movement in a musical work.).freeze,
      domain: "mo:Movement".freeze,
      label: "movement number".freeze,
      "mo:level" => %(2).freeze,
      range: "xsd:int".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :musicbrainz,
      comment: %(
        Linking an agent, a track or a record to its corresponding Musicbrainz page.
        ).freeze,
      label: "musicbrainz".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:isPrimaryTopicOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :musicbrainz_guid,
      comment: %(Links an object to the corresponding Musicbrainz identifier).freeze,
      label: "Musicbrainz GUID".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:uuid".freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :musicmoz,
      comment: %(Used to link an artist, a musical work or the expression of a musical work to its corresponding MusicMoz page.).freeze,
      label: "musicmoz".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:isPrimaryTopicOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :myspace,
      comment: %(Used to link a person to its corresponding MySpace page.).freeze,
      domain: "foaf:Agent".freeze,
      label: "myspace".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:isPrimaryTopicOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :olga,
      comment: %(Used to link a track to a tabulature file for track in the On-Line Guitar Archive.).freeze,
      domain: "mo:Track".freeze,
      label: "olga".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:isPrimaryTopicOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :onlinecommunity,
      comment: %(Used to link a person with an online community web page like a blog, a wiki, a forum, a livejournal page, Etc.).freeze,
      domain: "foaf:Agent".freeze,
      label: "onlinecommunity".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:isPrimaryTopicOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :opus,
      comment: %(
        Used to define a creative work, especially a musical composition numbered to designate the order of a composer's works.
    ).freeze,
      domain: "mo:MusicalWork".freeze,
      label: "opus".freeze,
      "mo:level" => %(2).freeze,
      range: "rdfs:Literal".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :origin,
      comment: %(Relates an artist to its geographic origin).freeze,
      domain: "mo:MusicArtist".freeze,
      label: "origin".freeze,
      "mo:level" => %(1).freeze,
      range: "geo:SpatialThing".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :other_release_of,
      comment: %(Indicates that two musical manifestations are essentially the same.).freeze,
      domain: "mo:MusicalManifestation".freeze,
      label: "other_release_of".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:MusicalManifestation".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: ["owl:SymmetricProperty".freeze, "owl:ObjectProperty".freeze],
      "vs:term_status" => %(unstable).freeze
    property :paid_download,
      comment: %(
                Provide a link from an artist to a web page where all of that artist's musical work is available for some money,
                or a link from a manifestation \(record/track, for example\) to a web page providing a paid access to this manifestation.
        ).freeze,
      label: "paid download".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: ["mo:download".freeze, "foaf:isPrimaryTopicOf".freeze],
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :paiddownload,
      label: "paiddownload".freeze,
      "owl:equivalentProperty" => %(mo:paid_download).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :performance_of,
      comment: %(
        Associates a Performance to a musical work or an arrangement that is being used as a factor in it.
        For example, I might use this property to attach the Magic Flute musical work to 
        a particular Performance.
    ).freeze,
      domain: "mo:Performance".freeze,
      label: "performance of".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:performed_in).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#factor".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :performed,
      comment: %(Relates agents to the performances they were performing in).freeze,
      domain: "foaf:Agent".freeze,
      label: "performed".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:performer).freeze,
      range: "mo:Performance".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: ["http://purl.org/vocab/bio/0.1/event".freeze, "http://purl.org/NET/c4dm/event.owl#isAgentIn".freeze],
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :performed_in,
      comment: %(
        Associates a Musical Work or an Score to Performances in which they were
        a factor. For example, I might use this property in order to 
        associate the Magic Flute to a particular performance at the Opera
        Bastille last year.).freeze,
      label: "performed in".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:performance_of).freeze,
      range: "mo:Performance".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#isFactorOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :performer,
      comment: %(Relates a performance to the performers involved).freeze,
      domain: "mo:Performance".freeze,
      label: "performer".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:performed).freeze,
      range: "foaf:Agent".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#agent".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :possess_item,
      comment: %(A person, a group of person or an organization possessing an exemplar of a single manifestation.).freeze,
      domain: "foaf:Agent".freeze,
      label: "possess_item".freeze,
      "mo:level" => %(1).freeze,
      range: "http://purl.org/vocab/frbr/core#Item".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :preview,
      comment: %(
                Relates a musical manifestation to a musical item \(this album, and my particular cd\), which holds
                a preview of the manifestation \(eg. one track for an album, or a snippet for a track\)
        ).freeze,
      domain: "mo:MusicalManifestation".freeze,
      label: "preview".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:MusicalItem".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:available_as".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :preview_download,
      comment: %(
                This property can be used to link from a person to the website where they make previews of their works available, or from
                a manifestation \(a track or an album, for example\) to a web page where a preview download is available.

                This property MUST be used only if the content is just available through a web page \(holding, for example
                a Flash application\) - it is better to link to actual content directly through the use of mo:available_as and
                mo:Stream, mo:Torrent or mo:ED2K, etc. Therefore, Semantic Web user agents that don't know how to read HTML and even
                less to rip streams from Flash applications can still access the audio content.
        ).freeze,
      label: "preview download".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: ["foaf:isPrimaryTopicOf".freeze, "mo:download".freeze],
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :primary_instrument,
      comment: %(Indicates that an artist primarily plays an instrument, or that a member was primarily playing a particular instrument during his membership).freeze,
      label: "primary instrument".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:Instrument".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :produced,
      comment: %(Used to relate an person or a group of person who produced the manifestation of a work.).freeze,
      domain: "foaf:Agent".freeze,
      label: "produced".freeze,
      "mo:level" => %(1).freeze,
      "owl:inverseOf" => %(mo:producer).freeze,
      range: "mo:MusicalManifestation".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :produced_score,
      comment: %(
        Associates an arrangement or a composition event to a score product \(score here does not refer to a published score, but more
        an abstract arrangement of a particular work\).
    ).freeze,
      label: "produced score".freeze,
      "mo:level" => %(2).freeze,
      range: "mo:Score".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#product".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :produced_signal,
      comment: %(
                Associates a Recording to the outputted signal.
        ).freeze,
      domain: "mo:Recording".freeze,
      label: "produced signal".freeze,
      "mo:level" => %(2).freeze,
      range: "mo:Signal".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#product".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :produced_signal_group,
      comment: %(Associates a recording session with a group of master signals produced by it.).freeze,
      domain: "mo:RecordingSession".freeze,
      label: "produced signal group".freeze,
      "mo:level" => %(2).freeze,
      range: "mo:SignalGroup".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#product".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :produced_sound,
      comment: %(
                Associates a Performance to a physical Sound that is being produced by it.
        ).freeze,
      domain: "mo:Performance".freeze,
      label: "produced sound".freeze,
      "mo:level" => %(2).freeze,
      range: "mo:Sound".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#product".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :produced_work,
      comment: %(
                Associates a composition event to the produced MusicalWork. For example,
                this property could link the event corresponding to the composition of the
                Magic Flute in 1782 to the Magic Flute musical work itself. This musical work
                can then be used in particular performances.
        ).freeze,
      domain: "mo:Composition".freeze,
      label: "produced work".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:composed_in).freeze,
      range: "mo:MusicalWork".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#product".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :producer,
      comment: %(Used to relate the manifestation of a work to a person or a group of person who produced it.).freeze,
      domain: "mo:MusicalManifestation".freeze,
      label: "producer".freeze,
      "mo:level" => %(1).freeze,
      "owl:inverseOf" => %(mo:produced).freeze,
      range: "foaf:Agent".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :producesSignal,
      label: "producesSignal".freeze,
      "owl:equivalentProperty" => %(mo:produced_signal).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :producesSound,
      label: "producesSound".freeze,
      "owl:equivalentProperty" => %(mo:produced_sound).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :producesWork,
      label: "producesWork".freeze,
      "owl:equivalentProperty" => %(mo:produced_work).freeze,
      type: "owl:ObjectProperty".freeze
    property :productOfComposition,
      label: "productOfComposition".freeze,
      "owl:equivalentProperty" => %(mo:composed_in).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :publicationOf,
      label: "publicationOf".freeze,
      "owl:equivalentProperty" => %(mo:publication_of).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :publication_of,
      comment: %(Link a particular manifestation to the related signal, score, libretto, or lyrics).freeze,
      domain: "mo:MusicalManifestation".freeze,
      label: "publication of".freeze,
      "mo:level" => %(1).freeze,
      "owl:inverseOf" => %(mo:published_as).freeze,
      range: "mo:MusicalExpression".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :published,
      comment: %(Used to relate an person or a group of person who published the manifestation of a work.).freeze,
      domain: "foaf:Agent".freeze,
      label: "published".freeze,
      "mo:level" => %(1).freeze,
      "owl:inverseOf" => %(mo:publisher).freeze,
      range: "mo:MusicalManifestation".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :publishedAs,
      label: "publishedAs".freeze,
      "owl:equivalentProperty" => %(mo:published_as).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :published_as,
      comment: %(
        Links a musical expression \(e.g. a signal or a score\) to one of its manifestations \(e.g. a track on a particular record or a published score\).
    ).freeze,
      domain: "mo:MusicalExpression".freeze,
      label: "published as".freeze,
      "mo:level" => %(1).freeze,
      "owl:inverseOf" => %(mo:publication_of).freeze,
      range: "mo:MusicalManifestation".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/vocab/frbr/core#embodiment".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :publisher,
      comment: %(Used to relate a musical manifestation to a person or a group of person who published it.).freeze,
      domain: "mo:MusicalManifestation".freeze,
      label: "publisher".freeze,
      "mo:level" => %(1).freeze,
      "owl:inverseOf" => %(mo:published).freeze,
      range: "foaf:Agent".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :publishingLocation,
      label: "publishingLocation".freeze,
      "owl:equivalentProperty" => %(mo:publishing_location).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :publishing_location,
      comment: %(
        Relates a musical manifestation to its publication location.
        ).freeze,
      domain: "mo:MusicalManifestation".freeze,
      label: "publishingLocation".freeze,
      "mo:level" => %(1).freeze,
      range: "geo:SpatialThing".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :puid,
      comment: %(
        Link a signal to the PUIDs associated with it, that is, PUID computed from MusicalItems \(mo:AudioFile\) 
        derived from this signal.
        PUIDs \(Portable Unique IDentifier\) are the IDs used in the 
        proprietary MusicDNS AudioFingerprinting system which is operated by MusicIP.

        Using PUIDs, one \(with some luck\) can identify the Signal object associated with a particular audio file, therefore allowing
        to access further information \(on which release this track is featured? etc.\). Using some more metadata one can identify
        the particular Track corresponding to the audio file \(a track on a particular release\).).freeze,
      domain: "mo:Signal".freeze,
      label: "puid".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :record,
      comment: %(Associates a release with the records it contains. A single release can be associated with multiple records, for example for a multi-disc release.).freeze,
      domain: "mo:Release".freeze,
      label: "released record".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:Record".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :record_count,
      comment: %(Associates a release with the number of records it contains, e.g. the number of discs it contains in the case of a multi-disc release.).freeze,
      domain: "mo:Release".freeze,
      label: "record count".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:int".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :record_number,
      comment: %(Indicates the position of a record in a release \(e.g. a 2xLP, etc.\).).freeze,
      domain: "mo:Record".freeze,
      label: "has record number".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:nonNegativeInteger".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :record_side,
      comment: %(Associates the side on a vinyl record, where a track is located, e.g. A, B, C, etc. This property can then also be used 
in conjunction with mo:track_number, so that one can infer e.g. "A1", that means, track number 1 on side A.).freeze,
      domain: "mo:Track".freeze,
      label: "has record side".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :recordedAs,
      label: "recordedAs".freeze,
      "owl:equivalentProperty" => %(mo:recorded_as).freeze,
      type: "owl:ObjectProperty".freeze
    property :recorded_as,
      comment: %(
        This is a shortcut property, allowing to bypass all the Sound/Recording steps. This property
        allows to directly link a Performance to the recorded Signal. This is recommended for "normal"
        users. However, advanced users wanting to express things such as the location of the microphone will
        have to create this shortcut as well as the whole workflow, in order to let the "normal" users access
        simply the, well, simple information:-\) .
    ).freeze,
      domain: "mo:Performance".freeze,
      label: "recorded as".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:records).freeze,
      range: "mo:Signal".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :recorded_in,
      comment: %(
            Associates a physical Sound to a Recording event where it is being used 
        in order to produce a signal. For example, I might use this property to 
        associate the sound produced by a particular performance of the magic flute
        to a given recording, done using my cell-phone.
    ).freeze,
      domain: "mo:Sound".freeze,
      label: "recorded in".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:recording_of).freeze,
      range: "mo:Recording".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#isFactorOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :recording_of,
      comment: %(
            Associates a Recording event to a physical Sound being recorded.
                For example, I might use this property to
                associate a given recording, done using my cell phone, to the 
        sound produced by a particular performance of the magic flute.
    ).freeze,
      domain: "mo:Recording".freeze,
      label: "recorded sound".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:recorded_in).freeze,
      range: "mo:Sound".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#factor".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :records,
      comment: %(
        This is the inverse of the shortcut property recordedAs, allowing to relate directly a performance
        to a signal.
    ).freeze,
      domain: "mo:Signal".freeze,
      label: "records".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:recordedAs).freeze,
      range: "mo:Performance".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :release,
      comment: %(Associates a release with the corresponding release event).freeze,
      domain: "mo:ReleaseEvent".freeze,
      label: "release".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:Release".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "http://purl.org/NET/c4dm/event.owl#product".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :releaseStatus,
      label: "releaseStatus".freeze,
      "owl:equivalentProperty" => %(mo:release_status).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :releaseType,
      label: "releaseType".freeze,
      "owl:equivalentProperty" => %(mo:release_type).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :release_status,
      comment: %(
                Relates a musical manifestation to its release status \(bootleg, ...\)
        ).freeze,
      domain: "mo:MusicalManifestation".freeze,
      label: "release_status".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:ReleaseStatus".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :release_type,
      comment: %(
        Relates a musical manifestation to its release type \(interview, spoken word, album, ...\)
    ).freeze,
      domain: "mo:MusicalManifestation".freeze,
      label: "release_type".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:ReleaseType".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :remaster_of,
      comment: %(This relates two musical work or the expression of a musical work, where one is a remaster of the other. 
    
A remaster is a new version made for release from source recordings that were earlier released separately. This is usually done to improve the audio quality or adjust for more modern playback equipment. The process generally doesn't involve changing the music in any artistically important way. It may, however, result in tracks that are a few seconds longer or shorter.).freeze,
      label: "remaster_of".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:derived_from".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :remix_of,
      comment: %(Used to relate the remix of a musical work in a substantially altered version produced by mixing together individual tracks or segments of an original musical source work.).freeze,
      label: "remix_of".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:derived_from".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :remixed,
      comment: %(Used to relate an artist who remixed a musical work or the expression of a musical work. 
    
This involves taking just one other musical work and using audio editing to make it sound like a significantly different, but usually still recognisable, song. It can be used to link an artist to a single song that they remixed, or, if they remixed an entire musical work.).freeze,
      domain: "mo:MusicArtist".freeze,
      label: "remixed".freeze,
      "mo:level" => %(1).freeze,
      "owl:inverseOf" => %(mo:remixer).freeze,
      range: "mo:Signal".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :remixer,
      comment: %(Used to relate a musical work or the expression of a musical work to an artist who remixed it. 
    
This involves taking just one other musical work and using audio editing to make it sound like a significantly different, but usually still recognisable, song. It can be used to link an artist to a single song that they remixed, or, if they remixed an entire musical work.).freeze,
      label: "remixer".freeze,
      "mo:level" => %(1).freeze,
      "owl:inverseOf" => %(mo:remixed).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:interpreter".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :review,
      comment: %(Used to link a work or the expression of a work to a review. 
    
The review does not have to be open content, as long as it is accessible to the general internet population.).freeze,
      label: "review".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:isPrimaryTopicOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :sampleRate,
      label: "sampleRate".freeze,
      "owl:equivalentProperty" => %(mo:sample_rate).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :sample_rate,
      comment: %(
        Associates a digital signal to its sample rate. It might be easier to express it this way instead of
        defining a timeline map:-\) Range is xsd:float.
    ).freeze,
      domain: "mo:DigitalSignal".freeze,
      label: "sample_rate".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:float".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:DatatypeProperty".freeze],
      "vs:term_status" => %(stable).freeze
    property :sampled,
      comment: %(Used to relate an artist who sampled a Signal.).freeze,
      domain: "mo:MusicArtist".freeze,
      label: "sampled".freeze,
      "mo:level" => %(1).freeze,
      "owl:inverseOf" => %(mo:sampler).freeze,
      range: "mo:Signal".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :sampledVersionOf,
      label: "sampledVersionOf".freeze,
      "owl:equivalentProperty" => %(mo:sampled_version_of).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :sampled_version,
      comment: %(
        Associates an analog signal with a sampled version of it
    ).freeze,
      domain: "mo:AnalogSignal".freeze,
      label: "sampled version".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:sampled_version_of).freeze,
      range: "mo:DigitalSignal".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :sampled_version_of,
      comment: %(
        Associates a digital signal with the analog version of it
    ).freeze,
      domain: "mo:DigitalSignal".freeze,
      label: "sampled version of".freeze,
      "mo:level" => %(2).freeze,
      "owl:inverseOf" => %(mo:sampled_version).freeze,
      range: "mo:AnalogSignal".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:derived_from".freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:ObjectProperty".freeze],
      "vs:term_status" => %(stable).freeze
    property :sampler,
      comment: %(Used to relate the signal of a musical work to an artist who sampled it.).freeze,
      label: "sampler".freeze,
      "mo:level" => %(1).freeze,
      "owl:inverseOf" => %(mo:sampled).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:interpreter".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :sell_item,
      comment: %(A person, a group of person or an organization selling an exemplar of a single manifestation.).freeze,
      domain: "foaf:Agent".freeze,
      label: "sell_item".freeze,
      "mo:level" => %(1).freeze,
      range: "http://purl.org/vocab/frbr/core#Item".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :signal,
      comment: %(Associates a group of signals with one of the signals it contains).freeze,
      domain: "mo:SignalGroup".freeze,
      label: "signal".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:Signal".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :signalTime,
      label: "signalTime".freeze,
      "owl:equivalentProperty" => %(mo:time).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :similar_to,
      comment: %(
            A similarity relationships between two objects \(so far, either an agent, a signal or a genre, but
        this could grow\).
        This relationship is pretty general and doesn't make any assumptions on how the similarity claim
        was derived.
        Such similarity statements can come from a range of different sources \(Musicbrainz similarities between
        artists, or coming from some automatic content analysis\).
        However, the origin of such statements should be kept using a named graph approach - and ultimately, the 
        documents providing such statements should attach some metadata to themselves \(confidence of the claim, etc.\).
        ).freeze,
      label: "similar_to".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :singer,
      comment: %(Relates a performance to an involved singer).freeze,
      domain: "mo:Performance".freeze,
      label: "singer".freeze,
      "mo:level" => %(2).freeze,
      range: "foaf:Agent".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:performer".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :supporting_musician,
      comment: %(Used to relate an artist doing long-time instrumental or vocal support for another artist.).freeze,
      domain: "mo:MusicArtist".freeze,
      label: "supporting_musician".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:MusicArtist".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :tempo,
      comment: %(
        Rate of speed or pace of music. Tempo markings are traditionally given in Italian; 
        common markings include: grave \(solemn; very, very slow\); largo \(broad; very slow\); 
        adagio \(quite slow\); andante \(a walking pace\); moderato \(moderate\); allegro \(fast; cheerful\); 
        vivace \(lively\); presto \(very fast\); accelerando \(getting faster\); ritardando \(getting slower\); 
        and a tempo \(in time; returning to the original pace\).
    ).freeze,
      label: "tempo".freeze,
      "mo:level" => %(2).freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :text,
      comment: %(Associates lyrics with their text.).freeze,
      domain: "mo:Lyrics".freeze,
      label: "text".freeze,
      "mo:level" => %(2).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :time,
      comment: %(
        Associates a Signal to a time object - its actual domain
    ).freeze,
      domain: "mo:Signal".freeze,
      label: "time".freeze,
      "mo:level" => %(1).freeze,
      range: "http://www.w3.org/2006/time#TemporalEntity".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: ["owl:FunctionalProperty".freeze, "owl:ObjectProperty".freeze],
      "vs:term_status" => %(stable).freeze
    property :track,
      comment: %(Indicates a part of a musical manifestation - in this particular case, a track.).freeze,
      domain: "mo:Record".freeze,
      label: "track".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:Track".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :trackNum,
      label: "trackNum".freeze,
      "owl:equivalentProperty" => %(mo:track_number).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :track_count,
      comment: %(The track count of a record).freeze,
      domain: "mo:Record".freeze,
      label: "track count".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:int".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :track_number,
      comment: %(Indicates the position of a track on a record medium \(a CD, etc.\).).freeze,
      domain: "mo:Track".freeze,
      label: "track number".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:nonNegativeInteger".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :translation_of,
      comment: %(Indicates that a work or the expression of a work has translated or transliterated into another expression of a work.).freeze,
      domain: "http://purl.org/vocab/frbr/core#Expression".freeze,
      label: "translation_of".freeze,
      "mo:level" => %(1).freeze,
      range: "http://purl.org/vocab/frbr/core#Expression".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :tribute_to,
      comment: %(Indicates a musical work or the expression of a musical work that is a tribute to an artist - normally consisting of music being composed by the artist but performed by other artists. ).freeze,
      domain: "mo:MusicalManifestation".freeze,
      label: "tribute_to".freeze,
      "mo:level" => %(1).freeze,
      range: "mo:MusicArtist".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(unstable).freeze
    property :trmid,
      comment: %(
        Indicates the TRMID of a track.
        TRM IDs are MusicBrainz' old AudioFingerprinting system. 
        TRM \(TRM Recognizes Music\) IDs are \(somewhat\) unique ids that represent 
        the audio signature of a musical piece \(see AudioFingerprint\).
    ).freeze,
      domain: "mo:Signal".freeze,
      label: "trmid".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :upc,
      comment: %(UPC stands for "Universal Product Code", which was the original barcode used in the United States and Canada. The UPC \(now officially EAN.UCC-12 is a numerical method of identifying products without redundancy worldwide for all types of products in the retail sector. The EAN is a superset of the original UPC increasing the digits to 13 with the prefix 0 reserved for UPC. As of 2005, manufacturers are only allowed to use the new 13-digit codes on their items, rather than having two separate numbers.).freeze,
      domain: "mo:Release".freeze,
      label: "upc".freeze,
      "mo:level" => %(1).freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "mo:gtin".freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :usedInPerformance,
      label: "usedInPerformance".freeze,
      "owl:equivalentProperty" => %(mo:performed_in).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :usedInRecording,
      label: "usedInRecording".freeze,
      "owl:equivalentProperty" => %(mo:recorded_in).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :usesSound,
      label: "usesSound".freeze,
      "owl:equivalentProperty" => %(mo:recording_of).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :usesWork,
      label: "usesWork".freeze,
      "owl:equivalentProperty" => %(mo:performance_of).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(deprecated).freeze
    property :uuid,
      comment: %(
            Links an object to an universally unique identifier for it.
    ).freeze,
      domain: "owl:Thing".freeze,
      label: "universally unique identifier".freeze,
      "mo:level" => %(1).freeze,
      subPropertyOf: "dc:identifier".freeze,
      type: "owl:DatatypeProperty".freeze,
      "vs:term_status" => %(testing).freeze
    property :want_item,
      comment: %(A person, a group of person or an organization wanting an exemplar of a single manifestation.).freeze,
      domain: "foaf:Agent".freeze,
      label: "want_item".freeze,
      "mo:level" => %(1).freeze,
      range: "http://purl.org/vocab/frbr/core#Item".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze
    property :wikipedia,
      comment: %(
        Used to link an work, an expression of a work, a manifestation of a work, 
        a person, an instrument or a musical genre to its corresponding WikiPedia page. 
        The full URL should be used, not just the WikiName.
    ).freeze,
      label: "wikipedia".freeze,
      "mo:level" => %(1).freeze,
      range: "foaf:Document".freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      subPropertyOf: "foaf:isPrimaryTopicOf".freeze,
      type: "owl:ObjectProperty".freeze,
      "vs:term_status" => %(stable).freeze

    # Extra definitions
    term :"",
      "dc11:created" => %(2006/12/21 12:00:00).freeze,
      "dc11:date" => %(2013/07/22 16:54:19).freeze,
      "dc11:description" => %(
        The Music Ontology Specification provides main concepts and 
        properties fo describing music \(i.e. artists, albums and tracks\) 
        on the Semantic Web. 
    ).freeze,
      "dc11:title" => %(The Music Ontology).freeze,
      "foaf:maker" => [%(http://raimond.me.uk/foaf.rdf#moustaki).freeze, %(http://foaf.me/zazi#me).freeze, %(http://www.talkdigger.com/foaf/fgiasson).freeze, %(http://kurtisrandom.com/foaf.rdf#kurtjx).freeze],
      label: "".freeze,
      "owl:imports" => [%(http://purl.org/vocab/bio/0.1/).freeze, %(http://purl.org/NET/c4dm/event.owl).freeze, %(http://purl.org/ontology/ao/core).freeze, %(http://www.w3.org/2006/time).freeze, %(foaf:).freeze, %(dc:).freeze, %(http://purl.org/NET/c4dm/keys.owl).freeze, %(http://purl.org/vocab/frbr/core).freeze],
      "owl:versionInfo" => %(Revision: 2.1.5).freeze,
      type: "owl:Ontology".freeze
    term :album,
      "dc11:description" => %(
        One or more track issued together.
            This is a type of MusicalManifestation defined by the musical industry.
    ).freeze,
      "dc11:title" => %(album).freeze,
      label: "album".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "mo:ReleaseType".freeze
    term :audiobook,
      "dc11:description" => %(
        Book read by a narrator without music.
        This is a type of MusicalManifestation defined by the musical industry.
    ).freeze,
      "dc11:title" => %(audio book).freeze,
      label: "audiobook".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "mo:ReleaseType".freeze
    term :bootleg,
      "dc11:description" => %(An unofficial/underground musical work or the expression of a musical work that was not sanctioned by the artist and/or the corporate body. ).freeze,
      "dc11:title" => %(bootleg).freeze,
      label: "bootleg".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "mo:ReleaseStatus".freeze
    term :compilation,
      "dc11:description" => %(
        Collection of previously released manifestations of a musical expression by one or more artists.
        This is a type of MusicalManifestation defined by the musical industry.
    ).freeze,
      "dc11:title" => %(compilation).freeze,
      label: "compilation".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "mo:ReleaseType".freeze
    term :ep,
      "dc11:description" => %(
            An EP
    ).freeze,
      "dc11:title" => %(ep).freeze,
      label: "ep".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "mo:ReleaseType".freeze
    term :interview,
      "dc11:description" => %(
        Recording of the questioning of a person.
        This is a type of MusicalManifestation defined by the musical industry.
    ).freeze,
      "dc11:title" => %(interview).freeze,
      label: "interview".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "mo:ReleaseType".freeze
    term :live,
      "dc11:description" => %(
        A musical manifestation that was recorded live.
        This is a type of MusicalManifestation defined by the musical industry.).freeze,
      "dc11:title" => %(live).freeze,
      label: "live".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "mo:ReleaseType".freeze
    term :official,
      "dc11:description" => %(Any musical work or the expression of a musical work officially sanctioned by the artist and/or their corporate body.).freeze,
      "dc11:title" => %(official).freeze,
      label: "official".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "mo:ReleaseStatus".freeze
    term :promotion,
      "dc11:description" => %(A giveaway musical work or the expression of a musical work intended to promote an upcoming official musical work or the expression of a musical work.).freeze,
      "dc11:title" => %(promotion).freeze,
      label: "promotion".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "mo:ReleaseStatus".freeze
    term :remix,
      "dc11:description" => %(
        Musical manifestation that primarily contains remixed material. 
        This is a type of MusicalManifestation defined by the musical industry.
    ).freeze,
      "dc11:title" => %(remix).freeze,
      label: "remix".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "mo:ReleaseType".freeze
    term :single,
      "dc11:description" => %(A single or record single is a type of release, typically a recording of two tracks. In most cases, the single is a song that is released separately from an album, but it can still appear on an album.).freeze,
      "dc11:title" => %(single).freeze,
      label: "single".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "mo:ReleaseType".freeze
    term :soundtrack,
      "dc11:description" => %(
        Sound recording on a narrow strip of a motion picture film.
        This is a type of MusicalManifestation defined by the musical industry.
    ).freeze,
      "dc11:title" => %(soundtrack).freeze,
      label: "soundtrack".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "mo:ReleaseType".freeze
    term :spokenword,
      "dc11:description" => %(
        Spoken word is a form of music or artistic performance in which lyrics, poetry, or stories are spoken rather than sung. 
        Spoken-word is often done with a musical background, but emphasis is kept on the speaker.
        This is a type of MusicalManifestation defined by the musical industry.
    ).freeze,
      "dc11:title" => %(spoken word).freeze,
      label: "spokenword".freeze,
      "mo:level" => %(1).freeze,
      "rdfs:isDefinedBy" => %(mo:).freeze,
      type: "mo:ReleaseType".freeze
  end
end
