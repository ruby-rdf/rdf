# This file generated automatically using vocab-fetch from http://www.w3.org/ns/prov#
require 'rdf'
module RDF
  class PROV < StrictVocabulary("http://www.w3.org/ns/prov#")

    # Class definitions
    property :Accept, :label => 'Accept'
    property :Activity, :label => 'Activity'
    property :ActivityInfluence, :label => 'ActivityInfluence', :comment =>
      %(ActivityInfluence provides additional descriptions of an
        Activity's binary influence upon any other kind of resource.
        Instances of ActivityInfluence use the prov:activity property
        to cite the influencing Activity.)
    property :ActivityInfluence, :label => 'ActivityInfluence', :comment =>
      %(It is not recommended that the type ActivityInfluence be
        asserted without also asserting one of its more specific
        subclasses.)
    property :Agent, :label => 'Agent'
    property :AgentInfluence, :label => 'AgentInfluence', :comment =>
      %(AgentInfluence provides additional descriptions of an Agent's
        binary influence upon any other kind of resource. Instances of
        AgentInfluence use the prov:agent property to cite the
        influencing Agent.)
    property :AgentInfluence, :label => 'AgentInfluence', :comment =>
      %(It is not recommended that the type AgentInfluence be asserted
        without also asserting one of its more specific subclasses.)
    property :Association, :label => 'Association', :comment =>
      %(An instance of prov:Association provides additional
        descriptions about the binary prov:wasAssociatedWith relation
        from an prov:Activity to some prov:Agent that had some
        responsiblity for it. For example, :baking
        prov:wasAssociatedWith :baker; prov:qualifiedAssociation [ a
        prov:Association; prov:agent :baker; :foo :bar ].)
    property :Attribution, :label => 'Attribution', :comment =>
      %(An instance of prov:Attribution provides additional
        descriptions about the binary prov:wasAttributedTo relation
        from an prov:Entity to some prov:Agent that had some
        responsible for it. For example, :cake prov:wasAttributedTo
        :baker; prov:qualifiedAttribution [ a prov:Attribution;
        prov:entity :baker; :foo :bar ].)
    property :Bundle, :label => 'Bundle', :comment =>
      %(Note that there are kinds of bundles \(e.g. handwritten
        letters, audio recordings, etc.\) that are not expressed in
        PROV-O, but can be still be described by PROV-O.)
    property :Collection, :label => 'Collection'
    property :Communication, :label => 'Communication', :comment =>
      %(An instance of prov:Communication provides additional
        descriptions about the binary prov:wasInformedBy relation from
        an informed prov:Activity to the prov:Activity that informed
        it. For example, :you_jumping_off_bridge prov:wasInformedBy
        :everyone_else_jumping_off_bridge; prov:qualifiedCommunication
        [ a prov:Communication; prov:activity
        :everyone_else_jumping_off_bridge; :foo :bar ].)
    property :Contribute, :label => 'Contribute'
    property :Contributor, :label => 'Contributor'
    property :Copyright, :label => 'Copyright'
    property :Create, :label => 'Create'
    property :Creator, :label => 'Creator'
    property :Delegation, :label => 'Delegation', :comment =>
      %(An instance of prov:Delegation provides additional
        descriptions about the binary prov:actedOnBehalfOf relation
        from a performing prov:Agent to some prov:Agent for whom it
        was performed. For example, :mixing prov:wasAssociatedWith
        :toddler . :toddler prov:actedOnBehalfOf :mother;
        prov:qualifiedDelegation [ a prov:Delegation; prov:entity
        :mother; :foo :bar ].)
    property :Derivation, :label => 'Derivation', :comment =>
      %(An instance of prov:Derivation provides additional
        descriptions about the binary prov:wasDerivedFrom relation
        from some derived prov:Entity to another prov:Entity from
        which it was derived. For example, :chewed_bubble_gum
        prov:wasDerivedFrom :unwrapped_bubble_gum;
        prov:qualifiedDerivation [ a prov:Derivation; prov:entity
        :unwrapped_bubble_gum; :foo :bar ].)
    property :Derivation, :label => 'Derivation', :comment =>
      %(The more specific forms of prov:Derivation \(i.e.,
        prov:Revision, prov:Quotation, prov:PrimarySource\) should be
        asserted if they apply.)
    property :Dictionary, :label => 'Dictionary', :comment =>
      %(A given dictionary forms a given structure for its members. A
        different structure \(obtained either by insertion or removal
        of members\) constitutes a different dictionary.)
    property :Dictionary, :label => 'Dictionary', :comment =>
      %(This concept allows for the provenance of the dictionary, but
        also of its constituents to be expressed. Such a notion of
        dictionary corresponds to a wide variety of concrete data
        structures, such as a maps or associative arrays.)
    property :EmptyDictionary, :label => 'Empty Dictionary'
    property :EmptyCollection, :label => 'EmptyCollection'
    property :End, :label => 'End', :comment =>
      %(An instance of prov:End provides additional descriptions about
        the binary prov:wasEndedBy relation from some ended
        prov:Activity to an prov:Entity that ended it. For example,
        :ball_game prov:wasEndedBy :buzzer; prov:qualifiedEnd [ a
        prov:End; prov:entity :buzzer; :foo :bar; prov:atTime
        '2012-03-09T08:05:08-05:00'^^xsd:dateTime ].)
    property :Entity, :label => 'Entity'
    property :EntityInfluence, :label => 'EntityInfluence', :comment =>
      %(EntityInfluence provides additional descriptions of an
        Entity's binary influence upon any other kind of resource.
        Instances of EntityInfluence use the prov:entity property to
        cite the influencing Entity.)
    property :EntityInfluence, :label => 'EntityInfluence', :comment =>
      %(It is not recommended that the type EntityInfluence be
        asserted without also asserting one of its more specific
        subclasses.)
    property :Generation, :label => 'Generation', :comment =>
      %(An instance of prov:Generation provides additional
        descriptions about the binary prov:wasGeneratedBy relation
        from a generated prov:Entity to the prov:Activity that
        generated it. For example, :cake prov:wasGeneratedBy :baking;
        prov:qualifiedGeneration [ a prov:Generation; prov:activity
        :baking; :foo :bar ].)
    property :Influence, :label => 'Influence', :comment =>
      %(Because prov:Influence is a broad relation, its most specific
        subclasses \(e.g. prov:Communication, prov:Delegation,
        prov:End, prov:Revision, etc.\) should be used when
        applicable.)
    property :Influence, :label => 'Influence', :comment =>
      %(An instance of prov:Influence provides additional descriptions
        about the binary prov:wasInfluencedBy relation from some
        influenced Activity, Entity, or Agent to the influencing
        Activity, Entity, or Agent. For example, :stomach_ache
        prov:wasInfluencedBy :spoon; prov:qualifiedInfluence [ a
        prov:Influence; prov:entity :spoon; :foo :bar ] . Because
        prov:Influence is a broad relation, the more specific
        relations \(Communication, Delegation, End, etc.\) should be
        used when applicable.)
    property :Insertion, :label => 'Insertion'
    property :InstantaneousEvent, :label => 'InstantaneousEvent', :comment =>
      %(An instantaneous event, or event for short, happens in the
        world and marks a change in the world, in its activities and
        in its entities. The term 'event' is commonly used in process
        algebra with a similar meaning. Events represent
        communications or interactions; they are assumed to be atomic
        and instantaneous.)
    property :Invalidation, :label => 'Invalidation', :comment =>
      %(An instance of prov:Invalidation provides additional
        descriptions about the binary prov:wasInvalidatedBy relation
        from an invalidated prov:Entity to the prov:Activity that
        invalidated it. For example, :uncracked_egg
        prov:wasInvalidatedBy :baking; prov:qualifiedInvalidation [ a
        prov:Invalidation; prov:activity :baking; :foo :bar ].)
    property :KeyEntityPair, :label => 'Key-Entity Pair'
    property :Location, :label => 'Location'
    property :Modify, :label => 'Modify'
    property :Organization, :label => 'Organization'
    property :Person, :label => 'Person'
    property :Plan, :label => 'Plan', :comment =>
      %(There exist no prescriptive requirement on the nature of
        plans, their representation, the actions or steps they consist
        of, or their intended goals. Since plans may evolve over time,
        it may become necessary to track their provenance, so plans
        themselves are entities. Representing the plan explicitly in
        the provenance can be useful for various tasks: for example,
        to validate the execution as represented in the provenance
        record, to manage expectation failures, or to provide
        explanations.)
    property :PrimarySource, :label => 'PrimarySource', :comment =>
      %(An instance of prov:PrimarySource provides additional
        descriptions about the binary prov:hadPrimarySource relation
        from some secondary prov:Entity to an earlier, primary
        prov:Entity. For example, :blog prov:hadPrimarySource
        :newsArticle; prov:qualifiedPrimarySource [ a
        prov:PrimarySource; prov:entity :newsArticle; :foo :bar ] .)
    property :DirectQueryService, :label => 'ProvenanceService', :comment =>
      %(Type for a generic provenance query service. Mainly for use in
        RDF provenance query service descriptions, to facilitate
        discovery in linked data environments.)
    property :Publish, :label => 'Publish'
    property :Publisher, :label => 'Publisher'
    property :Quotation, :label => 'Quotation', :comment =>
      %(An instance of prov:Quotation provides additional descriptions
        about the binary prov:wasQuotedFrom relation from some taken
        prov:Entity from an earlier, larger prov:Entity. For example,
        :here_is_looking_at_you_kid prov:wasQuotedFrom
        :casablanca_script; prov:qualifiedQuotation [ a
        prov:Quotation; prov:entity :casablanca_script; :foo :bar ].)
    property :Removal, :label => 'Removal'
    property :Replace, :label => 'Replace'
    property :Revision, :label => 'Revision', :comment =>
      %(An instance of prov:Revision provides additional descriptions
        about the binary prov:wasRevisionOf relation from some newer
        prov:Entity to an earlier prov:Entity. For example, :draft_2
        prov:wasRevisionOf :draft_1; prov:qualifiedRevision [ a
        prov:Revision; prov:entity :draft_1; :foo :bar ].)
    property :RightsAssignment, :label => 'RightsAssignment'
    property :RightsHolder, :label => 'RightsHolder'
    property :Role, :label => 'Role'
    property :ServiceDescription, :label => 'ServiceDescription', :comment =>
      %(Type for a generic provenance query service. Mainly for use in
        RDF provenance query service descriptions, to facilitate
        discovery in linked data environments.)
    property :SoftwareAgent, :label => 'SoftwareAgent'
    property :Start, :label => 'Start', :comment =>
      %(An instance of prov:Start provides additional descriptions
        about the binary prov:wasStartedBy relation from some started
        prov:Activity to an prov:Entity that started it. For example,
        :foot_race prov:wasStartedBy :bang; prov:qualifiedStart [ a
        prov:Start; prov:entity :bang; :foo :bar; prov:atTime
        '2012-03-09T08:05:08-05:00'^^xsd:dateTime ] .)
    property :Submit, :label => 'Submit'
    property :Usage, :label => 'Usage', :comment =>
      %(An instance of prov:Usage provides additional descriptions
        about the binary prov:used relation from some prov:Activity to
        an prov:Entity that it used. For example, :keynote prov:used
        :podium; prov:qualifiedUsage [ a prov:Usage; prov:entity
        :podium; :foo :bar ].)

    # Property definitions
    property :atTime, :label => 'atTime', :comment =>
      %(The time at which an InstantaneousEvent occurred, in the form
        of xsd:dateTime.)
    property :endedAtTime, :label => 'endedAtTime', :comment =>
      %(The time at which an activity ended. See also
        prov:startedAtTime.)
    property :generatedAtTime, :label => 'generatedAtTime', :comment =>
      %(The time at which an entity was completely created and is
        available for use.)
    property :invalidatedAtTime, :label => 'invalidatedAtTime', :comment =>
      %(The time at which an entity was invalidated \(i.e., no longer
        usable\).)
    property :pairKey, :label => 'pairKey'
    property :provenanceUriTemplate, :label => 'provenanceUriTemplate', :comment =>
      %(Relates a provenance service to a URI template string for
        constructing provenance-URIs.)
    property :removedKey, :label => 'removedKey'
    property :startedAtTime, :label => 'startedAtTime', :comment =>
      %(The time at which an activity started. See also
        prov:endedAtTime.)
    property :value, :label => 'value'
    property :actedOnBehalfOf, :label => 'actedOnBehalfOf', :comment =>
      %(An object property to express the accountability of an agent
        towards another agent. The subordinate agent acted on behalf
        of the responsible agent in an actual activity.)
    property :activity, :label => 'activity'
    property :agent, :label => 'agent'
    property :alternateOf, :label => 'alternateOf'
    property :asInBundle, :label => 'asInBundle', :comment =>
      %(prov:asInBundle is used to specify which bundle the general
        entity of a prov:mentionOf property is described. When :x
        prov:mentionOf :y and :y is described in Bundle :b, the triple
        :x prov:asInBundle :b is also asserted to cite the Bundle in
        which :y was described.)
    property :atLocation, :label => 'atLocation', :comment =>
      %(This property has multiple RDFS domains to suit multiple OWL
        Profiles. See <a href="#owl-profile">PROV-O OWL Profile</a>.)
    property :atLocation, :label => 'atLocation', :comment =>
      %(The Location of any resource.)
    property :derivedByInsertionFrom, :label => 'derivedByInsertionFrom'
    property :derivedByRemovalFrom, :label => 'derivedByRemovalFrom'
    property :describesService, :label => 'describesService', :comment =>
      %(relates a generic provenance query service resource \(type
        prov:ServiceDescription\) to a specific query service
        description \(e.g. a prov:DirectQueryService or a
        sd:Service\).)
    property :dictionary, :label => 'dictionary'
    property :entity, :label => 'entity'
    property :generated, :label => 'generated'
    property :hadActivity, :label => 'hadActivity', :comment =>
      %(The _optional_ Activity of an Influence, which used,
        generated, invalidated, or was the responsibility of some
        Entity. This property is _not_ used by ActivityInfluence \(use
        prov:activity instead\).)
    property :hadActivity, :label => 'hadActivity', :comment =>
      %(This property has multiple RDFS domains to suit multiple OWL
        Profiles. See <a href="#owl-profile">PROV-O OWL Profile</a>.)
    property :hadDictionaryMember, :label => 'hadDictionaryMember'
    property :hadGeneration, :label => 'hadGeneration', :comment =>
      %(The _optional_ Generation involved in an Entity's Derivation.)
    property :hadMember, :label => 'hadMember'
    property :hadPlan, :label => 'hadPlan', :comment =>
      %(The _optional_ Plan adopted by an Agent in Association with
        some Activity. Plan specifications are out of the scope of
        this specification.)
    property :hadPrimarySource, :label => 'hadPrimarySource'
    property :hadRole, :label => 'hadRole', :comment =>
      %(This property has multiple RDFS domains to suit multiple OWL
        Profiles. See <a href="#owl-profile">PROV-O OWL Profile</a>.)
    property :hadRole, :label => 'hadRole', :comment =>
      %(The _optional_ Role that an Entity assumed in the context of
        an Activity. For example, :baking prov:used :spoon;
        prov:qualified [ a prov:Usage; prov:entity :spoon;
        prov:hadRole roles:mixing_implement ].)
    property :hadUsage, :label => 'hadUsage', :comment =>
      %(The _optional_ Usage involved in an Entity's Derivation.)
    property :has_query_service, :label => 'hasProvenanceService', :comment =>
      %(Indicates a provenance query service that can access
        provenance related to its subject or anchor resource.)
    property :has_anchor, :label => 'has_anchor', :comment =>
      %(Indicates anchor URI for a potentially dynamic resource
        instance.)
    property :has_provenance, :label => 'has_provenance', :comment =>
      %(Indicates a provenance-URI for a resource; the resource
        identified by this property presents a provenance record about
        its subject or anchor resource.)
    property :influenced, :label => 'influenced'
    property :influencer, :label => 'influencer', :comment =>
      %(Subproperties of prov:influencer are used to cite the object
        of an unqualified PROV-O triple whose predicate is a
        subproperty of prov:wasInfluencedBy \(e.g. prov:used,
        prov:wasGeneratedBy\). prov:influencer is used much like
        rdf:object is used.)
    property :insertedKeyEntityPair, :label => 'insertedKeyEntityPair'
    property :invalidated, :label => 'invalidated'
    property :mentionOf, :label => 'mentionOf', :comment =>
      %(prov:mentionOf is used to specialize an entity as described in
        another bundle. It is to be used in conjuction with
        prov:asInBundle. prov:asInBundle is used to cite the Bundle in
        which the generalization was mentioned.)
    property :pairEntity, :label => 'pairKey'
    property :pingback, :label => 'provenance pingback', :comment =>
      %(Relates a resource to a provenance pingback service that may
        receive additional provenance links about the resource.)
    property :qualifiedAssociation, :label => 'qualifiedAssociation', :comment =>
      %(If this Activity prov:wasAssociatedWith Agent :ag, then it can
        qualify the Association using prov:qualifiedAssociation [ a
        prov:Association; prov:agent :ag; :foo :bar ].)
    property :qualifiedAttribution, :label => 'qualifiedAttribution', :comment =>
      %(If this Entity prov:wasAttributedTo Agent :ag, then it can
        qualify how it was influenced using prov:qualifiedAttribution
        [ a prov:Attribution; prov:agent :ag; :foo :bar ].)
    property :qualifiedCommunication, :label => 'qualifiedCommunication', :comment =>
      %(If this Activity prov:wasInformedBy Activity :a, then it can
        qualify how it was influenced using
        prov:qualifiedCommunication [ a prov:Communication;
        prov:activity :a; :foo :bar ].)
    property :qualifiedDelegation, :label => 'qualifiedDelegation', :comment =>
      %(If this Agent prov:actedOnBehalfOf Agent :ag, then it can
        qualify how with prov:qualifiedResponsibility [ a
        prov:Responsibility; prov:agent :ag; :foo :bar ].)
    property :qualifiedDerivation, :label => 'qualifiedDerivation', :comment =>
      %(If this Entity prov:wasDerivedFrom Entity :e, then it can
        qualify how it was derived using prov:qualifiedDerivation [ a
        prov:Derivation; prov:entity :e; :foo :bar ].)
    property :qualifiedEnd, :label => 'qualifiedEnd', :comment =>
      %(If this Activity prov:wasEndedBy Entity :e1, then it can
        qualify how it was ended using prov:qualifiedEnd [ a prov:End;
        prov:entity :e1; :foo :bar ].)
    property :qualifiedGeneration, :label => 'qualifiedGeneration', :comment =>
      %(If this Activity prov:generated Entity :e, then it can qualify
        how it performed the Generation using prov:qualifiedGeneration
        [ a prov:Generation; prov:entity :e; :foo :bar ].)
    property :qualifiedInfluence, :label => 'qualifiedInfluence', :comment =>
      %(Because prov:qualifiedInfluence is a broad relation, the more
        specific relations \(qualifiedCommunication,
        qualifiedDelegation, qualifiedEnd, etc.\) should be used when
        applicable.)
    property :qualifiedInsertion, :label => 'qualifiedInsertion'
    property :qualifiedInvalidation, :label => 'qualifiedInvalidation', :comment =>
      %(If this Entity prov:wasInvalidatedBy Activity :a, then it can
        qualify how it was invalidated using
        prov:qualifiedInvalidation [ a prov:Invalidation;
        prov:activity :a; :foo :bar ].)
    property :qualifiedPrimarySource, :label => 'qualifiedPrimarySource', :comment =>
      %(If this Entity prov:hadPrimarySource Entity :e, then it can
        qualify how using prov:qualifiedPrimarySource [ a
        prov:PrimarySource; prov:entity :e; :foo :bar ].)
    property :qualifiedQuotation, :label => 'qualifiedQuotation', :comment =>
      %(If this Entity prov:wasQuotedFrom Entity :e, then it can
        qualify how using prov:qualifiedQuotation [ a prov:Quotation;
        prov:entity :e; :foo :bar ].)
    property :qualifiedRemoval, :label => 'qualifiedRemoval'
    property :qualifiedRevision, :label => 'qualifiedRevision', :comment =>
      %(If this Entity prov:wasRevisionOf Entity :e, then it can
        qualify how it was revised using prov:qualifiedRevision [ a
        prov:Revision; prov:entity :e; :foo :bar ].)
    property :qualifiedStart, :label => 'qualifiedStart', :comment =>
      %(If this Activity prov:wasStartedBy Entity :e1, then it can
        qualify how it was started using prov:qualifiedStart [ a
        prov:Start; prov:entity :e1; :foo :bar ].)
    property :qualifiedUsage, :label => 'qualifiedUsage', :comment =>
      %(If this Activity prov:used Entity :e, then it can qualify how
        it used it using prov:qualifiedUsage [ a prov:Usage;
        prov:entity :e; :foo :bar ].)
    property :specializationOf, :label => 'specializationOf'
    property :used, :label => 'used', :comment =>
      %(A prov:Entity that was used by this prov:Activity. For
        example, :baking prov:used :spoon, :egg, :oven .)
    property :wasAssociatedWith, :label => 'wasAssociatedWith', :comment =>
      %(An prov:Agent that had some \(unspecified\) responsibility for
        the occurrence of this prov:Activity.)
    property :wasAttributedTo, :label => 'wasAttributedTo', :comment =>
      %(Attribution is the ascribing of an entity to an agent.)
    property :wasDerivedFrom, :label => 'wasDerivedFrom', :comment =>
      %(The more specific subproperties of prov:wasDerivedFrom \(i.e.,
        prov:wasQuotedFrom, prov:wasRevisionOf,
        prov:hadPrimarySource\) should be used when applicable.)
    property :wasEndedBy, :label => 'wasEndedBy', :comment =>
      %(End is when an activity is deemed to have ended. An end may
        refer to an entity, known as trigger, that terminated the
        activity.)
    property :wasGeneratedBy, :label => 'wasGeneratedBy'
    property :wasInfluencedBy, :label => 'wasInfluencedBy', :comment =>
      %(This property has multiple RDFS domains to suit multiple OWL
        Profiles. See <a href="#owl-profile">PROV-O OWL Profile</a>.)
    property :wasInfluencedBy, :label => 'wasInfluencedBy', :comment =>
      %(Because prov:wasInfluencedBy is a broad relation, its more
        specific subproperties \(e.g. prov:wasInformedBy,
        prov:actedOnBehalfOf, prov:wasEndedBy, etc.\) should be used
        when applicable.)
    property :wasInformedBy, :label => 'wasInformedBy', :comment =>
      %(An activity a2 is dependent on or informed by another activity
        a1, by way of some unspecified entity that is generated by a1
        and used by a2.)
    property :wasInvalidatedBy, :label => 'wasInvalidatedBy'
    property :wasQuotedFrom, :label => 'wasQuotedFrom', :comment =>
      %(An entity is derived from an original entity by copying, or
        'quoting', some or all of it.)
    property :wasRevisionOf, :label => 'wasRevisionOf', :comment =>
      %(A revision is a derivation that revises an entity into a
        revised version.)
    property :wasStartedBy, :label => 'wasStartedBy', :comment =>
      %(Start is when an activity is deemed to have started. A start
        may refer to an entity, known as trigger, that initiated the
        activity.)
    property :aq
    property :category, :comment =>
      %(Classify prov-o terms into three categories, including
        'starting-point', 'qualifed', and 'extended'. This
        classification is used by the prov-o html document to gently
        introduce prov-o terms to its users.)
    property :component, :comment =>
      %(Classify prov-o terms into six components according to
        prov-dm, including 'agents-responsibility', 'alternate',
        'annotations', 'collections', 'derivations', and
        'entities-activities'. This classification is used so that
        readers of prov-o specification can find its correspondence
        with the prov-dm specification.)
    property :constraints, :comment =>
      %(A reference to the principal section of the PROV-CONSTRAINTS
        document that describes this concept.)
    property :definition, :comment =>
      %(A definition quoted from PROV-DM or PROV-CONSTRAINTS that
        describes the concept expressed with this OWL term.)
    property :dm, :comment =>
      %(A reference to the principal section of the PROV-DM document
        that describes this concept.)
    property :editorialNote, :comment =>
      %(A note by the OWL development team about how this term
        expresses the PROV-DM concept, or how it should be used in
        context of semantic web or linked data.)
    property :editorsDefinition, :comment =>
      %(When the prov-o term does not have a definition drawn from
        prov-dm, and the prov-o editor provides one.)
    property :inverse, :comment =>
      %(PROV-O does not define all property inverses. The
        directionalities defined in PROV-O should be given preference
        over those not defined. However, if users wish to name the
        inverse of a PROV-O property, the local name given by
        prov:inverse should be used.)
    property :n, :comment =>
      %(A reference to the principal section of the PROV-M document
        that describes this concept.)
    property :n, :comment =>
      %(A reference to the principal section of the PROV-DM document
        that describes this concept.)
    property :order, :comment =>
      %(The position that this OWL term should be listed within
        documentation. The scope of the documentation \(e.g., among
        all terms, among terms within a prov:category, among
        properties applying to a particular class, etc.\) is
        unspecified.)
    property :qualifiedForm, :comment =>
      %(This annotation property links a subproperty of
        prov:wasInfluencedBy with the subclass of prov:Influence and
        the qualifying property that are used to qualify it. Example
        annotation: prov:wasGeneratedBy prov:qualifiedForm
        prov:qualifiedGeneration, prov:Generation . Then this
        unqualified assertion: :entity1 prov:wasGeneratedBy :activity1
        . can be qualified by adding: :entity1
        prov:qualifiedGeneration :entity1Gen . :entity1Gen a
        prov:Generation, prov:Influence; prov:activity :activity1;
        :customValue 1337 . Note how the value of the unqualified
        influence \(prov:wasGeneratedBy :activity1\) is mirrored as
        the value of the prov:activity \(or prov:entity, or
        prov:agent\) property on the influence class.)
    property :sharesDefinitionWith
    property :todo
    property :unqualifiedForm, :comment =>
      %(Classes and properties used to qualify relationships are
        annotated with prov:unqualifiedForm to indicate the property
        used to assert an unqualified provenance relation.)
    property :specializationOf, :label => 'specializationOf'
    property :wasRevisionOf, :label => 'wasRevisionOf', :comment =>
      %(A revision is a derivation that revises an entity into a
        revised version.)
  end
end
