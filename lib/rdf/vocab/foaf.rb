# This file generated automatically using vocab-fetch from http://xmlns.com/foaf/0.1/
require 'rdf'
module RDF
  class FOAF < StrictVocabulary("http://xmlns.com/foaf/0.1/")

    # Class definitions
    property :Agent, :label => 'Agent', :comment =>
      %(An agent \(eg. person, group, software or physical artifact\).)
    property :Agent, :label => 'Agent', :comment =>
      %(An agent \(eg. person, group, software or physical artifact\).)
    property :Document, :label => 'Document', :comment =>
      %(A document.)
    property :Document, :label => 'Document', :comment =>
      %(A document.)
    property :Group, :label => 'Group', :comment =>
      %(A class of Agents.)
    property :Group, :label => 'Group', :comment =>
      %(A class of Agents.)
    property :Image, :label => 'Image', :comment =>
      %(An image.)
    property :Image, :label => 'Image', :comment =>
      %(An image.)
    property :LabelProperty, :label => 'Label Property', :comment =>
      %(A foaf:LabelProperty is any RDF property with texual values
        that serve as labels.)
    property :LabelProperty, :label => 'Label Property', :comment =>
      %(A foaf:LabelProperty is any RDF property with texual values
        that serve as labels.)
    property :OnlineAccount, :label => 'Online Account', :comment =>
      %(An online account.)
    property :OnlineAccount, :label => 'Online Account', :comment =>
      %(An online account.)
    property :OnlineChatAccount, :label => 'Online Chat Account', :comment =>
      %(An online chat account.)
    property :OnlineChatAccount, :label => 'Online Chat Account', :comment =>
      %(An online chat account.)
    property :OnlineEcommerceAccount, :label => 'Online E-commerce Account', :comment =>
      %(An online e-commerce account.)
    property :OnlineEcommerceAccount, :label => 'Online E-commerce Account', :comment =>
      %(An online e-commerce account.)
    property :OnlineGamingAccount, :label => 'Online Gaming Account', :comment =>
      %(An online gaming account.)
    property :OnlineGamingAccount, :label => 'Online Gaming Account', :comment =>
      %(An online gaming account.)
    property :Organization, :label => 'Organization', :comment =>
      %(An organization.)
    property :Organization, :label => 'Organization', :comment =>
      %(An organization.)
    property :Person, :label => 'Person', :comment =>
      %(A person.)
    property :Person, :label => 'Person', :comment =>
      %(A person.)
    property :PersonalProfileDocument, :label => 'PersonalProfileDocument', :comment =>
      %(A personal profile RDF document.)
    property :PersonalProfileDocument, :label => 'PersonalProfileDocument', :comment =>
      %(A personal profile RDF document.)
    property :Project, :label => 'Project', :comment =>
      %(A project \(a collective endeavour of some kind\).)
    property :Project, :label => 'Project', :comment =>
      %(A project \(a collective endeavour of some kind\).)

    # Property definitions
    property :aimChatID, :label => 'AIM chat ID', :comment =>
      %(An AIM chat ID)
    property :dnaChecksum, :label => 'DNA checksum', :comment =>
      %(A checksum for the DNA of some thing. Joke.)
    property :givenname, :label => 'Given name', :comment =>
      %(The given name of some person.)
    property :givenName, :label => 'Given name', :comment =>
      %(The given name of some person.)
    property :icqChatID, :label => 'ICQ chat ID', :comment =>
      %(An ICQ chat ID)
    property :msnChatID, :label => 'MSN chat ID', :comment =>
      %(An MSN chat ID)
    property :skypeID, :label => 'Skype ID', :comment =>
      %(A Skype ID)
    property :surname, :label => 'Surname', :comment =>
      %(The surname of some person.)
    property :yahooChatID, :label => 'Yahoo chat ID', :comment =>
      %(A Yahoo chat ID)
    property :holdsAccount, :label => 'account', :comment =>
      %(Indicates an account held by this agent.)
    property :account, :label => 'account', :comment =>
      %(Indicates an account held by this agent.)
    property :accountName, :label => 'account name', :comment =>
      %(Indicates the name \(identifier\) associated with this online
        account.)
    property :accountServiceHomepage, :label => 'account service homepage', :comment =>
      %(Indicates a homepage of the service provide for this online
        account.)
    property :age, :label => 'age', :comment =>
      %(The age in years of some agent.)
    property :based_near, :label => 'based near', :comment =>
      %(A location that something is based near, for some broadly
        human notion of near.)
    property :birthday, :label => 'birthday', :comment =>
      %(The birthday of this Agent, represented in mm-dd string form,
        eg. '12-31'.)
    property :currentProject, :label => 'current project', :comment =>
      %(A current project this person works on.)
    property :depiction, :label => 'depiction', :comment =>
      %(A depiction of some thing.)
    property :depicts, :label => 'depicts', :comment =>
      %(A thing depicted in this representation.)
    property :familyName, :label => 'familyName', :comment =>
      %(The family name of some person.)
    property :family_name, :label => 'family_name', :comment =>
      %(The family name of some person.)
    property :firstName, :label => 'firstName', :comment =>
      %(The first name of a person.)
    property :focus, :label => 'focus', :comment =>
      %(The underlying or 'focal' entity associated with some
        SKOS-described concept.)
    property :fundedBy, :label => 'funded by', :comment =>
      %(An organization funding a project or person.)
    property :geekcode, :label => 'geekcode', :comment =>
      %(A textual geekcode for this person, see
        http://www.geekcode.com/geek.html)
    property :gender, :label => 'gender', :comment =>
      %(The gender of this Agent \(typically but not necessarily
        'male' or 'female'\).)
    property :homepage, :label => 'homepage', :comment =>
      %(A homepage for some thing.)
    property :img, :label => 'image', :comment =>
      %(An image that can be used to represent some thing \(ie. those
        depictions which are particularly representative of something,
        eg. one's photo on a homepage\).)
    property :interest, :label => 'interest', :comment =>
      %(A page about a topic of interest to this person.)
    property :isPrimaryTopicOf, :label => 'is primary topic of', :comment =>
      %(A document that this thing is the primary topic of.)
    property :jabberID, :label => 'jabber ID', :comment =>
      %(A jabber ID for something.)
    property :knows, :label => 'knows', :comment =>
      %(A person known by this person \(indicating some level of
        reciprocated interaction between the parties\).)
    property :lastName, :label => 'lastName', :comment =>
      %(The last name of a person.)
    property :logo, :label => 'logo', :comment =>
      %(A logo representing some thing.)
    property :made, :label => 'made', :comment =>
      %(Something that was made by this agent.)
    property :maker, :label => 'maker', :comment =>
      %(An agent that made this thing.)
    property :member, :label => 'member', :comment =>
      %(Indicates a member of a Group)
    property :membershipClass, :label => 'membershipClass', :comment =>
      %(Indicates the class of individuals that are a member of a
        Group)
    property :myersBriggs, :label => 'myersBriggs', :comment =>
      %(A Myers Briggs \(MBTI\) personality classification.)
    property :name, :label => 'name', :comment =>
      %(A name for some thing.)
    property :nick, :label => 'nickname', :comment =>
      %(A short informal nickname characterising an agent \(includes
        login identifiers, IRC and other chat nicknames\).)
    property :openid, :label => 'openid', :comment =>
      %(An OpenID for an Agent.)
    property :page, :label => 'page', :comment =>
      %(A page or document about this thing.)
    property :pastProject, :label => 'past project', :comment =>
      %(A project this person has previously worked on.)
    property :mbox, :label => 'personal mailbox', :comment =>
      %(A personal mailbox, ie. an Internet mailbox associated with
        exactly one owner, the first owner of this mailbox. This is a
        'static inverse functional property', in that there is
        \(across time and change\) at most one individual that ever
        has any particular value for foaf:mbox.)
    property :phone, :label => 'phone', :comment =>
      %(A phone, specified using fully qualified tel: URI scheme
        \(refs: http://www.w3.org/Addressing/schemes.html#tel\).)
    property :plan, :label => 'plan', :comment =>
      %(A .plan comment, in the tradition of finger and '.plan' files.)
    property :primaryTopic, :label => 'primary topic', :comment =>
      %(The primary topic of some page or document.)
    property :publications, :label => 'publications', :comment =>
      %(A link to the publications of this person.)
    property :schoolHomepage, :label => 'schoolHomepage', :comment =>
      %(A homepage of a school attended by the person.)
    property :sha1, :label => 'sha1sum (hex)', :comment =>
      %(A sha1sum hash, in hex.)
    property :mbox_sha1sum, :label => 'sha1sum of a personal mailbox URI name', :comment =>
      %(The sha1sum of the URI of an Internet mailbox associated with
        exactly one owner, the first owner of the mailbox.)
    property :status, :label => 'status', :comment =>
      %(A string expressing what the user is happy for the general
        public \(normally\) to know about their current activity.)
    property :theme, :label => 'theme', :comment =>
      %(A theme.)
    property :thumbnail, :label => 'thumbnail', :comment =>
      %(A derived thumbnail image.)
    property :tipjar, :label => 'tipjar', :comment =>
      %(A tipjar document for this agent, describing means for payment
        and reward.)
    property :title, :label => 'title', :comment =>
      %(Title \(Mr, Mrs, Ms, Dr. etc\))
    property :topic, :label => 'topic', :comment =>
      %(A topic of some page or document.)
    property :topic_interest, :label => 'topic_interest', :comment =>
      %(A thing of interest to this person.)
    property :weblog, :label => 'weblog', :comment =>
      %(A weblog of some thing \(whether person, group, company
        etc.\).)
    property :workInfoHomepage, :label => 'work info homepage', :comment =>
      %(A work info homepage of some person; a page about their work
        for some organization.)
    property :workplaceHomepage, :label => 'workplace homepage', :comment =>
      %(A workplace homepage of some person; the homepage of an
        organization they work for.)
    property :aimChatID, :label => 'AIM chat ID', :comment =>
      %(An AIM chat ID)
    property :dnaChecksum, :label => 'DNA checksum', :comment =>
      %(A checksum for the DNA of some thing. Joke.)
    property :givenname, :label => 'Given name', :comment =>
      %(The given name of some person.)
    property :givenName, :label => 'Given name', :comment =>
      %(The given name of some person.)
    property :icqChatID, :label => 'ICQ chat ID', :comment =>
      %(An ICQ chat ID)
    property :msnChatID, :label => 'MSN chat ID', :comment =>
      %(An MSN chat ID)
    property :skypeID, :label => 'Skype ID', :comment =>
      %(A Skype ID)
    property :surname, :label => 'Surname', :comment =>
      %(The surname of some person.)
    property :yahooChatID, :label => 'Yahoo chat ID', :comment =>
      %(A Yahoo chat ID)
    property :accountName, :label => 'account name', :comment =>
      %(Indicates the name \(identifier\) associated with this online
        account.)
    property :age, :label => 'age', :comment =>
      %(The age in years of some agent.)
    property :birthday, :label => 'birthday', :comment =>
      %(The birthday of this Agent, represented in mm-dd string form,
        eg. '12-31'.)
    property :familyName, :label => 'familyName', :comment =>
      %(The family name of some person.)
    property :family_name, :label => 'family_name', :comment =>
      %(The family name of some person.)
    property :firstName, :label => 'firstName', :comment =>
      %(The first name of a person.)
    property :geekcode, :label => 'geekcode', :comment =>
      %(A textual geekcode for this person, see
        http://www.geekcode.com/geek.html)
    property :gender, :label => 'gender', :comment =>
      %(The gender of this Agent \(typically but not necessarily
        'male' or 'female'\).)
    property :jabberID, :label => 'jabber ID', :comment =>
      %(A jabber ID for something.)
    property :lastName, :label => 'lastName', :comment =>
      %(The last name of a person.)
    property :myersBriggs, :label => 'myersBriggs', :comment =>
      %(A Myers Briggs \(MBTI\) personality classification.)
    property :name, :label => 'name', :comment =>
      %(A name for some thing.)
    property :nick, :label => 'nickname', :comment =>
      %(A short informal nickname characterising an agent \(includes
        login identifiers, IRC and other chat nicknames\).)
    property :plan, :label => 'plan', :comment =>
      %(A .plan comment, in the tradition of finger and '.plan' files.)
    property :sha1, :label => 'sha1sum (hex)', :comment =>
      %(A sha1sum hash, in hex.)
    property :mbox_sha1sum, :label => 'sha1sum of a personal mailbox URI name', :comment =>
      %(The sha1sum of the URI of an Internet mailbox associated with
        exactly one owner, the first owner of the mailbox.)
    property :status, :label => 'status', :comment =>
      %(A string expressing what the user is happy for the general
        public \(normally\) to know about their current activity.)
    property :title, :label => 'title', :comment =>
      %(Title \(Mr, Mrs, Ms, Dr. etc\))
    property :holdsAccount, :label => 'account', :comment =>
      %(Indicates an account held by this agent.)
    property :account, :label => 'account', :comment =>
      %(Indicates an account held by this agent.)
    property :accountServiceHomepage, :label => 'account service homepage', :comment =>
      %(Indicates a homepage of the service provide for this online
        account.)
    property :based_near, :label => 'based near', :comment =>
      %(A location that something is based near, for some broadly
        human notion of near.)
    property :currentProject, :label => 'current project', :comment =>
      %(A current project this person works on.)
    property :depiction, :label => 'depiction', :comment =>
      %(A depiction of some thing.)
    property :depicts, :label => 'depicts', :comment =>
      %(A thing depicted in this representation.)
    property :focus, :label => 'focus', :comment =>
      %(The underlying or 'focal' entity associated with some
        SKOS-described concept.)
    property :fundedBy, :label => 'funded by', :comment =>
      %(An organization funding a project or person.)
    property :homepage, :label => 'homepage', :comment =>
      %(A homepage for some thing.)
    property :img, :label => 'image', :comment =>
      %(An image that can be used to represent some thing \(ie. those
        depictions which are particularly representative of something,
        eg. one's photo on a homepage\).)
    property :interest, :label => 'interest', :comment =>
      %(A page about a topic of interest to this person.)
    property :knows, :label => 'knows', :comment =>
      %(A person known by this person \(indicating some level of
        reciprocated interaction between the parties\).)
    property :logo, :label => 'logo', :comment =>
      %(A logo representing some thing.)
    property :made, :label => 'made', :comment =>
      %(Something that was made by this agent.)
    property :maker, :label => 'maker', :comment =>
      %(An agent that made this thing.)
    property :member, :label => 'member', :comment =>
      %(Indicates a member of a Group)
    property :openid, :label => 'openid', :comment =>
      %(An OpenID for an Agent.)
    property :page, :label => 'page', :comment =>
      %(A page or document about this thing.)
    property :pastProject, :label => 'past project', :comment =>
      %(A project this person has previously worked on.)
    property :mbox, :label => 'personal mailbox', :comment =>
      %(A personal mailbox, ie. an Internet mailbox associated with
        exactly one owner, the first owner of this mailbox. This is a
        'static inverse functional property', in that there is
        \(across time and change\) at most one individual that ever
        has any particular value for foaf:mbox.)
    property :phone, :label => 'phone', :comment =>
      %(A phone, specified using fully qualified tel: URI scheme
        \(refs: http://www.w3.org/Addressing/schemes.html#tel\).)
    property :primaryTopic, :label => 'primary topic', :comment =>
      %(The primary topic of some page or document.)
    property :publications, :label => 'publications', :comment =>
      %(A link to the publications of this person.)
    property :schoolHomepage, :label => 'schoolHomepage', :comment =>
      %(A homepage of a school attended by the person.)
    property :theme, :label => 'theme', :comment =>
      %(A theme.)
    property :thumbnail, :label => 'thumbnail', :comment =>
      %(A derived thumbnail image.)
    property :tipjar, :label => 'tipjar', :comment =>
      %(A tipjar document for this agent, describing means for payment
        and reward.)
    property :topic, :label => 'topic', :comment =>
      %(A topic of some page or document.)
    property :topic_interest, :label => 'topic_interest', :comment =>
      %(A thing of interest to this person.)
    property :weblog, :label => 'weblog', :comment =>
      %(A weblog of some thing \(whether person, group, company
        etc.\).)
    property :workInfoHomepage, :label => 'work info homepage', :comment =>
      %(A work info homepage of some person; a page about their work
        for some organization.)
    property :workplaceHomepage, :label => 'workplace homepage', :comment =>
      %(A workplace homepage of some person; the homepage of an
        organization they work for.)
    property :membershipClass, :label => 'membershipClass', :comment =>
      %(Indicates the class of individuals that are a member of a
        Group)
  end
end
