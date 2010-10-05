require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Vocabulary do
  VOCABS = %w(cc cert dc doap exif foaf geo http owl rdfs rsa rss sioc skos wot xhtml xsd)

  context "when created" do
    it "should require one argument" do
      lambda { RDF::Vocabulary.new }.should raise_error(ArgumentError)
      lambda { RDF::Vocabulary.new("http://purl.org/dc/terms/") }.should_not raise_error
      lambda { RDF::Vocabulary.new("http://purl.org/dc/terms/", "http://purl.org/dc/terms/") }.should raise_error(ArgumentError)
    end
  end

  describe ".[]" do
    subject {RDF::CC}
    it "returns a URI" do
      subject["foo"].should == RDF::URI.new("http://creativecommons.org/ns#foo")
    end
    
    it "returns a URI referencing itself as a vocabulary" do
      subject["foo"].vocab.should == subject
    end
  end
  
  describe "to_uri" do
    subject {RDF::CC}
    it "returns a URI" do
      subject.to_uri.should be_a(RDF::URI)
      subject.to_uri.should == RDF::URI.new("http://creativecommons.org/ns#")
    end
    
    it "returns a URI referencing itself as a vocabulary" do
      subject.to_uri.vocab.should == subject
    end
  end
  
  context "pre-defined vocabularies" do
    it "should support pre-defined vocabularies" do
      VOCABS.map { |s| s.to_s.upcase.to_sym }.each do |vocab|
        lambda { RDF.const_get(vocab) }.should_not raise_error(NameError)
      end
    end

    it "should support Creative Commons (CC)" do
      RDF::CC.should be_a_vocabulary("http://creativecommons.org/ns#")
      RDF::CC.should have_properties("http://creativecommons.org/ns#", %w(attributionName attributionURL deprecatedOn jurisdiction legalcode license morePermissions permits prohibits requires))
    end

    it "should support W3 Authentication Certificate (CERT)" do
      RDF::CERT.should be_a_vocabulary("http://www.w3.org/ns/auth/cert#")
      RDF::CERT.should have_properties("http://www.w3.org/ns/auth/cert#", %w(decimal hex identity public_key))
      RDF::CERT.should have_subclasses("http://www.w3.org/ns/auth/cert#", %w(Certificate Integer Key PGPCertificate PrivateKey PublicKey Signature X509Certificate))
    end

    it "should support Dublin Core (DC)" do
      RDF::DC.should be_a_vocabulary("http://purl.org/dc/terms/")
      RDF::DC.should have_properties("http://purl.org/dc/terms/", %w(abstract accessRights accrualMethod accrualPeriodicity accrualPolicy alternative audience available bibliographicCitation conformsTo contributor coverage created creator date dateAccepted dateCopyrighted dateSubmitted description educationLevel extent format hasFormat hasPart hasVersion identifier instructionalMethod isFormatOf isPartOf isReferencedBy isReplacedBy isRequiredBy isVersionOf issued language license mediator medium modified provenance publisher references relation replaces requires rights rightsHolder source spatial subject tableOfContents temporal title type valid))
    end

    it "should support Description of a Project (DOAP)" do
      RDF::DOAP.should be_a_vocabulary("http://usefulinc.com/ns/doap#")
      RDF::DOAP.should have_properties("http://usefulinc.com/ns/doap#", %w(anon-root audience blog browse bug-database category created description developer documenter download-mirror download-page file-release helper homepage implements language license location mailing-list maintainer module name old-homepage os platform programming-language release repository revision screenshots service-endpoint shortdesc tester translator vendor wiki))
    end

    it "should support Exchangeable Image File Format (EXIF)" do
      RDF::EXIF.should be_a_vocabulary("http://www.w3.org/2003/12/exif/ns#")
      RDF::EXIF.should have_properties("http://www.w3.org/2003/12/exif/ns#", %w(_unknown apertureValue artist bitsPerSample brightnessValue cfaPattern colorSpace componentsConfiguration compressedBitsPerPixel compression contrast copyright customRendered datatype date dateAndOrTime dateTime dateTimeDigitized dateTimeOriginal deviceSettingDescription digitalZoomRatio exifAttribute exifVersion exif_IFD_Pointer exifdata exposureBiasValue exposureIndex exposureMode exposureProgram exposureTime fNumber fileSource flash flashEnergy flashpixVersion focalLength focalLengthIn35mmFilm focalPlaneResolutionUnit focalPlaneXResolution focalPlaneYResolution gainControl geo gpsAltitude gpsAltitudeRef gpsAreaInformation gpsDOP gpsDateStamp gpsDestBearing gpsDestBearingRef gpsDestDistance gpsDestDistanceRef gpsDestLatitude gpsDestLatitudeRef gpsDestLongitude gpsDestLongitudeRef gpsDifferential gpsImgDirection gpsImgDirectionRef gpsInfo gpsInfo_IFD_Pointer gpsLatitude gpsLatitudeRef gpsLongitude gpsLongitudeRef gpsMapDatum gpsMeasureMode gpsProcessingMethod gpsSatellites gpsSpeed gpsSpeedRef gpsStatus gpsTimeStamp gpsTrack gpsTrackRef gpsVersionID height ifdPointer imageConfig imageDataCharacter imageDataStruct imageDescription imageLength imageUniqueID imageWidth interopInfo interoperabilityIndex interoperabilityVersion interoperability_IFD_Pointer isoSpeedRatings jpegInterchangeFormat jpegInterchangeFormatLength length lightSource make makerNote maxApertureValue meter meteringMode mm model oecf orientation photometricInterpretation pictTaking pimBrightness pimColorBalance pimContrast pimInfo pimSaturation pimSharpness pixelXDimension pixelYDimension planarConfiguration primaryChromaticities printImageMatching_IFD_Pointer recOffset referenceBlackWhite relatedFile relatedImageFileFormat relatedImageLength relatedImageWidth relatedSoundFile resolution resolutionUnit rowsPerStrip samplesPerPixel saturation sceneCaptureType sceneType seconds sensingMethod sharpness shutterSpeedValue software spatialFrequencyResponse spectralSensitivity stripByteCounts stripOffsets subSecTime subSecTimeDigitized subSecTimeOriginal subjectArea subjectDistance subjectDistanceRange subjectLocation subseconds tag_number tagid transferFunction userComment userInfo versionInfo whiteBalance whitePoint width xResolution yCbCrCoefficients yCbCrPositioning yCbCrSubSampling yResolution))
    end

    it "should support Friend of a Friend (FOAF)" do
      RDF::FOAF.should be_a_vocabulary("http://xmlns.com/foaf/0.1/")
      RDF::FOAF.should have_properties("http://xmlns.com/foaf/0.1/", %w(account accountName accountServiceHomepage age aimChatID based_near birthday currentProject depiction depicts dnaChecksum familyName family_name firstName fundedBy geekcode gender givenName givenname holdsAccount homepage icqChatID img interest isPrimaryTopicOf jabberID knows lastName logo made maker mbox mbox_sha1sum member membershipClass msnChatID myersBriggs name nick openid page pastProject phone plan primaryTopic publications schoolHomepage sha1 skypeID status surname theme thumbnail tipjar title topic topic_interest weblog workInfoHomepage workplaceHomepage yahooChatID))
    end

    it "should support WGS84 Geo Positioning (GEO)" do
      RDF::GEO.should be_a_vocabulary("http://www.w3.org/2003/01/geo/wgs84_pos#")
      RDF::GEO.should have_properties("http://www.w3.org/2003/01/geo/wgs84_pos#", %w(lat location long alt lat_long))
      RDF::GEO.should have_subclasses("http://www.w3.org/2003/01/geo/wgs84_pos#", %w(SpatialThing Point))
    end

    it "should support Hypertext Transfer Protocol (HTTP)" do
      RDF::HTTP.should be_a_vocabulary("http://www.w3.org/2006/http#")
      RDF::HTTP.should have_properties("http://www.w3.org/2006/http#", %w(abs_path absoluteURI authority body connectionAuthority elementName elementValue fieldName fieldValue header param paramName paramValue request requestURI response responseCode version))
    end

    it "should support Web Ontology Language (OWL)" do
      RDF::OWL.should be_a_vocabulary("http://www.w3.org/2002/07/owl#")
      RDF::OWL.should have_properties("http://www.w3.org/2002/07/owl#", %w(allValuesFrom annotatedProperty annotatedSource annotatedTarget assertionProperty backwardCompatibleWith bottomDataProperty bottomObjectProperty cardinality complementOf datatypeComplementOf deprecated differentFrom disjointUnionOf disjointWith distinctMembers equivalentClass equivalentProperty hasKey hasSelf hasValue imports incompatibleWith intersectionOf inverseOf maxCardinality maxQualifiedCardinality members minCardinality minQualifiedCardinality onClass onDataRange onDatatype onProperties onProperty oneOf priorVersion propertyChainAxiom propertyDisjointWith qualifiedCardinality sameAs someValuesFrom sourceIndividual targetIndividual targetValue topDataProperty topObjectProperty unionOf versionIRI versionInfo withRestrictions))
    end

    it "should support Resource Description Framework (RDF)" do
      RDF.should be_a_vocabulary("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
      RDF.should have_properties("http://www.w3.org/1999/02/22-rdf-syntax-ns#", %w(first object predicate rest subject type value))
    end

    it "should support RDF Schema (RDFS)" do
      RDF::RDFS.should be_a_vocabulary("http://www.w3.org/2000/01/rdf-schema#")
      RDF::RDFS.should have_properties("http://www.w3.org/2000/01/rdf-schema#", %w(comment domain isDefinedBy label member range seeAlso subClassOf subPropertyOf))
      RDF::RDFS.should have_subclasses("http://www.w3.org/2000/01/rdf-schema#", %w(Class Container ContainerMembershipProperty Datatype Literal Resource))
    end

    it "should support W3 RSA Keys (RSA)" do
      RDF::RSA.should be_a_vocabulary("http://www.w3.org/ns/auth/rsa#")
      RDF::RSA.should have_properties("http://www.w3.org/ns/auth/rsa#", %w(modulus private_exponent public_exponent))
      RDF::RSA.should have_subclasses("http://www.w3.org/ns/auth/rsa#", %w(RSAKey RSAPrivateKey RSAPublicKey))
    end

    it "should support RDF Site Summary (RSS)" do
      RDF::RSS.should be_a_vocabulary("http://purl.org/rss/1.0/")
      RDF::RSS.should have_properties("http://purl.org/rss/1.0/", %w(description items link name title url))
    end

    it "should support Semantically-Interlinked Online Communities (SIOC)" do
      RDF::SIOC.should be_a_vocabulary("http://rdfs.org/sioc/ns#")
      RDF::SIOC.should have_properties("http://rdfs.org/sioc/ns#", %w(about account_of administrator_of attachment avatar container_of content content_encoded created_at creator_of description earlier_version email email_sha1 feed first_name follows function_of group_of has_administrator has_container has_creator has_discussion has_function has_group has_host has_member has_moderator has_modifier has_owner has_parent has_part has_reply has_scope has_space has_subscriber has_usergroup host_of id ip_address last_activity_date last_item_date last_name last_reply_date later_version latest_version link links_to member_of moderator_of modified_at modifier_of name next_by_date next_version note num_authors num_items num_replies num_threads num_views owner_of parent_of part_of previous_by_date previous_version reference related_to reply_of scope_of sibling space_of subject subscriber_of title topic usergroup_of))
    end

    it "should support Simple Knowledge Organization System (SKOS)" do
      RDF::SKOS.should be_a_vocabulary("http://www.w3.org/2004/02/skos/core#")
      RDF::SKOS.should have_properties("http://www.w3.org/2004/02/skos/core#", %w(altLabel broadMatch broader broaderTransitive changeNote closeMatch definition editorialNote exactMatch example hasTopConcept hiddenLabel historyNote inScheme mappingRelation member memberList narrowMatch narrower narrowerTransitive notation note prefLabel related relatedMatch scopeNote semanticRelation topConceptOf))
    end

    it "should support Web of Trust (WOT)" do
      RDF::WOT.should be_a_vocabulary("http://xmlns.com/wot/0.1/")
      RDF::WOT.should have_properties("http://xmlns.com/wot/0.1/", %w(assurance encryptedTo encrypter fingerprint hasKey hex_id identity length pubkeyAddress sigdate signed signer sigtime))
    end

    it "should support Extensible HyperText Markup Language (XHTML)" do
      RDF::XHTML.should be_a_vocabulary("http://www.w3.org/1999/xhtml#")
      RDF::XHTML.should have_properties("http://www.w3.org/1999/xhtml#", %w()) # TODO
    end

    it "should support XML Schema (XSD)" do
      RDF::XSD.should be_a_vocabulary("http://www.w3.org/2001/XMLSchema#")
      RDF::XSD.should have_properties("http://www.w3.org/2001/XMLSchema#", %w(NOTATION QName anyURI base64Binary boolean date dateTime decimal double duration float gDay gMonth gMonthDay gYear gYearMonth hexBinary string time ENTITIES ENTITY ID IDREF IDREFS NCName NMTOKEN NMTOKENS Name byte int integer language long negativeInteger nonNegativeInteger nonPositiveInteger normalizedString positiveInteger short token unsignedByte unsignedInt unsignedLong unsignedShort))
    end
  end

  context "ad-hoc vocabularies" do
    it "should support ad-hoc vocabularies" do
      dc = RDF::Vocabulary.new("http://purl.org/dc/terms/")

      dc.creator.should be_kind_of(RDF::URI)
      dc[:creator].should be_kind_of(RDF::URI)
      dc.creator.should eql(RDF::DC.creator)

      dc.title.should be_kind_of(RDF::URI)
      dc[:title].should be_kind_of(RDF::URI)
      dc.title.should eql(RDF::DC.title)
    end
  end
end
