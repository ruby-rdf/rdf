# This file generated automatically using vocab-fetch from http://rdfs.org/sioc/ns#
require 'rdf'
module RDF
  class SIOC < StrictVocabulary("http://rdfs.org/sioc/ns#")

    # Class definitions
    property :Community, :label => 'Community', :comment =>
      %(Community is a high-level concept that defines an online
        community and what it consists of.)
    property :Container, :label => 'Container', :comment =>
      %(An area in which content Items are contained.)
    property :Forum, :label => 'Forum', :comment =>
      %(A discussion area on which Posts or entries are made.)
    property :Item, :label => 'Item', :comment =>
      %(An Item is something which can be in a Container.)
    property :Post, :label => 'Post', :comment =>
      %(An article or message that can be posted to a Forum.)
    property :Role, :label => 'Role', :comment =>
      %(A Role is a function of a UserAccount within a scope of a
        particular Forum, Site, etc.)
    property :Site, :label => 'Site', :comment =>
      %(A Site can be the location of an online community or set of
        communities, with UserAccounts and Usergroups creating Items
        in a set of Containers. It can be thought of as a
        web-accessible data Space.)
    property :Space, :label => 'Space', :comment =>
      %(A Space is a place where data resides, e.g. on a website,
        desktop, fileshare, etc.)
    property :Thread, :label => 'Thread', :comment =>
      %(A container for a series of threaded discussion Posts or
        Items.)
    property :UserAccount, :label => 'User Account', :comment =>
      %(A user account in an online community site.)
    property :Usergroup, :label => 'Usergroup', :comment =>
      %(A set of UserAccounts whose owners have a common purpose or
        interest. Can be used for access control purposes.)

    # Property definitions
    property :content, :label => 'content', :comment =>
      %(The content of the Item in plain text format.)
    property :content_encoded, :label => 'content encoded', :comment =>
      %(The encoded content of the Post, contained in CDATA areas.)
    property :created_at, :label => 'created at', :comment =>
      %(When this was created, in ISO 8601 format.)
    property :description, :label => 'description', :comment =>
      %(The content of the Post.)
    property :email_sha1, :label => 'email sha1', :comment =>
      %(An electronic mail address of the UserAccount, encoded using
        SHA1.)
    property :first_name, :label => 'first name', :comment =>
      %(First \(real\) name of this User. Synonyms include given name
        or christian name.)
    property :id, :label => 'id', :comment =>
      %(An identifier of a SIOC concept instance. For example, a user
        ID. Must be unique for instances of each type of SIOC concept
        within the same site.)
    property :ip_address, :label => 'ip address', :comment =>
      %(The IP address used when creating this Item. This can be
        associated with a creator. Some wiki articles list the IP
        addresses for the creator or modifiers when the usernames are
        absent.)
    property :last_activity_date, :label => 'last activity date', :comment =>
      %(The date and time of the last activity associated with a SIOC
        concept instance, and expressed in ISO 8601 format. This could
        be due to a reply Post or Comment, a modification to an Item,
        etc.)
    property :last_item_date, :label => 'last item date', :comment =>
      %(The date and time of the last Post \(or Item\) in a Forum \(or
        a Container\), in ISO 8601 format.)
    property :last_name, :label => 'last name', :comment =>
      %(Last \(real\) name of this user. Synonyms include surname or
        family name.)
    property :last_reply_date, :label => 'last reply date', :comment =>
      %(The date and time of the last reply Post or Comment, which
        could be associated with a starter Item or Post or with a
        Thread, and expressed in ISO 8601 format.)
    property :modified_at, :label => 'modified at', :comment =>
      %(When this was modified, in ISO 8601 format.)
    property :name, :label => 'name', :comment =>
      %(The name of a SIOC concept instance, e.g. a username for a
        UserAccount, group name for a Usergroup, etc.)
    property :note, :label => 'note', :comment =>
      %(A note associated with this resource, for example, if it has
        been edited by a UserAccount.)
    property :num_authors, :label => 'num authors', :comment =>
      %(The number of unique authors \(UserAccounts and unregistered
        posters\) who have contributed to this Item, Thread, Post,
        etc.)
    property :num_items, :label => 'num items', :comment =>
      %(The number of Posts \(or Items\) in a Forum \(or a
        Container\).)
    property :num_replies, :label => 'num replies', :comment =>
      %(The number of replies that this Item, Thread, Post, etc. has.
        Useful for when the reply structure is absent.)
    property :num_threads, :label => 'num threads', :comment =>
      %(The number of Threads \(AKA discussion topics\) in a Forum.)
    property :num_views, :label => 'num views', :comment =>
      %(The number of times this Item, Thread, UserAccount profile,
        etc. has been viewed.)
    property :subject, :label => 'subject', :comment =>
      %(Keyword\(s\) describing subject of the Post.)
    property :title, :label => 'title', :comment =>
      %(This is the title \(subject line\) of the Post. Note that for
        a Post within a threaded discussion that has no parents, it
        would detail the topic thread.)
    property :about, :label => 'about', :comment =>
      %(Specifies that this Item is about a particular resource, e.g.
        a Post describing a book, hotel, etc.)
    property :account_of, :label => 'account of', :comment =>
      %(Refers to the foaf:Agent or foaf:Person who owns this
        sioc:UserAccount.)
    property :addressed_to, :label => 'addressed to', :comment =>
      %(Refers to who \(e.g. a UserAccount, e-mail address, etc.\) a
        particular Item is addressed to.)
    property :administrator_of, :label => 'administrator of', :comment =>
      %(A Site that the UserAccount is an administrator of.)
    property :attachment, :label => 'attachment', :comment =>
      %(The URI of a file attached to an Item.)
    property :avatar, :label => 'avatar', :comment =>
      %(An image or depiction used to represent this UserAccount.)
    property :container_of, :label => 'container of', :comment =>
      %(An Item that this Container contains.)
    property :creator_of, :label => 'creator of', :comment =>
      %(A resource that the UserAccount is a creator of.)
    property :email, :label => 'email', :comment =>
      %(An electronic mail address of the UserAccount.)
    property :embeds_knowledge, :label => 'embeds knowledge', :comment =>
      %(This links Items to embedded statements, facts and structured
        content.)
    property :feed, :label => 'feed', :comment =>
      %(A feed \(e.g. RSS, Atom, etc.\) pertaining to this resource
        \(e.g. for a Forum, Site, UserAccount, etc.\).)
    property :follows, :label => 'follows', :comment =>
      %(Indicates that one UserAccount follows another UserAccount
        \(e.g. for microblog posts or other content item updates\).)
    property :function_of, :label => 'function of', :comment =>
      %(A UserAccount that has this Role.)
    property :group_of, :label => 'group of'
    property :has_administrator, :label => 'has administrator', :comment =>
      %(A UserAccount that is an administrator of this Site.)
    property :has_container, :label => 'has container', :comment =>
      %(The Container to which this Item belongs.)
    property :has_creator, :label => 'has creator', :comment =>
      %(This is the UserAccount that made this resource.)
    property :has_discussion, :label => 'has discussion', :comment =>
      %(The discussion that is related to this Item.)
    property :has_function, :label => 'has function', :comment =>
      %(A Role that this UserAccount has.)
    property :has_group, :label => 'has group'
    property :has_host, :label => 'has host', :comment =>
      %(The Site that hosts this Forum.)
    property :has_member, :label => 'has member', :comment =>
      %(A UserAccount that is a member of this Usergroup.)
    property :has_moderator, :label => 'has moderator', :comment =>
      %(A UserAccount that is a moderator of this Forum.)
    property :has_modifier, :label => 'has modifier', :comment =>
      %(A UserAccount that modified this Item.)
    property :has_owner, :label => 'has owner', :comment =>
      %(A UserAccount that this resource is owned by.)
    property :has_parent, :label => 'has parent', :comment =>
      %(A Container or Forum that this Container or Forum is a child
        of.)
    property :has_part, :label => 'has part', :comment =>
      %(An resource that is a part of this subject.)
    property :has_reply, :label => 'has reply', :comment =>
      %(Points to an Item or Post that is a reply or response to this
        Item or Post.)
    property :has_scope, :label => 'has scope', :comment =>
      %(A resource that this Role applies to.)
    property :has_space, :label => 'has space', :comment =>
      %(A data Space which this resource is a part of.)
    property :has_subscriber, :label => 'has subscriber', :comment =>
      %(A UserAccount that is subscribed to this Container.)
    property :has_usergroup, :label => 'has usergroup', :comment =>
      %(Points to a Usergroup that has certain access to this Space.)
    property :host_of, :label => 'host of', :comment =>
      %(A Forum that is hosted on this Site.)
    property :latest_version, :label => 'latest version', :comment =>
      %(Links to the latest revision of this Item or Post.)
    property :link, :label => 'link', :comment =>
      %(A URI of a document which contains this SIOC object.)
    property :links_to, :label => 'links to', :comment =>
      %(Links extracted from hyperlinks within a SIOC concept, e.g.
        Post or Site.)
    property :member_of, :label => 'member of', :comment =>
      %(A Usergroup that this UserAccount is a member of.)
    property :moderator_of, :label => 'moderator of', :comment =>
      %(A Forum that a UserAccount is a moderator of.)
    property :modifier_of, :label => 'modifier of', :comment =>
      %(An Item that this UserAccount has modified.)
    property :next_by_date, :label => 'next by date', :comment =>
      %(Next Item or Post in a given Container sorted by date.)
    property :next_version, :label => 'next version', :comment =>
      %(Links to the next revision of this Item or Post.)
    property :owner_of, :label => 'owner of', :comment =>
      %(A resource owned by a particular UserAccount, for example, a
        weblog or image gallery.)
    property :parent_of, :label => 'parent of', :comment =>
      %(A child Container or Forum that this Container or Forum is a
        parent of.)
    property :part_of, :label => 'part of', :comment =>
      %(A resource that the subject is a part of.)
    property :previous_by_date, :label => 'previous by date', :comment =>
      %(Previous Item or Post in a given Container sorted by date.)
    property :previous_version, :label => 'previous version', :comment =>
      %(Links to the previous revision of this Item or Post.)
    property :reference, :label => 'reference', :comment =>
      %(Links either created explicitly or extracted implicitly on the
        HTML level from the Post.)
    property :related_to, :label => 'related to', :comment =>
      %(Related Posts for this Post, perhaps determined implicitly
        from topics or references.)
    property :reply_of, :label => 'reply of', :comment =>
      %(Links to an Item or Post which this Item or Post is a reply
        to.)
    property :scope_of, :label => 'scope of', :comment =>
      %(A Role that has a scope of this resource.)
    property :space_of, :label => 'space of', :comment =>
      %(A resource which belongs to this data Space.)
    property :subscriber_of, :label => 'subscriber of', :comment =>
      %(A Container that a UserAccount is subscribed to.)
    property :topic, :label => 'topic', :comment =>
      %(A topic of interest, linking to the appropriate URI, e.g. in
        the Open Directory Project or of a SKOS category.)
    property :usergroup_of, :label => 'usergroup of', :comment =>
      %(A Space that the Usergroup has access to.)
  end
end
