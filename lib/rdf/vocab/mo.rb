# This file generated automatically using vocab-fetch from http://purl.org/ontology/mo/
require 'rdf'
module RDF
  class MO < StrictVocabulary("http://purl.org/ontology/mo/")

    # Class definitions
    property :CD, :label => 'CD', :comment =>
      %(Compact Disc used as medium to record a musical manifestation.)
    property :DAT, :label => 'DAT', :comment =>
      %(Digital Audio Tape used as medium to record a musical
        manifestation.)
    property :DCC, :label => 'DCC', :comment =>
      %(Digital Compact Cassette used as medium to record a musical
        manifestation.)
    property :DVDA, :label => 'DVDA', :comment =>
      %(DVD-Audio used as medium to record a musical manifestation.)
    property :ED2K, :label => 'ED2K', :comment =>
      %(Something available on the E-Donkey peer-2-peer filesharing
        network)
    property :Festival, :label => 'Festival', :comment =>
      %(A festival - musical/artistic event lasting several days, like
        Glastonbury, Rock Am Ring... We migth decompose this event
        \(which is in fact just a classification of the space/time
        region related to a particular festival\) using hasSubEvent in
        several performances at different space/time.)
    property :Genre, :label => 'Genre', :comment =>
      %(An expressive style of music. Any taxonomy can be plug-in
        here. You can either define a genre by yourself, like this:
        :mygenre a mo:Genre; dc:title "electro rock". Or you can refer
        to a DBPedia genre \(such as
        http://dbpedia.org/resource/Baroque_music\), allowing semantic
        web clients to access easily really detailed structured
        information about the genre you are refering to.)
    property :Instrument, :label => 'Instrument', :comment =>
      %(Any of various devices or contrivances that can be used to
        produce musical tones or sound. Any taxonomy can be used to
        subsume this concept. The default one is one extracted by Ivan
        Herman from the Musicbrainz instrument taxonomy, conforming to
        SKOS. This concept holds a seeAlso link towards this taxonomy.)
    property :MD, :label => 'MD', :comment =>
      %(Mini Disc used as medium to record a musical manifestation.)
    property :MagneticTape, :label => 'MagneticTape', :comment =>
      %(Magnetic analogue tape used as medium to record a musical
        manifestation.)
    property :Medium, :label => 'Medium', :comment =>
      %(A means or instrumentality for storing or communicating
        musical manifestation.)
    property :MusicalItem, :label => 'MusicalItem', :comment =>
      %(A single exemplar of a musical expression. For example, it
        could be a single exemplar of a CD. This is normally an single
        object \(a CD\) possessed by somebody. From the FRBR final
        report: The entity defined as item is a concrete entity. It is
        in many instances a single physical object \(e.g., a copy of a
        one-volume monograph, a single audio cassette, etc.\). There
        are instances, however, where the entity defined as item
        comprises more than one physical object \(e.g., a monograph
        issued as two separately bound volumes, a recording issued on
        three separate compact discs, etc.\). In terms of intellectual
        content and physical form, an item exemplifying a
        manifestation is normally the same as the manifestation
        itself. However, variations may occur from one item to
        another, even when the items exemplify the same manifestation,
        where those variations are the result of actions external to
        the intent of the producer of the manifestation \(e.g., damage
        occurring after the item was produced, binding performed by a
        library, etc.\).)
    property :ReleaseType, :label => 'Release type', :comment =>
      %(Release type of a particular manifestation, such as "album" or
        "interview"...)
    property :SACD, :label => 'SACD', :comment =>
      %(Super Audio Compact Disc used as medium to record a musical
        manifestation.)
    property :Show, :label => 'Show', :comment =>
      %(A show - a musical event lasting several days, in a particular
        venue. Examples can be "The Magic Flute" at the Opera
        Bastille, August 2005, or a musical in the west end...)
    property :Stream, :label => 'Stream', :comment =>
      %(Transmission over a network used as medium to broadcast a
        musical manifestation)
    property :Torrent, :label => 'Torrent', :comment =>
      %(Something available on the Bittorrent peer-2-peer filesharing
        network)
    property :Vinyl, :label => 'Vinyl', :comment =>
      %(Vinyl used as medium to record a musical manifestation)
    property :Activity, :label => 'activity', :comment =>
      %(An activity period, defining when an artist was musically
        active.)
    property :AnalogSignal, :label => 'analogue signal', :comment =>
      %(An analog signal.)
    property :Arrangement, :label => 'arrangement', :comment =>
      %(An arrangement event. Takes as agent the arranger, and
        produces a score \(informational object, not the actually
        published score\).)
    property :Arranger, :label => 'arranger'
    property :AudioFile, :label => 'audio file', :comment =>
      %(An audio file, which may be available on a local file system
        or through http, ftp, etc.)
    property :Composer, :label => 'composer'
    property :Composition, :label => 'composition', :comment =>
      %(A composition event. Takes as agent the composer himself. It
        produces a MusicalWork, or a MusicalExpression \(when the
        initial "product" is a score, for example\), or both...)
    property :Conductor, :label => 'conductor'
    property :CorporateBody, :label => 'corporate body', :comment =>
      %(Organization or group of individuals and/or other
        organizations involved in the music market.)
    property :DigitalSignal, :label => 'digital signal', :comment =>
      %(A digital signal)
    property :Instrumentation, :label => 'instrumentation', :comment =>
      %(Instrumentation deals with the techniques of writing music for
        a specific instrument, including the limitations of the
        instrument, playing techniques and idiomatic handling of the
        instrument.)
    property :Label, :label => 'label', :comment =>
      %(Trade name of a company that produces musical works or
        expression of musical works.)
    property :Libretto, :label => 'libretto', :comment =>
      %(Libretto)
    property :Listener, :label => 'listened'
    property :Lyrics, :label => 'lyrics', :comment =>
      %(Lyrics)
    property :Membership, :label => 'membership', :comment =>
      %(A membership event, where one or several people belongs to a
        group during a particular time period.)
    property :Movement, :label => 'movement', :comment =>
      %(A movement is a self-contained part of a musical work. While
        individual or selected movements from a composition are
        sometimes performed separately, a performance of the complete
        work requires all the movements to be performed in succession.
        Often a composer attempts to interrelate the movements
        thematically, or sometimes in more subtle ways, in order that
        the individual movements exert a cumulative effect. In some
        forms, composers sometimes link the movements, or ask for them
        to be played without a pause between them.)
    property :MusicArtist, :label => 'music artist', :comment =>
      %(A person or a group of people \(or a computer :-\) \), whose
        musical creative work shows sensitivity and imagination)
    property :MusicGroup, :label => 'music group', :comment =>
      %(Group of musicians, or musical ensemble, usually popular or
        folk, playing parts of or improvising off of a musical
        arrangement.)
    property :MusicalExpression, :label => 'musical expression', :comment =>
      %(The intellectual or artistic realization of a work in the form
        of alpha-numeric, musical, or choreographic notation, sound,
        etc., or any combination of such forms. For example: Work #1
        Franz Schubert's Trout quintet * Expression #1 the composer's
        score * Expression #2 sound issued from the performance by the
        Amadeus Quartet and Hephzibah Menuhin on piano * Expression #3
        sound issued from the performance by the Cleveland Quartet and
        Yo-Yo Ma on the cello * . . . . The Music Ontology defines the
        following sub-concepts of a MusicalExpression, which should be
        used instead of MusicalExpression itself: Score \(the result
        of an arrangement\), Sound \(produced during a performance\),
        Signal. However, it is possible to stick to FRBR and bypass
        the worflow mechanism this ontology defines by using the core
        FRBR properties on such objects. But it is often better to use
        events to interconnect such expressions \(allowing to go
        deeply into the production process - `this performer was
        playing this particular instrument at that particular time'\).)
    property :MusicalManifestation, :label => 'musical manifestation', :comment =>
      %(This entity is related to the edition/production/publication
        of a musical expression \(musical manifestation are closely
        related with the music industry \(their terms, concepts,
        definitions, methods \(production, publication, etc.\), etc.\)
        From the FRBR final report: The entity defined as
        manifestation encompasses a wide range of materials, including
        manuscripts, books, periodicals, maps, posters, sound
        recordings, films, video recordings, CD-ROMs, multimedia kits,
        etc. As an entity, manifestation represents all the physical
        objects that bear the same characteristics, in respect to both
        intellectual content and physical form. Work #1 J. S. Bach's
        Six suites for unaccompanied cello * Expression #1 sound
        issued during the performance by Janos Starker recorded in
        1963 and 1965 o Manifestation #1 recordings released on 33 1/3
        rpm sound discs in 1965 by Mercury o Manifestation #2
        recordings re-released on compact disc in 1991 by Mercury *
        Expression #2 sound issued during the performances by Yo-Yo Ma
        recorded in 1983 o Manifestation #1 recordings released on 33
        1/3 rpm sound discs in 1983 by CBS Records o Manifestation #2
        recordings re-released on compact disc in 1992 by CBS Records
        Changes that occur deliberately or even inadvertently in the
        production process that affect the copies result, strictly
        speaking, in a new manifestation. A manifestation resulting
        from such a change may be identified as a particular "state"
        or "issue" of the publication. Changes that occur to an
        individual copy after the production process is complete
        \(e.g., the loss of a page, rebinding, etc.\) are not
        considered to result in a new manifestation. That copy is
        simply considered to be an exemplar \(or item\) of the
        manifestation that deviates from the copy as produced. With
        the entity defined as manifestation we can describe the
        physical characteristics of a set of items and the
        characteristics associated with the production and
        distribution of that set of items that may be important
        factors in enabling users to choose a manifestation
        appropriate to their physical needs and constraints, and to
        identify and acquire a copy of that manifestation. Defining
        manifestation as an entity also enables us to draw
        relationships between specific manifestations of a work. We
        can use the relationships between manifestations to identify,
        for example, the specific publication that was used to create
        a microreproduction.)
    property :MusicalWork, :label => 'musical work', :comment =>
      %(Distinct intellectual or artistic musical creation. From the
        FRBR final report: A work is an abstract entity; there is no
        single material object one can point to as the work. We
        recognize the work through individual realizations or
        expressions of the work, but the work itself exists only in
        the commonality of content between and among the various
        expressions of the work. When we speak of Homer's Iliad as a
        work, our point of reference is not a particular recitation or
        text of the work, but the intellectual creation that lies
        behind all the various expressions of the work. For example:
        work #1 J. S. Bach's The art of the fugue)
    property :Orchestration, :label => 'orchestration', :comment =>
      %(Orchestration includes, in addition to instrumentation, the
        handling of groups of instruments and their balance and
        interaction.)
    property :Performance, :label => 'performance', :comment =>
      %(A performance event. It might include as agents performers,
        engineers, conductors, or even listeners. It might include as
        factors a score, a MusicalWork, musical instruments. It might
        produce a sound:-\))
    property :Performer, :label => 'performer'
    property :PublishedLibretto, :label => 'published libretto', :comment =>
      %(A published libretto)
    property :PublishedLyrics, :label => 'published lyrics', :comment =>
      %(Published lyrics, as a book or as a text file, for example)
    property :PublishedScore, :label => 'published score', :comment =>
      %(A published score \(subclass of MusicalManifestation\))
    property :Record, :label => 'record', :comment =>
      %(A published record \(manifestation which first aim is to
        render the product of a recording\))
    property :Recording, :label => 'recording', :comment =>
      %(A recording event. Takes a sound as a factor to produce a
        signal \(analog or digital\). The location of such events \(if
        any\) is the actual location of the corresponding microphone
        or the "recording device".)
    property :RecordingSession, :label => 'recording session', :comment =>
      %(A set of performances/recordings/mastering events. This event
        can be decomposed in its constituent events using
        event:sub_event)
    property :Release, :label => 'release', :comment =>
      %(A specific release, with barcode, box, liner notes, cover art,
        and a number of records)
    property :ReleaseEvent, :label => 'release event', :comment =>
      %(A release event, in a particular place \(e.g. a country\) at a
        particular time. Other factors of this event might include
        cover art, liner notes, box, etc. or a release grouping all
        these.)
    property :ReleaseStatus, :label => 'release status', :comment =>
      %(Musical manifestation release status.)
    property :Score, :label => 'score', :comment =>
      %(Here, we are dealing with the informational object \(the
        MusicalExpression\), not the actually "published" score. This
        may be, for example, the product of an arrangement process.)
    property :Signal, :label => 'signal', :comment =>
      %(A subclass of MusicalExpression, representing a signal, for
        example a master signal produced by a performance and a
        recording.)
    property :SignalGroup, :label => 'signal group', :comment =>
      %(A musical expression representing a group of signals, for
        example a set of masters resulting from a whole
        recording/mastering session.)
    property :SoloMusicArtist, :label => 'solo music artist', :comment =>
      %(Single person whose musical creative work shows sensitivity
        and imagination.)
    property :Sound, :label => 'sound', :comment =>
      %(A subclass of MusicalExpression, representing a sound.
        Realisation of a MusicalWork during a musical Performance.)
    property :SoundEngineer, :label => 'sound engineer'
    property :Track, :label => 'track', :comment =>
      %(A track on a particular record)
    property :Transcription, :label => 'transcription', :comment =>
      %(Transcription event)

    # Property definitions
    property :grid, :label => 'GRid', :comment =>
      %(The Global Release Identifier \(GRid\) is a system for
        uniquely identifying Releases of music over electronic
        networks \(that is, online stores where you can buy music as
        digital files\). As that it can be seen as the equivalent of
        the BarCode \(or more correctly the GTIN\) as found on
        physical releases of music. Like the ISRC \(a code for
        identifying single recordings as found on releases\) it was
        developed by the IFPI but it does not appear to be a standard
        of the ISO.)
    property :musicbrainz_guid, :label => 'Musicbrainz GUID', :comment =>
      %(Links an object to the corresponding Musicbrainz identifier)
    property :activity_end, :label => 'activity end', :comment =>
      %(Relates an artist to a date at which its activity ended)
    property :activity_start, :label => 'activity start', :comment =>
      %(Relates an artist to a date at which its activity started)
    property :bpm, :label => 'bpm', :comment =>
      %(Indicates the BPM of a MusicalWork or a particular Performance
        Beats per minute: the pace of music measured by the number of
        beats occurring in 60 seconds.)
    property :catalogue_number, :label => 'catalogue number', :comment =>
      %(Links a release with the corresponding catalogue number)
    property :ean, :label => 'ean', :comment =>
      %(The European Article Number \(EAN\) is a universal identifier
        for products, commonly printed in form of barcodes on them.
        The numbers represented by those codes can either be 8 or 13
        digits long, with the 13-digit-version being most common. EANs
        form a superset of the North American Universal Product Code
        \(UPC\) as every UPC can be made an EAN by adding a leading
        zero to it. Additionally every EAN is also a Japanese Article
        Number \(JAN\). The identifiers were formerly assigned by EAN
        International which merged with Uniform Code Council \(UCC,
        the guys behind the UPCs\) and Electronic Commerce Council of
        Canada \(ECCC\) to become GS1.)
    property :encoding, :label => 'encoding', :comment =>
      %(Method used to convert analog electronic signals into digital
        format such as "MP3 CBR @ 128kbps", "OGG @ 160kbps", "FLAC",
        etc.)
    property :gtin, :label => 'gtin', :comment =>
      %(GTIN is a grouping term for EANs and UPCs. In common speech
        those are called barcodes although the barcodes are just a
        representation of those identifying numbers.)
    property :record_number, :label => 'has record number', :comment =>
      %(Indicates the position of a record in a release \(e.g. a 2xLP,
        etc.\).)
    property :record_side, :label => 'has record side', :comment =>
      %(Associates the side on a vinyl record, where a track is
        located, e.g. A, B, C, etc. This property can then also be
        used in conjunction with mo:track_number, so that one can
        infer e.g. "A1", that means, track number 1 on side A.)
    property :bitsPerSample, :comment =>
      %(Associates a digital signal to the number a bits used to
        encode one sample. Range is xsd:int.)
    property :channels, :comment =>
      %(Associates a signal to the number of channels it holds \(mono
        --> 1, stereo --> 2\). Range is xsd:int.)
    property :duration, :comment =>
      %(The duration of a track or a signal in ms)
    property :movementNum
    property :sampleRate
    property :sample_rate, :comment =>
      %(Associates a digital signal to its sample rate. It might be
        easier to express it this way instead of defining a timeline
        map:-\) Range is xsd:float.)
    property :trackNum
    property :ipi, :label => 'ipi', :comment =>
      %(The Interested Parties Information Code \(IPI\) is an ISO
        standard similar to ISBNs for identifying the people or groups
        with some involvement with a particular musical work /
        compositions.)
    property :ismn, :label => 'ismn', :comment =>
      %(The International Standard Music Number \(ISMN\) is an ISO
        standard similar to ISBNs for identifying printed music
        publications)
    property :isrc, :label => 'isrc', :comment =>
      %(The ISRC \(International Standard Recording Code\) is the
        international identification system for sound recordings and
        music videorecordings. Each ISRC is a unique and permanent
        identifier for a specific recording which can be permanently
        encoded into a product as its digital fingerprint. Encoded
        ISRC provide the means to automatically identify recordings
        for royalty payments.)
    property :iswc, :label => 'iswc', :comment =>
      %(Links a musical work to the corresponding ISWC number)
    property :lc, :label => 'lc', :comment =>
      %(The Label Code \(LC\) was introduced in 1977 by the IFPI
        \(International Federation of Phonogram and Videogram
        Industries\) in order to unmistakably identify the different
        record labels \(see Introduction, Record labels\) for rights
        purposes. The Label Code consists historically of 4 figures,
        presently being extended to 5 figures, preceded by LC and a
        dash \(e.g. LC-0193 = Electrola; LC-0233 = His Master's
        Voice\). Note that the number of countries using the LC is
        limited, and that the code given on the item is not always
        accurate.)
    property :meter, :label => 'meter', :comment =>
      %(Associates a musical work or a score with its meter)
    property :movement_number, :label => 'movement number', :comment =>
      %(Indicates the position of a movement in a musical work.)
    property :opus, :label => 'opus', :comment =>
      %(Used to define a creative work, especially a musical
        composition numbered to designate the order of a composer's
        works.)
    property :puid, :label => 'puid', :comment =>
      %(Link a signal to the PUIDs associated with it, that is, PUID
        computed from MusicalItems \(mo:AudioFile\) derived from this
        signal. PUIDs \(Portable Unique IDentifier\) are the IDs used
        in the proprietary MusicDNS AudioFingerprinting system which
        is operated by MusicIP. Using PUIDs, one \(with some luck\)
        can identify the Signal object associated with a particular
        audio file, therefore allowing to access further information
        \(on which release this track is featured? etc.\). Using some
        more metadata one can identify the particular Track
        corresponding to the audio file \(a track on a particular
        release\).)
    property :record_count, :label => 'record count', :comment =>
      %(Associates a release with the number of records it contains,
        e.g. the number of discs it contains in the case of a
        multi-disc release.)
    property :tempo, :label => 'tempo', :comment =>
      %(Rate of speed or pace of music. Tempo markings are
        traditionally given in Italian; common markings include: grave
        \(solemn; very, very slow\); largo \(broad; very slow\);
        adagio \(quite slow\); andante \(a walking pace\); moderato
        \(moderate\); allegro \(fast; cheerful\); vivace \(lively\);
        presto \(very fast\); accelerando \(getting faster\);
        ritardando \(getting slower\); and a tempo \(in time;
        returning to the original pace\).)
    property :text, :label => 'text', :comment =>
      %(Associates lyrics with their text.)
    property :track_count, :label => 'track count', :comment =>
      %(The track count of a record)
    property :track_number, :label => 'track number', :comment =>
      %(Indicates the position of a track on a record medium \(a CD,
        etc.\).)
    property :trmid, :label => 'trmid', :comment =>
      %(Indicates the TRMID of a track. TRM IDs are MusicBrainz' old
        AudioFingerprinting system. TRM \(TRM Recognizes Music\) IDs
        are \(somewhat\) unique ids that represent the audio signature
        of a musical piece \(see AudioFingerprint\).)
    property :uuid, :label => 'universally unique identifier', :comment =>
      %(Links an object to an universally unique identifier for it.)
    property :upc, :label => 'upc', :comment =>
      %(UPC stands for "Universal Product Code", which was the
        original barcode used in the United States and Canada. The UPC
        \(now officially EAN.UCC-12 is a numerical method of
        identifying products without redundancy worldwide for all
        types of products in the retail sector. The EAN is a superset
        of the original UPC increasing the digits to 13 with the
        prefix 0 reserved for UPC. As of 2005, manufacturers are only
        allowed to use the new 13-digit codes on their items, rather
        than having two separate numbers.)
    property :activity, :label => 'activity', :comment =>
      %(Relates an artist to an activity period)
    property :amazon_asin, :label => 'amazon_asin', :comment =>
      %(Used to link a work or the expression of a work to its
        corresponding Amazon ASINs page.)
    property :arranged_in, :label => 'arranged in', :comment =>
      %(Associates a work to an arrangement event where it was
        arranged)
    property :arrangement_of, :label => 'arrangement of', :comment =>
      %(Associates an arrangement event to a work)
    property :artist, :label => 'artist', :comment =>
      %(Relates a membership event with the corresponding artist)
    property :biography, :label => 'biography', :comment =>
      %(Used to link an artist to their online biography.)
    property :collaborated_with, :label => 'collaborated_with', :comment =>
      %(Used to relate two collaborating people on a work.)
    property :compilation_of, :label => 'compilation_of', :comment =>
      %(Indicates that a musical manifestation is a compilation of
        several Signals.)
    property :compiled, :label => 'compiled', :comment =>
      %(Used to relate an person or a group of person who compiled the
        manifestation of a musical work.)
    property :compiler, :label => 'compiler', :comment =>
      %(Used to relate the manifestation of a musical work to a person
        or a group of person who compiled it.)
    property :composed_in, :label => 'composed in', :comment =>
      %(Associates a MusicalWork to the Composition event pertaining
        to its creation. For example, I might use this property to
        associate the Magic Flute to its composition event, occuring
        during 1782 and having as a mo:composer Mozart.)
    property :composer, :label => 'composer', :comment =>
      %(Associates a composition event to the actual composer. For
        example, this property could link the event corresponding to
        the composition of the Magic Flute in 1782 to Mozart himself
        \(who obviously has a FOAF profile:-\) \).)
    property :conducted, :label => 'conducted', :comment =>
      %(Relates agents to the performances they were conducting)
    property :contains_sample_from, :label => 'contains_sample_from', :comment =>
      %(Relates a signal to another signal, which has been sampled.)
    property :derived_from, :label => 'derived from', :comment =>
      %(A related signal from which the described signal is derived.)
    property :discography, :label => 'discography', :comment =>
      %(Used to links an artist to an online discography of their
        musical works. The discography should provide a summary of
        each released musical work of the artist.)
    property :discogs, :label => 'discogs', :comment =>
      %(Used to link a musical work or the expression of a musical
        work, an artist or a corporate body to to its corresponding
        Discogs page.)
    property :djmix_of, :label => 'djmix_of', :comment =>
      %(Indicates that all \(or most of\) the tracks of a musical work
        or the expression of a musical work were mixed together from
        all \(or most of\) the tracks from another musical work or the
        expression of a musical work to form a so called DJ-Mix. The
        tracks might have been altered by pitching \(so that the tempo
        of one track matches the tempo of the following track\) and
        fading \(so that one track blends in smoothly with the
        other\). If the tracks have been more substantially altered,
        the "mo:remix" relationship type is more appropriate.)
    property :djmixed, :label => 'djmixed', :comment =>
      %(Used to relate an artist who djmixed a musical work or the
        expression of a musical work. The artist usually selected the
        tracks, chose their sequence, and slightly changed them by
        fading \(so that one track blends in smoothly with the other\)
        or pitching \(so that the tempo of one track matches the tempo
        of the following track\). This applies to a 'Mixtape' in which
        all tracks were DJ-mixed together into one single long track.)
    property :djmixed_by, :label => 'djmixed_by', :comment =>
      %(Used to relate a work or the expression of a work to an artist
        who djmixed it. The artist usually selected the tracks, chose
        their sequence, and slightly changed them by fading \(so that
        one track blends in smoothly with the other\) or pitching \(so
        that the tempo of one track matches the tempo of the following
        track\). This applies to a 'Mixtape' in which all tracks were
        DJ-mixed together into one single long track.)
    property :download, :label => 'download', :comment =>
      %(This property can be used to link from a person to the website
        where they make their works available, or from a manifestation
        \(a track or an album, for example\) to a web page where it is
        available for download. It is better to use one of the three
        sub-properties instead of this one in order to specify wether
        the content can be accessed for free \(mo:freedownload\), if
        it is just free preview material \(mo:previewdownload\), or if
        it can be accessed for some money \(mo:paiddownload\) \(this
        includes links to the Amazon store, for example\). This
        property MUST be used only if the content is just available
        through a web page \(holding, for example a Flash
        application\) - it is better to link to actual content
        directly through the use of mo:available_as and mo:Stream,
        mo:Torrent or mo:ED2K, etc. Therefore, Semantic Web user
        agents that don't know how to read HTML and even less to rip
        streams from Flash applications can still access the audio
        content.)
    property :encodes, :label => 'encodes', :comment =>
      %(Relates a MusicalItem \(a track on a particular CD, an audio
        file, a stream somewhere\) to the signal it encodes. This is
        usually a lower-resolution version of the master signal
        \(issued from a Recording event\).)
    property :engineered, :label => 'engineered', :comment =>
      %(Relates agents to the performances/recordings they were
        engineering in)
    property :event_homepage, :label => 'event homepage', :comment =>
      %(Links a particular event to a web page)
    property :exchange_item, :label => 'exchange_item', :comment =>
      %(A person, a group of person or an organization exchanging an
        exemplar of a single manifestation.)
    property :fanpage, :label => 'fanpage', :comment =>
      %(Used to link an artist to a fan-created webpage devoted to
        that artist.)
    property :free_download, :label => 'free download', :comment =>
      %(This property can be used to link from a person to the website
        where they make their works available, or from a manifestation
        \(a track or an album, for example\) to a web page where it is
        available for free download. This property MUST be used only
        if the content is just available through a web page \(holding,
        for example a Flash application\) - it is better to link to
        actual content directly through the use of mo:available_as and
        mo:Stream, mo:Torrent or mo:ED2K, etc. Therefore, Semantic Web
        user agents that don't know how to read HTML and even less to
        rip streams from Flash applications can still access the audio
        content.)
    property :genre, :label => 'genre', :comment =>
      %(Associates an event \(like a performance or a recording\) to a
        particular musical genre. Further version of this property may
        also include works and scores in the domain.)
    property :group, :label => 'group', :comment =>
      %(Relates a membership event with the corresponding group)
    property :interpreter, :label => 'has interpeter', :comment =>
      %(Adds an involved music artist, who interpreted, remixed, or
        otherwise modified an existing signal, which resulted in the
        signal that is here the subject of this relation.)
    property :media_type, :label => 'has media type', :comment =>
      %(The mediatype \(file format or MIME type, or physical medium\)
        of a musical manifestation, e.g. a MP3, CD or vinyl.)
    property :movement, :label => 'has_movement', :comment =>
      %(Indicates that a musical work has movements)
    property :headliner, :label => 'headliner', :comment =>
      %(Relates a performance to the headliner\(s\) involved)
    property :homepage, :label => 'homepage', :comment =>
      %(Links an artist, a record, etc. to a corresponding web page)
    property :availableAs
    property :available_as, :comment =>
      %(Relates a musical manifestation to a musical item \(this
        album, and my particular cd\). By using this property, there
        is no assumption on wether the full content is available on
        the linked item. To be explicit about this, you can use a
        sub-property, such as mo:item \(the full manifestation is
        available on that item\) or mo:preview \(only a part of the
        manifestation is available on that item\). This is a
        subproperty of frbr:examplar.)
    property :conductor, :comment =>
      %(Relates a performance to the conductor involved)
    property :engineer, :comment =>
      %(Relates a performance or a recording to the engineer involved)
    property :eventHomePage
    property :freedownload
    property :has_track
    property :instrument, :comment =>
      %(Relates a performance to a musical instrument involved)
    property :item, :comment =>
      %(Relates a musical manifestation to a musical item \(this
        album, and my particular cd\) holding the entire
        manifestation, and not just a part of it.)
    property :listener, :comment =>
      %(Relates a performance to the listener involved)
    property :paiddownload
    property :performer, :comment =>
      %(Relates a performance to the performers involved)
    property :preview, :comment =>
      %(Relates a musical manifestation to a musical item \(this
        album, and my particular cd\), which holds a preview of the
        manifestation \(eg. one track for an album, or a snippet for a
        track\))
    property :producesSignal
    property :producesSound
    property :producesWork
    property :productOfComposition
    property :publicationOf
    property :publishedAs
    property :publishingLocation
    property :recordedAs
    property :releaseStatus
    property :releaseType
    property :release_status, :comment =>
      %(Relates a musical manifestation to its release status
        \(bootleg, ...\))
    property :release_type, :comment =>
      %(Relates a musical manifestation to its release type
        \(interview, spoken word, album, ...\))
    property :sampledVersionOf
    property :signalTime
    property :singer, :comment =>
      %(Relates a performance to an involved singer)
    property :usedInPerformance
    property :usedInRecording
    property :usesSound
    property :usesWork
    property :image, :label => 'image', :comment =>
      %(Indicates a pictorial image \(JPEG, GIF, PNG, Etc.\) of a
        musical work, the expression of a musical work, the
        manifestation of a work or the examplar of a manifestation.)
    property :imdb, :label => 'imdb', :comment =>
      %(Used to link an artist, a musical work or the expression of a
        musical work to their equivalent page on IMDb, the
        InternetMovieDatabase.)
    property :key, :label => 'key', :comment =>
      %(Indicated the key used by the musicians during a performance,
        or the key of a MusicalWork. Any of 24 major or minor diatonic
        scales that provide the tonal framework for a piece of music.)
    property :label, :label => 'label', :comment =>
      %(Associates a release event with the label releasing the record)
    property :licence, :label => 'licence', :comment =>
      %(Used to link a work or the expression of a work to the license
        under which they can be manipulated \(downloaded, modified,
        etc\). This is usually used to link to a Creative Commons
        licence.)
    property :listened, :label => 'listened', :comment =>
      %(Relates agents to the performances they were listening in)
    property :lyrics, :label => 'lyrics', :comment =>
      %(Associates lyrics with a musical work)
    property :mailorder, :label => 'mailorder', :comment =>
      %(Used to link a musical work or the expression of a musical
        work to a website where people can buy a copy of the musical
        manifestation.)
    property :mashup_of, :label => 'mashup_of', :comment =>
      %(Indicates that musical works or the expressions of a musical
        work were mashed up on this album or track. This means that
        two musical works or the expressions of a musical work by
        different artists are mixed together, over each other, or
        otherwise combined into a single musical work \(usually by a
        third artist, the remixer\).)
    property :medley_of, :label => 'medley_of', :comment =>
      %(Indicates that a musical expression is a medley of several
        other musical expressions. This means that the orignial
        musical expression were rearranged to create a new musical
        expression in the form of a medley.)
    property :member, :label => 'member', :comment =>
      %(Indicates a member of a musical group)
    property :member_of, :label => 'member_of', :comment =>
      %(Inverse of the foaf:member property)
    property :membership, :label => 'membership', :comment =>
      %(Relates an agent with related membership events)
    property :musicbrainz, :label => 'musicbrainz', :comment =>
      %(Linking an agent, a track or a record to its corresponding
        Musicbrainz page.)
    property :musicmoz, :label => 'musicmoz', :comment =>
      %(Used to link an artist, a musical work or the expression of a
        musical work to its corresponding MusicMoz page.)
    property :myspace, :label => 'myspace', :comment =>
      %(Used to link a person to its corresponding MySpace page.)
    property :olga, :label => 'olga', :comment =>
      %(Used to link a track to a tabulature file for track in the
        On-Line Guitar Archive.)
    property :onlinecommunity, :label => 'onlinecommunity', :comment =>
      %(Used to link a person with an online community web page like a
        blog, a wiki, a forum, a livejournal page, Etc.)
    property :origin, :label => 'origin', :comment =>
      %(Relates an artist to its geographic origin)
    property :other_release_of, :label => 'other_release_of', :comment =>
      %(Indicates that two musical manifestations are essentially the
        same.)
    property :paid_download, :label => 'paid download', :comment =>
      %(Provide a link from an artist to a web page where all of that
        artist's musical work is available for some money, or a link
        from a manifestation \(record/track, for example\) to a web
        page providing a paid access to this manifestation.)
    property :performance_of, :label => 'performance of', :comment =>
      %(Associates a Performance to a musical work or an arrangement
        that is being used as a factor in it. For example, I might use
        this property to attach the Magic Flute musical work to a
        particular Performance.)
    property :performed, :label => 'performed', :comment =>
      %(Relates agents to the performances they were performing in)
    property :performed_in, :label => 'performed in', :comment =>
      %(Associates a Musical Work or an Score to Performances in which
        they were a factor. For example, I might use this property in
        order to associate the Magic Flute to a particular performance
        at the Opera Bastille last year.)
    property :possess_item, :label => 'possess_item', :comment =>
      %(A person, a group of person or an organization possessing an
        exemplar of a single manifestation.)
    property :preview_download, :label => 'preview download', :comment =>
      %(This property can be used to link from a person to the website
        where they make previews of their works available, or from a
        manifestation \(a track or an album, for example\) to a web
        page where a preview download is available. This property MUST
        be used only if the content is just available through a web
        page \(holding, for example a Flash application\) - it is
        better to link to actual content directly through the use of
        mo:available_as and mo:Stream, mo:Torrent or mo:ED2K, etc.
        Therefore, Semantic Web user agents that don't know how to
        read HTML and even less to rip streams from Flash applications
        can still access the audio content.)
    property :primary_instrument, :label => 'primary instrument', :comment =>
      %(Indicates that an artist primarily plays an instrument, or
        that a member was primarily playing a particular instrument
        during his membership)
    property :produced, :label => 'produced', :comment =>
      %(Used to relate an person or a group of person who produced the
        manifestation of a work.)
    property :produced_score, :label => 'produced score', :comment =>
      %(Associates an arrangement or a composition event to a score
        product \(score here does not refer to a published score, but
        more an abstract arrangement of a particular work\).)
    property :produced_signal, :label => 'produced signal', :comment =>
      %(Associates a Recording to the outputted signal.)
    property :produced_signal_group, :label => 'produced signal group', :comment =>
      %(Associates a recording session with a group of master signals
        produced by it.)
    property :produced_sound, :label => 'produced sound', :comment =>
      %(Associates a Performance to a physical Sound that is being
        produced by it.)
    property :produced_work, :label => 'produced work', :comment =>
      %(Associates a composition event to the produced MusicalWork.
        For example, this property could link the event corresponding
        to the composition of the Magic Flute in 1782 to the Magic
        Flute musical work itself. This musical work can then be used
        in particular performances.)
    property :producer, :label => 'producer', :comment =>
      %(Used to relate the manifestation of a work to a person or a
        group of person who produced it.)
    property :publication_of, :label => 'publication of', :comment =>
      %(Link a particular manifestation to the related signal, score,
        libretto, or lyrics)
    property :published, :label => 'published', :comment =>
      %(Used to relate an person or a group of person who published
        the manifestation of a work.)
    property :published_as, :label => 'published as', :comment =>
      %(Links a musical expression \(e.g. a signal or a score\) to one
        of its manifestations \(e.g. a track on a particular record or
        a published score\).)
    property :publisher, :label => 'publisher', :comment =>
      %(Used to relate a musical manifestation to a person or a group
        of person who published it.)
    property :publishing_location, :label => 'publishingLocation', :comment =>
      %(Relates a musical manifestation to its publication location.)
    property :recorded_as, :label => 'recorded as', :comment =>
      %(This is a shortcut property, allowing to bypass all the
        Sound/Recording steps. This property allows to directly link a
        Performance to the recorded Signal. This is recommended for
        "normal" users. However, advanced users wanting to express
        things such as the location of the microphone will have to
        create this shortcut as well as the whole workflow, in order
        to let the "normal" users access simply the, well, simple
        information:-\) .)
    property :recorded_in, :label => 'recorded in', :comment =>
      %(Associates a physical Sound to a Recording event where it is
        being used in order to produce a signal. For example, I might
        use this property to associate the sound produced by a
        particular performance of the magic flute to a given
        recording, done using my cell-phone.)
    property :recording_of, :label => 'recorded sound', :comment =>
      %(Associates a Recording event to a physical Sound being
        recorded. For example, I might use this property to associate
        a given recording, done using my cell phone, to the sound
        produced by a particular performance of the magic flute.)
    property :records, :label => 'records', :comment =>
      %(This is the inverse of the shortcut property recordedAs,
        allowing to relate directly a performance to a signal.)
    property :release, :label => 'release', :comment =>
      %(Associates a release with the corresponding release event)
    property :record, :label => 'released record', :comment =>
      %(Associates a release with the records it contains. A single
        release can be associated with multiple records, for example
        for a multi-disc release.)
    property :remaster_of, :label => 'remaster_of', :comment =>
      %(This relates two musical work or the expression of a musical
        work, where one is a remaster of the other. A remaster is a
        new version made for release from source recordings that were
        earlier released separately. This is usually done to improve
        the audio quality or adjust for more modern playback
        equipment. The process generally doesn't involve changing the
        music in any artistically important way. It may, however,
        result in tracks that are a few seconds longer or shorter.)
    property :remix_of, :label => 'remix_of', :comment =>
      %(Used to relate the remix of a musical work in a substantially
        altered version produced by mixing together individual tracks
        or segments of an original musical source work.)
    property :remixed, :label => 'remixed', :comment =>
      %(Used to relate an artist who remixed a musical work or the
        expression of a musical work. This involves taking just one
        other musical work and using audio editing to make it sound
        like a significantly different, but usually still
        recognisable, song. It can be used to link an artist to a
        single song that they remixed, or, if they remixed an entire
        musical work.)
    property :remixer, :label => 'remixer', :comment =>
      %(Used to relate a musical work or the expression of a musical
        work to an artist who remixed it. This involves taking just
        one other musical work and using audio editing to make it
        sound like a significantly different, but usually still
        recognisable, song. It can be used to link an artist to a
        single song that they remixed, or, if they remixed an entire
        musical work.)
    property :review, :label => 'review', :comment =>
      %(Used to link a work or the expression of a work to a review.
        The review does not have to be open content, as long as it is
        accessible to the general internet population.)
    property :sampled, :label => 'sampled', :comment =>
      %(Used to relate an artist who sampled a Signal.)
    property :sampled_version, :label => 'sampled version', :comment =>
      %(Associates an analog signal with a sampled version of it)
    property :sampled_version_of, :label => 'sampled version of', :comment =>
      %(Associates a digital signal with the analog version of it)
    property :sampler, :label => 'sampler', :comment =>
      %(Used to relate the signal of a musical work to an artist who
        sampled it.)
    property :sell_item, :label => 'sell_item', :comment =>
      %(A person, a group of person or an organization selling an
        exemplar of a single manifestation.)
    property :signal, :label => 'signal', :comment =>
      %(Associates a group of signals with one of the signals it
        contains)
    property :similar_to, :label => 'similar_to', :comment =>
      %(A similarity relationships between two objects \(so far,
        either an agent, a signal or a genre, but this could grow\).
        This relationship is pretty general and doesn't make any
        assumptions on how the similarity claim was derived. Such
        similarity statements can come from a range of different
        sources \(Musicbrainz similarities between artists, or coming
        from some automatic content analysis\). However, the origin of
        such statements should be kept using a named graph approach -
        and ultimately, the documents providing such statements should
        attach some metadata to themselves \(confidence of the claim,
        etc.\).)
    property :supporting_musician, :label => 'supporting_musician', :comment =>
      %(Used to relate an artist doing long-time instrumental or vocal
        support for another artist.)
    property :time, :label => 'time', :comment =>
      %(Associates a Signal to a time object - its actual domain)
    property :track, :label => 'track', :comment =>
      %(Indicates a part of a musical manifestation - in this
        particular case, a track.)
    property :translation_of, :label => 'translation_of', :comment =>
      %(Indicates that a work or the expression of a work has
        translated or transliterated into another expression of a
        work.)
    property :tribute_to, :label => 'tribute_to', :comment =>
      %(Indicates a musical work or the expression of a musical work
        that is a tribute to an artist - normally consisting of music
        being composed by the artist but performed by other artists.)
    property :want_item, :label => 'want_item', :comment =>
      %(A person, a group of person or an organization wanting an
        exemplar of a single manifestation.)
    property :wikipedia, :label => 'wikipedia', :comment =>
      %(Used to link an work, an expression of a work, a manifestation
        of a work, a person, an instrument or a musical genre to its
        corresponding WikiPedia page. The full URL should be used, not
        just the WikiName.)
    property :level, :label => 'level', :comment =>
      %(This annotation property associates to a particular Music
        Ontology term the corresponding expressiveness level. These
        levels can be: - 1: Only editorial/Musicbrainz type
        information - 2: Workflow information - 3: Even decomposition
        This property is mainly used for specification generation.)
  end
end
