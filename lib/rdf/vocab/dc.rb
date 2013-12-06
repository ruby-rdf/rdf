# This file generated automatically using vocab-fetch from http://purl.org/dc/terms/
require 'rdf'
module RDF
  class DC < StrictVocabulary("http://purl.org/dc/terms/")

    # Class definitions
    property :Agent, :label => 'Agent', :comment =>
      %(A resource that acts or has the power to act.)
    property :AgentClass, :label => 'Agent Class', :comment =>
      %(A group of agents.)
    property :BibliographicResource, :label => 'Bibliographic Resource', :comment =>
      %(A book, article, or other documentary resource.)
    property :FileFormat, :label => 'File Format', :comment =>
      %(A digital resource format.)
    property :Frequency, :label => 'Frequency', :comment =>
      %(A rate at which something recurs.)
    property :Jurisdiction, :label => 'Jurisdiction', :comment =>
      %(The extent or range of judicial, law enforcement, or other
        authority.)
    property :LicenseDocument, :label => 'License Document', :comment =>
      %(A legal document giving official permission to do something
        with a Resource.)
    property :LinguisticSystem, :label => 'Linguistic System', :comment =>
      %(A system of signs, symbols, sounds, gestures, or rules used in
        communication.)
    property :Location, :label => 'Location', :comment =>
      %(A spatial region or named place.)
    property :LocationPeriodOrJurisdiction, :label => 'Location, Period, or Jurisdiction', :comment =>
      %(A location, period of time, or jurisdiction.)
    property :MediaType, :label => 'Media Type', :comment =>
      %(A file format or physical medium.)
    property :MediaTypeOrExtent, :label => 'Media Type or Extent', :comment =>
      %(A media type or extent.)
    property :MethodOfAccrual, :label => 'Method of Accrual', :comment =>
      %(A method by which resources are added to a collection.)
    property :MethodOfInstruction, :label => 'Method of Instruction', :comment =>
      %(A process that is used to engender knowledge, attitudes, and
        skills.)
    property :PeriodOfTime, :label => 'Period of Time', :comment =>
      %(An interval of time that is named or defined by its start and
        end dates.)
    property :PhysicalMedium, :label => 'Physical Medium', :comment =>
      %(A physical material or carrier.)
    property :PhysicalResource, :label => 'Physical Resource', :comment =>
      %(A material thing.)
    property :Policy, :label => 'Policy', :comment =>
      %(A plan or course of action by an authority, intended to
        influence and determine decisions, actions, and other matters.)
    property :ProvenanceStatement, :label => 'Provenance Statement', :comment =>
      %(A statement of any changes in ownership and custody of a
        resource since its creation that are significant for its
        authenticity, integrity, and interpretation.)
    property :RightsStatement, :label => 'Rights Statement', :comment =>
      %(A statement about the intellectual property rights \(IPR\)
        held in or over a Resource, a legal document giving official
        permission to do something with a resource, or a statement
        about access rights.)
    property :SizeOrDuration, :label => 'Size or Duration', :comment =>
      %(A dimension or extent, or a time taken to play or execute.)
    property :Standard, :label => 'Standard', :comment =>
      %(A basis for comparison; a reference point against which other
        things can be evaluated.)

    # Property definitions
    property :abstract, :label => 'Abstract', :comment =>
      %(A summary of the resource.)
    property :accessRights, :label => 'Access Rights', :comment =>
      %(Information about who can access the resource or an indication
        of its security status.)
    property :accrualMethod, :label => 'Accrual Method', :comment =>
      %(The method by which items are added to a collection.)
    property :accrualPeriodicity, :label => 'Accrual Periodicity', :comment =>
      %(The frequency with which items are added to a collection.)
    property :accrualPolicy, :label => 'Accrual Policy', :comment =>
      %(The policy governing the addition of items to a collection.)
    property :alternative, :label => 'Alternative Title', :comment =>
      %(An alternative name for the resource.)
    property :audience, :label => 'Audience', :comment =>
      %(A class of entity for whom the resource is intended or useful.)
    property :educationLevel, :label => 'Audience Education Level', :comment =>
      %(A class of entity, defined in terms of progression through an
        educational or training context, for which the described
        resource is intended.)
    property :bibliographicCitation, :label => 'Bibliographic Citation', :comment =>
      %(A bibliographic reference for the resource.)
    property :conformsTo, :label => 'Conforms To', :comment =>
      %(An established standard to which the described resource
        conforms.)
    property :contributor, :label => 'Contributor', :comment =>
      %(An entity responsible for making contributions to the
        resource.)
    property :coverage, :label => 'Coverage', :comment =>
      %(The spatial or temporal topic of the resource, the spatial
        applicability of the resource, or the jurisdiction under which
        the resource is relevant.)
    property :creator, :label => 'Creator', :comment =>
      %(An entity primarily responsible for making the resource.)
    property :date, :label => 'Date', :comment =>
      %(A point or period of time associated with an event in the
        lifecycle of the resource.)
    property :dateAccepted, :label => 'Date Accepted', :comment =>
      %(Date of acceptance of the resource.)
    property :available, :label => 'Date Available', :comment =>
      %(Date \(often a range\) that the resource became or will become
        available.)
    property :dateCopyrighted, :label => 'Date Copyrighted', :comment =>
      %(Date of copyright.)
    property :created, :label => 'Date Created', :comment =>
      %(Date of creation of the resource.)
    property :issued, :label => 'Date Issued', :comment =>
      %(Date of formal issuance \(e.g., publication\) of the resource.)
    property :modified, :label => 'Date Modified', :comment =>
      %(Date on which the resource was changed.)
    property :dateSubmitted, :label => 'Date Submitted', :comment =>
      %(Date of submission of the resource.)
    property :valid, :label => 'Date Valid', :comment =>
      %(Date \(often a range\) of validity of a resource.)
    property :description, :label => 'Description', :comment =>
      %(An account of the resource.)
    property :extent, :label => 'Extent', :comment =>
      %(The size or duration of the resource.)
    property :format, :label => 'Format', :comment =>
      %(The file format, physical medium, or dimensions of the
        resource.)
    property :hasFormat, :label => 'Has Format', :comment =>
      %(A related resource that is substantially the same as the
        pre-existing described resource, but in another format.)
    property :hasPart, :label => 'Has Part', :comment =>
      %(A related resource that is included either physically or
        logically in the described resource.)
    property :hasVersion, :label => 'Has Version', :comment =>
      %(A related resource that is a version, edition, or adaptation
        of the described resource.)
    property :identifier, :label => 'Identifier', :comment =>
      %(An unambiguous reference to the resource within a given
        context.)
    property :instructionalMethod, :label => 'Instructional Method', :comment =>
      %(A process, used to engender knowledge, attitudes and skills,
        that the described resource is designed to support.)
    property :isFormatOf, :label => 'Is Format Of', :comment =>
      %(A related resource that is substantially the same as the
        described resource, but in another format.)
    property :isPartOf, :label => 'Is Part Of', :comment =>
      %(A related resource in which the described resource is
        physically or logically included.)
    property :isReferencedBy, :label => 'Is Referenced By', :comment =>
      %(A related resource that references, cites, or otherwise points
        to the described resource.)
    property :isReplacedBy, :label => 'Is Replaced By', :comment =>
      %(A related resource that supplants, displaces, or supersedes
        the described resource.)
    property :isRequiredBy, :label => 'Is Required By', :comment =>
      %(A related resource that requires the described resource to
        support its function, delivery, or coherence.)
    property :isVersionOf, :label => 'Is Version Of', :comment =>
      %(A related resource of which the described resource is a
        version, edition, or adaptation.)
    property :language, :label => 'Language', :comment =>
      %(A language of the resource.)
    property :license, :label => 'License', :comment =>
      %(A legal document giving official permission to do something
        with the resource.)
    property :mediator, :label => 'Mediator', :comment =>
      %(An entity that mediates access to the resource and for whom
        the resource is intended or useful.)
    property :medium, :label => 'Medium', :comment =>
      %(The material or physical carrier of the resource.)
    property :provenance, :label => 'Provenance', :comment =>
      %(A statement of any changes in ownership and custody of the
        resource since its creation that are significant for its
        authenticity, integrity, and interpretation.)
    property :publisher, :label => 'Publisher', :comment =>
      %(An entity responsible for making the resource available.)
    property :references, :label => 'References', :comment =>
      %(A related resource that is referenced, cited, or otherwise
        pointed to by the described resource.)
    property :relation, :label => 'Relation', :comment =>
      %(A related resource.)
    property :replaces, :label => 'Replaces', :comment =>
      %(A related resource that is supplanted, displaced, or
        superseded by the described resource.)
    property :requires, :label => 'Requires', :comment =>
      %(A related resource that is required by the described resource
        to support its function, delivery, or coherence.)
    property :rights, :label => 'Rights', :comment =>
      %(Information about rights held in and over the resource.)
    property :rightsHolder, :label => 'Rights Holder', :comment =>
      %(A person or organization owning or managing rights over the
        resource.)
    property :source, :label => 'Source', :comment =>
      %(A related resource from which the described resource is
        derived.)
    property :spatial, :label => 'Spatial Coverage', :comment =>
      %(Spatial characteristics of the resource.)
    property :subject, :label => 'Subject', :comment =>
      %(The topic of the resource.)
    property :tableOfContents, :label => 'Table Of Contents', :comment =>
      %(A list of subunits of the resource.)
    property :temporal, :label => 'Temporal Coverage', :comment =>
      %(Temporal characteristics of the resource.)
    property :title, :label => 'Title', :comment =>
      %(A name given to the resource.)
    property :type, :label => 'Type', :comment =>
      %(The nature or genre of the resource.)

    # Datatype definitions
    property :Box, :label => 'DCMI Box', :comment =>
      %(The set of regions in space defined by their geographic
        coordinates according to the DCMI Box Encoding Scheme.)
    property :Period, :label => 'DCMI Period', :comment =>
      %(The set of time intervals defined by their limits according to
        the DCMI Period Encoding Scheme.)
    property :Point, :label => 'DCMI Point', :comment =>
      %(The set of points in space defined by their geographic
        coordinates according to the DCMI Point Encoding Scheme.)
    property :ISO3166, :label => 'ISO 3166', :comment =>
      %(The set of codes listed in ISO 3166-1 for the representation
        of names of countries.)
    property :"ISO639-2", :label => 'ISO 639-2', :comment =>
      %(The three-letter alphabetic codes listed in ISO639-2 for the
        representation of names of languages.)
    property :"ISO639-3", :label => 'ISO 639-3', :comment =>
      %(The set of three-letter codes listed in ISO 639-3 for the
        representation of names of languages.)
    property :RFC1766, :label => 'RFC 1766', :comment =>
      %(The set of tags, constructed according to RFC 1766, for the
        identification of languages.)
    property :RFC3066, :label => 'RFC 3066', :comment =>
      %(The set of tags constructed according to RFC 3066 for the
        identification of languages.)
    property :RFC4646, :label => 'RFC 4646', :comment =>
      %(The set of tags constructed according to RFC 4646 for the
        identification of languages.)
    property :RFC5646, :label => 'RFC 5646', :comment =>
      %(The set of tags constructed according to RFC 5646 for the
        identification of languages.)
    property :URI, :label => 'URI', :comment =>
      %(The set of identifiers constructed according to the generic
        syntax for Uniform Resource Identifiers as specified by the
        Internet Engineering Task Force.)
    property :W3CDTF, :label => 'W3C-DTF', :comment =>
      %(The set of dates and times constructed according to the W3C
        Date and Time Formats Specification.)
  end
end
