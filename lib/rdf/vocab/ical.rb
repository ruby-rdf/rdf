# This file generated automatically using vocab-fetch from http://www.w3.org/2002/12/cal/icaltzd#
require 'rdf'
module RDF
  class ICAL < StrictVocabulary("http://www.w3.org/2002/12/cal/icaltzd#")

    # Class definitions
    property :Vevent, :label => 'Event', :comment =>
      %(Provide a grouping of component properties that describe an
        event.)
    property :Vtodo, :label => 'To-do', :comment =>
      %(Provide a grouping of calendar properties that describe a
        to-do.)
    property :Vcalendar, :label => 'VCALENDAR'
    property :DomainOf_rrule
    property :List_of_Float
    property :Valarm, :comment =>
      %(Provide a grouping of component properties that define an
        alarm.)
    property :"Value_CAL-ADDRESS"
    property :Value_DATE
    property :Value_DURATION
    property :Value_PERIOD
    property :Value_RECUR
    property :Vfreebusy, :comment =>
      %(Provide a grouping of component properties that describe
        either a request for free/busy time, describe a response to a
        request for free/busy time or describe a published set of busy
        time.)
    property :Vjournal, :comment =>
      %(Provide a grouping of component properties that describe a
        journal entry.)
    property :Vtimezone, :comment =>
      %(Provide a grouping of component properties that defines a time
        zone.)

    # Property definitions
    property :byday, :label => 'BYDAY'
    property :byhour, :label => 'BYHOUR'
    property :byminute, :label => 'BYMINUTE'
    property :bymonth, :label => 'BYMONTH'
    property :bysecond, :label => 'BYSECOND'
    property :bysetpos, :label => 'BYSETPOS'
    property :byweekno, :label => 'BYWEEKNO'
    property :byyearday, :label => 'BYYEARDAY'
    property :count, :label => 'COUNT'
    property :freq, :label => 'FREQ'
    property :interval, :label => 'INTERVAL'
    property :until, :label => 'UNTIL'
    property :wkst, :label => 'WKST'
    property :dtend, :label => 'end', :comment =>
      %(This property specifies the date and time that a calendar
        component ends.)
    property :dtend, :label => 'end', :comment =>
      %(default value type: DATE-TIME)
    property :"X-", :comment =>
      %(value type: TEXT)
    property :"X-", :comment =>
      %(This class of property provides a framework for defining
        non-standard properties.)
    property :action, :comment =>
      %(This property defines the action to be invoked when an alarm
        is triggered.)
    property :action, :comment =>
      %(value type: TEXT)
    property :altrep, :comment =>
      %(To specify an alternate text representation for the property
        value.)
    property :calscale, :comment =>
      %(value type: TEXT)
    property :calscale, :comment =>
      %(This property defines the calendar scale used for the calendar
        information specified in the iCalendar object.)
    property :categories, :comment =>
      %(value type: TEXT)
    property :categories, :comment =>
      %(This property defines the categories for a calendar component.)
    property :class, :comment =>
      %(value type: TEXT)
    property :class, :comment =>
      %(This property defines the access classification for a calendar
        component.)
    property :cn, :comment =>
      %(To specify the common name to be associated with the calendar
        user specified by the property.)
    property :comment, :comment =>
      %(value type: TEXT)
    property :comment, :comment =>
      %(This property specifies non-processing information intended to
        provide a comment to the calendar user.)
    property :completed, :comment =>
      %(This property defines the date and time that a to-do was
        actually completed.)
    property :completed, :comment =>
      %(value type: DATE-TIME)
    property :contact, :comment =>
      %(value type: TEXT)
    property :contact, :comment =>
      %(The property is used to represent contact information or
        alternately a reference to contact information associated with
        the calendar component.)
    property :created, :comment =>
      %(value type: DATE-TIME)
    property :created, :comment =>
      %(This property specifies the date and time that the calendar
        information was created by the calendar user agent in the
        calendar store. Note: This is analogous to the creation date
        and time for a file in the file system.)
    property :cutype, :comment =>
      %(To specify the type of calendar user specified by the
        property.)
    property :delegatedFrom, :comment =>
      %(To specify the calendar users that have delegated their
        participation to the calendar user specified by the property.)
    property :delegatedTo, :comment =>
      %(To specify the calendar users to whom the calendar user
        specified by the property has delegated participation.)
    property :description, :comment =>
      %(value type: TEXT)
    property :description, :comment =>
      %(This property provides a more complete description of the
        calendar component, than that provided by the "SUMMARY"
        property.)
    property :dir, :comment =>
      %(To specify reference to a directory entry associated with the
        calendar user specified by the property.)
    property :dtstamp, :comment =>
      %(value type: DATE-TIME)
    property :dtstamp, :comment =>
      %(The property indicates the date/time that the instance of the
        iCalendar object was created.)
    property :due, :comment =>
      %(default value type: DATE-TIME)
    property :due, :comment =>
      %(This property defines the date and time that a to-do is
        expected to be completed.)
    property :encoding, :comment =>
      %(To specify an alternate inline encoding for the property
        value.)
    property :exdate, :comment =>
      %(default value type: DATE-TIME)
    property :exdate, :comment =>
      %(This property defines the list of date/time exceptions for a
        recurring calendar component.)
    property :fbtype, :comment =>
      %(To specify the free or busy time type.)
    property :fmttype, :comment =>
      %(To specify the content type of a referenced object.)
    property :language, :comment =>
      %(To specify the language for text values in a property or
        property parameter.)
    property :lastModified, :comment =>
      %(The property specifies the date and time that the information
        associated with the calendar component was last revised in the
        calendar store. Note: This is analogous to the modification
        date and time for a file in the file system.)
    property :lastModified, :comment =>
      %(value type: DATE-TIME)
    property :member, :comment =>
      %(To specify the group or list membership of the calendar user
        specified by the property.)
    property :method, :comment =>
      %(value type: TEXT)
    property :method, :comment =>
      %(This property defines the iCalendar object method associated
        with the calendar object.)
    property :partstat, :comment =>
      %(To specify the participation status for the calendar user
        specified by the property.)
    property :percentComplete, :comment =>
      %(This property is used by an assignee or delegatee of a to-do
        to convey the percent completion of a to-do to the Organizer.)
    property :percentComplete, :comment =>
      %(value type: INTEGER)
    property :priority, :comment =>
      %(value type: INTEGER)
    property :priority, :comment =>
      %(The property defines the relative priority for a calendar
        component.)
    property :prodid, :comment =>
      %(value type: TEXT)
    property :prodid, :comment =>
      %(This property specifies the identifier for the product that
        created the iCalendar object.)
    property :range, :comment =>
      %(To specify the effective range of recurrence instances from
        the instance specified by the recurrence identifier specified
        by the property.)
    property :rdate, :comment =>
      %(This property defines the list of date/times for a recurrence
        set.)
    property :rdate, :comment =>
      %(default value type: DATE-TIME)
    property :recurrenceId, :comment =>
      %(default value type: DATE-TIME)
    property :recurrenceId, :comment =>
      %(This property is used in conjunction with the "UID" and
        "SEQUENCE" property to identify a specific instance of a
        recurring "VEVENT", "VTODO" or "VJOURNAL" calendar component.
        The property value is the effective value of the "DTSTART"
        property of the recurrence instance.)
    property :related, :comment =>
      %(To specify the relationship of the alarm trigger with respect
        to the start or end of the calendar component.)
    property :relatedTo, :comment =>
      %(value type: TEXT)
    property :relatedTo, :comment =>
      %(The property is used to represent a relationship or reference
        between one calendar component and another.)
    property :reltype, :comment =>
      %(To specify the type of hierarchical relationship associated
        with the calendar component specified by the property.)
    property :repeat, :comment =>
      %(This property defines the number of time the alarm should be
        repeated, after the initial trigger.)
    property :repeat, :comment =>
      %(value type: INTEGER)
    property :requestStatus, :comment =>
      %(value type: TEXT)
    property :requestStatus, :comment =>
      %(This property defines the status code returned for a
        scheduling request.)
    property :resources, :comment =>
      %(value type: TEXT)
    property :resources, :comment =>
      %(This property defines the equipment or resources anticipated
        for an activity specified by a calendar entity..)
    property :role, :comment =>
      %(To specify the participation role for the calendar user
        specified by the property.)
    property :rsvp, :comment =>
      %(To specify whether there is an expectation of a favor of a
        reply from the calendar user specified by the property value.)
    property :sentBy, :comment =>
      %(To specify the calendar user that is acting on behalf of the
        calendar user specified by the property.)
    property :sequence, :comment =>
      %(value type: integer)
    property :sequence, :comment =>
      %(This property defines the revision sequence number of the
        calendar component within a sequence of revisions.)
    property :status, :comment =>
      %(This property defines the overall status or confirmation for
        the calendar component.)
    property :status, :comment =>
      %(value type: TEXT)
    property :transp, :comment =>
      %(This property defines whether an event is transparent or not
        to busy time searches.)
    property :transp, :comment =>
      %(value type: TEXT)
    property :tzid, :comment =>
      %(This property specifies the text value that uniquely
        identifies the "VTIMEZONE" calendar component.)
    property :tzid, :comment =>
      %(To specify the identifier for the time zone definition for a
        time component in the property value.)
    property :tzid, :comment =>
      %(value type: TEXT)
    property :tzname, :comment =>
      %(This property specifies the customary designation for a time
        zone description.)
    property :tzname, :comment =>
      %(value type: TEXT)
    property :tzoffsetfrom, :comment =>
      %(value type: UTC-OFFSET)
    property :tzoffsetfrom, :comment =>
      %(This property specifies the offset which is in use prior to
        this time zone observance.)
    property :tzoffsetto, :comment =>
      %(value type: UTC-OFFSET)
    property :tzoffsetto, :comment =>
      %(This property specifies the offset which is in use in this
        time zone observance.)
    property :uid, :comment =>
      %(value type: TEXT)
    property :uid, :comment =>
      %(This property defines the persistent, globally unique
        identifier for the calendar component.)
    property :version, :comment =>
      %(This property specifies the identifier corresponding to the
        highest version number or the minimum and maximum range of the
        iCalendar specification that is required in order to interpret
        the iCalendar object.)
    property :version, :comment =>
      %(value type: TEXT)
    property :location, :label => 'location', :comment =>
      %(value type: TEXT)
    property :location, :label => 'location', :comment =>
      %(The property defines the intended venue for the activity
        defined by a calendar component.)
    property :dtstart, :label => 'start', :comment =>
      %(default value type: DATE-TIME)
    property :dtstart, :label => 'start', :comment =>
      %(This property specifies when the calendar component begins.)
    property :summary, :label => 'summary', :comment =>
      %(This property defines a short summary or subject for the
        calendar component.)
    property :summary, :label => 'summary', :comment =>
      %(value type: TEXT)
    property :daylight, :label => 'DAYLIGHT'
    property :standard, :label => 'STANDARD'
    property :attendee, :label => 'attendee', :comment =>
      %(The property defines an "Attendee" within a calendar
        component.)
    property :attendee, :label => 'attendee', :comment =>
      %(value type: CAL-ADDRESS)
    property :attach, :comment =>
      %(default value type: URI)
    property :attach, :comment =>
      %(The property provides the capability to associate a document
        object with a calendar component.)
    property :calAddress
    property :component
    property :duration, :comment =>
      %(The property specifies a positive duration of time.)
    property :duration, :comment =>
      %(value type: DURATION)
    property :exrule, :comment =>
      %(value type: RECUR)
    property :exrule, :comment =>
      %(This property defines a rule or repeating pattern for an
        exception to a recurrence set.)
    property :freebusy, :comment =>
      %(The property defines one or more free or busy time intervals.)
    property :freebusy, :comment =>
      %(value type: PERIOD)
    property :geo, :comment =>
      %(value type: list of FLOAT)
    property :geo, :comment =>
      %(This property specifies information related to the global
        position for the activity specified by a calendar component.)
    property :organizer, :comment =>
      %(value type: CAL-ADDRESS)
    property :organizer, :comment =>
      %(The property defines the organizer for a calendar component.)
    property :rrule, :comment =>
      %(This property defines a rule or repeating pattern for
        recurring events, to-dos, or time zone definitions.)
    property :rrule, :comment =>
      %(value type: RECUR)
    property :trigger, :comment =>
      %(default value type: DURATION)
    property :trigger, :comment =>
      %(This property specifies when an alarm will trigger.)
    property :tzurl, :comment =>
      %(value type: URI)
    property :tzurl, :comment =>
      %(The TZURL provides a means for a VTIMEZONE component to point
        to a network location that can be used to retrieve an up-to-
        date version of itself.)
    property :url, :label => 'see also', :comment =>
      %(value type: URI)
    property :url, :label => 'see also', :comment =>
      %(This property defines a Uniform Resource Locator \(URL\)
        associated with the iCalendar object.)

    # Datatype definitions
    property :"Value_DATE-TIME"
    property :dateTime
  end
end
