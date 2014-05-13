# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://creativecommons.org/ns#
require 'rdf'
module RDF
  class CC < StrictVocabulary("http://creativecommons.org/ns#")

    # Class definitions
    term :Jurisdiction,
      type: "rdfs:Class".freeze
    term :License,
      subClassOf: "dc:LicenseDocument".freeze,
      type: "rdfs:Class".freeze
    term :Permission,
      type: "rdfs:Class".freeze
    term :Prohibition,
      type: "rdfs:Class".freeze
    term :Requirement,
      type: "rdfs:Class".freeze
    term :Work,
      type: "rdfs:Class".freeze

    # Property definitions
    property :attributionName,
      domain: "cc:Work".freeze,
      range: "rdfs:Literal".freeze,
      type: "rdf:Property".freeze
    property :attributionURL,
      domain: "cc:Work".freeze,
      range: "rdfs:Resource".freeze,
      type: "rdf:Property".freeze
    property :deprecatedOn,
      domain: "cc:License".freeze,
      range: "http://www.w3.org/2001/XMLSchema-datatypes#date".freeze,
      type: "rdf:Property".freeze
    property :jurisdiction,
      domain: "cc:License".freeze,
      range: "cc:Jurisdiction".freeze,
      type: "rdf:Property".freeze
    property :legalcode,
      domain: "cc:License".freeze,
      range: "rdfs:Resource".freeze,
      type: "rdf:Property".freeze
    property :license,
      domain: "cc:Work".freeze,
      "owl:sameAs" => %(xhv:license).freeze,
      range: "cc:License".freeze,
      subPropertyOf: "dc:license".freeze,
      type: "rdf:Property".freeze
    property :morePermissions,
      domain: "cc:Work".freeze,
      range: "rdfs:Resource".freeze,
      subPropertyOf: "dc:relation".freeze,
      type: "rdf:Property".freeze
    property :permits,
      domain: "cc:License".freeze,
      range: "cc:Permission".freeze,
      type: "rdf:Property".freeze
    property :prohibits,
      domain: "cc:License".freeze,
      range: "cc:Prohibition".freeze,
      type: "rdf:Property".freeze
    property :requires,
      domain: "cc:License".freeze,
      range: "cc:Requirement".freeze,
      type: "rdf:Property".freeze
    property :useGuidelines,
      domain: "cc:Work".freeze,
      range: "rdfs:Resource".freeze,
      subPropertyOf: "dc:relation".freeze,
      type: "rdf:Property".freeze

    # Extra definitions
    term :Attribution,
      type: "cc:Requirement".freeze
    term :CommercialUse,
      type: "cc:Prohibition".freeze
    term :Copyleft,
      type: "cc:Requirement".freeze
    term :DerivativeWorks,
      type: "cc:Permission".freeze
    term :Distribution,
      type: "cc:Permission".freeze
    term :HighIncomeNationUse,
      type: "cc:Prohibition".freeze
    term :LesserCopyleft,
      type: "cc:Requirement".freeze
    term :Notice,
      type: "cc:Requirement".freeze
    term :Reproduction,
      type: "cc:Permission".freeze
    term :ShareAlike,
      type: "cc:Requirement".freeze
    term :Sharing,
      type: "cc:Permission".freeze
    term :SourceCode,
      type: "cc:Requirement".freeze
  end
end
