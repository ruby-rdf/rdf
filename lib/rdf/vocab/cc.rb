# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://creativecommons.org/ns#
require 'rdf'
module RDF
  # @deprecated Please use `RDF::Vocab::CC` from the rdf-vocab gem instead
  class CC < RDF::StrictVocabulary("http://creativecommons.org/ns#")

    # Class definitions
    term :Jurisdiction,
      label: "Jurisdiction".freeze,
      type: "rdfs:Class".freeze
    term :License,
      label: "License".freeze,
      subClassOf: "dc:LicenseDocument".freeze,
      type: "rdfs:Class".freeze
    term :Permission,
      label: "Permission".freeze,
      type: "rdfs:Class".freeze
    term :Prohibition,
      label: "Prohibition".freeze,
      type: "rdfs:Class".freeze
    term :Requirement,
      label: "Requirement".freeze,
      type: "rdfs:Class".freeze
    term :Work,
      label: "Work".freeze,
      type: "rdfs:Class".freeze

    # Property definitions
    property :attributionName,
      domain: "cc:Work".freeze,
      label: "attributionName".freeze,
      range: "rdfs:Literal".freeze,
      type: "rdf:Property".freeze
    property :attributionURL,
      domain: "cc:Work".freeze,
      label: "attributionURL".freeze,
      range: "rdfs:Resource".freeze,
      type: "rdf:Property".freeze
    property :deprecatedOn,
      domain: "cc:License".freeze,
      label: "deprecatedOn".freeze,
      range: "xsd:date".freeze,
      type: "rdf:Property".freeze
    property :jurisdiction,
      domain: "cc:License".freeze,
      label: "jurisdiction".freeze,
      range: "cc:Jurisdiction".freeze,
      type: "rdf:Property".freeze
    property :legalcode,
      domain: "cc:License".freeze,
      label: "legalcode".freeze,
      range: "rdfs:Resource".freeze,
      type: "rdf:Property".freeze
    property :license,
      domain: "cc:Work".freeze,
      label: "license".freeze,
      "owl:sameAs" => %(xhv:license).freeze,
      range: "cc:License".freeze,
      subPropertyOf: "dc:license".freeze,
      type: "rdf:Property".freeze
    property :morePermissions,
      domain: "cc:Work".freeze,
      label: "morePermissions".freeze,
      range: "rdfs:Resource".freeze,
      subPropertyOf: "dc:relation".freeze,
      type: "rdf:Property".freeze
    property :permits,
      domain: "cc:License".freeze,
      label: "permits".freeze,
      range: "cc:Permission".freeze,
      type: "rdf:Property".freeze
    property :prohibits,
      domain: "cc:License".freeze,
      label: "prohibits".freeze,
      range: "cc:Prohibition".freeze,
      type: "rdf:Property".freeze
    property :requires,
      domain: "cc:License".freeze,
      label: "requires".freeze,
      range: "cc:Requirement".freeze,
      type: "rdf:Property".freeze
    property :useGuidelines,
      domain: "cc:Work".freeze,
      label: "useGuidelines".freeze,
      range: "rdfs:Resource".freeze,
      subPropertyOf: "dc:relation".freeze,
      type: "rdf:Property".freeze

    # Extra definitions
    term :Attribution,
      label: "Attribution".freeze,
      type: "cc:Requirement".freeze
    term :CommercialUse,
      label: "CommercialUse".freeze,
      type: "cc:Prohibition".freeze
    term :Copyleft,
      label: "Copyleft".freeze,
      type: "cc:Requirement".freeze
    term :DerivativeWorks,
      label: "DerivativeWorks".freeze,
      type: "cc:Permission".freeze
    term :Distribution,
      label: "Distribution".freeze,
      type: "cc:Permission".freeze
    term :HighIncomeNationUse,
      label: "HighIncomeNationUse".freeze,
      type: "cc:Prohibition".freeze
    term :LesserCopyleft,
      label: "LesserCopyleft".freeze,
      type: "cc:Requirement".freeze
    term :Notice,
      label: "Notice".freeze,
      type: "cc:Requirement".freeze
    term :Reproduction,
      label: "Reproduction".freeze,
      type: "cc:Permission".freeze
    term :ShareAlike,
      label: "ShareAlike".freeze,
      type: "cc:Requirement".freeze
    term :Sharing,
      label: "Sharing".freeze,
      type: "cc:Permission".freeze
    term :SourceCode,
      label: "SourceCode".freeze,
      type: "cc:Requirement".freeze
  end
end
