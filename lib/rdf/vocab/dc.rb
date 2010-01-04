module RDF
  ##
  # Dublin Core (DC) vocabulary.
  #
  # @see http://dublincore.org/schemas/rdfs/
  class DC < Vocabulary("http://purl.org/dc/terms/")
    property :abstract
    property :accessRights
    property :accrualMethod
    property :accrualPeriodicity
    property :accrualPolicy
    property :alternative
    property :audience
    property :available
    property :bibliographicCitation
    property :conformsTo
    property :contributor
    property :coverage
    property :created
    property :creator
    property :date
    property :dateAccepted
    property :dateCopyrighted
    property :dateSubmitted
    property :description
    property :educationLevel
    property :extent
    property :format
    property :hasFormat
    property :hasPart
    property :hasVersion
    property :identifier
    property :instructionalMethod
    property :isFormatOf
    property :isPartOf
    property :isReferencedBy
    property :isReplacedBy
    property :isRequiredBy
    property :isVersionOf
    property :issued
    property :language
    property :license
    property :mediator
    property :medium
    property :modified
    property :provenance
    property :publisher
    property :references
    property :relation
    property :replaces
    property :requires
    property :rights
    property :rightsHolder
    property :source
    property :spatial
    property :subject
    property :tableOfContents
    property :temporal
    property :title
    property :type
    property :valid
  end
end
