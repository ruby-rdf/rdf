module RDF
  ##
  # Semantically-Interlinked Online Communities (SIOC) vocabulary.
  #
  # @see http://rdfs.org/sioc/spec/
  class SIOC < Vocabulary("http://rdfs.org/sioc/ns#")
    property :about
    property :account_of
    property :administrator_of
    property :attachment
    property :avatar
    property :container_of
    property :content
    property :content_encoded    # @deprecated
    property :created_at         # @deprecated
    property :creator_of
    property :description        # @deprecated
    property :earlier_version
    property :email
    property :email_sha1
    property :feed
    property :first_name         # @deprecated
    property :follows
    property :function_of
    property :group_of           # @deprecated
    property :has_administrator
    property :has_container
    property :has_creator
    property :has_discussion
    property :has_function
    property :has_group          # @deprecated
    property :has_host
    property :has_member
    property :has_moderator
    property :has_modifier
    property :has_owner
    property :has_parent
    property :has_part           # @deprecated
    property :has_reply
    property :has_scope
    property :has_space
    property :has_subscriber
    property :has_usergroup
    property :host_of
    property :id
    property :ip_address
    property :last_activity_date
    property :last_item_date
    property :last_name          # @deprecated
    property :last_reply_date
    property :later_version
    property :latest_version
    property :link
    property :links_to
    property :member_of
    property :moderator_of
    property :modified_at        # @deprecated
    property :modifier_of
    property :name
    property :next_by_date
    property :next_version
    property :note
    property :num_authors
    property :num_items
    property :num_replies
    property :num_threads
    property :num_views
    property :owner_of
    property :parent_of
    property :part_of            # @deprecated
    property :previous_by_date
    property :previous_version
    property :reference          # @deprecated
    property :related_to
    property :reply_of
    property :scope_of
    property :sibling
    property :space_of
    property :subject            # @deprecated
    property :subscriber_of
    property :title              # @deprecated
    property :topic
    property :usergroup_of

    ##
    # Semantically-Interlinked Online Communities (SIOC) types vocabulary.
    #
    # @see http://rdfs.org/sioc/spec/#sec-modules
    class Types < RDF::Vocabulary("http://rdfs.org/sioc/types#")
      # TODO
    end
  end
end
