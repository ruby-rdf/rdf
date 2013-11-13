# This file generated automatically using vocab-fetch from http://schema.org/docs/schema_org_rdfa.html
require 'rdf'
module RDF
  class SCHEMA < StrictVocabulary("http://schema.org/")

    # Class definitions
    property :APIReference, :label => 'APIReference', :comment =>
      %(Reference documentation for application programming interfaces
        \(APIs\).)
    property :AboutPage, :label => 'AboutPage', :comment =>
      %(Web page type: About page.)
    property :AcceptAction, :label => 'AcceptAction', :comment =>
      %(The act of committing to/adopting an object.<p>Related
        actions:</p><ul><li><a
        href="http://schema.org/RejectAction">RejectAction</a>: The
        antagonym of AcceptAction.</li></ul>)
    property :AccountingService, :label => 'AccountingService', :comment =>
      %(Accountancy business.)
    property :AchieveAction, :label => 'AchieveAction', :comment =>
      %(The act of accomplishing something via previous efforts. It is
        an instantaneous action rather than an ongoing process.)
    property :Action, :label => 'Action', :comment =>
      %(An action performed by a direct agent and indirect
        participants upon a direct object. Optionally happens at a
        location with the help of an inanimate instrument. The
        execution of the action may produce a result. Specific action
        sub-type documentation specifies the exact expectation of each
        argument/role.)
    property :AddAction, :label => 'AddAction', :comment =>
      %(The act of editing by adding an object to a collection.)
    property :AdministrativeArea, :label => 'AdministrativeArea', :comment =>
      %(A geographical region under the jurisdiction of a particular
        government.)
    property :AdultEntertainment, :label => 'AdultEntertainment', :comment =>
      %(An adult entertainment establishment.)
    property :AggregateOffer, :label => 'AggregateOffer', :comment =>
      %(When a single product that has different offers \(for example,
        the same pair of shoes is offered by different merchants\),
        then AggregateOffer can be used.)
    property :AggregateRating, :label => 'AggregateRating', :comment =>
      %(The average rating based on multiple ratings or reviews.)
    property :AgreeAction, :label => 'AgreeAction', :comment =>
      %(The act of expressing a consistency of opinion with the
        object. An agent agrees to/about an object \(a proposition,
        topic or theme\) with participants.)
    property :Airport, :label => 'Airport', :comment =>
      %(An airport.)
    property :AlignmentObject, :label => 'AlignmentObject', :comment =>
      %(An intangible item that describes an alignment between a
        learning resource and a node in an educational framework.)
    property :AllocateAction, :label => 'AllocateAction', :comment =>
      %(The act of organizing tasks/objects/events by associating
        resources to it.)
    property :AmusementPark, :label => 'AmusementPark', :comment =>
      %(An amusement park.)
    property :AnatomicalStructure, :label => 'AnatomicalStructure', :comment =>
      %(Any part of the human body, typically a component of an
        anatomical system. Organs, tissues, and cells are all
        anatomical structures.)
    property :AnatomicalSystem, :label => 'AnatomicalSystem', :comment =>
      %(An anatomical system is a group of anatomical structures that
        work together to perform a certain task. Anatomical systems,
        such as organ systems, are one organizing principle of
        anatomy, and can includes circulatory, digestive, endocrine,
        integumentary, immune, lymphatic, muscular, nervous,
        reproductive, respiratory, skeletal, urinary, vestibular, and
        other systems.)
    property :AnimalShelter, :label => 'AnimalShelter', :comment =>
      %(Animal shelter.)
    property :ApartmentComplex, :label => 'ApartmentComplex', :comment =>
      %(Residence type: Apartment complex.)
    property :AppendAction, :label => 'AppendAction', :comment =>
      %(The act of inserting at the end if an ordered collection.)
    property :ApplyAction, :label => 'ApplyAction', :comment =>
      %(The act of registering to an organization/service without the
        guarantee to receive it. NOTE\(goto\): should this be under
        InteractAction instead?<p>Related actions:</p><ul><li><a
        href="http://schema.org/RegisterAction">RegisterAction</a>:
        Unlike RegisterAction, ApplyAction has no guarantees that the
        application will be accepted.</li></ul>)
    property :ApprovedIndication, :label => 'ApprovedIndication', :comment =>
      %(An indication for a medical therapy that has been formally
        specified or approved by a regulatory body that regulates use
        of the therapy; for example, the US FDA approves indications
        for most drugs in the US.)
    property :Aquarium, :label => 'Aquarium', :comment =>
      %(Aquarium.)
    property :ArriveAction, :label => 'ArriveAction', :comment =>
      %(The act of arriving at a place. An agent arrives at a
        destination from an fromLocation, optionally with
        participants.)
    property :ArtGallery, :label => 'ArtGallery', :comment =>
      %(An art gallery.)
    property :Artery, :label => 'Artery', :comment =>
      %(A type of blood vessel that specifically carries blood away
        from the heart.)
    property :Article, :label => 'Article', :comment =>
      %(An article, such as a news article or piece of investigative
        report. Newspapers and magazines have articles of many
        different types and this is intended to cover them all.)
    property :AskAction, :label => 'AskAction', :comment =>
      %(The act of posing a question / favor to someone.<p>Related
        actions:</p><ul><li><a
        href="http://schema.org/ReplyAction">ReplyAction</a>: Appears
        generally as a response to AskAction.</li></ul>)
    property :AssessAction, :label => 'AssessAction', :comment =>
      %(The act of forming one's opinion, reaction or sentiment.)
    property :AssignAction, :label => 'AssignAction', :comment =>
      %(The act of allocating an action/event/task to some destination
        \(someone or something\).)
    property :Attorney, :label => 'Attorney', :comment =>
      %(Professional service: Attorney.)
    property :Audience, :label => 'Audience', :comment =>
      %(Intended audience for an item, i.e. the group for whom the
        item was created.)
    property :AudioObject, :label => 'AudioObject', :comment =>
      %(An audio file.)
    property :AuthorizeAction, :label => 'AuthorizeAction', :comment =>
      %(The act of granting permission to an object.)
    property :AutoBodyShop, :label => 'AutoBodyShop', :comment =>
      %(Auto body shop.)
    property :AutoDealer, :label => 'AutoDealer', :comment =>
      %(An car dealership.)
    property :AutoPartsStore, :label => 'AutoPartsStore', :comment =>
      %(An auto parts store.)
    property :AutoRental, :label => 'AutoRental', :comment =>
      %(A car rental business.)
    property :AutoRepair, :label => 'AutoRepair', :comment =>
      %(Car repair business.)
    property :AutoWash, :label => 'AutoWash', :comment =>
      %(A car wash business.)
    property :AutomatedTeller, :label => 'AutomatedTeller', :comment =>
      %(ATM/cash machine.)
    property :AutomotiveBusiness, :label => 'AutomotiveBusiness', :comment =>
      %(Car repair, sales, or parts.)
    property :Bakery, :label => 'Bakery', :comment =>
      %(A bakery.)
    property :BankOrCreditUnion, :label => 'BankOrCreditUnion', :comment =>
      %(Bank or credit union.)
    property :BarOrPub, :label => 'BarOrPub', :comment =>
      %(A bar or pub.)
    property :Beach, :label => 'Beach', :comment =>
      %(Beach.)
    property :BeautySalon, :label => 'BeautySalon', :comment =>
      %(Beauty salon.)
    property :BedAndBreakfast, :label => 'BedAndBreakfast', :comment =>
      %(Bed and breakfast.)
    property :BefriendAction, :label => 'BefriendAction', :comment =>
      %(The act of forming a personal connection with someone
        \(object\) mutually/bidirectionally/symmetrically.<p>Related
        actions:</p><ul><li><a
        href="http://schema.org/FollowAction">FollowAction</a>: Unlike
        FollowAction, BefriendAction implies that the connection is
        reciprocal.</li></ul>)
    property :BikeStore, :label => 'BikeStore', :comment =>
      %(A bike store.)
    property :Blog, :label => 'Blog', :comment =>
      %(A blog)
    property :BlogPosting, :label => 'BlogPosting', :comment =>
      %(A blog post.)
    property :BloodTest, :label => 'BloodTest', :comment =>
      %(A medical test performed on a sample of a patient's blood.)
    property :BodyOfWater, :label => 'BodyOfWater', :comment =>
      %(A body of water, such as a sea, ocean, or lake.)
    property :Bone, :label => 'Bone', :comment =>
      %(Rigid connective tissue that comprises up the skeletal
        structure of the human body.)
    property :Book, :label => 'Book', :comment =>
      %(A book.)
    property :BookFormatType, :label => 'BookFormatType', :comment =>
      %(The publication format of the book.)
    property :BookStore, :label => 'BookStore', :comment =>
      %(A bookstore.)
    property :BookmarkAction, :label => 'BookmarkAction', :comment =>
      %(An agent bookmarks/flags/labels/tags/marks an object.)
    property :Boolean, :label => 'Boolean', :comment =>
      %(Boolean: True or False.)
    property :BorrowAction, :label => 'BorrowAction', :comment =>
      %(The act of obtaining an object under an agreement to return it
        at a later date. Reciprocal of LendAction.<p>Related
        actions:</p><ul><li><a
        href="http://schema.org/LendAction">LendAction</a>: Reciprocal
        of BorrowAction.</li></ul>)
    property :BowlingAlley, :label => 'BowlingAlley', :comment =>
      %(A bowling alley.)
    property :BrainStructure, :label => 'BrainStructure', :comment =>
      %(Any anatomical structure which pertains to the soft nervous
        tissue functioning as the coordinating center of sensation and
        intellectual and nervous activity.)
    property :Brand, :label => 'Brand', :comment =>
      %(A brand is a name used by an organization or business person
        for labeling a product, product group, or similar.)
    property :Brewery, :label => 'Brewery', :comment =>
      %(Brewery.)
    property :BuddhistTemple, :label => 'BuddhistTemple', :comment =>
      %(A Buddhist temple.)
    property :BusStation, :label => 'BusStation', :comment =>
      %(A bus station.)
    property :BusStop, :label => 'BusStop', :comment =>
      %(A bus stop.)
    property :BusinessEntityType, :label => 'BusinessEntityType', :comment =>
      %(A business entity type is a conceptual entity representing the
        legal form, the size, the main line of business, the position
        in the value chain, or any combination thereof, of an
        organization or business person. Commonly used values:
        http://purl.org/goodrelations/v1#Business
        http://purl.org/goodrelations/v1#Enduser
        http://purl.org/goodrelations/v1#PublicInstitution
        http://purl.org/goodrelations/v1#Reseller)
    property :BusinessEvent, :label => 'BusinessEvent', :comment =>
      %(Event type: Business event.)
    property :BusinessFunction, :label => 'BusinessFunction', :comment =>
      %(The business function specifies the type of activity or access
        \(i.e., the bundle of rights\) offered by the organization or
        business person through the offer. Typical are sell, rental or
        lease, maintenance or repair, manufacture / produce, recycle /
        dispose, engineering / construction, or installation.
        Proprietary specifications of access rights are also instances
        of this class. Commonly used values:
        http://purl.org/goodrelations/v1#ConstructionInstallation
        http://purl.org/goodrelations/v1#Dispose
        http://purl.org/goodrelations/v1#LeaseOut
        http://purl.org/goodrelations/v1#Maintain
        http://purl.org/goodrelations/v1#ProvideService
        http://purl.org/goodrelations/v1#Repair
        http://purl.org/goodrelations/v1#Sell
        http://purl.org/goodrelations/v1#Buy)
    property :BuyAction, :label => 'BuyAction', :comment =>
      %(The act of giving money to a seller in exchange for goods or
        services rendered. An agent buys an object, product, or
        service from a seller for a price. Reciprocal of SellAction.)
    property :CafeOrCoffeeShop, :label => 'CafeOrCoffeeShop', :comment =>
      %(A cafe or coffee shop.)
    property :Campground, :label => 'Campground', :comment =>
      %(A campground.)
    property :Canal, :label => 'Canal', :comment =>
      %(A canal, like the Panama Canal)
    property :CancelAction, :label => 'CancelAction', :comment =>
      %(The act of asserting that a future event/action is no longer
        going to happen.<p>Related actions:</p><ul><li><a
        href="http://schema.org/ConfirmAction">ConfirmAction</a>: The
        antagonym of CancelAction.</li></ul>)
    property :Casino, :label => 'Casino', :comment =>
      %(A casino.)
    property :CatholicChurch, :label => 'CatholicChurch', :comment =>
      %(A Catholic church.)
    property :Cemetery, :label => 'Cemetery', :comment =>
      %(A graveyard.)
    property :CheckAction, :label => 'CheckAction', :comment =>
      %(An agent inspects/determines/investigates/inquire or examine
        an object's accuracy/quality/condition or state.)
    property :CheckInAction, :label => 'CheckInAction', :comment =>
      %(The act of an agent communicating \(service provider, social
        media, etc\) their arrival by registering/confirming for a
        previously reserved service \(e.g. flight check in\) or at a
        place \(e.g. hotel\), possibly resulting in a result
        \(boarding pass, etc\).<p>Related actions:</p><ul><li><a
        href="http://schema.org/CheckOutAction">CheckOutAction</a>:
        The antagonym of CheckInAction.</li><li><a
        href="http://schema.org/ArriveAction">ArriveAction</a>: Unlike
        ArriveAction, CheckInAction implies that the agent is
        informing/confirming the start of a previously reserved
        service.</li><li><a
        href="http://schema.org/ConfirmAction">ConfirmAction</a>:
        Unlike ConfirmAction, CheckInAction implies that the agent is
        informing/confirming the *start* of a previously reserved
        service rather than its validity/existance.</li></ul>)
    property :CheckOutAction, :label => 'CheckOutAction', :comment =>
      %(The act of an agent communicating \(service provider, social
        media, etc\) their departure of a previously reserved service
        \(e.g. flight check in\) or place \(e.g. hotel\).<p>Related
        actions:</p><ul><li><a
        href="http://schema.org/CheckInAction">CheckInAction</a>: The
        antagonym of CheckOutAction.</li><li><a
        href="http://schema.org/DepartAction">DepartAction</a>: Unlike
        DepartAction, CheckOutAction implies that the agent is
        informing/confirming the end of a previously reserved
        service.</li><li><a
        href="http://schema.org/CancelAction">CancelAction</a>: Unlike
        CancelAction, CheckOutAction implies that the agent is
        informing/confirming the end of a previously reserved
        service.</li></ul>)
    property :CheckoutPage, :label => 'CheckoutPage', :comment =>
      %(Web page type: Checkout page.)
    property :ChildCare, :label => 'ChildCare', :comment =>
      %(A Childcare center.)
    property :ChildrensEvent, :label => 'ChildrensEvent', :comment =>
      %(Event type: Children's event.)
    property :ChooseAction, :label => 'ChooseAction', :comment =>
      %(The act of expressing a preference from a set of options or a
        large or unbounded set of choices/options.)
    property :Church, :label => 'Church', :comment =>
      %(A church.)
    property :City, :label => 'City', :comment =>
      %(A city or town.)
    property :CityHall, :label => 'CityHall', :comment =>
      %(A city hall.)
    property :CivicStructure, :label => 'CivicStructure', :comment =>
      %(A public structure, such as a town hall or concert hall.)
    property :Class, :label => 'Class', :comment =>
      %(A class, also often called a 'Type'; equivalent to rdfs:Class.)
    property :ClothingStore, :label => 'ClothingStore', :comment =>
      %(A clothing store.)
    property :Code, :label => 'Code', :comment =>
      %(Computer programming source code. Example: Full \(compile
        ready\) solutions, code snippet samples, scripts, templates.)
    property :CollectionPage, :label => 'CollectionPage', :comment =>
      %(Web page type: Collection page.)
    property :CollegeOrUniversity, :label => 'CollegeOrUniversity', :comment =>
      %(A college, university, or other third-level educational
        institution.)
    property :ComedyClub, :label => 'ComedyClub', :comment =>
      %(A comedy club.)
    property :ComedyEvent, :label => 'ComedyEvent', :comment =>
      %(Event type: Comedy event.)
    property :Comment, :label => 'Comment', :comment =>
      %(A comment on an item - for example, a comment on a blog post.
        The comment's content is expressed via the "text" property,
        and its topic via "about", properties shared with all
        CreativeWorks.)
    property :CommentAction, :label => 'CommentAction', :comment =>
      %(The act of generating a comment about a subject.)
    property :CommunicateAction, :label => 'CommunicateAction', :comment =>
      %(The act of conveying information to another person via a
        communication medium \(instrument\) such as speech, email, or
        telephone conversation.)
    property :ComputerStore, :label => 'ComputerStore', :comment =>
      %(A computer store.)
    property :ConfirmAction, :label => 'ConfirmAction', :comment =>
      %(The act of notifying someone that a future event/action is
        going to happen as expected.<p>Related actions:</p><ul><li><a
        href="http://schema.org/CancelAction">CancelAction</a>: The
        antagonym of ConfirmAction.</li></ul>)
    property :ConsumeAction, :label => 'ConsumeAction', :comment =>
      %(The act of ingesting information/resources/food.)
    property :ContactPage, :label => 'ContactPage', :comment =>
      %(Web page type: Contact page.)
    property :ContactPoint, :label => 'ContactPoint', :comment =>
      %(A contact point&#x2014;for example, a Customer Complaints
        department.)
    property :Continent, :label => 'Continent', :comment =>
      %(One of the continents \(for example, Europe or Africa\).)
    property :ConvenienceStore, :label => 'ConvenienceStore', :comment =>
      %(A convenience store.)
    property :CookAction, :label => 'CookAction', :comment =>
      %(The act of producing/preparing food.)
    property :Corporation, :label => 'Corporation', :comment =>
      %(Organization: A business corporation.)
    property :Country, :label => 'Country', :comment =>
      %(A country.)
    property :Courthouse, :label => 'Courthouse', :comment =>
      %(A courthouse.)
    property :CreateAction, :label => 'CreateAction', :comment =>
      %(The act of deliberately creating/producing/generating/building
        a result out of the agent.)
    property :CreativeWork, :label => 'CreativeWork', :comment =>
      %(The most generic kind of creative work, including books,
        movies, photographs, software programs, etc.)
    property :CreditCard, :label => 'CreditCard', :comment =>
      %(A credit or debit card type as a standardized procedure for
        transferring the monetary amount for a purchase. Commonly used
        values: http://purl.org/goodrelations/v1#AmericanExpress
        http://purl.org/goodrelations/v1#DinersClub
        http://purl.org/goodrelations/v1#Discover
        http://purl.org/goodrelations/v1#JCB
        http://purl.org/goodrelations/v1#MasterCard
        http://purl.org/goodrelations/v1#VISA)
    property :Crematorium, :label => 'Crematorium', :comment =>
      %(A crematorium.)
    property :DDxElement, :label => 'DDxElement', :comment =>
      %(An alternative, closely-related condition typically considered
        later in the differential diagnosis process along with the
        signs that are used to distinguish it.)
    property :DanceEvent, :label => 'DanceEvent', :comment =>
      %(Event type: A social dance.)
    property :DanceGroup, :label => 'DanceGroup', :comment =>
      %(A dance group&#x2014;for example, the Alvin Ailey Dance
        Theater or Riverdance.)
    property :DataCatalog, :label => 'DataCatalog', :comment =>
      %(A collection of datasets.)
    property :DataDownload, :label => 'DataDownload', :comment =>
      %(A dataset in downloadable form.)
    property :DataType, :label => 'DataType', :comment =>
      %(The basic data types such as Integers, Strings, etc.)
    property :Dataset, :label => 'Dataset', :comment =>
      %(A body of structured information describing some topic\(s\) of
        interest.)
    property :Date, :label => 'Date', :comment =>
      %(A date value in <a
        href='http://en.wikipedia.org/wiki/ISO_8601'>ISO 8601 date
        format</a>.)
    property :DateTime, :label => 'DateTime', :comment =>
      %(A combination of date and time of day in the form
        [-]CCYY-MM-DDThh:mm:ss[Z|\(+|-\)hh:mm] \(see Chapter 5.4 of
        ISO 8601\).)
    property :DayOfWeek, :label => 'DayOfWeek', :comment =>
      %(The day of the week, e.g. used to specify to which day the
        opening hours of an OpeningHoursSpecification refer. Commonly
        used values: http://purl.org/goodrelations/v1#Monday
        http://purl.org/goodrelations/v1#Tuesday
        http://purl.org/goodrelations/v1#Wednesday
        http://purl.org/goodrelations/v1#Thursday
        http://purl.org/goodrelations/v1#Friday
        http://purl.org/goodrelations/v1#Saturday
        http://purl.org/goodrelations/v1#Sunday
        http://purl.org/goodrelations/v1#PublicHolidays)
    property :DaySpa, :label => 'DaySpa', :comment =>
      %(A day spa.)
    property :DefenceEstablishment, :label => 'DefenceEstablishment', :comment =>
      %(A defence establishment, such as an army or navy base.)
    property :DeleteAction, :label => 'DeleteAction', :comment =>
      %(The act of editing a recipient by removing one of its objects.)
    property :DeliveryChargeSpecification, :label => 'DeliveryChargeSpecification', :comment =>
      %(The price for the delivery of an offer using a particular
        delivery method.)
    property :DeliveryMethod, :label => 'DeliveryMethod', :comment =>
      %(A delivery method is a standardized procedure for transferring
        the product or service to the destination of fulfilment chosen
        by the customer. Delivery methods are characterized by the
        means of transportation used, and by the organization or group
        that is the contracting party for the sending organization or
        person. Commonly used values:
        http://purl.org/goodrelations/v1#DeliveryModeDirectDownload
        http://purl.org/goodrelations/v1#DeliveryModeFreight
        http://purl.org/goodrelations/v1#DeliveryModeMail
        http://purl.org/goodrelations/v1#DeliveryModeOwnFleet
        http://purl.org/goodrelations/v1#DeliveryModePickUp
        http://purl.org/goodrelations/v1#DHL
        http://purl.org/goodrelations/v1#FederalExpress
        http://purl.org/goodrelations/v1#UPS)
    property :Demand, :label => 'Demand', :comment =>
      %(A demand entity represents the public, not necessarily
        binding, not necessarily exclusive, announcement by an
        organization or person to seek a certain type of goods or
        services. For describing demand using this type, the very same
        properties used for Offer apply.)
    property :Dentist, :label => 'Dentist', :comment =>
      %(A dentist.)
    property :DepartAction, :label => 'DepartAction', :comment =>
      %(The act of departing from a place. An agent departs from an
        fromLocation for a destination, optionally with participants.)
    property :DepartmentStore, :label => 'DepartmentStore', :comment =>
      %(A department store.)
    property :DiagnosticLab, :label => 'DiagnosticLab', :comment =>
      %(A medical laboratory that offers on-site or off-site
        diagnostic services.)
    property :DiagnosticProcedure, :label => 'DiagnosticProcedure', :comment =>
      %(A medical procedure intended primarly for diagnostic, as
        opposed to therapeutic, purposes.)
    property :Diet, :label => 'Diet', :comment =>
      %(A strategy of regulating the intake of food to achieve or
        maintain a specific health-related goal.)
    property :DietarySupplement, :label => 'DietarySupplement', :comment =>
      %(A product taken by mouth that contains a dietary ingredient
        intended to supplement the diet. Dietary ingredients may
        include vitamins, minerals, herbs or other botanicals, amino
        acids, and substances such as enzymes, organ tissues,
        glandulars and metabolites.)
    property :DisagreeAction, :label => 'DisagreeAction', :comment =>
      %(The act of expressing a difference of opinion with the object.
        An agent disagrees to/about an object \(a proposition, topic
        or theme\) with participants.)
    property :DiscoverAction, :label => 'DiscoverAction', :comment =>
      %(The act of discovering/finding an object.)
    property :DislikeAction, :label => 'DislikeAction', :comment =>
      %(The act of expressing a negative sentiment about the object.
        An agent dislikes an object \(a proposition, topic or theme\)
        with participants.)
    property :Distance, :label => 'Distance', :comment =>
      %(Properties that take Distances as values are of the form
        '&lt;Number&gt; &lt;Length unit of measure&gt;'. E.g., '7 ft')
    property :DonateAction, :label => 'DonateAction', :comment =>
      %(The act of providing goods, services, or money without
        compensation, often for philanthropic reasons.)
    property :DoseSchedule, :label => 'DoseSchedule', :comment =>
      %(A specific dosing schedule for a drug or supplement.)
    property :DownloadAction, :label => 'DownloadAction', :comment =>
      %(The act of downloading an object.)
    property :DrawAction, :label => 'DrawAction', :comment =>
      %(The act of producing a visual/graphical representation of an
        object, typically with a pen/pencil and paper as instruments.)
    property :DrinkAction, :label => 'DrinkAction', :comment =>
      %(The act of swallowing liquids.)
    property :Drug, :label => 'Drug', :comment =>
      %(A chemical or biologic substance, used as a medical therapy,
        that has a physiological effect on an organism.)
    property :DrugClass, :label => 'DrugClass', :comment =>
      %(A class of medical drugs, e.g., statins. Classes can represent
        general pharmacological class, common mechanisms of action,
        common physiological effects, etc.)
    property :DrugCost, :label => 'DrugCost', :comment =>
      %(The cost per unit of a medical drug. Note that this type is
        not meant to represent the price in an offer of a drug for
        sale; see the Offer type for that. This type will typically be
        used to tag wholesale or average retail cost of a drug, or
        maximum reimbursable cost. Costs of medical drugs vary widely
        depending on how and where they are paid for, so while this
        type captures some of the variables, costs should be used with
        caution by consumers of this schema's markup.)
    property :DrugCostCategory, :label => 'DrugCostCategory', :comment =>
      %(Enumerated categories of medical drug costs.)
    property :DrugLegalStatus, :label => 'DrugLegalStatus', :comment =>
      %(The legal availability status of a medical drug.)
    property :DrugPregnancyCategory, :label => 'DrugPregnancyCategory', :comment =>
      %(Categories that represent an assessment of the risk of fetal
        injury due to a drug or pharmaceutical used as directed by the
        mother during pregnancy.)
    property :DrugPrescriptionStatus, :label => 'DrugPrescriptionStatus', :comment =>
      %(Indicates whether this drug is available by prescription or
        over-the-counter.)
    property :DrugStrength, :label => 'DrugStrength', :comment =>
      %(A specific strength in which a medical drug is available in a
        specific country.)
    property :DryCleaningOrLaundry, :label => 'DryCleaningOrLaundry', :comment =>
      %(A dry-cleaning business.)
    property :Duration, :label => 'Duration', :comment =>
      %(Quantity: Duration \(use <a
        href='http://en.wikipedia.org/wiki/ISO_8601'>ISO 8601 duration
        format</a>\).)
    property :EatAction, :label => 'EatAction', :comment =>
      %(The act of swallowing solid objects.)
    property :EducationEvent, :label => 'EducationEvent', :comment =>
      %(Event type: Education event.)
    property :EducationalAudience, :label => 'EducationalAudience', :comment =>
      %(An EducationalAudience)
    property :EducationalOrganization, :label => 'EducationalOrganization', :comment =>
      %(An educational organization.)
    property :Electrician, :label => 'Electrician', :comment =>
      %(An electrician.)
    property :ElectronicsStore, :label => 'ElectronicsStore', :comment =>
      %(An electronics store.)
    property :ElementarySchool, :label => 'ElementarySchool', :comment =>
      %(An elementary school.)
    property :Embassy, :label => 'Embassy', :comment =>
      %(An embassy.)
    property :EmergencyService, :label => 'EmergencyService', :comment =>
      %(An emergency service, such as a fire station or ER.)
    property :EmploymentAgency, :label => 'EmploymentAgency', :comment =>
      %(An employment agency.)
    property :EndorseAction, :label => 'EndorseAction', :comment =>
      %(An agent approves/certifies/likes/supports/sanction an object.)
    property :Energy, :label => 'Energy', :comment =>
      %(Properties that take Enerygy as values are of the form
        '&lt;Number&gt; &lt;Energy unit of measure&gt;')
    property :EntertainmentBusiness, :label => 'EntertainmentBusiness', :comment =>
      %(A business providing entertainment.)
    property :Enumeration, :label => 'Enumeration', :comment =>
      %(Lists or enumerations&#x2014;for example, a list of cuisines
        or music genres, etc.)
    property :Event, :label => 'Event', :comment =>
      %(An event happening at a certain time at a certain location.)
    property :EventVenue, :label => 'EventVenue', :comment =>
      %(An event venue.)
    property :ExerciseAction, :label => 'ExerciseAction', :comment =>
      %(The act of participating in exertive activity for the purposes
        of improving health and fitness)
    property :ExerciseGym, :label => 'ExerciseGym', :comment =>
      %(A gym.)
    property :ExercisePlan, :label => 'ExercisePlan', :comment =>
      %(Fitness-related activity designed for a specific
        health-related purpose, including defined exercise routines as
        well as activity prescribed by a clinician.)
    property :FastFoodRestaurant, :label => 'FastFoodRestaurant', :comment =>
      %(A fast-food restaurant.)
    property :Festival, :label => 'Festival', :comment =>
      %(Event type: Festival.)
    property :FilmAction, :label => 'FilmAction', :comment =>
      %(The act of capturing sound and moving images on film, video,
        or digitally.)
    property :FinancialService, :label => 'FinancialService', :comment =>
      %(Financial services business.)
    property :FindAction, :label => 'FindAction', :comment =>
      %(The act of finding an object.<p>Related actions:</p><ul><li><a
        href="http://schema.org/SearchAction">SearchAction</a>:
        FindAction is generally lead by a SearchAction, but not
        necessarily.</li></ul>)
    property :FireStation, :label => 'FireStation', :comment =>
      %(A fire station. With firemen.)
    property :Float, :label => 'Float', :comment =>
      %(Data type: Floating number.)
    property :Florist, :label => 'Florist', :comment =>
      %(A florist.)
    property :FollowAction, :label => 'FollowAction', :comment =>
      %(The act of forming a personal connection with
        someone/something \(object\) unidirectionally/asymmetrically
        to get updates polled from.<p>Related actions:</p><ul><li><a
        href="http://schema.org/BefriendAction">BefriendAction</a>:
        Unlike BefriendAction, FollowAction implies that the
        connection is *not* necessarily reciprocal.</li><li><a
        href="http://schema.org/SubscribeAction">SubscribeAction</a>:
        Unlike SubscribeAction, FollowAction implies that the follower
        acts as an active agent constantly/actively polling for
        updates.</li><li><a
        href="http://schema.org/RegisterAction">RegisterAction</a>:
        Unlike RegisterAction, FollowAction implies that the agent is
        interested in continuing receiving updates from the
        object.</li><li><a
        href="http://schema.org/JoinAction">JoinAction</a>: Unlike
        JoinAction, FollowAction implies that the agent is interested
        in getting updates from the object.</li><li><a
        href="http://schema.org/TrackAction">TrackAction</a>: Unlike
        TrackAction, FollowAction refers to the polling of updates of
        all aspects of animate objects rather than the location of
        inanimate objects \(e.g. you track a package, but you don't
        follow it\).</li></ul>)
    property :FoodEstablishment, :label => 'FoodEstablishment', :comment =>
      %(A food-related business.)
    property :FoodEvent, :label => 'FoodEvent', :comment =>
      %(Event type: Food event.)
    property :FurnitureStore, :label => 'FurnitureStore', :comment =>
      %(A furniture store.)
    property :GardenStore, :label => 'GardenStore', :comment =>
      %(A garden store.)
    property :GasStation, :label => 'GasStation', :comment =>
      %(A gas station.)
    property :GatedResidenceCommunity, :label => 'GatedResidenceCommunity', :comment =>
      %(Residence type: Gated community.)
    property :GeneralContractor, :label => 'GeneralContractor', :comment =>
      %(A general contractor.)
    property :GeoCoordinates, :label => 'GeoCoordinates', :comment =>
      %(The geographic coordinates of a place or event.)
    property :GeoShape, :label => 'GeoShape', :comment =>
      %(The geographic shape of a place.)
    property :GiveAction, :label => 'GiveAction', :comment =>
      %(The act of transferring ownership of an object to a
        destination. Reciprocal of TakeAction.<p>Related
        actions:</p><ul><li><a
        href="http://schema.org/TakeAction">TakeAction</a>: Reciprocal
        of GiveAction.</li><li><a
        href="http://schema.org/SendAction">SendAction</a>: Unlike
        SendAction, GiveAction implies that ownership is being
        transferred \(e.g. I may send my laptop to you, but that
        doesn't mean I'm giving it to you\).</li></ul>)
    property :GolfCourse, :label => 'GolfCourse', :comment =>
      %(A golf course.)
    property :GovernmentBuilding, :label => 'GovernmentBuilding', :comment =>
      %(A government building.)
    property :GovernmentOffice, :label => 'GovernmentOffice', :comment =>
      %(A government office&#x2014;for example, an IRS or DMV office.)
    property :GovernmentOrganization, :label => 'GovernmentOrganization', :comment =>
      %(A governmental organization or agency.)
    property :GroceryStore, :label => 'GroceryStore', :comment =>
      %(A grocery store.)
    property :HVACBusiness, :label => 'HVACBusiness', :comment =>
      %(An HVAC service.)
    property :HairSalon, :label => 'HairSalon', :comment =>
      %(A hair salon.)
    property :HardwareStore, :label => 'HardwareStore', :comment =>
      %(A hardware store.)
    property :HealthAndBeautyBusiness, :label => 'HealthAndBeautyBusiness', :comment =>
      %(Health and beauty.)
    property :HealthClub, :label => 'HealthClub', :comment =>
      %(A health club.)
    property :HighSchool, :label => 'HighSchool', :comment =>
      %(A high school.)
    property :HinduTemple, :label => 'HinduTemple', :comment =>
      %(A Hindu temple.)
    property :HobbyShop, :label => 'HobbyShop', :comment =>
      %(A hobby store.)
    property :HomeAndConstructionBusiness, :label => 'HomeAndConstructionBusiness', :comment =>
      %(A construction business.)
    property :HomeGoodsStore, :label => 'HomeGoodsStore', :comment =>
      %(A home goods store.)
    property :Hospital, :label => 'Hospital', :comment =>
      %(A hospital.)
    property :Hostel, :label => 'Hostel', :comment =>
      %(A hostel.)
    property :Hotel, :label => 'Hotel', :comment =>
      %(A hotel.)
    property :HousePainter, :label => 'HousePainter', :comment =>
      %(A house painting service.)
    property :IceCreamShop, :label => 'IceCreamShop', :comment =>
      %(An ice cream shop)
    property :IgnoreAction, :label => 'IgnoreAction', :comment =>
      %(The act of intentionally disregarding the object. An agent
        ignores an object.)
    property :ImageGallery, :label => 'ImageGallery', :comment =>
      %(Web page type: Image gallery page.)
    property :ImageObject, :label => 'ImageObject', :comment =>
      %(An image file.)
    property :ImagingTest, :label => 'ImagingTest', :comment =>
      %(Any medical imaging modality typically used for diagnostic
        purposes.)
    property :IndividualProduct, :label => 'IndividualProduct', :comment =>
      %(A single, identifiable product instance \(e.g. a laptop with a
        particular serial number\).)
    property :InfectiousAgentClass, :label => 'InfectiousAgentClass', :comment =>
      %(Classes of agents or pathogens that transmit infectious
        diseases. Enumerated type.)
    property :InfectiousDisease, :label => 'InfectiousDisease', :comment =>
      %(An infectious disease is a clinically evident human disease
        resulting from the presence of pathogenic microbial agents,
        like pathogenic viruses, pathogenic bacteria, fungi, protozoa,
        multicellular parasites, and prions. To be considered an
        infectious disease, such pathogens are known to be able to
        cause this disease.)
    property :InformAction, :label => 'InformAction', :comment =>
      %(The act of notifying someone of information pertinent to them,
        with no expectation of a response.)
    property :InsertAction, :label => 'InsertAction', :comment =>
      %(The act of adding at a specific location in an ordered
        collection.)
    property :InstallAction, :label => 'InstallAction', :comment =>
      %(The act of installing an application.)
    property :InsuranceAgency, :label => 'InsuranceAgency', :comment =>
      %(Insurance agency.)
    property :Intangible, :label => 'Intangible', :comment =>
      %(A utility class that serves as the umbrella for a number of
        'intangible' things such as quantities, structured values,
        etc.)
    property :Integer, :label => 'Integer', :comment =>
      %(Data type: Integer.)
    property :InteractAction, :label => 'InteractAction', :comment =>
      %(The act of interacting with another person or organization.)
    property :InternetCafe, :label => 'InternetCafe', :comment =>
      %(An internet cafe.)
    property :InviteAction, :label => 'InviteAction', :comment =>
      %(The act of asking someone to attend an event. Reciprocal of
        RsvpAction.)
    property :ItemAvailability, :label => 'ItemAvailability', :comment =>
      %(A list of possible product availablity options.)
    property :ItemList, :label => 'ItemList', :comment =>
      %(A list of items of any sort&#x2014;for example, Top 10 Movies
        About Weathermen, or Top 100 Party Songs. Not to be confused
        with HTML lists, which are often used only for formatting.)
    property :ItemPage, :label => 'ItemPage', :comment =>
      %(A page devoted to a single item, such as a particular product
        or hotel.)
    property :JewelryStore, :label => 'JewelryStore', :comment =>
      %(A jewelry store.)
    property :JobPosting, :label => 'JobPosting', :comment =>
      %(A listing that describes a job opening in a certain
        organization.)
    property :JoinAction, :label => 'JoinAction', :comment =>
      %(An agent joins an event/group with participants/friends at a
        location.<p>Related actions:</p><ul><li><a
        href="http://schema.org/RegisterAction">RegisterAction</a>:
        Unlike RegisterAction, JoinAction refers to joining a
        group/team of people.</li><li><a
        href="http://schema.org/SubscribeAction">SubscribeAction</a>:
        Unlike SubscribeAction, JoinAction does not imply that you'll
        be receiving updates.</li><li><a
        href="http://schema.org/FollowAction">FollowAction</a>: Unlike
        FollowAction, JoinAction does not imply that you'll be polling
        for updates.</li></ul>)
    property :Joint, :label => 'Joint', :comment =>
      %(The anatomical location at which two or more bones make
        contact.)
    property :LakeBodyOfWater, :label => 'LakeBodyOfWater', :comment =>
      %(A lake \(for example, Lake Pontrachain\).)
    property :Landform, :label => 'Landform', :comment =>
      %(A landform or physical feature. Landform elements include
        mountains, plains, lakes, rivers, seascape and oceanic
        waterbody interface features such as bays, peninsulas, seas
        and so forth, including sub-aqueous terrain features such as
        submersed mountain ranges, volcanoes, and the great ocean
        basins.)
    property :LandmarksOrHistoricalBuildings, :label => 'LandmarksOrHistoricalBuildings', :comment =>
      %(An historical landmark or building.)
    property :Language, :label => 'Language', :comment =>
      %(Natural languages such as Spanish, Tamil, Hindi, English, etc.
        and programming languages such as Scheme and Lisp.)
    property :LeaveAction, :label => 'LeaveAction', :comment =>
      %(An agent leaves an event / group with participants/friends at
        a location.<p>Related actions:</p><ul><li><a
        href="http://schema.org/JoinAction">JoinAction</a>: The
        antagonym of LeaveAction.</li><li><a
        href="http://schema.org/UnRegisterAction">UnRegisterAction</a>:
        Unlike UnRegisterAction, LeaveAction implies leaving a
        group/team of people rather than a service.</li></ul>)
    property :LegislativeBuilding, :label => 'LegislativeBuilding', :comment =>
      %(A legislative building&#x2014;for example, the state capitol.)
    property :LendAction, :label => 'LendAction', :comment =>
      %(The act of providing an object under an agreement that it will
        be returned at a later date. Reciprocal of
        BorrowAction.<p>Related actions:</p><ul><li><a
        href="http://schema.org/BorrowAction">BorrowAction</a>:
        Reciprocal of LendAction.</li></ul>)
    property :Library, :label => 'Library', :comment =>
      %(A library.)
    property :LifestyleModification, :label => 'LifestyleModification', :comment =>
      %(A process of care involving exercise, changes to diet, fitness
        routines, and other lifestyle changes aimed at improving a
        health condition.)
    property :Ligament, :label => 'Ligament', :comment =>
      %(A short band of tough, flexible, fibrous connective tissue
        that functions to connect multiple bones, cartilages, and
        structurally support joints.)
    property :LikeAction, :label => 'LikeAction', :comment =>
      %(The act of expressing a positive sentiment about the object.
        An agent likes an object \(a proposition, topic or theme\)
        with participants.)
    property :LiquorStore, :label => 'LiquorStore', :comment =>
      %(A liquor store.)
    property :ListenAction, :label => 'ListenAction', :comment =>
      %(The act of consuming audio content.)
    property :LiteraryEvent, :label => 'LiteraryEvent', :comment =>
      %(Event type: Literary event.)
    property :LocalBusiness, :label => 'LocalBusiness', :comment =>
      %(A particular physical business or branch of an organization.
        Examples of LocalBusiness include a restaurant, a particular
        branch of a restaurant chain, a branch of a bank, a medical
        practice, a club, a bowling alley, etc.)
    property :Locksmith, :label => 'Locksmith', :comment =>
      %(A locksmith.)
    property :LodgingBusiness, :label => 'LodgingBusiness', :comment =>
      %(A lodging business, such as a motel, hotel, or inn.)
    property :LoseAction, :label => 'LoseAction', :comment =>
      %(The act of being defeated in a competitive activity.)
    property :LymphaticVessel, :label => 'LymphaticVessel', :comment =>
      %(A type of blood vessel that specifically carries lymph fluid
        unidirectionally toward the heart.)
    property :Map, :label => 'Map', :comment =>
      %(A map.)
    property :MarryAction, :label => 'MarryAction', :comment =>
      %(The act of marrying a person.)
    property :Mass, :label => 'Mass', :comment =>
      %(Properties that take Mass as values are of the form
        '&lt;Number&gt; &lt;Mass unit of measure&gt;'. E.g., '7 kg')
    property :MaximumDoseSchedule, :label => 'MaximumDoseSchedule', :comment =>
      %(The maximum dosing schedule considered safe for a drug or
        supplement as recommended by an authority or by the
        drug/supplement's manufacturer. Capture the recommending
        authority in the recognizingAuthority property of
        MedicalEntity.)
    property :MediaObject, :label => 'MediaObject', :comment =>
      %(An image, video, or audio object embedded in a web page. Note
        that a creative work may have many media objects associated
        with it on the same web page. For example, a page about a
        single song \(MusicRecording\) may have a music video
        \(VideoObject\), and a high and low bandwidth audio stream \(2
        AudioObject's\).)
    property :MedicalAudience, :label => 'MedicalAudience', :comment =>
      %(Target audiences for medical web pages. Enumerated type.)
    property :MedicalCause, :label => 'MedicalCause', :comment =>
      %(The causative agent\(s\) that are responsible for the
        pathophysiologic process that eventually results in a medical
        condition, symptom or sign. In this schema, unless otherwise
        specified this is meant to be the proximate cause of the
        medical condition, symptom or sign. The proximate cause is
        defined as the causative agent that most directly results in
        the medical condition, symptom or sign. For example, the HIV
        virus could be considered a cause of AIDS. Or in a diagnostic
        context, if a patient fell and sustained a hip fracture and
        two days later sustained a pulmonary embolism which eventuated
        in a cardiac arrest, the cause of the cardiac arrest \(the
        proximate cause\) would be the pulmonary embolism and not the
        fall. <p>Medical causes can include cardiovascular, chemical,
        dermatologic, endocrine, environmental, gastroenterologic,
        genetic, hematologic, gynecologic, iatrogenic, infectious,
        musculoskeletal, neurologic, nutritional, obstetric,
        oncologic, otolaryngologic, pharmacologic, psychiatric,
        pulmonary, renal, rheumatologic, toxic, traumatic, or urologic
        causes; medical conditions can be causes as well.)
    property :MedicalClinic, :label => 'MedicalClinic', :comment =>
      %(A medical clinic.)
    property :MedicalCode, :label => 'MedicalCode', :comment =>
      %(A code for a medical entity.)
    property :MedicalCondition, :label => 'MedicalCondition', :comment =>
      %(Any condition of the human body that affects the normal
        functioning of a person, whether physically or mentally.
        Includes diseases, injuries, disabilities, disorders,
        syndromes, etc.)
    property :MedicalConditionStage, :label => 'MedicalConditionStage', :comment =>
      %(A stage of a medical condition, such as 'Stage IIIa'.)
    property :MedicalContraindication, :label => 'MedicalContraindication', :comment =>
      %(A condition or factor that serves as a reason to withhold a
        certain medical therapy. Contraindications can be absolute
        \(there are no reasonable circumstances for undertaking a
        course of action\) or relative \(the patient is at higher risk
        of complications, but that these risks may be outweighed by
        other considerations or mitigated by other measures\).)
    property :MedicalDevice, :label => 'MedicalDevice', :comment =>
      %(Any object used in a medical capacity, such as to diagnose or
        treat a patient.)
    property :MedicalDevicePurpose, :label => 'MedicalDevicePurpose', :comment =>
      %(Categories of medical devices, organized by the purpose or
        intended use of the device.)
    property :MedicalEntity, :label => 'MedicalEntity', :comment =>
      %(The most generic type of entity related to health and the
        practice of medicine.)
    property :MedicalEnumeration, :label => 'MedicalEnumeration', :comment =>
      %(Enumerations related to health and the practice of medicine.)
    property :MedicalEvidenceLevel, :label => 'MedicalEvidenceLevel', :comment =>
      %(Level of evidence for a medical guideline. Enumerated type.)
    property :MedicalGuideline, :label => 'MedicalGuideline', :comment =>
      %(Any recommendation made by a standard society \(e.g. ACC/AHA\)
        or consensus statement that denotes how to diagnose and treat
        a particular condition. Note: this type should be used to tag
        the actual guideline recommendation; if the guideline
        recommendation occurs in a larger scholarly article, use
        MedicalScholarlyArticle to tag the overall article, not this
        type. Note also: the organization making the recommendation
        should be captured in the recognizingAuthority base property
        of MedicalEntity.)
    property :MedicalGuidelineContraindication, :label => 'MedicalGuidelineContraindication', :comment =>
      %(A guideline contraindication that designates a process as
        harmful and where quality of the data supporting the
        contraindication is sound.)
    property :MedicalGuidelineRecommendation, :label => 'MedicalGuidelineRecommendation', :comment =>
      %(A guideline recommendation that is regarded as efficacious and
        where quality of the data supporting the recommendation is
        sound.)
    property :MedicalImagingTechnique, :label => 'MedicalImagingTechnique', :comment =>
      %(Any medical imaging modality typically used for diagnostic
        purposes. Enumerated type.)
    property :MedicalIndication, :label => 'MedicalIndication', :comment =>
      %(A condition or factor that indicates use of a medical therapy,
        including signs, symptoms, risk factors, anatomical states,
        etc.)
    property :MedicalIntangible, :label => 'MedicalIntangible', :comment =>
      %(A utility class that serves as the umbrella for a number of
        'intangible' things in the medical space.)
    property :MedicalObservationalStudy, :label => 'MedicalObservationalStudy', :comment =>
      %(An observational study is a type of medical study that
        attempts to infer the possible effect of a treatment through
        observation of a cohort of subjects over a period of time. In
        an observational study, the assignment of subjects into
        treatment groups versus control groups is outside the control
        of the investigator. This is in contrast with controlled
        studies, such as the randomized controlled trials represented
        by MedicalTrial, where each subject is randomly assigned to a
        treatment group or a control group before the start of the
        treatment.)
    property :MedicalObservationalStudyDesign, :label => 'MedicalObservationalStudyDesign', :comment =>
      %(Design models for observational medical studies. Enumerated
        type.)
    property :MedicalOrganization, :label => 'MedicalOrganization', :comment =>
      %(A medical organization, such as a doctor's office or clinic.)
    property :MedicalProcedure, :label => 'MedicalProcedure', :comment =>
      %(A process of care used in either a diagnostic, therapeutic, or
        palliative capacity that relies on invasive \(surgical\),
        non-invasive, or percutaneous techniques.)
    property :MedicalProcedureType, :label => 'MedicalProcedureType', :comment =>
      %(An enumeration that describes different types of medical
        procedures.)
    property :MedicalRiskCalculator, :label => 'MedicalRiskCalculator', :comment =>
      %(A complex mathematical calculation requiring an online
        calculator, used to assess prognosis. Note: use the url
        property of Thing to record any URLs for online calculators.)
    property :MedicalRiskEstimator, :label => 'MedicalRiskEstimator', :comment =>
      %(Any rule set or interactive tool for estimating the risk of
        developing a complication or condition.)
    property :MedicalRiskFactor, :label => 'MedicalRiskFactor', :comment =>
      %(A risk factor is anything that increases a person's likelihood
        of developing or contracting a disease, medical condition, or
        complication.)
    property :MedicalRiskScore, :label => 'MedicalRiskScore', :comment =>
      %(A simple system that adds up the number of risk factors to
        yield a score that is associated with prognosis, e.g. CHAD
        score, TIMI risk score.)
    property :MedicalScholarlyArticle, :label => 'MedicalScholarlyArticle', :comment =>
      %(A scholarly article in the medical domain.)
    property :MedicalSign, :label => 'MedicalSign', :comment =>
      %(Any physical manifestation of a person's medical condition
        discoverable by objective diagnostic tests or physical
        examination.)
    property :MedicalSignOrSymptom, :label => 'MedicalSignOrSymptom', :comment =>
      %(Any indication of the existence of a medical condition or
        disease.)
    property :MedicalSpecialty, :label => 'MedicalSpecialty', :comment =>
      %(Any specific branch of medical science or practice. Medical
        specialities include clinical specialties that pertain to
        particular organ systems and their respective disease states,
        as well as allied health specialties. Enumerated type.)
    property :MedicalStudy, :label => 'MedicalStudy', :comment =>
      %(A medical study is an umbrella type covering all kinds of
        research studies relating to human medicine or health,
        including observational studies and interventional trials and
        registries, randomized, controlled or not. When the specific
        type of study is known, use one of the extensions of this
        type, such as MedicalTrial or MedicalObservationalStudy. Also,
        note that this type should be used to mark up data that
        describes the study itself; to tag an article that publishes
        the results of a study, use MedicalScholarlyArticle. Note: use
        the code property of MedicalEntity to store study IDs, e.g.
        clinicaltrials.gov ID.)
    property :MedicalStudyStatus, :label => 'MedicalStudyStatus', :comment =>
      %(The status of a medical study. Enumerated type.)
    property :MedicalSymptom, :label => 'MedicalSymptom', :comment =>
      %(Any indication of the existence of a medical condition or
        disease that is apparent to the patient.)
    property :MedicalTest, :label => 'MedicalTest', :comment =>
      %(Any medical test, typically performed for diagnostic purposes.)
    property :MedicalTestPanel, :label => 'MedicalTestPanel', :comment =>
      %(Any collection of tests commonly ordered together.)
    property :MedicalTherapy, :label => 'MedicalTherapy', :comment =>
      %(Any medical intervention designed to prevent, treat, and cure
        human diseases and medical conditions, including both curative
        and palliative therapies. Medical therapies are typically
        processes of care relying upon pharmacotherapy, behavioral
        therapy, supportive therapy \(with fluid or nutrition for
        example\), or detoxification \(e.g. hemodialysis\) aimed at
        improving or preventing a health condition.)
    property :MedicalTrial, :label => 'MedicalTrial', :comment =>
      %(A medical trial is a type of medical study that uses
        scientific process used to compare the safety and efficacy of
        medical therapies or medical procedures. In general, medical
        trials are controlled and subjects are allocated at random to
        the different treatment and/or control groups.)
    property :MedicalTrialDesign, :label => 'MedicalTrialDesign', :comment =>
      %(Design models for medical trials. Enumerated type.)
    property :MedicalWebPage, :label => 'MedicalWebPage', :comment =>
      %(A web page that provides medical information.)
    property :MedicineSystem, :label => 'MedicineSystem', :comment =>
      %(Systems of medical practice.)
    property :MensClothingStore, :label => 'MensClothingStore', :comment =>
      %(A men's clothing store.)
    property :MiddleSchool, :label => 'MiddleSchool', :comment =>
      %(A middle school.)
    property :MobileApplication, :label => 'MobileApplication', :comment =>
      %(A mobile software application.)
    property :MobilePhoneStore, :label => 'MobilePhoneStore', :comment =>
      %(A mobile-phone store.)
    property :Mosque, :label => 'Mosque', :comment =>
      %(A mosque.)
    property :Motel, :label => 'Motel', :comment =>
      %(A motel.)
    property :MotorcycleDealer, :label => 'MotorcycleDealer', :comment =>
      %(A motorcycle dealer.)
    property :MotorcycleRepair, :label => 'MotorcycleRepair', :comment =>
      %(A motorcycle repair shop.)
    property :Mountain, :label => 'Mountain', :comment =>
      %(A mountain, like Mount Whitney or Mount Everest)
    property :MoveAction, :label => 'MoveAction', :comment =>
      %(The act of an agent relocating to a place.<p>Related
        actions:</p><ul><li><a
        href="http://schema.org/TransferAction">TransferAction</a>:
        Unlike TransferAction, the subject of the move is a living
        Person or Organization rather than an inanimate
        object.</li></ul>)
    property :Movie, :label => 'Movie', :comment =>
      %(A movie.)
    property :MovieRentalStore, :label => 'MovieRentalStore', :comment =>
      %(A movie rental store.)
    property :MovieTheater, :label => 'MovieTheater', :comment =>
      %(A movie theater.)
    property :MovingCompany, :label => 'MovingCompany', :comment =>
      %(A moving company.)
    property :Muscle, :label => 'Muscle', :comment =>
      %(A muscle is an anatomical structure consisting of a
        contractile form of tissue that animals use to effect
        movement.)
    property :Museum, :label => 'Museum', :comment =>
      %(A museum.)
    property :MusicAlbum, :label => 'MusicAlbum', :comment =>
      %(A collection of music tracks.)
    property :MusicEvent, :label => 'MusicEvent', :comment =>
      %(Event type: Music event.)
    property :MusicGroup, :label => 'MusicGroup', :comment =>
      %(A musical group, such as a band, an orchestra, or a choir. Can
        also be a solo musician.)
    property :MusicPlaylist, :label => 'MusicPlaylist', :comment =>
      %(A collection of music tracks in playlist form.)
    property :MusicRecording, :label => 'MusicRecording', :comment =>
      %(A music recording \(track\), usually a single song.)
    property :MusicStore, :label => 'MusicStore', :comment =>
      %(A music store.)
    property :MusicVenue, :label => 'MusicVenue', :comment =>
      %(A music venue.)
    property :MusicVideoObject, :label => 'MusicVideoObject', :comment =>
      %(A music video file.)
    property :NGO, :label => 'NGO', :comment =>
      %(Organization: Non-governmental Organization.)
    property :NailSalon, :label => 'NailSalon', :comment =>
      %(A nail salon.)
    property :Nerve, :label => 'Nerve', :comment =>
      %(A common pathway for the electrochemical nerve impulses that
        are transmitted along each of the axons.)
    property :NewsArticle, :label => 'NewsArticle', :comment =>
      %(A news article)
    property :NightClub, :label => 'NightClub', :comment =>
      %(A nightclub or discotheque.)
    property :Notary, :label => 'Notary', :comment =>
      %(A notary.)
    property :Number, :label => 'Number', :comment =>
      %(Data type: Number.)
    property :NutritionInformation, :label => 'NutritionInformation', :comment =>
      %(Nutritional information about the recipe.)
    property :OceanBodyOfWater, :label => 'OceanBodyOfWater', :comment =>
      %(An ocean \(for example, the Pacific\).)
    property :Offer, :label => 'Offer', :comment =>
      %(An offer to sell an item&#x2014;for example, an offer to sell
        a product, the DVD of a movie, or tickets to an event.)
    property :OfferItemCondition, :label => 'OfferItemCondition', :comment =>
      %(A list of possible conditions for the item for sale.)
    property :OfficeEquipmentStore, :label => 'OfficeEquipmentStore', :comment =>
      %(An office equipment store.)
    property :OpeningHoursSpecification, :label => 'OpeningHoursSpecification', :comment =>
      %(A structured value providing information about the opening
        hours of a place or a certain service inside a place.)
    property :Optician, :label => 'Optician', :comment =>
      %(An optician's store.)
    property :OrderAction, :label => 'OrderAction', :comment =>
      %(An agent orders an object/product/service to be
        delivered/sent.)
    property :Organization, :label => 'Organization', :comment =>
      %(An organization such as a school, NGO, corporation, club, etc.)
    property :OrganizeAction, :label => 'OrganizeAction', :comment =>
      %(The act of manipulating/administering/supervising/controlling
        one or more objects.)
    property :OutletStore, :label => 'OutletStore', :comment =>
      %(An outlet store.)
    property :OwnershipInfo, :label => 'OwnershipInfo', :comment =>
      %(A structured value providing information about when a certain
        organization or person owned a certain product.)
    property :PaintAction, :label => 'PaintAction', :comment =>
      %(The act of producing a painting, typically with paint and
        canvas as instruments.)
    property :Painting, :label => 'Painting', :comment =>
      %(A painting.)
    property :PalliativeProcedure, :label => 'PalliativeProcedure', :comment =>
      %(A medical procedure intended primarly for palliative purposes,
        aimed at relieving the symptoms of an underlying health
        condition.)
    property :ParcelService, :label => 'ParcelService', :comment =>
      %(A private parcel service as the delivery mode available for a
        certain offer. Commonly used values:
        http://purl.org/goodrelations/v1#DHL
        http://purl.org/goodrelations/v1#FederalExpress
        http://purl.org/goodrelations/v1#UPS)
    property :ParentAudience, :label => 'ParentAudience', :comment =>
      %(A set of characteristics describing parents, who can be
        interested in viewing some content)
    property :Park, :label => 'Park', :comment =>
      %(A park.)
    property :ParkingFacility, :label => 'ParkingFacility', :comment =>
      %(A parking lot or other parking facility.)
    property :PathologyTest, :label => 'PathologyTest', :comment =>
      %(A medical test performed by a laboratory that typically
        involves examination of a tissue sample by a pathologist.)
    property :PawnShop, :label => 'PawnShop', :comment =>
      %(A pawnstore.)
    property :PayAction, :label => 'PayAction', :comment =>
      %(An agent pays a price to a participant.)
    property :PaymentChargeSpecification, :label => 'PaymentChargeSpecification', :comment =>
      %(The costs of settling the payment using a particular payment
        method.)
    property :PaymentMethod, :label => 'PaymentMethod', :comment =>
      %(A payment method is a standardized procedure for transferring
        the monetary amount for a purchase. Payment methods are
        characterized by the legal and technical structures used, and
        by the organization or group carrying out the transaction.
        Commonly used values:
        http://purl.org/goodrelations/v1#ByBankTransferInAdvance
        http://purl.org/goodrelations/v1#ByInvoice
        http://purl.org/goodrelations/v1#Cash
        http://purl.org/goodrelations/v1#CheckInAdvance
        http://purl.org/goodrelations/v1#COD
        http://purl.org/goodrelations/v1#DirectDebit
        http://purl.org/goodrelations/v1#GoogleCheckout
        http://purl.org/goodrelations/v1#PayPal
        http://purl.org/goodrelations/v1#PaySwarm)
    property :PeopleAudience, :label => 'PeopleAudience', :comment =>
      %(A set of characteristics belonging to people, e.g. who compose
        an item's target audience.)
    property :PerformAction, :label => 'PerformAction', :comment =>
      %(The act of participating in performance arts.)
    property :PerformingArtsTheater, :label => 'PerformingArtsTheater', :comment =>
      %(A theatre or other performing art center.)
    property :PerformingGroup, :label => 'PerformingGroup', :comment =>
      %(A performance group, such as a band, an orchestra, or a
        circus.)
    property :Person, :label => 'Person', :comment =>
      %(A person \(alive, dead, undead, or fictional\).)
    property :PetStore, :label => 'PetStore', :comment =>
      %(A pet store.)
    property :Pharmacy, :label => 'Pharmacy', :comment =>
      %(A pharmacy or drugstore.)
    property :Photograph, :label => 'Photograph', :comment =>
      %(A photograph.)
    property :PhotographAction, :label => 'PhotographAction', :comment =>
      %(The act of capturing still images of objects using a camera.)
    property :PhysicalActivity, :label => 'PhysicalActivity', :comment =>
      %(Any bodily activity that enhances or maintains physical
        fitness and overall health and wellness. Includes activity
        that is part of daily living and routine, structured exercise,
        and exercise prescribed as part of a medical treatment or
        recovery plan.)
    property :PhysicalActivityCategory, :label => 'PhysicalActivityCategory', :comment =>
      %(Categories of physical activity, organized by physiologic
        classification.)
    property :PhysicalExam, :label => 'PhysicalExam', :comment =>
      %(A type of physical examination of a patient performed by a
        physician. Enumerated type.)
    property :PhysicalTherapy, :label => 'PhysicalTherapy', :comment =>
      %(A process of progressive physical care and rehabilitation
        aimed at improving a health condition.)
    property :Physician, :label => 'Physician', :comment =>
      %(A doctor's office.)
    property :Place, :label => 'Place', :comment =>
      %(Entities that have a somewhat fixed, physical extension.)
    property :PlaceOfWorship, :label => 'PlaceOfWorship', :comment =>
      %(Place of worship, such as a church, synagogue, or mosque.)
    property :PlanAction, :label => 'PlanAction', :comment =>
      %(The act of planning the execution of an
        event/task/action/reservation/plan to a future date.)
    property :PlayAction, :label => 'PlayAction', :comment =>
      %(The act of playing/exercising/training/performing for
        enjoyment, leisure, recreation, competion or
        exercise.<p>Related actions:</p><ul><li><a
        href="http://schema.org/ListenAction">ListenAction</a>: Unlike
        ListenAction \(which is under ConsumeAction\), PlayAction
        refers to performing for an audience or at an event, rather
        than consuming music.</li><li><a
        href="http://schema.org/WatchAction">WatchAction</a>: Unlike
        WatchAction \(which is under ConsumeAction\), PlayAction
        refers to showing/displaying for an audience or at an event,
        rather than consuming visual content.</li></ul>)
    property :Playground, :label => 'Playground', :comment =>
      %(A playground.)
    property :Plumber, :label => 'Plumber', :comment =>
      %(A plumbing service.)
    property :PoliceStation, :label => 'PoliceStation', :comment =>
      %(A police station.)
    property :Pond, :label => 'Pond', :comment =>
      %(A pond)
    property :PostOffice, :label => 'PostOffice', :comment =>
      %(A post office.)
    property :PostalAddress, :label => 'PostalAddress', :comment =>
      %(The mailing address.)
    property :PrependAction, :label => 'PrependAction', :comment =>
      %(The act of inserting at the beginning if an ordered
        collection.)
    property :Preschool, :label => 'Preschool', :comment =>
      %(A preschool.)
    property :PreventionIndication, :label => 'PreventionIndication', :comment =>
      %(An indication for preventing an underlying condition, symptom,
        etc.)
    property :PriceSpecification, :label => 'PriceSpecification', :comment =>
      %(A structured value representing a monetary amount. Typically,
        only the subclasses of this type are used for markup.)
    property :ProductModel, :label => 'ProductModel', :comment =>
      %(A datasheet or vendor specification of a product \(in the
        sense of a prototypical description\).)
    property :ProfessionalService, :label => 'ProfessionalService', :comment =>
      %(Provider of professional services.)
    property :ProfilePage, :label => 'ProfilePage', :comment =>
      %(Web page type: Profile page.)
    property :Property, :label => 'Property', :comment =>
      %(A property, used to indicate attributes and relationships of
        some Thing; equivalent to rdf:Property.)
    property :PsychologicalTreatment, :label => 'PsychologicalTreatment', :comment =>
      %(A process of care relying upon counseling, dialogue,
        communication, verbalization aimed at improving a mental
        health condition.)
    property :PublicSwimmingPool, :label => 'PublicSwimmingPool', :comment =>
      %(A public swimming pool.)
    property :QualitativeValue, :label => 'QualitativeValue', :comment =>
      %(A predefined value for a product characteristic, e.g. the the
        power cord plug type "US" or the garment sizes "S", "M", "L",
        and "XL")
    property :QuantitativeValue, :label => 'QuantitativeValue', :comment =>
      %(A point value or interval for product characteristics and
        other purposes.)
    property :Quantity, :label => 'Quantity', :comment =>
      %(Quantities such as distance, time, mass, weight, etc.
        Particular instances of say Mass are entities like '3 Kg' or
        '4 milligrams'.)
    property :QuoteAction, :label => 'QuoteAction', :comment =>
      %(An agent quotes/estimates/appraises an object/product/service
        with a price at a location/store.)
    property :RVPark, :label => 'RVPark', :comment =>
      %(An RV park.)
    property :RadiationTherapy, :label => 'RadiationTherapy', :comment =>
      %(A process of care using radiation aimed at improving a health
        condition.)
    property :RadioStation, :label => 'RadioStation', :comment =>
      %(A radio station.)
    property :Rating, :label => 'Rating', :comment =>
      %(The rating of the video.)
    property :ReactAction, :label => 'ReactAction', :comment =>
      %(The act of responding instinctively and emotionally to an
        object, expressing a sentiment.)
    property :ReadAction, :label => 'ReadAction', :comment =>
      %(The act of consuming written content.)
    property :RealEstateAgent, :label => 'RealEstateAgent', :comment =>
      %(A real-estate agent.)
    property :ReceiveAction, :label => 'ReceiveAction', :comment =>
      %(The act of physically/electronically taking delivery of an
        object thathas been transferred from an origin to a
        destination. Reciprocal of SendAction.<p>Related
        actions:</p><ul><li><a
        href="http://schema.org/SendAction">SendAction</a>: The
        reciprocal of ReceiveAction.</li><li><a
        href="http://schema.org/TakeAction">TakeAction</a>: Unlike
        TakeAction, ReceiveAction does not imply that the ownership
        has been transfered \(e.g. I can receive a package, but it
        does not mean the package is now mine\).</li></ul>)
    property :Recipe, :label => 'Recipe', :comment =>
      %(A recipe.)
    property :RecommendedDoseSchedule, :label => 'RecommendedDoseSchedule', :comment =>
      %(A recommended dosing schedule for a drug or supplement as
        prescribed or recommended by an authority or by the
        drug/supplement's manufacturer. Capture the recommending
        authority in the recognizingAuthority property of
        MedicalEntity.)
    property :RecyclingCenter, :label => 'RecyclingCenter', :comment =>
      %(A recycling center.)
    property :RegisterAction, :label => 'RegisterAction', :comment =>
      %(The act of registering to be a user of a service, product or
        web page.<p>Related actions:</p><ul><li><a
        href="http://schema.org/JoinAction">JoinAction</a>: Unlike
        JoinAction, RegisterAction implies you are registering to be a
        user of a service, *not* a group/team of people.</li><li><a
        href="http://schema.org/FollowAction">FollowAction</a>: Unlike
        FollowAction, RegisterAction doesn't imply that the agent is
        expecting to poll for updates from the object.</li><li><a
        href="http://schema.org/SubscribeAction">SubscribeAction</a>:
        Unlike SubscribeAction, RegisterAction doesn't imply that the
        agent is expecting updates from the object.</li></ul>)
    property :RejectAction, :label => 'RejectAction', :comment =>
      %(The act of rejecting to/adopting an object.<p>Related
        actions:</p><ul><li><a
        href="http://schema.org/AcceptAction">AcceptAction</a>: The
        antagonym of RejectAction.</li></ul>)
    property :RentAction, :label => 'RentAction', :comment =>
      %(The act of giving money in return for temporary use, but not
        ownership, of an object such as a vehicle or property. For
        example, an agent rents a property from a landlord in exchange
        for a periodic payment.)
    property :ReplaceAction, :label => 'ReplaceAction', :comment =>
      %(The act of editing a recipient by replacing an old object with
        a new object.)
    property :ReplyAction, :label => 'ReplyAction', :comment =>
      %(The act of responding to a question/message asked/sent by the
        object. Related to <a
        href="AskAction">AskAction</a>.<p>Related
        actions:</p><ul><li><a
        href="http://schema.org/AskAction">AskAction</a>: Appears
        generally as an origin of a ReplyAction.</li></ul>)
    property :ReportedDoseSchedule, :label => 'ReportedDoseSchedule', :comment =>
      %(A patient-reported or observed dosing schedule for a drug or
        supplement.)
    property :ReserveAction, :label => 'ReserveAction', :comment =>
      %(Reserving a concrete object.<p>Related actions:</p><ul><li><a
        href="http://schema.org/ScheduleAction">ScheduleAction</a>:
        Unlike ScheduleAction, ReserveAction reserves concrete objects
        \(e.g. a table, a hotel\) towards a time slot / spatial
        allocation.</li></ul>)
    property :Reservoir, :label => 'Reservoir', :comment =>
      %(A reservoir, like the Lake Kariba reservoir.)
    property :Residence, :label => 'Residence', :comment =>
      %(The place where a person lives.)
    property :Restaurant, :label => 'Restaurant', :comment =>
      %(A restaurant.)
    property :ReturnAction, :label => 'ReturnAction', :comment =>
      %(The act of returning to the origin that which was previously
        received \(concrete objects\) or taken \(ownership\).)
    property :Review, :label => 'Review', :comment =>
      %(A review of an item - for example, a restaurant, movie, or
        store.)
    property :ReviewAction, :label => 'ReviewAction', :comment =>
      %(The act of producing a balanced opinion about the object for
        an audience. An agent reviews an object with participants
        resulting in a review.)
    property :RiverBodyOfWater, :label => 'RiverBodyOfWater', :comment =>
      %(A river \(for example, the broad majestic Shannon\).)
    property :RoofingContractor, :label => 'RoofingContractor', :comment =>
      %(A roofing contractor.)
    property :RsvpAction, :label => 'RsvpAction', :comment =>
      %(The act of notifying an event organiser as to whether you
        expect to attend the event.)
    property :SaleEvent, :label => 'SaleEvent', :comment =>
      %(Event type: Sales event.)
    property :ScheduleAction, :label => 'ScheduleAction', :comment =>
      %(Scheduling future actions, events, or tasks.<p>Related
        actions:</p><ul><li><a
        href="http://schema.org/ReserveAction">ReserveAction</a>:
        Unlike ReserveAction, ScheduleAction allocates future actions
        \(e.g. an event, a task, etc\) towards a time slot / spatial
        allocation.</li></ul>)
    property :ScholarlyArticle, :label => 'ScholarlyArticle', :comment =>
      %(A scholarly article.)
    property :School, :label => 'School', :comment =>
      %(A school.)
    property :Sculpture, :label => 'Sculpture', :comment =>
      %(A piece of sculpture.)
    property :SeaBodyOfWater, :label => 'SeaBodyOfWater', :comment =>
      %(A sea \(for example, the Caspian sea\).)
    property :SearchAction, :label => 'SearchAction', :comment =>
      %(The act of searching for an object.<p>Related
        actions:</p><ul><li><a
        href="http://schema.org/FindAction">FindAction</a>:
        SearchAction generally leads to a FindAction, but not
        necessarily.</li></ul>)
    property :SearchResultsPage, :label => 'SearchResultsPage', :comment =>
      %(Web page type: Search results page.)
    property :SelfStorage, :label => 'SelfStorage', :comment =>
      %(Self-storage facility.)
    property :SellAction, :label => 'SellAction', :comment =>
      %(The act of taking money from a buyer in exchange for goods or
        services rendered. An agent sells an object, product, or
        service to a buyer for a price. Reciprocal of BuyAction.)
    property :SendAction, :label => 'SendAction', :comment =>
      %(The act of physically/electronically dispatching an object for
        transfer from an origin to a destination.<p>Related
        actions:</p><ul><li><a
        href="http://schema.org/ReceiveAction">ReceiveAction</a>: The
        reciprocal of SendAction.</li><li><a
        href="http://schema.org/GiveAction">GiveAction</a>: Unlike
        GiveAction, SendAction does not imply the transfer of
        ownership \(e.g. I can send you my laptop, but I'm not
        necessarily giving it to you\).</li></ul>)
    property :ShareAction, :label => 'ShareAction', :comment =>
      %(The act of distributing content to people for their amusement
        or edification.)
    property :ShoeStore, :label => 'ShoeStore', :comment =>
      %(A shoe store.)
    property :ShoppingCenter, :label => 'ShoppingCenter', :comment =>
      %(A shopping center or mall.)
    property :SingleFamilyResidence, :label => 'SingleFamilyResidence', :comment =>
      %(Residence type: Single-family home.)
    property :SiteNavigationElement, :label => 'SiteNavigationElement', :comment =>
      %(A navigation element of the page.)
    property :SkiResort, :label => 'SkiResort', :comment =>
      %(A ski resort.)
    property :SocialEvent, :label => 'SocialEvent', :comment =>
      %(Event type: Social event.)
    property :SoftwareApplication, :label => 'SoftwareApplication', :comment =>
      %(A software application.)
    property :SomeProducts, :label => 'SomeProducts', :comment =>
      %(A placeholder for multiple similar products of the same kind.)
    property :Specialty, :label => 'Specialty', :comment =>
      %(Any branch of a field in which people typically develop
        specific expertise, usually after significant study, time, and
        effort.)
    property :SportingGoodsStore, :label => 'SportingGoodsStore', :comment =>
      %(A sporting goods store.)
    property :SportsActivityLocation, :label => 'SportsActivityLocation', :comment =>
      %(A sports location, such as a playing field.)
    property :SportsClub, :label => 'SportsClub', :comment =>
      %(A sports club.)
    property :SportsEvent, :label => 'SportsEvent', :comment =>
      %(Event type: Sports event.)
    property :SportsTeam, :label => 'SportsTeam', :comment =>
      %(Organization: Sports team.)
    property :StadiumOrArena, :label => 'StadiumOrArena', :comment =>
      %(A stadium.)
    property :State, :label => 'State', :comment =>
      %(A state or province.)
    property :Store, :label => 'Store', :comment =>
      %(A retail good store.)
    property :StructuredValue, :label => 'StructuredValue', :comment =>
      %(Structured values are strings&#x2014;for example,
        addresses&#x2014;that have certain constraints on their
        structure.)
    property :SubscribeAction, :label => 'SubscribeAction', :comment =>
      %(The act of forming a personal connection with
        someone/something \(object\) unidirectionally/asymmetrically
        to get updates pushed to.<p>Related actions:</p><ul><li><a
        href="http://schema.org/FollowAction">FollowAction</a>: Unlike
        FollowAction, SubscribeAction implies that the subscriber acts
        as a passive agent being constantly/actively pushed for
        updates.</li><li><a
        href="http://schema.org/RegisterAction">RegisterAction</a>:
        Unlike RegisterAction, SubscribeAction implies that the agent
        is interested in continuing receiving updates from the
        object.</li><li><a
        href="http://schema.org/JoinAction">JoinAction</a>: Unlike
        JoinAction, SubscribeAction implies that the agent is
        interested in continuing receiving updates from the
        object.</li></ul>)
    property :SubwayStation, :label => 'SubwayStation', :comment =>
      %(A subway station.)
    property :SuperficialAnatomy, :label => 'SuperficialAnatomy', :comment =>
      %(Anatomical features that can be observed by sight \(without
        dissection\), including the form and proportions of the human
        body as well as surface landmarks that correspond to deeper
        subcutaneous structures. Superficial anatomy plays an
        important role in sports medicine, phlebotomy, and other
        medical specialties as underlying anatomical structures can be
        identified through surface palpation. For example, during back
        surgery, superficial anatomy can be used to palpate and count
        vertebrae to find the site of incision. Or in phlebotomy,
        superficial anatomy can be used to locate an underlying vein;
        for example, the median cubital vein can be located by
        palpating the borders of the cubital fossa \(such as the
        epicondyles of the humerus\) and then looking for the
        superficial signs of the vein, such as size, prominence,
        ability to refill after depression, and feel of surrounding
        tissue support. As another example, in a subluxation
        \(dislocation\) of the glenohumeral joint, the bony structure
        becomes pronounced with the deltoid muscle failing to cover
        the glenohumeral joint allowing the edges of the scapula to be
        superficially visible. Here, the superficial anatomy is the
        visible edges of the scapula, implying the underlying
        dislocation of the joint \(the related anatomical structure\).)
    property :Synagogue, :label => 'Synagogue', :comment =>
      %(A synagogue.)
    property :TVEpisode, :label => 'TVEpisode', :comment =>
      %(An episode of a TV series or season.)
    property :TVSeason, :label => 'TVSeason', :comment =>
      %(A TV season.)
    property :TVSeries, :label => 'TVSeries', :comment =>
      %(A television series.)
    property :Table, :label => 'Table', :comment =>
      %(A table on the page.)
    property :TakeAction, :label => 'TakeAction', :comment =>
      %(The act of gaining ownership of an object from an origin.
        Reciprocal of GiveAction.<p>Related actions:</p><ul><li><a
        href="http://schema.org/GiveAction">GiveAction</a>: The
        reciprocal of TakeAction.</li><li><a
        href="http://schema.org/ReceiveAction">ReceiveAction</a>:
        Unlike ReceiveAction, TakeAction implies that ownership has
        been transfered.</li></ul>)
    property :TattooParlor, :label => 'TattooParlor', :comment =>
      %(A tattoo parlor.)
    property :TaxiStand, :label => 'TaxiStand', :comment =>
      %(A taxi stand.)
    property :TechArticle, :label => 'TechArticle', :comment =>
      %(A technical article - Example: How-to \(task\) topics,
        step-by-step, procedural troubleshooting, specifications, etc.)
    property :TelevisionStation, :label => 'TelevisionStation', :comment =>
      %(A television station.)
    property :TennisComplex, :label => 'TennisComplex', :comment =>
      %(A tennis complex.)
    property :Text, :label => 'Text', :comment =>
      %(Data type: Text.)
    property :TheaterEvent, :label => 'TheaterEvent', :comment =>
      %(Event type: Theater performance.)
    property :TheaterGroup, :label => 'TheaterGroup', :comment =>
      %(A theater group or company&#x2014;for example, the Royal
        Shakespeare Company or Druid Theatre.)
    property :TherapeuticProcedure, :label => 'TherapeuticProcedure', :comment =>
      %(A medical procedure intended primarly for therapeutic
        purposes, aimed at improving a health condition.)
    property :Thing, :label => 'Thing', :comment =>
      %(The most generic type of item.)
    property :TieAction, :label => 'TieAction', :comment =>
      %(The act of reaching a draw in a competitive activity.)
    property :Time, :label => 'Time', :comment =>
      %(A point in time recurring on multiple days in the form
        hh:mm:ss[Z|\(+|-\)hh:mm] \(see <a
        href="http://www.w3.org/TR/xmlschema-2/#time">XML schema for
        details</a>\).)
    property :TipAction, :label => 'TipAction', :comment =>
      %(The act of giving money voluntarily to a beneficiary in
        recognition of services rendered.)
    property :TireShop, :label => 'TireShop', :comment =>
      %(A tire shop.)
    property :TouristAttraction, :label => 'TouristAttraction', :comment =>
      %(A tourist attraction.)
    property :TouristInformationCenter, :label => 'TouristInformationCenter', :comment =>
      %(A tourist information center.)
    property :ToyStore, :label => 'ToyStore', :comment =>
      %(A toystore.)
    property :TrackAction, :label => 'TrackAction', :comment =>
      %(An agent tracks an object for updates.<p>Related
        actions:</p><ul><li><a
        href="http://schema.org/FollowAction">FollowAction</a>: Unlike
        FollowAction, TrackAction refers to the interest on the
        location of innanimates objects.</li><li><a
        href="http://schema.org/SubscribeAction">SubscribeAction</a>:
        Unlike SubscribeAction, TrackAction refers to the interest on
        the location of innanimate objects.</li></ul>)
    property :TradeAction, :label => 'TradeAction', :comment =>
      %(The act of participating in an exchange of goods and services
        for monetary compensation. An agent trades an object, product
        or service with a participant in exchange for a one time or
        periodic payment.)
    property :TrainStation, :label => 'TrainStation', :comment =>
      %(A train station.)
    property :TransferAction, :label => 'TransferAction', :comment =>
      %(The act of transferring/moving \(abstract or concrete\)
        animate or inanimate objects from one place to another.)
    property :TravelAction, :label => 'TravelAction', :comment =>
      %(The act of traveling from an fromLocation to a destination by
        a specified mode of transport, optionally with participants.)
    property :TravelAgency, :label => 'TravelAgency', :comment =>
      %(A travel agency.)
    property :TreatmentIndication, :label => 'TreatmentIndication', :comment =>
      %(An indication for treating an underlying condition, symptom,
        etc.)
    property :TypeAndQuantityNode, :label => 'TypeAndQuantityNode', :comment =>
      %(A structured value indicating the quantity, unit of
        measurement, and business function of goods included in a
        bundle offer.)
    property :URL, :label => 'URL', :comment =>
      %(Data type: URL.)
    property :UnRegisterAction, :label => 'UnRegisterAction', :comment =>
      %(The act of un-registering from a service.<p>Related
        actions:</p><ul><li><a
        href="http://schema.org/RegisterAction">RegisterAction</a>:
        Antagonym of UnRegisterAction.</li><li><a
        href="http://schema.org/Leave">Leave</a>: Unlike LeaveAction,
        UnRegisterAction implies that you are unregistering from a
        service you werer previously registered, rather than leaving a
        team/group of people.</li></ul>)
    property :UnitPriceSpecification, :label => 'UnitPriceSpecification', :comment =>
      %(The price asked for a given offer by the respective
        organization or person.)
    property :UpdateAction, :label => 'UpdateAction', :comment =>
      %(The act of managing by changing/editing the state of the
        object.)
    property :UseAction, :label => 'UseAction', :comment =>
      %(The act of applying an object to its intended purpose.)
    property :UserBlocks, :label => 'UserBlocks', :comment =>
      %(User interaction: Block this content.)
    property :UserCheckins, :label => 'UserCheckins', :comment =>
      %(User interaction: Check-in at a place.)
    property :UserComments, :label => 'UserComments', :comment =>
      %(The UserInteraction event in which a user comments on an item.)
    property :UserDownloads, :label => 'UserDownloads', :comment =>
      %(User interaction: Download of an item.)
    property :UserInteraction, :label => 'UserInteraction', :comment =>
      %(A user interacting with a page)
    property :UserLikes, :label => 'UserLikes', :comment =>
      %(User interaction: Like an item.)
    property :UserPageVisits, :label => 'UserPageVisits', :comment =>
      %(User interaction: Visit to a web page.)
    property :UserPlays, :label => 'UserPlays', :comment =>
      %(User interaction: Play count of an item, for example a video
        or a song.)
    property :UserPlusOnes, :label => 'UserPlusOnes', :comment =>
      %(User interaction: +1.)
    property :UserTweets, :label => 'UserTweets', :comment =>
      %(User interaction: Tweets.)
    property :Vein, :label => 'Vein', :comment =>
      %(A type of blood vessel that specifically carries blood to the
        heart.)
    property :Vessel, :label => 'Vessel', :comment =>
      %(A component of the human body circulatory system comprised of
        an intricate network of hollow tubes that transport blood
        throughout the entire body.)
    property :VeterinaryCare, :label => 'VeterinaryCare', :comment =>
      %(A vet's office.)
    property :VideoGallery, :label => 'VideoGallery', :comment =>
      %(Web page type: Video gallery page.)
    property :VideoObject, :label => 'VideoObject', :comment =>
      %(A video file.)
    property :ViewAction, :label => 'ViewAction', :comment =>
      %(The act of consuming static visual content.)
    property :VisualArtsEvent, :label => 'VisualArtsEvent', :comment =>
      %(Event type: Visual arts event.)
    property :Volcano, :label => 'Volcano', :comment =>
      %(A volcano, like Fuji san)
    property :VoteAction, :label => 'VoteAction', :comment =>
      %(The act of expressing a preference from a
        fixed/finite/structured set of choices/options.)
    property :WPAdBlock, :label => 'WPAdBlock', :comment =>
      %(An advertising section of the page.)
    property :WPFooter, :label => 'WPFooter', :comment =>
      %(The footer section of the page.)
    property :WPHeader, :label => 'WPHeader', :comment =>
      %(The header section of the page.)
    property :WPSideBar, :label => 'WPSideBar', :comment =>
      %(A sidebar section of the page.)
    property :WantAction, :label => 'WantAction', :comment =>
      %(The act of expressing a desire about the object. An agent
        wants an object.)
    property :WarrantyPromise, :label => 'WarrantyPromise', :comment =>
      %(A structured value representing the duration and scope of
        services that will be provided to a customer free of charge in
        case of a defect or malfunction of a product.)
    property :WarrantyScope, :label => 'WarrantyScope', :comment =>
      %(A range of of services that will be provided to a customer
        free of charge in case of a defect or malfunction of a
        product. Commonly used values:
        http://purl.org/goodrelations/v1#Labor-BringIn
        http://purl.org/goodrelations/v1#PartsAndLabor-BringIn
        http://purl.org/goodrelations/v1#PartsAndLabor-PickUp)
    property :WatchAction, :label => 'WatchAction', :comment =>
      %(The act of consuming dynamic/moving visual content.)
    property :Waterfall, :label => 'Waterfall', :comment =>
      %(A waterfall, like Niagara)
    property :WearAction, :label => 'WearAction', :comment =>
      %(The act of dressing oneself in clothing.)
    property :WebApplication, :label => 'WebApplication', :comment =>
      %(Web applications.)
    property :WebPage, :label => 'WebPage', :comment =>
      %(A web page. Every web page is implicitly assumed to be
        declared to be of type WebPage, so the various properties
        about that webpage, such as <code>breadcrumb</code> may be
        used. We recommend explicit declaration if these properties
        are specified, but if they are found outside of an itemscope,
        they will be assumed to be about the page)
    property :WebPageElement, :label => 'WebPageElement', :comment =>
      %(A web page element, like a table or an image)
    property :WholesaleStore, :label => 'WholesaleStore', :comment =>
      %(A wholesale store.)
    property :WinAction, :label => 'WinAction', :comment =>
      %(The act of achieving victory in a competitive activity.)
    property :Winery, :label => 'Winery', :comment =>
      %(A winery.)
    property :WriteAction, :label => 'WriteAction', :comment =>
      %(The act of authoring written creative content.)
    property :Zoo, :label => 'Zoo', :comment =>
      %(A zoo.)

    # Property definitions
    property :about, :label => 'about', :comment =>
      %(The subject matter of the content.)
    property :acceptedPaymentMethod, :label => 'acceptedPaymentMethod', :comment =>
      %(The payment method\(s\) accepted by seller for this offer.)
    property :acceptsReservations, :label => 'acceptsReservations', :comment =>
      %(Either <code>Yes/No</code>, or a URL at which reservations can
        be made.)
    property :accountablePerson, :label => 'accountablePerson', :comment =>
      %(Specifies the Person that is legally accountable for the
        CreativeWork.)
    property :acquiredFrom, :label => 'acquiredFrom', :comment =>
      %(The organization or person from which the product was
        acquired.)
    property :action, :label => 'action', :comment =>
      %(The movement the muscle generates.)
    property :activeIngredient, :label => 'activeIngredient', :comment =>
      %(An active ingredient, typically chemical compounds and/or
        biologic substances.)
    property :activityDuration, :label => 'activityDuration', :comment =>
      %(Length of time to engage in the activity.)
    property :activityFrequency, :label => 'activityFrequency', :comment =>
      %(How often one should engage in the activity.)
    property :actor, :label => 'actor', :comment =>
      %(A cast member of the movie, TV series, season, or episode, or
        video.)
    property :actors, :label => 'actors', :comment =>
      %(A cast member of the movie, TV series, season, or episode, or
        video. \(legacy spelling; see singular form, actor\))
    property :addOn, :label => 'addOn', :comment =>
      %(An additional offer that can only be obtained in combination
        with the first base offer \(e.g. supplements and extensions
        that are available for a surcharge\).)
    property :additionalName, :label => 'additionalName', :comment =>
      %(An additional name for a Person, can be used for a middle
        name.)
    property :additionalType, :label => 'additionalType', :comment =>
      %(An additional type for the item, typically used for adding
        more specific types from external vocabularies in microdata
        syntax. This is a relationship between something and a class
        that the thing is in. In RDFa syntax, it is better to use the
        native RDFa syntax - the 'typeof' attribute - for multiple
        types. Schema.org tools may have only weaker understanding of
        extra types, in particular those defined externally.)
    property :additionalVariable, :label => 'additionalVariable', :comment =>
      %(Any additional component of the exercise prescription that may
        need to be articulated to the patient. This may include the
        order of exercises, the number of repetitions of movement,
        quantitative distance, progressions over time, etc.)
    property :address, :label => 'address', :comment =>
      %(Physical address of the item.)
    property :addressCountry, :label => 'addressCountry', :comment =>
      %(The country. For example, USA. You can also provide the
        two-letter <a
        href='http://en.wikipedia.org/wiki/ISO_3166-1'>ISO 3166-1
        alpha-2 country code</a>.)
    property :addressLocality, :label => 'addressLocality', :comment =>
      %(The locality. For example, Mountain View.)
    property :addressRegion, :label => 'addressRegion', :comment =>
      %(The region. For example, CA.)
    property :administrationRoute, :label => 'administrationRoute', :comment =>
      %(A route by which this drug may be administered, e.g. 'oral'.)
    property :advanceBookingRequirement, :label => 'advanceBookingRequirement', :comment =>
      %(The amount of time that is required between accepting the
        offer and the actual usage of the resource or service.)
    property :adverseOutcome, :label => 'adverseOutcome', :comment =>
      %(A possible complication and/or side effect of this therapy. If
        it is known that an adverse outcome is serious \(resulting in
        death, disability, or permanent damage; requiring
        hospitalization; or is otherwise life-threatening or requires
        immediate medical attention\), tag it as a
        seriouseAdverseOutcome instead.)
    property :affectedBy, :label => 'affectedBy', :comment =>
      %(Drugs that affect the test's results.)
    property :affiliation, :label => 'affiliation', :comment =>
      %(An organization that this person is affiliated with. For
        example, a school/university, a club, or a team.)
    property :agent, :label => 'agent', :comment =>
      %(The direct performer or driver of the action \(animate or
        inanimate\). e.g. *John* wrote a book.)
    property :aggregateRating, :label => 'aggregateRating', :comment =>
      %(The overall rating, based on a collection of reviews or
        ratings, of the item.)
    property :album, :label => 'album', :comment =>
      %(A music album.)
    property :albums, :label => 'albums', :comment =>
      %(A collection of music albums \(legacy spelling; see singular
        form, album\).)
    property :alcoholWarning, :label => 'alcoholWarning', :comment =>
      %(Any precaution, guidance, contraindication, etc. related to
        consumption of alcohol while taking this drug.)
    property :algorithm, :label => 'algorithm', :comment =>
      %(The algorithm or rules to follow to compute the score.)
    property :alignmentType, :label => 'alignmentType', :comment =>
      %(A category of alignment between the learning resource and the
        framework node. Recommended values include: 'assesses',
        'teaches', 'requires', 'textComplexity', 'readingLevel',
        'educationalSubject', and 'educationLevel'.)
    property :alternateName, :label => 'alternateName', :comment =>
      %(Any alternate name for this medical entity.)
    property :alternativeHeadline, :label => 'alternativeHeadline', :comment =>
      %(A secondary title of the CreativeWork.)
    property :alumni, :label => 'alumni', :comment =>
      %(Alumni of educational organization.)
    property :alumniOf, :label => 'alumniOf', :comment =>
      %(An educational organizations that the person is an alumni of.)
    property :amountOfThisGood, :label => 'amountOfThisGood', :comment =>
      %(The quantity of the goods included in the offer.)
    property :antagonist, :label => 'antagonist', :comment =>
      %(The muscle whose action counteracts the specified muscle.)
    property :applicableLocation, :label => 'applicableLocation', :comment =>
      %(The location in which the status applies.)
    property :applicationCategory, :label => 'applicationCategory', :comment =>
      %(Type of software application, e.g. "Game, Multimedia".)
    property :applicationSubCategory, :label => 'applicationSubCategory', :comment =>
      %(Subcategory of the application, e.g. "Arcade Game".)
    property :applicationSuite, :label => 'applicationSuite', :comment =>
      %(The name of the application suite to which the application
        belongs \(e.g. Excel belongs to Office\))
    property :appliesToDeliveryMethod, :label => 'appliesToDeliveryMethod', :comment =>
      %(The delivery method\(s\) to which the delivery charge or
        payment charge specification applies.)
    property :appliesToPaymentMethod, :label => 'appliesToPaymentMethod', :comment =>
      %(The payment method\(s\) to which the payment charge
        specification applies.)
    property :arterialBranch, :label => 'arterialBranch', :comment =>
      %(The branches that comprise the arterial structure.)
    property :articleBody, :label => 'articleBody', :comment =>
      %(The actual body of the article.)
    property :articleSection, :label => 'articleSection', :comment =>
      %(Articles may belong to one or more 'sections' in a magazine or
        newspaper, such as Sports, Lifestyle, etc.)
    property :aspect, :label => 'aspect', :comment =>
      %(An aspect of medical practice that is considered on the page,
        such as 'diagnosis', 'treatment', 'causes', 'prognosis',
        'etiology', 'epidemiology', etc.)
    property :assembly, :label => 'assembly', :comment =>
      %(Library file name e.g., mscorlib.dll, system.web.dll)
    property :assemblyVersion, :label => 'assemblyVersion', :comment =>
      %(Associated product/technology version. e.g., .NET Framework
        4.5)
    property :associatedAnatomy, :label => 'associatedAnatomy', :comment =>
      %(The anatomy of the underlying organ system or structures
        associated with this entity.)
    property :associatedArticle, :label => 'associatedArticle', :comment =>
      %(A NewsArticle associated with the Media Object.)
    property :associatedMedia, :label => 'associatedMedia', :comment =>
      %(The media objects that encode this creative work. This
        property is a synonym for encodings.)
    property :associatedPathophysiology, :label => 'associatedPathophysiology', :comment =>
      %(If applicable, a description of the pathophysiology associated
        with the anatomical system, including potential abnormal
        changes in the mechanical, physical, and biochemical functions
        of the system.)
    property :attendee, :label => 'attendee', :comment =>
      %(A person or organization attending the event.)
    property :attendees, :label => 'attendees', :comment =>
      %(A person attending the event \(legacy spelling; see singular
        form, attendee\).)
    property :audience, :label => 'audience', :comment =>
      %(The intended audience of the item, i.e. the group for whom the
        item was created.)
    property :audio, :label => 'audio', :comment =>
      %(An embedded audio object.)
    property :author, :label => 'author', :comment =>
      %(The author of this content. Please note that author is special
        in that HTML 5 provides a special mechanism for indicating
        authorship via the rel tag. That is equivalent to this and may
        be used interchangeably.)
    property :availability, :label => 'availability', :comment =>
      %(The availability of this item&#x2014;for example In stock, Out
        of stock, Pre-order, etc.)
    property :availabilityEnds, :label => 'availabilityEnds', :comment =>
      %(The end of the availability of the product or service included
        in the offer.)
    property :availabilityStarts, :label => 'availabilityStarts', :comment =>
      %(The beginning of the availability of the product or service
        included in the offer.)
    property :availableAtOrFrom, :label => 'availableAtOrFrom', :comment =>
      %(The place\(s\) from which the offer can be obtained \(e.g.
        store locations\).)
    property :availableDeliveryMethod, :label => 'availableDeliveryMethod', :comment =>
      %(The delivery method\(s\) available for this offer.)
    property :availableIn, :label => 'availableIn', :comment =>
      %(The location in which the strength is available.)
    property :availableService, :label => 'availableService', :comment =>
      %(A medical service available from this provider.)
    property :availableStrength, :label => 'availableStrength', :comment =>
      %(An available dosage strength for the drug.)
    property :availableTest, :label => 'availableTest', :comment =>
      %(A diagnostic test or procedure offered by this lab.)
    property :award, :label => 'award', :comment =>
      %(An award won by this person or for this creative work.)
    property :awards, :label => 'awards', :comment =>
      %(Awards won by this person or for this creative work. \(legacy
        spelling; see singular form, award\))
    property :background, :label => 'background', :comment =>
      %(Descriptive information establishing a historical perspective
        on the supplement. May include the rationale for the name, the
        population where the supplement first came to prominence, etc.)
    property :baseSalary, :label => 'baseSalary', :comment =>
      %(The base salary of the job.)
    property :benefits, :label => 'benefits', :comment =>
      %(Description of benefits associated with the job.)
    property :bestRating, :label => 'bestRating', :comment =>
      %(The highest value allowed in this rating system. If bestRating
        is omitted, 5 is assumed.)
    property :billingIncrement, :label => 'billingIncrement', :comment =>
      %(This property specifies the minimal quantity and rounding
        increment that will be the basis for the billing. The unit of
        measurement is specified by the unitCode property.)
    property :biomechnicalClass, :label => 'biomechnicalClass', :comment =>
      %(The biomechanical properties of the bone.)
    property :birthDate, :label => 'birthDate', :comment =>
      %(Date of birth.)
    property :bitrate, :label => 'bitrate', :comment =>
      %(The bitrate of the media object.)
    property :blogPost, :label => 'blogPost', :comment =>
      %(A posting that is part of this blog.)
    property :blogPosts, :label => 'blogPosts', :comment =>
      %(The postings that are part of this blog \(legacy spelling; see
        singular form, blogPost\).)
    property :bloodSupply, :label => 'bloodSupply', :comment =>
      %(The blood vessel that carries blood from the heart to the
        muscle.)
    property :bodyLocation, :label => 'bodyLocation', :comment =>
      %(Location in the body of the anatomical structure.)
    property :bookEdition, :label => 'bookEdition', :comment =>
      %(The edition of the book.)
    property :bookFormat, :label => 'bookFormat', :comment =>
      %(The format of the book.)
    property :borrower, :label => 'borrower', :comment =>
      %(A sub property of participant. The person that borrows the
        object being lent.)
    property :box, :label => 'box', :comment =>
      %(A polygon is the area enclosed by a point-to-point path for
        which the starting and ending points are the same. A polygon
        is expressed as a series of four or more spacedelimited points
        where the first and final points are identical.)
    property :branch, :label => 'branch', :comment =>
      %(The branches that delineate from the nerve bundle.)
    property :branchOf, :label => 'branchOf', :comment =>
      %(The larger organization that this local business is a branch
        of, if any.)
    property :brand, :label => 'brand', :comment =>
      %(The brand\(s\) associated with a product or service, or the
        brand\(s\) maintained by an organization or business person.)
    property :breadcrumb, :label => 'breadcrumb', :comment =>
      %(A set of links that can help a user understand and navigate a
        website hierarchy.)
    property :breastfeedingWarning, :label => 'breastfeedingWarning', :comment =>
      %(Any precaution, guidance, contraindication, etc. related to
        this drug's use by breastfeeding mothers.)
    property :browserRequirements, :label => 'browserRequirements', :comment =>
      %(Specifies browser requirements in human-readable text. For
        example,"requires HTML5 support".)
    property :businessFunction, :label => 'businessFunction', :comment =>
      %(The business function \(e.g. sell, lease, repair, dispose\) of
        the offer or component of a bundle \(TypeAndQuantityNode\).
        The default is http://purl.org/goodrelations/v1#Sell.)
    property :buyer, :label => 'buyer', :comment =>
      %(A sub property of participant. The
        participant/person/organization that bought the object.)
    property :byArtist, :label => 'byArtist', :comment =>
      %(The artist that performed this album or recording.)
    property :calories, :label => 'calories', :comment =>
      %(The number of calories)
    property :candidate, :label => 'candidate', :comment =>
      %(A sub property of object. The candidate subject of this
        action.)
    property :caption, :label => 'caption', :comment =>
      %(The caption for this object.)
    property :carbohydrateContent, :label => 'carbohydrateContent', :comment =>
      %(The number of grams of carbohydrates.)
    property :carrierRequirements, :label => 'carrierRequirements', :comment =>
      %(Specifies specific carrier\(s\) requirements for the
        application \(e.g. an application may only work on a specific
        carrier network\).)
    property :catalog, :label => 'catalog', :comment =>
      %(A data catalog which contains a dataset.)
    property :category, :label => 'category', :comment =>
      %(A category for the item. Greater signs or slashes can be used
        to informally indicate a category hierarchy.)
    property :cause, :label => 'cause', :comment =>
      %(An underlying cause. More specifically, one of the causative
        agent\(s\) that are most directly responsible for the
        pathophysiologic process that eventually results in the
        occurrence.)
    property :causeOf, :label => 'causeOf', :comment =>
      %(The condition, complication, symptom, sign, etc. caused.)
    property :childMaxAge, :label => 'childMaxAge', :comment =>
      %(Maximal age of the child)
    property :childMinAge, :label => 'childMinAge', :comment =>
      %(Minimal age of the child)
    property :children, :label => 'children', :comment =>
      %(A child of the person.)
    property :cholesterolContent, :label => 'cholesterolContent', :comment =>
      %(The number of milligrams of cholesterol.)
    property :circle, :label => 'circle', :comment =>
      %(A circle is the circular region of a specified radius centered
        at a specified latitude and longitude. A circle is expressed
        as a pair followed by a radius in meters.)
    property :citation, :label => 'citation', :comment =>
      %(A citation or reference to another creative work, such as
        another publication, web page, scholarly article, etc. NOTE:
        Candidate for promotion to ScholarlyArticle.)
    property :clincalPharmacology, :label => 'clincalPharmacology', :comment =>
      %(Description of the absorption and elimination of drugs,
        including their concentration \(pharmacokinetics, pK\) and
        biological effects \(pharmacodynamics, pD\).)
    property :closes, :label => 'closes', :comment =>
      %(The closing hour of the place or service on the given day\(s\)
        of the week.)
    property :code, :label => 'code', :comment =>
      %(A medical code for the entity, taken from a controlled
        vocabulary or ontology such as ICD-9, DiseasesDB, MeSH,
        SNOMED-CT, RxNorm, etc.)
    property :codeRepository, :label => 'codeRepository', :comment =>
      %(Link to the repository where the un-compiled, human readable
        code and related code is located \(SVN, github, CodePlex\))
    property :codeValue, :label => 'codeValue', :comment =>
      %(The actual code.)
    property :codingSystem, :label => 'codingSystem', :comment =>
      %(The coding system, e.g. 'ICD-10'.)
    property :colleague, :label => 'colleague', :comment =>
      %(A colleague of the person.)
    property :colleagues, :label => 'colleagues', :comment =>
      %(A colleague of the person \(legacy spelling; see singular
        form, colleague\).)
    property :collection, :label => 'collection', :comment =>
      %(A sub property of object. The collection target of the action.)
    property :color, :label => 'color', :comment =>
      %(The color of the product.)
    property :comment, :label => 'comment', :comment =>
      %(Comments, typically from users, on this CreativeWork.)
    property :commentText, :label => 'commentText', :comment =>
      %(The text of the UserComment.)
    property :commentTime, :label => 'commentTime', :comment =>
      %(The time at which the UserComment was made.)
    property :comprisedOf, :label => 'comprisedOf', :comment =>
      %(The underlying anatomical structures, such as organs, that
        comprise the anatomical system.)
    property :connectedTo, :label => 'connectedTo', :comment =>
      %(Other anatomical structures to which this structure is
        connected.)
    property :contactPoint, :label => 'contactPoint', :comment =>
      %(A contact point for a person or organization.)
    property :contactPoints, :label => 'contactPoints', :comment =>
      %(A contact point for a person or organization \(legacy
        spelling; see singular form, contactPoint\).)
    property :contactType, :label => 'contactType', :comment =>
      %(A person or organization can have different contact points,
        for different purposes. For example, a sales contact point, a
        PR contact point and so on. This property is used to specify
        the kind of contact point.)
    property :containedIn, :label => 'containedIn', :comment =>
      %(The basic containment relation between places.)
    property :contentLocation, :label => 'contentLocation', :comment =>
      %(The location of the content.)
    property :contentRating, :label => 'contentRating', :comment =>
      %(Official rating of a piece of content&#x2014;for example,'MPAA
        PG-13'.)
    property :contentSize, :label => 'contentSize', :comment =>
      %(File size in \(mega/kilo\) bytes.)
    property :contentUrl, :label => 'contentUrl', :comment =>
      %(Actual bytes of the media object, for example the image file
        or video file. \(previous spelling: contentURL\))
    property :contraindication, :label => 'contraindication', :comment =>
      %(A contraindication for this therapy.)
    property :contributor, :label => 'contributor', :comment =>
      %(A secondary contributor to the CreativeWork.)
    property :cookTime, :label => 'cookTime', :comment =>
      %(The time it takes to actually cook the dish, in <a
        href='http://en.wikipedia.org/wiki/ISO_8601'>ISO 8601 duration
        format</a>.)
    property :cookingMethod, :label => 'cookingMethod', :comment =>
      %(The method of cooking, such as Frying, Steaming, ...)
    property :copyrightHolder, :label => 'copyrightHolder', :comment =>
      %(The party holding the legal copyright to the CreativeWork.)
    property :copyrightYear, :label => 'copyrightYear', :comment =>
      %(The year during which the claimed copyright for the
        CreativeWork was first asserted.)
    property :cost, :label => 'cost', :comment =>
      %(Cost per unit of the drug, as reported by the source being
        tagged.)
    property :costCategory, :label => 'costCategory', :comment =>
      %(The category of cost, such as wholesale, retail, reimbursement
        cap, etc.)
    property :costCurrency, :label => 'costCurrency', :comment =>
      %(The currency \(in 3-letter <a
        href=http://en.wikipedia.org/wiki/ISO_4217>ISO 4217
        format</a>\) of the drug cost.)
    property :costOrigin, :label => 'costOrigin', :comment =>
      %(Additional details to capture the origin of the cost data. For
        example, 'Medicare Part B'.)
    property :costPerUnit, :label => 'costPerUnit', :comment =>
      %(The cost per unit of the drug.)
    property :countriesNotSupported, :label => 'countriesNotSupported', :comment =>
      %(Countries for which the application is not supported. You can
        also provide the two-letter ISO 3166-1 alpha-2 country code.)
    property :countriesSupported, :label => 'countriesSupported', :comment =>
      %(Countries for which the application is supported. You can also
        provide the two-letter ISO 3166-1 alpha-2 country code.)
    property :course, :label => 'course', :comment =>
      %(A sub property of location. The course where this action was
        taken.)
    property :creator, :label => 'creator', :comment =>
      %(The creator/author of this CreativeWork or UserComments. This
        is the same as the Author property for CreativeWork.)
    property :currenciesAccepted, :label => 'currenciesAccepted', :comment =>
      %(The currency accepted \(in <a
        href='http://en.wikipedia.org/wiki/ISO_4217'>ISO 4217 currency
        format</a>\).)
    property :dataset, :label => 'dataset', :comment =>
      %(A dataset contained in a catalog.)
    property :dateCreated, :label => 'dateCreated', :comment =>
      %(The date on which the CreativeWork was created.)
    property :dateModified, :label => 'dateModified', :comment =>
      %(The date on which the CreativeWork was most recently modified.)
    property :datePosted, :label => 'datePosted', :comment =>
      %(Publication date for the job posting.)
    property :datePublished, :label => 'datePublished', :comment =>
      %(Date of first broadcast/publication.)
    property :dateline, :label => 'dateline', :comment =>
      %(The location where the NewsArticle was produced.)
    property :dayOfWeek, :label => 'dayOfWeek', :comment =>
      %(The day of the week for which these opening hours are valid.)
    property :deathDate, :label => 'deathDate', :comment =>
      %(Date of death.)
    property :deliveryLeadTime, :label => 'deliveryLeadTime', :comment =>
      %(The typical delay between the receipt of the order and the
        goods leaving the warehouse.)
    property :deliveryMethod, :label => 'deliveryMethod', :comment =>
      %(A sub property of instrument. The method of delivery)
    property :dependencies, :label => 'dependencies', :comment =>
      %(Prerequisites needed to fulfill steps in article.)
    property :depth, :label => 'depth', :comment =>
      %(The depth of the product.)
    property :description, :label => 'description', :comment =>
      %(A short description of the item.)
    property :device, :label => 'device', :comment =>
      %(Device required to run the application. Used in cases where a
        specific make/model is required to run the application.)
    property :diagnosis, :label => 'diagnosis', :comment =>
      %(One or more alternative conditions considered in the
        differential diagnosis process.)
    property :diagram, :label => 'diagram', :comment =>
      %(An image containing a diagram that illustrates the structure
        and/or its component substructures and/or connections with
        other structures.)
    property :diet, :label => 'diet', :comment =>
      %(A sub property of instrument. The died used in this action.)
    property :dietFeatures, :label => 'dietFeatures', :comment =>
      %(Nutritional information specific to the dietary plan. May
        include dietary recommendations on what foods to avoid, what
        foods to consume, and specific alterations/deviations from the
        USDA or other regulatory body's approved dietary guidelines.)
    property :differentialDiagnosis, :label => 'differentialDiagnosis', :comment =>
      %(One of a set of differential diagnoses for the condition.
        Specifically, a closely-related or competing diagnosis
        typically considered later in the cognitive process whereby
        this medical condition is distinguished from others most
        likely responsible for a similar collection of signs and
        symptoms to reach the most parsimonious diagnosis or diagnoses
        in a patient.)
    property :director, :label => 'director', :comment =>
      %(The director of the movie, TV episode, or series.)
    property :discusses, :label => 'discusses', :comment =>
      %(Specifies the CreativeWork associated with the UserComment.)
    property :discussionUrl, :label => 'discussionUrl', :comment =>
      %(A link to the page containing the comments of the
        CreativeWork.)
    property :distance, :label => 'distance', :comment =>
      %(A sub property of asset. The distance travelled.)
    property :distinguishingSign, :label => 'distinguishingSign', :comment =>
      %(One of a set of signs and symptoms that can be used to
        distinguish this diagnosis from others in the differential
        diagnosis.)
    property :distribution, :label => 'distribution', :comment =>
      %(A downloadable form of this dataset, at a specific location,
        in a specific format.)
    property :domainIncludes, :label => 'domainIncludes', :comment =>
      %(Relates a property to a class that is \(one of\) the type\(s\)
        the property is expected to be used on.)
    property :dosageForm, :label => 'dosageForm', :comment =>
      %(A dosage form in which this drug/supplement is available, e.g.
        'tablet', 'suspension', 'injection'.)
    property :doseSchedule, :label => 'doseSchedule', :comment =>
      %(A dosing schedule for the drug for a given population, either
        observed, recommended, or maximum dose based on the type used.)
    property :doseUnit, :label => 'doseUnit', :comment =>
      %(The unit of the dose, e.g. 'mg'.)
    property :doseValue, :label => 'doseValue', :comment =>
      %(The value of the dose, e.g. 500.)
    property :downloadUrl, :label => 'downloadUrl', :comment =>
      %(If the file can be downloaded, URL to download the binary.)
    property :drainsTo, :label => 'drainsTo', :comment =>
      %(The vasculature that the vein drains into.)
    property :drug, :label => 'drug', :comment =>
      %(A drug in this drug class.)
    property :drugClass, :label => 'drugClass', :comment =>
      %(The class of drug this belongs to \(e.g., statins\).)
    property :drugUnit, :label => 'drugUnit', :comment =>
      %(The unit in which the drug is measured, e.g. '5 mg tablet'.)
    property :duns, :label => 'duns', :comment =>
      %(The Dun & Bradstreet DUNS number for identifying an
        organization or business person.)
    property :duplicateTherapy, :label => 'duplicateTherapy', :comment =>
      %(A therapy that duplicates or overlaps this one.)
    property :duration, :label => 'duration', :comment =>
      %(The duration of the item \(movie, audio recording, event,
        etc.\) in <a href='http://en.wikipedia.org/wiki/ISO_8601'>ISO
        8601 date format</a>.)
    property :durationOfWarranty, :label => 'durationOfWarranty', :comment =>
      %(The duration of the warranty promise. Common unitCode values
        are ANN for year, MON for months, or DAY for days.)
    property :editor, :label => 'editor', :comment =>
      %(Specifies the Person who edited the CreativeWork.)
    property :educationRequirements, :label => 'educationRequirements', :comment =>
      %(Educational background needed for the position.)
    property :educationalAlignment, :label => 'educationalAlignment', :comment =>
      %(An alignment to an established educational framework.)
    property :educationalFramework, :label => 'educationalFramework', :comment =>
      %(The framework to which the resource being described is
        aligned.)
    property :educationalRole, :label => 'educationalRole', :comment =>
      %(An educationalRole of an EducationalAudience)
    property :educationalUse, :label => 'educationalUse', :comment =>
      %(The purpose of a work in the context of education; for
        example, 'assignment', 'group work'.)
    property :elevation, :label => 'elevation', :comment =>
      %(The elevation of a location.)
    property :eligibleCustomerType, :label => 'eligibleCustomerType', :comment =>
      %(The type\(s\) of customers for which the given offer is valid.)
    property :eligibleDuration, :label => 'eligibleDuration', :comment =>
      %(The duration for which the given offer is valid.)
    property :eligibleQuantity, :label => 'eligibleQuantity', :comment =>
      %(The interval and unit of measurement of ordering quantities
        for which the offer or price specification is valid. This
        allows e.g. specifying that a certain freight charge is valid
        only for a certain quantity.)
    property :eligibleRegion, :label => 'eligibleRegion', :comment =>
      %(The ISO 3166-1 \(ISO 3166-1 alpha-2\) or ISO 3166-2 code, or
        the GeoShape for the geo-political region\(s\) for which the
        offer or delivery charge specification is valid.)
    property :eligibleTransactionVolume, :label => 'eligibleTransactionVolume', :comment =>
      %(The transaction volume, in a monetary unit, for which the
        offer or price specification is valid, e.g. for indicating a
        minimal purchasing volume, to express free shipping above a
        certain order volume, or to limit the acceptance of credit
        cards to purchases to a certain minimal amount.)
    property :email, :label => 'email', :comment =>
      %(Email address.)
    property :embedUrl, :label => 'embedUrl', :comment =>
      %(A URL pointing to a player for a specific video. In general,
        this is the information in the <code>src</code> element of an
        <code>embed</code> tag and should not be the same as the
        content of the <code>loc</code> tag. \(previous spelling:
        embedURL\))
    property :employee, :label => 'employee', :comment =>
      %(Someone working for this organization.)
    property :employees, :label => 'employees', :comment =>
      %(People working for this organization. \(legacy spelling; see
        singular form, employee\))
    property :employmentType, :label => 'employmentType', :comment =>
      %(Type of employment \(e.g. full-time, part-time, contract,
        temporary, seasonal, internship\).)
    property :encodesCreativeWork, :label => 'encodesCreativeWork', :comment =>
      %(The creative work encoded by this media object)
    property :encoding, :label => 'encoding', :comment =>
      %(A media object that encode this CreativeWork.)
    property :encodingFormat, :label => 'encodingFormat', :comment =>
      %(mp3, mpeg4, etc.)
    property :encodings, :label => 'encodings', :comment =>
      %(The media objects that encode this creative work \(legacy
        spelling; see singular form, encoding\).)
    property :endDate, :label => 'endDate', :comment =>
      %(The end date and time of the event \(in <a
        href='http://en.wikipedia.org/wiki/ISO_8601'>ISO 8601 date
        format</a>\).)
    property :endTime, :label => 'endTime', :comment =>
      %(When the Action was performed: end time. This is for actions
        that span a period of time. e.g. John wrote a book from
        January to *December*.)
    property :endorsee, :label => 'endorsee', :comment =>
      %(A sub property of participant. The person/organization being
        supported.)
    property :endorsers, :label => 'endorsers', :comment =>
      %(People or organizations that endorse the plan.)
    property :entertainmentBusiness, :label => 'entertainmentBusiness', :comment =>
      %(A sub property of location. The entertainment business where
        the action occurred.)
    property :epidemiology, :label => 'epidemiology', :comment =>
      %(The characteristics of associated patients, such as age,
        gender, race etc.)
    property :episode, :label => 'episode', :comment =>
      %(An episode of a TV series or season.)
    property :episodeNumber, :label => 'episodeNumber', :comment =>
      %(The episode number.)
    property :episodes, :label => 'episodes', :comment =>
      %(The episode of a TV series or season \(legacy spelling; see
        singular form, episode\).)
    property :equal, :label => 'equal', :comment =>
      %(This ordering relation for qualitative values indicates that
        the subject is equal to the object.)
    property :estimatesRiskOf, :label => 'estimatesRiskOf', :comment =>
      %(The condition, complication, or symptom whose risk is being
        estimated.)
    property :event, :label => 'event', :comment =>
      %(Upcoming or past event associated with this place or
        organization.)
    property :events, :label => 'events', :comment =>
      %(Upcoming or past events associated with this place or
        organization \(legacy spelling; see singular form, event\).)
    property :evidenceLevel, :label => 'evidenceLevel', :comment =>
      %(Strength of evidence of the data used to formulate the
        guideline \(enumerated\).)
    property :evidenceOrigin, :label => 'evidenceOrigin', :comment =>
      %(Source of the data used to formulate the guidance, e.g. RCT,
        consensus opinion, etc.)
    property :exercisePlan, :label => 'exercisePlan', :comment =>
      %(A sub property of instrument. The exercise plan used on this
        action.)
    property :exerciseType, :label => 'exerciseType', :comment =>
      %(Type\(s\) of exercise or activity, such as strength training,
        flexibility training, aerobics, cardiac rehabilitation, etc.)
    property :exifData, :label => 'exifData', :comment =>
      %(exif data for this object.)
    property :expectedPrognosis, :label => 'expectedPrognosis', :comment =>
      %(The likely outcome in either the short term or long term of
        the medical condition.)
    property :experienceRequirements, :label => 'experienceRequirements', :comment =>
      %(Description of skills and experience needed for the position.)
    property :expertConsiderations, :label => 'expertConsiderations', :comment =>
      %(Medical expert advice related to the plan.)
    property :expires, :label => 'expires', :comment =>
      %(Date the content expires and is no longer useful or available.
        Useful for videos.)
    property :familyName, :label => 'familyName', :comment =>
      %(Family name. In the U.S., the last name of an Person. This can
        be used along with givenName instead of the Name property.)
    property :fatContent, :label => 'fatContent', :comment =>
      %(The number of grams of fat.)
    property :faxNumber, :label => 'faxNumber', :comment =>
      %(The fax number.)
    property :featureList, :label => 'featureList', :comment =>
      %(Features or modules provided by this application \(and
        possibly required by other applications\).)
    property :fiberContent, :label => 'fiberContent', :comment =>
      %(The number of grams of fiber.)
    property :fileFormat, :label => 'fileFormat', :comment =>
      %(MIME format of the binary \(e.g. application/zip\).)
    property :fileSize, :label => 'fileSize', :comment =>
      %(Size of the application / package \(e.g. 18MB\). In the
        absence of a unit \(MB, KB etc.\), KB will be assumed.)
    property :followee, :label => 'followee', :comment =>
      %(A sub property of object. The person or organization being
        followed.)
    property :follows, :label => 'follows', :comment =>
      %(The most generic uni-directional social relation.)
    property :followup, :label => 'followup', :comment =>
      %(Typical or recommended followup care after the procedure is
        performed.)
    property :foodEstablishment, :label => 'foodEstablishment', :comment =>
      %(A sub property of location. The specific food establishment
        where the action occurreed.)
    property :foodEvent, :label => 'foodEvent', :comment =>
      %(A sub property of location. The specific food event where the
        action occurred.)
    property :foodWarning, :label => 'foodWarning', :comment =>
      %(Any precaution, guidance, contraindication, etc. related to
        consumption of specific foods while taking this drug.)
    property :founder, :label => 'founder', :comment =>
      %(A person who founded this organization.)
    property :founders, :label => 'founders', :comment =>
      %(A person who founded this organization \(legacy spelling; see
        singular form, founder\).)
    property :foundingDate, :label => 'foundingDate', :comment =>
      %(The date that this organization was founded.)
    property :frequency, :label => 'frequency', :comment =>
      %(How often the dose is taken, e.g. 'daily'.)
    property :fromLocation, :label => 'fromLocation', :comment =>
      %(A sub property of location. The original location of the
        object or the agent before the action.)
    property :function, :label => 'function', :comment =>
      %(Function of the anatomical structure.)
    property :functionalClass, :label => 'functionalClass', :comment =>
      %(The degree of mobility the joint allows.)
    property :gender, :label => 'gender', :comment =>
      %(Gender of the person.)
    property :genre, :label => 'genre', :comment =>
      %(Genre of the creative work)
    property :geo, :label => 'geo', :comment =>
      %(The geo coordinates of the place.)
    property :givenName, :label => 'givenName', :comment =>
      %(Given name. In the U.S., the first name of a Person. This can
        be used along with familyName instead of the Name property.)
    property :globalLocationNumber, :label => 'globalLocationNumber', :comment =>
      %(The Global Location Number \(GLN, sometimes also referred to
        as International Location Number or ILN\) of the respective
        organization, person, or place. The GLN is a 13-digit number
        used to identify parties and physical locations.)
    property :greater, :label => 'greater', :comment =>
      %(This ordering relation for qualitative values indicates that
        the subject is greater than the object.)
    property :greaterOrEqual, :label => 'greaterOrEqual', :comment =>
      %(This ordering relation for qualitative values indicates that
        the subject is greater than or equal to the object.)
    property :gtin13, :label => 'gtin13', :comment =>
      %(The GTIN-13 code of the product, or the product to which the
        offer refers. This is equivalent to 13-digit ISBN codes and
        EAN UCC-13. Former 12-digit UPC codes can be converted into a
        GTIN-13 code by simply adding a preceeding zero.)
    property :gtin14, :label => 'gtin14', :comment =>
      %(The GTIN-14 code of the product, or the product to which the
        offer refers.)
    property :gtin8, :label => 'gtin8', :comment =>
      %(The GTIN-8 code of the product, or the product to which the
        offer refers. This code is also known as EAN/UCC-8 or 8-digit
        EAN.)
    property :guideline, :label => 'guideline', :comment =>
      %(A medical guideline related to this entity.)
    property :guidelineDate, :label => 'guidelineDate', :comment =>
      %(Date on which this guideline's recommendation was made.)
    property :guidelineSubject, :label => 'guidelineSubject', :comment =>
      %(The medical conditions, treatments, etc. that are the subject
        of the guideline.)
    property :hasPOS, :label => 'hasPOS', :comment =>
      %(Points-of-Sales operated by the organization or person.)
    property :headline, :label => 'headline', :comment =>
      %(Headline of the article)
    property :healthCondition, :label => 'healthCondition', :comment =>
      %(Expectations for health conditions of target audience)
    property :height, :label => 'height', :comment =>
      %(The height of the item.)
    property :highPrice, :label => 'highPrice', :comment =>
      %(The highest price of all offers available.)
    property :hiringOrganization, :label => 'hiringOrganization', :comment =>
      %(Organization offering the job position.)
    property :homeLocation, :label => 'homeLocation', :comment =>
      %(A contact location for a person's residence.)
    property :honorificPrefix, :label => 'honorificPrefix', :comment =>
      %(An honorific prefix preceding a Person's name such as
        Dr/Mrs/Mr.)
    property :honorificSuffix, :label => 'honorificSuffix', :comment =>
      %(An honorific suffix preceding a Person's name such as M.D.
        /PhD/MSCSW.)
    property :hospitalAffiliation, :label => 'hospitalAffiliation', :comment =>
      %(A hospital with which the physician or office is affiliated.)
    property :howPerformed, :label => 'howPerformed', :comment =>
      %(How the procedure is performed.)
    property :identifyingExam, :label => 'identifyingExam', :comment =>
      %(A physical examination that can identify this sign.)
    property :identifyingTest, :label => 'identifyingTest', :comment =>
      %(A diagnostic test that can identify this sign.)
    property :illustrator, :label => 'illustrator', :comment =>
      %(The illustrator of the book.)
    property :image, :label => 'image', :comment =>
      %(URL of an image of the item.)
    property :imagingTechnique, :label => 'imagingTechnique', :comment =>
      %(Imaging technique used.)
    property :inAlbum, :label => 'inAlbum', :comment =>
      %(The album to which this recording belongs.)
    property :inLanguage, :label => 'inLanguage', :comment =>
      %(The language of the content. please use one of the language
        codes from the <a href='http://tools.ietf.org/html/bcp47'>IETF
        BCP 47 standard.</a>)
    property :inPlaylist, :label => 'inPlaylist', :comment =>
      %(The playlist to which this recording belongs.)
    property :incentives, :label => 'incentives', :comment =>
      %(Description of bonus and commission compensation aspects of
        the job.)
    property :includedRiskFactor, :label => 'includedRiskFactor', :comment =>
      %(A modifiable or non-modifiable risk factor included in the
        calculation, e.g. age, coexisting condition.)
    property :includesObject, :label => 'includesObject', :comment =>
      %(This links to a node or nodes indicating the exact quantity of
        the products included in the offer.)
    property :increasesRiskOf, :label => 'increasesRiskOf', :comment =>
      %(The condition, complication, etc. influenced by this factor.)
    property :indication, :label => 'indication', :comment =>
      %(A factor that indicates use of this therapy for treatment
        and/or prevention of a condition, symptom, etc. For therapies
        such as drugs, indications can include both
        officially-approved indications as well as off-label uses.
        These can be distinguished by using the ApprovedIndication
        subtype of MedicalIndication.)
    property :industry, :label => 'industry', :comment =>
      %(The industry associated with the job position.)
    property :infectiousAgent, :label => 'infectiousAgent', :comment =>
      %(The actual infectious agent, such as a specific bacterium.)
    property :infectiousAgentClass, :label => 'infectiousAgentClass', :comment =>
      %(The class of infectious agent \(bacteria, prion, etc.\) that
        causes the disease.)
    property :ingredients, :label => 'ingredients', :comment =>
      %(An ingredient used in the recipe.)
    property :insertion, :label => 'insertion', :comment =>
      %(The place of attachment of a muscle, or what the muscle moves.)
    property :installUrl, :label => 'installUrl', :comment =>
      %(URL at which the app may be installed, if different from the
        URL of the item.)
    property :instrument, :label => 'instrument', :comment =>
      %(The object that helped the agent perform the action. e.g. John
        wrote a book with *a pen*.)
    property :intensity, :label => 'intensity', :comment =>
      %(Quantitative measure gauging the degree of force involved in
        the exercise, for example, heartbeats per minute. May include
        the velocity of the movement.)
    property :interactingDrug, :label => 'interactingDrug', :comment =>
      %(Another drug that is known to interact with this drug in a way
        that impacts the effect of this drug or causes a risk to the
        patient. Note: disease interactions are typically captured as
        contraindications.)
    property :interactionCount, :label => 'interactionCount', :comment =>
      %(A count of a specific user interactions with this
        item&#x2014;for example, <code>20 UserLikes</code>, <code>5
        UserComments</code>, or <code>300 UserDownloads</code>. The
        user interaction type should be one of the sub types of <a
        href='UserInteraction'>UserInteraction</a>.)
    property :interactivityType, :label => 'interactivityType', :comment =>
      %(The predominant mode of learning supported by the learning
        resource. Acceptable values are 'active', 'expositive', or
        'mixed'.)
    property :inventoryLevel, :label => 'inventoryLevel', :comment =>
      %(The current approximate inventory level for the item or items.)
    property :isAccessoryOrSparePartFor, :label => 'isAccessoryOrSparePartFor', :comment =>
      %(A pointer to another product \(or multiple products\) for
        which this product is an accessory or spare part.)
    property :isAvailableGenerically, :label => 'isAvailableGenerically', :comment =>
      %(True if the drug is available in a generic form \(regardless
        of name\).)
    property :isBasedOnUrl, :label => 'isBasedOnUrl', :comment =>
      %(A resource that was used in the creation of this resource.
        This term can be repeated for multiple sources. For example,
        http://example.com/great-multiplication-intro.html)
    property :isConsumableFor, :label => 'isConsumableFor', :comment =>
      %(A pointer to another product \(or multiple products\) for
        which this product is a consumable.)
    property :isFamilyFriendly, :label => 'isFamilyFriendly', :comment =>
      %(Indicates whether this content is family friendly.)
    property :isPartOf, :label => 'isPartOf', :comment =>
      %(Indicates the collection or gallery to which the item belongs.)
    property :isProprietary, :label => 'isProprietary', :comment =>
      %(True if this item's name is a proprietary/brand name \(vs.
        generic name\).)
    property :isRelatedTo, :label => 'isRelatedTo', :comment =>
      %(A pointer to another, somehow related product \(or multiple
        products\).)
    property :isSimilarTo, :label => 'isSimilarTo', :comment =>
      %(A pointer to another, functionally similar product \(or
        multiple products\).)
    property :isVariantOf, :label => 'isVariantOf', :comment =>
      %(A pointer to a base product from which this product is a
        variant. It is safe to infer that the variant inherits all
        product features from the base model, unless defined locally.
        This is not transitive.)
    property :isbn, :label => 'isbn', :comment =>
      %(The ISBN of the book.)
    property :isicV4, :label => 'isicV4', :comment =>
      %(The International Standard of Industrial Classification of All
        Economic Activities \(ISIC\), Revision 4 code for a particular
        organization, business person, or place.)
    property :itemCondition, :label => 'itemCondition', :comment =>
      %(A predefined value from OfferItemCondition or a textual
        description of the condition of the product or service, or the
        products or services included in the offer.)
    property :itemListElement, :label => 'itemListElement', :comment =>
      %(A single list item.)
    property :itemListOrder, :label => 'itemListOrder', :comment =>
      %(Type of ordering \(e.g. Ascending, Descending, Unordered\).)
    property :itemOffered, :label => 'itemOffered', :comment =>
      %(The item being sold.)
    property :itemReviewed, :label => 'itemReviewed', :comment =>
      %(The item that is being reviewed/rated.)
    property :jobLocation, :label => 'jobLocation', :comment =>
      %(A \(typically single\) geographic location associated with the
        job position.)
    property :jobTitle, :label => 'jobTitle', :comment =>
      %(The job title of the person \(for example, Financial
        Manager\).)
    property :keywords, :label => 'keywords', :comment =>
      %(The keywords/tags used to describe this content.)
    property :knows, :label => 'knows', :comment =>
      %(The most generic bi-directional social/work relation.)
    property :labelDetails, :label => 'labelDetails', :comment =>
      %(Link to the drug's label details.)
    property :landlord, :label => 'landlord', :comment =>
      %(A sub property of participant. The owner of the real estate
        property. Sub property of destination or participant?)
    property :language, :label => 'language', :comment =>
      %(A sub property of instrument. The languaged used on this
        action.)
    property :lastReviewed, :label => 'lastReviewed', :comment =>
      %(Date on which the content on this web page was last reviewed
        for accuracy and/or completeness.)
    property :latitude, :label => 'latitude', :comment =>
      %(The latitude of a location. For example <code>37.42242</code>.)
    property :learningResourceType, :label => 'learningResourceType', :comment =>
      %(The predominant type or kind characterizing the learning
        resource. For example, 'presentation', 'handout'.)
    property :legalName, :label => 'legalName', :comment =>
      %(The official name of the organization, e.g. the registered
        company name.)
    property :legalStatus, :label => 'legalStatus', :comment =>
      %(The drug or supplement's legal status, including any
        controlled substance schedules that apply.)
    property :lender, :label => 'lender', :comment =>
      %(A sub property of participant. The person that lends the
        object being borrowed.)
    property :lesser, :label => 'lesser', :comment =>
      %(This ordering relation for qualitative values indicates that
        the subject is lesser than the object.)
    property :lesserOrEqual, :label => 'lesserOrEqual', :comment =>
      %(This ordering relation for qualitative values indicates that
        the subject is lesser than or equal to the object.)
    property :line, :label => 'line', :comment =>
      %(A line is a point-to-point path consisting of two or more
        points. A line is expressed as a series of two or more point
        objects separated by space.)
    property :location, :label => 'location', :comment =>
      %(The location of the event, organization or action.)
    property :logo, :label => 'logo', :comment =>
      %(URL of an image for the logo of the item.)
    property :longitude, :label => 'longitude', :comment =>
      %(The longitude of a location. For example
        <code>-122.08585</code>.)
    property :loser, :label => 'loser', :comment =>
      %(A sub property of participant. The loser of the action.)
    property :lowPrice, :label => 'lowPrice', :comment =>
      %(The lowest price of all offers available.)
    property :mainContentOfPage, :label => 'mainContentOfPage', :comment =>
      %(Indicates if this web page element is the main subject of the
        page.)
    property :makesOffer, :label => 'makesOffer', :comment =>
      %(A pointer to products or services offered by the organization
        or person.)
    property :manufacturer, :label => 'manufacturer', :comment =>
      %(The manufacturer of the product.)
    property :map, :label => 'map', :comment =>
      %(A URL to a map of the place.)
    property :maps, :label => 'maps', :comment =>
      %(A URL to a map of the place \(legacy spelling; see singular
        form, map\).)
    property :maxPrice, :label => 'maxPrice', :comment =>
      %(The highest price if the price is a range.)
    property :maxValue, :label => 'maxValue', :comment =>
      %(The upper of the product characteristic.)
    property :maximumIntake, :label => 'maximumIntake', :comment =>
      %(Recommended intake of this supplement for a given population
        as defined by a specific recommending authority.)
    property :mechanismOfAction, :label => 'mechanismOfAction', :comment =>
      %(The specific biochemical interaction through which this drug
        or supplement produces its pharmacological effect.)
    property :medicalSpecialty, :label => 'medicalSpecialty', :comment =>
      %(A medical specialty of the provider.)
    property :medicineSystem, :label => 'medicineSystem', :comment =>
      %(The system of medicine that includes this MedicalEntity, for
        example 'evidence-based', 'homeopathic', 'chiropractic', etc.)
    property :member, :label => 'member', :comment =>
      %(A member of this organization.)
    property :memberOf, :label => 'memberOf', :comment =>
      %(An organization to which the person belongs.)
    property :members, :label => 'members', :comment =>
      %(A member of this organization \(legacy spelling; see singular
        form, member\).)
    property :memoryRequirements, :label => 'memoryRequirements', :comment =>
      %(Minimum memory requirements.)
    property :mentions, :label => 'mentions', :comment =>
      %(Indicates that the CreativeWork contains a reference to, but
        is not necessarily about a concept.)
    property :menu, :label => 'menu', :comment =>
      %(Either the actual menu or a URL of the menu.)
    property :minPrice, :label => 'minPrice', :comment =>
      %(The lowest price if the price is a range.)
    property :minValue, :label => 'minValue', :comment =>
      %(The lower value of the product characteristic.)
    property :model, :label => 'model', :comment =>
      %(The model of the product. Use with the URL of a ProductModel
        or a textual representation of the model identifier. The URL
        of the ProductModel can be from an external source. It is
        recommended to additionally provide strong product identifiers
        via the gtin8/gtin13/gtin14 and mpn properties.)
    property :mpn, :label => 'mpn', :comment =>
      %(The Manufacturer Part Number \(MPN\) of the product, or the
        product to which the offer refers.)
    property :musicBy, :label => 'musicBy', :comment =>
      %(The composer of the movie or TV soundtrack.)
    property :musicGroupMember, :label => 'musicGroupMember', :comment =>
      %(A member of the music group&#x2014;for example, John, Paul,
        George, or Ringo.)
    property :naics, :label => 'naics', :comment =>
      %(The North American Industry Classification System \(NAICS\)
        code for a particular organization or business person.)
    property :name, :label => 'name', :comment =>
      %(The name of the item.)
    property :nationality, :label => 'nationality', :comment =>
      %(Nationality of the person.)
    property :naturalProgression, :label => 'naturalProgression', :comment =>
      %(The expected progression of the condition if it is not treated
        and allowed to progress naturally.)
    property :nerve, :label => 'nerve', :comment =>
      %(The underlying innervation associated with the muscle.)
    property :nerveMotor, :label => 'nerveMotor', :comment =>
      %(The neurological pathway extension that involves muscle
        control.)
    property :nonEqual, :label => 'nonEqual', :comment =>
      %(This ordering relation for qualitative values indicates that
        the subject is not equal to the object.)
    property :nonProprietaryName, :label => 'nonProprietaryName', :comment =>
      %(The generic name of this drug or supplement.)
    property :normalRange, :label => 'normalRange', :comment =>
      %(Range of acceptable values for a typical patient, when
        applicable.)
    property :numTracks, :label => 'numTracks', :comment =>
      %(The number of tracks in this album or playlist.)
    property :numberOfEpisodes, :label => 'numberOfEpisodes', :comment =>
      %(The number of episodes in this season or series.)
    property :numberOfPages, :label => 'numberOfPages', :comment =>
      %(The number of pages in the book.)
    property :nutrition, :label => 'nutrition', :comment =>
      %(Nutrition information about the recipe.)
    property :object, :label => 'object', :comment =>
      %(The object upon the action is carried out, whose state is kept
        intact or changed. Also known as the semantic roles patient,
        affected or undergoer \(which change their state\) or theme
        \(which doesn't\). e.g. John read *a book*.)
    property :occupationalCategory, :label => 'occupationalCategory', :comment =>
      %(Category or categories describing the job. Use BLS O*NET-SOC
        taxonomy: http://www.onetcenter.org/taxonomy.html. Ideally
        includes textual label and formal code, with the property
        repeated for each applicable value.)
    property :offerCount, :label => 'offerCount', :comment =>
      %(The number of offers for the product.)
    property :offers, :label => 'offers', :comment =>
      %(An offer to sell this item&#x2014;for example, an offer to
        sell a product, the DVD of a movie, or tickets to an event.)
    property :openingHours, :label => 'openingHours', :comment =>
      %(The opening hours for a business. Opening hours can be
        specified as a weekly time range, starting with days, then
        times per day. Multiple days can be listed with commas ','
        separating each day. Day or time ranges are specified using a
        hyphen '-'.<br />- Days are specified using the following
        two-letter combinations: <code>Mo</code>, <code>Tu</code>,
        <code>We</code>, <code>Th</code>, <code>Fr</code>,
        <code>Sa</code>, <code>Su</code>.<br />- Times are specified
        using 24:00 time. For example, 3pm is specified as
        <code>15:00</code>. <br />- Here is an example: <code>&lt;time
        itemprop=&quot;openingHours&quot; datetime=&quot;Tu,Th
        16:00-20:00&quot;&gt;Tuesdays and Thursdays
        4-8pm&lt;/time&gt;</code>. <br />- If a business is open 7
        days a week, then it can be specified as <code>&lt;time
        itemprop=&quot;openingHours&quot;
        datetime=&quot;Mo-Su&quot;&gt;Monday through Sunday, all
        day&lt;/time&gt;</code>.)
    property :openingHoursSpecification, :label => 'openingHoursSpecification', :comment =>
      %(The opening hours of a certain place.)
    property :opens, :label => 'opens', :comment =>
      %(The opening hour of the place or service on the given day\(s\)
        of the week.)
    property :operatingSystem, :label => 'operatingSystem', :comment =>
      %(Operating systems supported \(Windows 7, OSX 10.6, Android
        1.6\).)
    property :oponent, :label => 'oponent', :comment =>
      %(A sub property of participant. The oponent on this action.)
    property :option, :label => 'option', :comment =>
      %(A sub property of object. The options subject to this action.)
    property :origin, :label => 'origin', :comment =>
      %(The place or point where a muscle arises.)
    property :originatesFrom, :label => 'originatesFrom', :comment =>
      %(The vasculature the lymphatic structure originates, or
        afferents, from.)
    property :outcome, :label => 'outcome', :comment =>
      %(Expected or actual outcomes of the study.)
    property :overdosage, :label => 'overdosage', :comment =>
      %(Any information related to overdose on a drug, including signs
        or symptoms, treatments, contact information for emergency
        response.)
    property :overview, :label => 'overview', :comment =>
      %(Descriptive information establishing the overarching
        theory/philosophy of the plan. May include the rationale for
        the name, the population where the plan first came to
        prominence, etc.)
    property :ownedFrom, :label => 'ownedFrom', :comment =>
      %(The date and time of obtaining the product.)
    property :ownedThrough, :label => 'ownedThrough', :comment =>
      %(The date and time of giving up ownership on the product.)
    property :owns, :label => 'owns', :comment =>
      %(Products owned by the organization or person.)
    property :parent, :label => 'parent', :comment =>
      %(A parent of this person.)
    property :parents, :label => 'parents', :comment =>
      %(A parents of the person \(legacy spelling; see singular form,
        parent\).)
    property :partOfSeason, :label => 'partOfSeason', :comment =>
      %(The season to which this episode belongs.)
    property :partOfSystem, :label => 'partOfSystem', :comment =>
      %(The anatomical or organ system that this structure is part of.)
    property :partOfTVSeries, :label => 'partOfTVSeries', :comment =>
      %(The TV series to which this episode or season belongs.)
    property :participant, :label => 'participant', :comment =>
      %(Other co-agents that participated in the action indirectly.
        e.g. John wrote a book with *Steve*.)
    property :pathophysiology, :label => 'pathophysiology', :comment =>
      %(Changes in the normal mechanical, physical, and biochemical
        functions that are associated with this activity or condition.)
    property :paymentAccepted, :label => 'paymentAccepted', :comment =>
      %(Cash, credit card, etc.)
    property :performer, :label => 'performer', :comment =>
      %(A performer at the event&#x2014;for example, a presenter,
        musician, musical group or actor.)
    property :performerIn, :label => 'performerIn', :comment =>
      %(Event that this person is a performer or participant in.)
    property :performers, :label => 'performers', :comment =>
      %(The main performer or performers of the event&#x2014;for
        example, a presenter, musician, or actor \(legacy spelling;
        see singular form, performer\).)
    property :permissions, :label => 'permissions', :comment =>
      %(Permission\(s\) required to run the app \(for example, a
        mobile app may require full internet access or may run only on
        wifi\).)
    property :phase, :label => 'phase', :comment =>
      %(The phase of the trial.)
    property :photo, :label => 'photo', :comment =>
      %(A photograph of this place.)
    property :photos, :label => 'photos', :comment =>
      %(Photographs of this place \(legacy spelling; see singular
        form, photo\).)
    property :physiologicalBenefits, :label => 'physiologicalBenefits', :comment =>
      %(Specific physiologic benefits associated to the plan.)
    property :playerType, :label => 'playerType', :comment =>
      %(Player type required&#x2014;for example, Flash or Silverlight.)
    property :polygon, :label => 'polygon', :comment =>
      %(A polygon is the area enclosed by a point-to-point path for
        which the starting and ending points are the same. A polygon
        is expressed as a series of four or more spacedelimited points
        where the first and final points are identical.)
    property :population, :label => 'population', :comment =>
      %(Any characteristics of the population used in the study, e.g.
        'males under 65'.)
    property :possibleComplication, :label => 'possibleComplication', :comment =>
      %(A possible unexpected and unfavorable evolution of a medical
        condition. Complications may include worsening of the signs or
        symptoms of the disease, extension of the condition to other
        organ systems, etc.)
    property :possibleTreatment, :label => 'possibleTreatment', :comment =>
      %(A possible treatment to address this condition, sign or
        symptom.)
    property :postOfficeBoxNumber, :label => 'postOfficeBoxNumber', :comment =>
      %(The post offce box number for PO box addresses.)
    property :postOp, :label => 'postOp', :comment =>
      %(A description of the postoperative procedures, care, and/or
        followups for this device.)
    property :postalCode, :label => 'postalCode', :comment =>
      %(The postal code. For example, 94043.)
    property :preOp, :label => 'preOp', :comment =>
      %(A description of the workup, testing, and other preparations
        required before implanting this device.)
    property :predecessorOf, :label => 'predecessorOf', :comment =>
      %(A pointer from a previous, often discontinued variant of the
        product to its newer variant.)
    property :pregnancyCategory, :label => 'pregnancyCategory', :comment =>
      %(Pregnancy category of this drug.)
    property :pregnancyWarning, :label => 'pregnancyWarning', :comment =>
      %(Any precaution, guidance, contraindication, etc. related to
        this drug's use during pregnancy.)
    property :prepTime, :label => 'prepTime', :comment =>
      %(The length of time it takes to prepare the recipe, in <a
        href='http://en.wikipedia.org/wiki/ISO_8601'>ISO 8601 duration
        format</a>.)
    property :preparation, :label => 'preparation', :comment =>
      %(Typical preparation that a patient must undergo before having
        the procedure performed.)
    property :prescribingInfo, :label => 'prescribingInfo', :comment =>
      %(Link to prescribing information for the drug.)
    property :prescriptionStatus, :label => 'prescriptionStatus', :comment =>
      %(Indicates whether this drug is available by prescription or
        over-the-counter.)
    property :price, :label => 'price', :comment =>
      %(The offer price of a product, or of a price component when
        attached to PriceSpecification and its subtypes.)
    property :priceCurrency, :label => 'priceCurrency', :comment =>
      %(The currency \(in 3-letter ISO 4217 format\) of the offer
        price or a price component, when attached to
        PriceSpecification and its subtypes.)
    property :priceRange, :label => 'priceRange', :comment =>
      %(The price range of the business, for example <code>$$$</code>.)
    property :priceSpecification, :label => 'priceSpecification', :comment =>
      %(One or more detailed price specifications, indicating the unit
        price and delivery or payment charges.)
    property :priceType, :label => 'priceType', :comment =>
      %(A short text or acronym indicating multiple price
        specifications for the same offer, e.g. SRP for the suggested
        retail price or INVOICE for the invoice price, mostly used in
        the car industry.)
    property :priceValidUntil, :label => 'priceValidUntil', :comment =>
      %(The date after which the price is no longer available.)
    property :primaryImageOfPage, :label => 'primaryImageOfPage', :comment =>
      %(Indicates the main image on the page)
    property :primaryPrevention, :label => 'primaryPrevention', :comment =>
      %(A preventative therapy used to prevent an initial occurrence
        of the medical condition, such as vaccination.)
    property :printColumn, :label => 'printColumn', :comment =>
      %(The number of the column in which the NewsArticle appears in
        the print edition.)
    property :printEdition, :label => 'printEdition', :comment =>
      %(The edition of the print product in which the NewsArticle
        appears.)
    property :printPage, :label => 'printPage', :comment =>
      %(If this NewsArticle appears in print, this field indicates the
        name of the page on which the article is found. Please note
        that this field is intended for the exact page name \(e.g. A5,
        B18\).)
    property :printSection, :label => 'printSection', :comment =>
      %(If this NewsArticle appears in print, this field indicates the
        print section in which the article appeared.)
    property :procedure, :label => 'procedure', :comment =>
      %(A description of the procedure involved in setting up, using,
        and/or installing the device.)
    property :procedureType, :label => 'procedureType', :comment =>
      %(The type of procedure, for example Surgical, Noninvasive, or
        Percutaneous.)
    property :processorRequirements, :label => 'processorRequirements', :comment =>
      %(Processor architecture required to run the application \(e.g.
        IA64\).)
    property :producer, :label => 'producer', :comment =>
      %(The producer of the movie, TV series, season, or episode, or
        video.)
    property :productID, :label => 'productID', :comment =>
      %(The product identifier, such as ISBN. For example:
        <code>&lt;meta itemprop='productID'
        content='isbn:123-456-789'/&gt;</code>.)
    property :productionCompany, :label => 'productionCompany', :comment =>
      %(The production company or studio that made the movie, TV
        series, season, or episode, or video.)
    property :proficiencyLevel, :label => 'proficiencyLevel', :comment =>
      %(Proficiency needed for this content; expected values:
        'Beginner', 'Expert'.)
    property :programmingLanguage, :label => 'programmingLanguage', :comment =>
      %(The computer programming language.)
    property :programmingModel, :label => 'programmingModel', :comment =>
      %(Indicates whether API is managed or unmanaged.)
    property :proprietaryName, :label => 'proprietaryName', :comment =>
      %(Proprietary name given to the diet plan, typically by its
        originator or creator.)
    property :proteinContent, :label => 'proteinContent', :comment =>
      %(The number of grams of protein.)
    property :provider, :label => 'provider', :comment =>
      %(Specifies the Person or Organization that distributed the
        CreativeWork.)
    property :publicationType, :label => 'publicationType', :comment =>
      %(The type of the medical article, taken from the US NLM MeSH <a
        href=http://www.nlm.nih.gov/mesh/pubtypes.html>publication
        type catalog.)
    property :publisher, :label => 'publisher', :comment =>
      %(The publisher of the creative work.)
    property :publishingPrinciples, :label => 'publishingPrinciples', :comment =>
      %(Link to page describing the editorial principles of the
        organization primarily responsible for the creation of the
        CreativeWork.)
    property :purpose, :label => 'purpose', :comment =>
      %(A goal towards an action is taken. Can be concrete or
        abstract.)
    property :qualifications, :label => 'qualifications', :comment =>
      %(Specific qualifications required for this role.)
    property :query, :label => 'query', :comment =>
      %(A sub property of instrument. The query used on this action.)
    property :question, :label => 'question', :comment =>
      %(A sub property of object. A question.)
    property :rangeIncludes, :label => 'rangeIncludes', :comment =>
      %(Relates a property to a class that constitutes \(one of\) the
        expected type\(s\) for values of the property.)
    property :ratingCount, :label => 'ratingCount', :comment =>
      %(The count of total number of ratings.)
    property :ratingValue, :label => 'ratingValue', :comment =>
      %(The rating for the content.)
    property :realEstateAgent, :label => 'realEstateAgent', :comment =>
      %(A sub property of participant. The real estate agent involved
        in the action.)
    property :recipe, :label => 'recipe', :comment =>
      %(A sub property of instrument. The recipe/instructions used to
        perform the action.)
    property :recipeCategory, :label => 'recipeCategory', :comment =>
      %(The category of the recipe&#x2014;for example, appetizer,
        entree, etc.)
    property :recipeCuisine, :label => 'recipeCuisine', :comment =>
      %(The cuisine of the recipe \(for example, French or Ethopian\).)
    property :recipeInstructions, :label => 'recipeInstructions', :comment =>
      %(The steps to make the dish.)
    property :recipeYield, :label => 'recipeYield', :comment =>
      %(The quantity produced by the recipe \(for example, number of
        people served, number of servings, etc\).)
    property :recipient, :label => 'recipient', :comment =>
      %(A sub property of participant. The participant who is at the
        receiving end of the action.)
    property :recognizingAuthority, :label => 'recognizingAuthority', :comment =>
      %(If applicable, the organization that officially recognizes
        this entity as part of its endorsed system of medicine.)
    property :recommendationStrength, :label => 'recommendationStrength', :comment =>
      %(Strength of the guideline's recommendation \(e.g. 'class I'\).)
    property :recommendedIntake, :label => 'recommendedIntake', :comment =>
      %(Recommended intake of this supplement for a given population
        as defined by a specific recommending authority.)
    property :regionDrained, :label => 'regionDrained', :comment =>
      %(The anatomical or organ system drained by this vessel;
        generally refers to a specific part of an organ.)
    property :regionsAllowed, :label => 'regionsAllowed', :comment =>
      %(The regions where the media is allowed. If not specified, then
        it's assumed to be allowed everywhere. Specify the countries
        in <a href='http://en.wikipedia.org/wiki/ISO_3166'>ISO 3166
        format</a>.)
    property :relatedAnatomy, :label => 'relatedAnatomy', :comment =>
      %(Anatomical systems or structures that relate to the
        superficial anatomy.)
    property :relatedCondition, :label => 'relatedCondition', :comment =>
      %(A medical condition associated with this anatomy.)
    property :relatedDrug, :label => 'relatedDrug', :comment =>
      %(Any other drug related to this one, for example
        commonly-prescribed alternatives.)
    property :relatedLink, :label => 'relatedLink', :comment =>
      %(A link related to this web page, for example to other related
        web pages.)
    property :relatedStructure, :label => 'relatedStructure', :comment =>
      %(Related anatomical structure\(s\) that are not part of the
        system but relate or connect to it, such as vascular bundles
        associated with an organ system.)
    property :relatedTherapy, :label => 'relatedTherapy', :comment =>
      %(A medical therapy related to this anatomy.)
    property :relatedTo, :label => 'relatedTo', :comment =>
      %(The most generic familial relation.)
    property :releaseDate, :label => 'releaseDate', :comment =>
      %(The release date of a product or product model. This can be
        used to distinguish the exact variant of a product.)
    property :releaseNotes, :label => 'releaseNotes', :comment =>
      %(Description of what changed in this version.)
    property :relevantSpecialty, :label => 'relevantSpecialty', :comment =>
      %(If applicable, a medical specialty in which this entity is
        relevant.)
    property :repetitions, :label => 'repetitions', :comment =>
      %(Number of times one should repeat the activity.)
    property :replacee, :label => 'replacee', :comment =>
      %(A sub property of object. The object that is being replaced.)
    property :replacer, :label => 'replacer', :comment =>
      %(A sub property of object. The object that replaces.)
    property :replyToUrl, :label => 'replyToUrl', :comment =>
      %(The URL at which a reply may be posted to the specified
        UserComment.)
    property :representativeOfPage, :label => 'representativeOfPage', :comment =>
      %(Indicates whether this image is representative of the content
        of the page.)
    property :requirements, :label => 'requirements', :comment =>
      %(Component dependency requirements for application. This
        includes runtime environments and shared libraries that are
        not included in the application distribution package, but
        required to run the application \(Examples: DirectX, Java or
        .NET runtime\).)
    property :requiresSubscription, :label => 'requiresSubscription', :comment =>
      %(Indicates if use of the media require a subscription \(either
        paid or free\). Allowed values are <code>true</code> or
        <code>false</code> \(note that an earlier version had 'yes',
        'no'\).)
    property :responsibilities, :label => 'responsibilities', :comment =>
      %(Responsibilities associated with this role.)
    property :restPeriods, :label => 'restPeriods', :comment =>
      %(How often one should break from the activity.)
    property :result, :label => 'result', :comment =>
      %(The result produced in the action. e.g. John wrote *a book*.)
    property :resultReview, :label => 'resultReview', :comment =>
      %(A sub property of result. The review that resulted in the
        performing of the action.)
    property :review, :label => 'review', :comment =>
      %(A review of the item.)
    property :reviewBody, :label => 'reviewBody', :comment =>
      %(The actual body of the review)
    property :reviewCount, :label => 'reviewCount', :comment =>
      %(The count of total number of reviews.)
    property :reviewRating, :label => 'reviewRating', :comment =>
      %(The rating given in this review. Note that reviews can
        themselves be rated. The <code>reviewRating</code> applies to
        rating given by the review. The <code>aggregateRating</code>
        property applies to the review itself, as a creative work.)
    property :reviewedBy, :label => 'reviewedBy', :comment =>
      %(People or organizations that have reviewed the content on this
        web page for accuracy and/or completeness.)
    property :reviews, :label => 'reviews', :comment =>
      %(Review of the item \(legacy spelling; see singular form,
        review\).)
    property :riskFactor, :label => 'riskFactor', :comment =>
      %(A modifiable or non-modifiable factor that increases the risk
        of a patient contracting this condition, e.g. age, coexisting
        condition.)
    property :risks, :label => 'risks', :comment =>
      %(Specific physiologic risks associated to the plan.)
    property :runsTo, :label => 'runsTo', :comment =>
      %(The vasculature the lymphatic structure runs, or efferents,
        to.)
    property :runtime, :label => 'runtime', :comment =>
      %(Runtime platform or script interpreter dependencies \(Example
        - Java v1, Python2.3, .Net Framework 3.0\))
    property :safetyConsideration, :label => 'safetyConsideration', :comment =>
      %(Any potential safety concern associated with the supplement.
        May include interactions with other drugs and foods,
        pregnancy, breastfeeding, known adverse reactions, and
        documented efficacy of the supplement.)
    property :salaryCurrency, :label => 'salaryCurrency', :comment =>
      %(The currency \(coded using ISO 4217,
        http://en.wikipedia.org/wiki/ISO_4217 used for the main salary
        information in this job posting.)
    property :sameAs, :label => 'sameAs', :comment =>
      %(URL of a reference Web page that unambiguously indicates the
        item's identity. E.g. the URL of the item's Wikipedia page,
        Freebase page, or official website.)
    property :sampleType, :label => 'sampleType', :comment =>
      %(Full \(compile ready\) solution, code snippet, inline code,
        scripts, template.)
    property :saturatedFatContent, :label => 'saturatedFatContent', :comment =>
      %(The number of grams of saturated fat.)
    property :scheduledTime, :label => 'scheduledTime', :comment =>
      %(The time the object is scheduled to.)
    property :screenshot, :label => 'screenshot', :comment =>
      %(A link to a screenshot image of the app.)
    property :season, :label => 'season', :comment =>
      %(A season of a TV series.)
    property :seasonNumber, :label => 'seasonNumber', :comment =>
      %(The season number.)
    property :seasons, :label => 'seasons', :comment =>
      %(The seasons of the TV series \(legacy spelling; see singular
        form, season\).)
    property :secondaryPrevention, :label => 'secondaryPrevention', :comment =>
      %(A preventative therapy used to prevent reoccurrence of the
        medical condition after an initial episode of the condition.)
    property :seeks, :label => 'seeks', :comment =>
      %(A pointer to products or services sought by the organization
        or person \(demand\).)
    property :seller, :label => 'seller', :comment =>
      %(The seller.)
    property :sender, :label => 'sender', :comment =>
      %(A sub property of participant. The participant who is at the
        sending end of the action.)
    property :sensoryUnit, :label => 'sensoryUnit', :comment =>
      %(The neurological pathway extension that inputs and sends
        information to the brain or spinal cord.)
    property :serialNumber, :label => 'serialNumber', :comment =>
      %(The serial number or any alphanumeric identifier of a
        particular product. When attached to an offer, it is a
        shortcut for the serial number of the product included in the
        offer.)
    property :seriousAdverseOutcome, :label => 'seriousAdverseOutcome', :comment =>
      %(A possible serious complication and/or serious side effect of
        this therapy. Serious adverse outcomes include those that are
        life-threatening; result in death, disability, or permanent
        damage; require hospitalization or prolong existing
        hospitalization; cause congenital anomalies or birth defects;
        or jeopardize the patient and may require medical or surgical
        intervention to prevent one of the outcomes in this
        definition.)
    property :servesCuisine, :label => 'servesCuisine', :comment =>
      %(The cuisine of the restaurant.)
    property :servingSize, :label => 'servingSize', :comment =>
      %(The serving size, in terms of the number of volume or mass)
    property :sibling, :label => 'sibling', :comment =>
      %(A sibling of the person.)
    property :siblings, :label => 'siblings', :comment =>
      %(A sibling of the person \(legacy spelling; see singular form,
        sibling\).)
    property :signDetected, :label => 'signDetected', :comment =>
      %(A sign detected by the test.)
    property :signOrSymptom, :label => 'signOrSymptom', :comment =>
      %(A sign or symptom of this condition. Signs are objective or
        physically observable manifestations of the medical condition
        while symptoms are the subjective experienceof the medical
        condition.)
    property :significance, :label => 'significance', :comment =>
      %(The significance associated with the superficial anatomy; as
        an example, how characteristics of the superficial anatomy can
        suggest underlying medical conditions or courses of treatment.)
    property :significantLink, :label => 'significantLink', :comment =>
      %(One of the more significant URLs on the page. Typically, these
        are the non-navigation links that are clicked on the most.)
    property :significantLinks, :label => 'significantLinks', :comment =>
      %(The most significant URLs on the page. Typically, these are
        the non-navigation links that are clicked on the most \(legacy
        spelling; see singular form, significantLink\).)
    property :skills, :label => 'skills', :comment =>
      %(Skills required to fulfill this role.)
    property :sku, :label => 'sku', :comment =>
      %(The Stock Keeping Unit \(SKU\), i.e. a merchant-specific
        identifier for a product or service, or the product to which
        the offer refers.)
    property :sodiumContent, :label => 'sodiumContent', :comment =>
      %(The number of milligrams of sodium.)
    property :softwareVersion, :label => 'softwareVersion', :comment =>
      %(Version of the software instance.)
    property :source, :label => 'source', :comment =>
      %(The anatomical or organ system that the artery originates
        from.)
    property :sourceOrganization, :label => 'sourceOrganization', :comment =>
      %(The Organization on whose behalf the creator was working.)
    property :sourcedFrom, :label => 'sourcedFrom', :comment =>
      %(The neurological pathway that originates the neurons.)
    property :spatial, :label => 'spatial', :comment =>
      %(The range of spatial applicability of a dataset, e.g. for a
        dataset of New York weather, the state of New York.)
    property :specialCommitments, :label => 'specialCommitments', :comment =>
      %(Any special commitments associated with this job posting.
        Valid entries include VeteranCommit, MilitarySpouseCommit,
        etc.)
    property :specialty, :label => 'specialty', :comment =>
      %(One of the domain specialities to which this web page's
        content applies.)
    property :sponsor, :label => 'sponsor', :comment =>
      %(Sponsor of the study.)
    property :sportsActivityLocation, :label => 'sportsActivityLocation', :comment =>
      %(A sub property of location. The sports activity location where
        this action occurred.)
    property :sportsEvent, :label => 'sportsEvent', :comment =>
      %(A sub property of location. The sports event where this action
        occurred.)
    property :sportsTeam, :label => 'sportsTeam', :comment =>
      %(A sub property of participant. The sports team that
        participated on this action.)
    property :spouse, :label => 'spouse', :comment =>
      %(The person's spouse.)
    property :stage, :label => 'stage', :comment =>
      %(The stage of the condition, if applicable.)
    property :stageAsNumber, :label => 'stageAsNumber', :comment =>
      %(The stage represented as a number, e.g. 3.)
    property :startDate, :label => 'startDate', :comment =>
      %(The start date and time of the event \(in <a
        href='http://en.wikipedia.org/wiki/ISO_8601'>ISO 8601 date
        format</a>\).)
    property :startTime, :label => 'startTime', :comment =>
      %(When the Action was performed: start time. This is for actions
        that span a period of time. e.g. John wrote a book from
        *January* to December.)
    property :status, :label => 'status', :comment =>
      %(The status of the study \(enumerated\).)
    property :storageRequirements, :label => 'storageRequirements', :comment =>
      %(Storage requirements \(free space required\).)
    property :streetAddress, :label => 'streetAddress', :comment =>
      %(The street address. For example, 1600 Amphitheatre Pkwy.)
    property :strengthUnit, :label => 'strengthUnit', :comment =>
      %(The units of an active ingredient's strength, e.g. mg.)
    property :strengthValue, :label => 'strengthValue', :comment =>
      %(The value of an active ingredient's strength, e.g. 325.)
    property :structuralClass, :label => 'structuralClass', :comment =>
      %(The name given to how bone physically connects to each other.)
    property :study, :label => 'study', :comment =>
      %(A medical study or trial related to this entity.)
    property :studyDesign, :label => 'studyDesign', :comment =>
      %(Specifics about the observational study design \(enumerated\).)
    property :studyLocation, :label => 'studyLocation', :comment =>
      %(The location in which the study is taking/took place.)
    property :studySubject, :label => 'studySubject', :comment =>
      %(A subject of the study, i.e. one of the medical conditions,
        therapies, devices, drugs, etc. investigated by the study.)
    property :subEvent, :label => 'subEvent', :comment =>
      %(An Event that is part of this event. For example, a conference
        event includes many presentations, each are a subEvent of the
        conference.)
    property :subEvents, :label => 'subEvents', :comment =>
      %(Events that are a part of this event. For example, a
        conference event includes many presentations, each are
        subEvents of the conference \(legacy spelling; see singular
        form, subEvent\).)
    property :subStageSuffix, :label => 'subStageSuffix', :comment =>
      %(The substage, e.g. 'a' for Stage IIIa.)
    property :subStructure, :label => 'subStructure', :comment =>
      %(Component \(sub-\)structure\(s\) that comprise this anatomical
        structure.)
    property :subTest, :label => 'subTest', :comment =>
      %(A component test of the panel.)
    property :subtype, :label => 'subtype', :comment =>
      %(A more specific type of the condition, where applicable, for
        example 'Type 1 Diabetes', 'Type 2 Diabetes', or 'Gestational
        Diabetes' for Diabetes.)
    property :successorOf, :label => 'successorOf', :comment =>
      %(A pointer from a newer variant of a product to its previous,
        often discontinued predecessor.)
    property :sugarContent, :label => 'sugarContent', :comment =>
      %(The number of grams of sugar.)
    property :suggestedGender, :label => 'suggestedGender', :comment =>
      %(The gender of the person or audience.)
    property :suggestedMaxAge, :label => 'suggestedMaxAge', :comment =>
      %(Maximal age recommended for viewing content)
    property :suggestedMinAge, :label => 'suggestedMinAge', :comment =>
      %(Minimal age recommended for viewing content)
    property :superEvent, :label => 'superEvent', :comment =>
      %(An event that this event is a part of. For example, a
        collection of individual music performances might each have a
        music festival as their superEvent.)
    property :supplyTo, :label => 'supplyTo', :comment =>
      %(The area to which the artery supplies blood to.)
    property :targetDescription, :label => 'targetDescription', :comment =>
      %(The description of a node in an established educational
        framework.)
    property :targetName, :label => 'targetName', :comment =>
      %(The name of a node in an established educational framework.)
    property :targetPlatform, :label => 'targetPlatform', :comment =>
      %(Type of app development: phone, Metro style, desktop, XBox,
        etc.)
    property :targetPopulation, :label => 'targetPopulation', :comment =>
      %(Characteristics of the population for which this is intended,
        or which typically uses it, e.g. 'adults'.)
    property :targetProduct, :label => 'targetProduct', :comment =>
      %(Target Operating System / Product to which the code applies.
        If applies to several versions, just the product name can be
        used.)
    property :targetUrl, :label => 'targetUrl', :comment =>
      %(The URL of a node in an established educational framework.)
    property :taxID, :label => 'taxID', :comment =>
      %(The Tax / Fiscal ID of the organization or person, e.g. the
        TIN in the US or the CIF/NIF in Spain.)
    property :telephone, :label => 'telephone', :comment =>
      %(The telephone number.)
    property :temporal, :label => 'temporal', :comment =>
      %(The range of temporal applicability of a dataset, e.g. for a
        2011 census dataset, the year 2011 \(in ISO 8601 time interval
        format\).)
    property :text, :label => 'text', :comment =>
      %(The textual content of this CreativeWork.)
    property :thumbnail, :label => 'thumbnail', :comment =>
      %(Thumbnail image for an image or video.)
    property :thumbnailUrl, :label => 'thumbnailUrl', :comment =>
      %(A thumbnail image relevant to the Thing.)
    property :tickerSymbol, :label => 'tickerSymbol', :comment =>
      %(The exchange traded instrument associated with a Corporation
        object. The tickerSymbol is expressed as an exchange and an
        instrument name separated by a space character. For the
        exchange component of the tickerSymbol attribute, we
        reccommend using the controlled vocaulary of Market Identifier
        Codes \(MIC\) specified in ISO15022.)
    property :timeRequired, :label => 'timeRequired', :comment =>
      %(Approximate or typical time it takes to work with or through
        this learning resource for the typical intended target
        audience, e.g. 'P30M', 'P1H25M'.)
    property :tissueSample, :label => 'tissueSample', :comment =>
      %(The type of tissue sample required for the test.)
    property :title, :label => 'title', :comment =>
      %(The title of the job.)
    property :toLocation, :label => 'toLocation', :comment =>
      %(A sub property of location. The final location of the object
        or the agent after the action.)
    property :totalTime, :label => 'totalTime', :comment =>
      %(The total time it takes to prepare and cook the recipe, in <a
        href='http://en.wikipedia.org/wiki/ISO_8601'>ISO 8601 duration
        format</a>.)
    property :track, :label => 'track', :comment =>
      %(A music recording \(track\)&#x2014;usually a single song.)
    property :tracks, :label => 'tracks', :comment =>
      %(A music recording \(track\)&#x2014;usually a single song
        \(legacy spelling; see singular form, track\).)
    property :trailer, :label => 'trailer', :comment =>
      %(The trailer of the movie or TV series, season, or episode.)
    property :transFatContent, :label => 'transFatContent', :comment =>
      %(The number of grams of trans fat.)
    property :transcript, :label => 'transcript', :comment =>
      %(If this MediaObject is an AudioObject or VideoObject, the
        transcript of that object.)
    property :transmissionMethod, :label => 'transmissionMethod', :comment =>
      %(How the disease spreads, either as a route or vector, for
        example 'direct contact', 'Aedes aegypti', etc.)
    property :trialDesign, :label => 'trialDesign', :comment =>
      %(Specifics about the trial design \(enumerated\).)
    property :tributary, :label => 'tributary', :comment =>
      %(The anatomical or organ system that the vein flows into; a
        larger structure that the vein connects to.)
    property :typeOfGood, :label => 'typeOfGood', :comment =>
      %(The product that this structured value is referring to.)
    property :typicalAgeRange, :label => 'typicalAgeRange', :comment =>
      %(The typical range of ages the content's intendedEndUser, for
        example '7-9', '11-'.)
    property :typicalTest, :label => 'typicalTest', :comment =>
      %(A medical test typically performed given this condition.)
    property :unitCode, :label => 'unitCode', :comment =>
      %(The unit of measurement given using the UN/CEFACT Common Code
        \(3 characters\).)
    property :unsaturatedFatContent, :label => 'unsaturatedFatContent', :comment =>
      %(The number of grams of unsaturated fat.)
    property :uploadDate, :label => 'uploadDate', :comment =>
      %(Date when this media object was uploaded to this site.)
    property :url, :label => 'url', :comment =>
      %(URL of the item.)
    property :usedToDiagnose, :label => 'usedToDiagnose', :comment =>
      %(A condition the test is used to diagnose.)
    property :usesDevice, :label => 'usesDevice', :comment =>
      %(Device used to perform the test.)
    property :validFrom, :label => 'validFrom', :comment =>
      %(The beginning of the validity of offer, price specification,
        or opening hours data.)
    property :validThrough, :label => 'validThrough', :comment =>
      %(The end of the validity of offer, price specification, or
        opening hours data.)
    property :value, :label => 'value', :comment =>
      %(The value of the product characteristic.)
    property :valueAddedTaxIncluded, :label => 'valueAddedTaxIncluded', :comment =>
      %(Specifies whether the applicable value-added tax \(VAT\) is
        included in the price specification or not.)
    property :valueReference, :label => 'valueReference', :comment =>
      %(A pointer to a secondary value that provides additional
        information on the original value, e.g. a reference
        temperature.)
    property :vatID, :label => 'vatID', :comment =>
      %(The Value-added Tax ID of the organisation or person.)
    property :vendor, :label => 'vendor', :comment =>
      %(A sub property of participant. The seller.The
        participant/person/organization that sold the object.)
    property :version, :label => 'version', :comment =>
      %(The version of the CreativeWork embodied by a specified
        resource.)
    property :video, :label => 'video', :comment =>
      %(An embedded video object.)
    property :videoFrameSize, :label => 'videoFrameSize', :comment =>
      %(The frame size of the video.)
    property :videoQuality, :label => 'videoQuality', :comment =>
      %(The quality of the video.)
    property :warning, :label => 'warning', :comment =>
      %(Any FDA or other warnings about the drug \(text or URL\).)
    property :warranty, :label => 'warranty', :comment =>
      %(The warranty promise\(s\) included in the offer.)
    property :warrantyPromise, :label => 'warrantyPromise', :comment =>
      %(The warranty promise\(s\) included in the offer.)
    property :warrantyScope, :label => 'warrantyScope', :comment =>
      %(The scope of the warranty promise.)
    property :weight, :label => 'weight', :comment =>
      %(The weight of the product.)
    property :width, :label => 'width', :comment =>
      %(The width of the item.)
    property :winner, :label => 'winner', :comment =>
      %(A sub property of participant. The winner of the action.)
    property :wordCount, :label => 'wordCount', :comment =>
      %(The number of words in the text of the Article.)
    property :workHours, :label => 'workHours', :comment =>
      %(The typical working hours for this job \(e.g. 1st shift, night
        shift, 8am-5pm\).)
    property :workLocation, :label => 'workLocation', :comment =>
      %(A contact location for a person's place of work.)
    property :workload, :label => 'workload', :comment =>
      %(Quantitative measure of the physiologic output of the
        exercise; also referred to as energy expenditure.)
    property :worksFor, :label => 'worksFor', :comment =>
      %(Organizations that the person works for.)
    property :worstRating, :label => 'worstRating', :comment =>
      %(The lowest value allowed in this rating system. If worstRating
        is omitted, 1 is assumed.)
  end
end
