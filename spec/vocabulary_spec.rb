require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Vocabulary do
  VOCABS = %w(cc cert dc doap exif foaf geo ht owl rdf rdfs rsa rss sioc skos vs wot xhtml xsd)
  STRICT_VOCABS = %w(cc cert dc doap exif foaf geo ht owl rdf rdfs rsa rss sioc skos vs wot)

  context "#new" do
    it "should require one argument" do
      expect { RDF::Vocabulary.new }.to raise_error(ArgumentError)
      expect { RDF::Vocabulary.new("http://purl.org/dc/terms/") }.not_to raise_error
      expect { RDF::Vocabulary.new("http://purl.org/dc/terms/", "http://purl.org/dc/terms/") }.to raise_error(ArgumentError)
    end

    subject {RDF::Vocabulary.new('http://example.org/')}
    it "should allow method_missing" do
      expect {subject.foo}.not_to raise_error
      expect(subject.foo).to be_a(RDF::Vocabulary::Term)
    end

    it "should allow []" do
      expect {subject["foo"]}.not_to raise_error
      expect(subject["foo"]).to be_a(RDF::Vocabulary::Term)
    end
  end

  describe "#each" do
    it "inumerates pre-defined vocabularies" do
      expect {|b| RDF::Vocabulary.each(&b)}.to yield_control.at_least(10).times
      expect(RDF::Vocabulary.each.to_a).to include(RDF, RDF::CC, RDF::DC, RDF::RDFS)
    end

    it "inumerates properties of a subclass" do
      expect {|b| RDF::RDFS.each(&b)}.to yield_control.at_least(5).times
      expect(RDF::RDFS.each.to_a).to include(RDF::RDFS.range, RDF::RDFS.subClassOf, RDF::RDFS.domain)
    end
  end

  describe "#to_enum" do
    subject {RDF::RDFS.to_enum}
    it {should be_enumerable}
    its(:count) {should >= 30}
    it "enumerates statements" do
      expect {|b| subject.each(&b)}.to yield_control.at_least(30).times
      subject.each {|s| expect(s).to be_statement}
    end

    it "yields rdfs:label" do
      expect(subject).to include(RDF::Statement(RDF::RDFS.comment, RDF::RDFS.label, RDF::RDFS.label_for("comment")))
    end
    it "yields rdfs:comment" do
      expect(subject.to_a).to include(RDF::Statement(RDF::RDFS.comment, RDF::RDFS.comment, RDF::RDFS.comment_for("comment")))
    end
    it "yields rdfs:isDefinedBy" do
      expect(subject.to_a).to include(RDF::Statement(RDF::RDFS.comment, RDF::RDFS.isDefinedBy, RDF::RDFS.to_uri))
    end
    it "yields rdf:type" do
      expect(subject.to_a).to include(RDF::Statement(RDF::RDFS.comment, RDF.type, RDF.Property))
    end
    it "yields rdfs:domain" do
      expect(subject.to_a).to include(RDF::Statement(RDF::RDFS.comment, RDF::RDFS.domain, RDF::RDFS.Resource))
    end
    it "yields rdfs:range" do
      expect(subject.to_a).to include(RDF::Statement(RDF::RDFS.comment, RDF::RDFS.range, RDF::RDFS.Literal))
    end
  end

  context "strict vocabularies" do
    STRICT_VOCABS.map {|s| RDF.const_get(s.upcase.to_sym)}.each do |vocab|
      context vocab do
        subject {vocab}
        specify {should be_strict}

        it "raises error on unknown property" do
          expect {vocab._unknown_}.to raise_error(NoMethodError)
        end
      end
    end
  end

  context "non-strict vocabularies" do
    (VOCABS - STRICT_VOCABS).map {|s| RDF.const_get(s.upcase.to_sym)}.each do |vocab|
      context vocab do
        subject {vocab}
        specify {should_not be_strict}
      end

      it "allows unknown property" do
        expect(vocab._unknown_).to eq "#{vocab.to_uri}_unknown_"
      end
    end
  end

  context "pre-defined vocabularies" do
    it "should support pre-defined vocabularies" do
      VOCABS.map { |s| s.to_s.upcase.to_sym }.each do |vocab|
        expect { RDF.const_get(vocab) }.not_to raise_error
      end
    end

    it "should expand PName for vocabulary" do
      expect(RDF::Vocabulary.expand_pname("rdfs:")).to eql RDF::RDFS.to_uri
      expect(RDF::Vocabulary.expand_pname("rdfs:label")).to eql RDF::RDFS.label
    end

    it "should support Creative Commons (CC)" do
      expect(RDF::CC).to be_a_vocabulary("http://creativecommons.org/ns#")
      expect(RDF::CC).to have_properties("http://creativecommons.org/ns#", %w(attributionName attributionURL deprecatedOn jurisdiction legalcode license morePermissions permits prohibits requires))
    end

    it "should support W3 Authentication Certificate (CERT)" do
      expect(RDF::CERT).to be_a_vocabulary("http://www.w3.org/ns/auth/cert#")
      expect(RDF::CERT).to have_properties("http://www.w3.org/ns/auth/cert#", %w(hex identity))
      expect(RDF::CERT).to have_terms("http://www.w3.org/ns/auth/cert#", %w(Certificate PGPCertificate PrivateKey PublicKey Signature X509Certificate))
    end

    it "should support Dublin Core (DC)" do
      expect(RDF::DC).to be_a_vocabulary("http://purl.org/dc/terms/")
      expect(RDF::DC).to have_properties("http://purl.org/dc/terms/", %w(abstract accessRights accrualMethod accrualPeriodicity accrualPolicy alternative audience available bibliographicCitation conformsTo contributor coverage created creator date dateAccepted dateCopyrighted dateSubmitted description educationLevel extent format hasFormat hasPart hasVersion identifier instructionalMethod isFormatOf isPartOf isReferencedBy isReplacedBy isRequiredBy isVersionOf issued language license mediator medium modified provenance publisher references relation replaces requires rights rightsHolder source spatial subject tableOfContents temporal title type valid))
    end

    it "should support Description of a Project (DOAP)" do
      expect(RDF::DOAP).to be_a_vocabulary("http://usefulinc.com/ns/doap#")
      expect(RDF::DOAP).to have_properties("http://usefulinc.com/ns/doap#", %w(anon-root audience blog browse bug-database category created description developer documenter download-mirror download-page file-release helper homepage implements language license location mailing-list maintainer module name old-homepage os platform programming-language release repository revision screenshots service-endpoint shortdesc tester translator vendor wiki))
    end

    it "should support Exchangeable Image File Format (EXIF)" do
      expect(RDF::EXIF).to be_a_vocabulary("http://www.w3.org/2003/12/exif/ns#")
      expect(RDF::EXIF).to have_properties("http://www.w3.org/2003/12/exif/ns#", %w(_unknown apertureValue artist bitsPerSample brightnessValue cfaPattern colorSpace componentsConfiguration compressedBitsPerPixel compression contrast copyright customRendered datatype date dateAndOrTime dateTime dateTimeDigitized dateTimeOriginal deviceSettingDescription digitalZoomRatio exifAttribute exifVersion exif_IFD_Pointer exifdata exposureBiasValue exposureIndex exposureMode exposureProgram exposureTime fNumber fileSource flash flashEnergy flashpixVersion focalLength focalLengthIn35mmFilm focalPlaneResolutionUnit focalPlaneXResolution focalPlaneYResolution gainControl geo gpsAltitude gpsAltitudeRef gpsAreaInformation gpsDOP gpsDateStamp gpsDestBearing gpsDestBearingRef gpsDestDistance gpsDestDistanceRef gpsDestLatitude gpsDestLatitudeRef gpsDestLongitude gpsDestLongitudeRef gpsDifferential gpsImgDirection gpsImgDirectionRef gpsInfo gpsInfo_IFD_Pointer gpsLatitude gpsLatitudeRef gpsLongitude gpsLongitudeRef gpsMapDatum gpsMeasureMode gpsProcessingMethod gpsSatellites gpsSpeed gpsSpeedRef gpsStatus gpsTimeStamp gpsTrack gpsTrackRef gpsVersionID height ifdPointer imageConfig imageDataCharacter imageDataStruct imageDescription imageLength imageUniqueID imageWidth interopInfo interoperabilityIndex interoperabilityVersion interoperability_IFD_Pointer isoSpeedRatings jpegInterchangeFormat jpegInterchangeFormatLength length lightSource make makerNote maxApertureValue meter meteringMode mm model oecf orientation photometricInterpretation pictTaking pimBrightness pimColorBalance pimContrast pimInfo pimSaturation pimSharpness pixelXDimension pixelYDimension planarConfiguration primaryChromaticities printImageMatching_IFD_Pointer recOffset referenceBlackWhite relatedFile relatedImageFileFormat relatedImageLength relatedImageWidth relatedSoundFile resolution resolutionUnit rowsPerStrip samplesPerPixel saturation sceneCaptureType sceneType seconds sensingMethod sharpness shutterSpeedValue software spatialFrequencyResponse spectralSensitivity stripByteCounts stripOffsets subSecTime subSecTimeDigitized subSecTimeOriginal subjectArea subjectDistance subjectDistanceRange subjectLocation subseconds tag_number tagid transferFunction userComment userInfo versionInfo whiteBalance whitePoint width xResolution yCbCrCoefficients yCbCrPositioning yCbCrSubSampling yResolution))
    end

    it "should support Friend of a Friend (FOAF)" do
      expect(RDF::FOAF).to be_a_vocabulary("http://xmlns.com/foaf/0.1/")
      expect(RDF::FOAF).to have_properties("http://xmlns.com/foaf/0.1/", %w(account accountName accountServiceHomepage age aimChatID based_near birthday currentProject depiction depicts dnaChecksum familyName family_name firstName fundedBy geekcode gender givenName givenname holdsAccount homepage icqChatID img interest isPrimaryTopicOf jabberID knows lastName logo made maker mbox mbox_sha1sum member membershipClass msnChatID myersBriggs name nick openid page pastProject phone plan primaryTopic publications schoolHomepage sha1 skypeID status surname theme thumbnail tipjar title topic topic_interest weblog workInfoHomepage workplaceHomepage yahooChatID))
    end

    it "should support WGS84 Geo Positioning (GEO)" do
      expect(RDF::GEO).to be_a_vocabulary("http://www.w3.org/2003/01/geo/wgs84_pos#")
      expect(RDF::GEO).to have_properties("http://www.w3.org/2003/01/geo/wgs84_pos#", %w(lat location long lat_long))
      expect(RDF::GEO).to have_terms("http://www.w3.org/2003/01/geo/wgs84_pos#", %w(SpatialThing Point))
    end

    it "should support Hypertext Transfer Protocol (HT)" do
      expect(RDF::HT).to be_a_vocabulary("http://www.w3.org/2006/http#")
      expect(RDF::HT).to have_properties("http://www.w3.org/2006/http#", %w(abs_path absoluteURI authority body connectionAuthority elementName elementValue fieldName fieldValue header param paramName paramValue request requestURI response responseCode version))
    end

    it "should support Web Ontology Language (OWL)" do
      expect(RDF::OWL).to be_a_vocabulary("http://www.w3.org/2002/07/owl#")
      expect(RDF::OWL).to have_properties("http://www.w3.org/2002/07/owl#", %w(allValuesFrom annotatedProperty annotatedSource annotatedTarget assertionProperty backwardCompatibleWith bottomDataProperty bottomObjectProperty cardinality complementOf datatypeComplementOf deprecated differentFrom disjointUnionOf disjointWith distinctMembers equivalentClass equivalentProperty hasKey hasSelf hasValue imports incompatibleWith intersectionOf inverseOf maxCardinality maxQualifiedCardinality members minCardinality minQualifiedCardinality onClass onDataRange onDatatype onProperties onProperty oneOf priorVersion propertyChainAxiom propertyDisjointWith qualifiedCardinality sameAs someValuesFrom sourceIndividual targetIndividual targetValue topDataProperty topObjectProperty unionOf versionIRI versionInfo withRestrictions))
    end

    it "should support Resource Description Framework (RDF)" do
      expect(RDF).to be_a_vocabulary("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
      expect(RDF).to have_properties("http://www.w3.org/1999/02/22-rdf-syntax-ns#", %w(first object predicate rest subject type value))
      expect(RDF).to have_terms("http://www.w3.org/1999/02/22-rdf-syntax-ns#", %w(datatype Description parseType ID nodeID li))
      expect(RDF).to have_terms("http://www.w3.org/1999/02/22-rdf-syntax-ns#", %w(datatype Description parseType ID nodeID li))
      %w(first object predicate rest subject type value).each do |p|
        expect(RDF.send(p)).to eq RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns##{p}")
      end
    end

    it "should support RDF Schema (RDFS)" do
      expect(RDF::RDFS).to be_a_vocabulary("http://www.w3.org/2000/01/rdf-schema#")
      expect(RDF::RDFS).to have_properties("http://www.w3.org/2000/01/rdf-schema#", %w(comment domain isDefinedBy label member range seeAlso subClassOf subPropertyOf))
      expect(RDF::RDFS).to have_terms("http://www.w3.org/2000/01/rdf-schema#", %w(Class Container ContainerMembershipProperty Datatype Literal Resource))
    end

    it "should support W3 RSA Keys (RSA)" do
      expect(RDF::RSA).to be_a_vocabulary("http://www.w3.org/ns/auth/rsa#")
      expect(RDF::RSA).to have_properties("http://www.w3.org/ns/auth/rsa#", %w(modulus private_exponent public_exponent))
      expect(RDF::RSA).to have_terms("http://www.w3.org/ns/auth/rsa#", %w(RSAKey RSAPrivateKey RSAPublicKey))
    end

    it "should support RDF Site Summary (RSS)" do
      expect(RDF::RSS).to be_a_vocabulary("http://purl.org/rss/1.0/")
      expect(RDF::RSS).to have_properties("http://purl.org/rss/1.0/", %w(description items link name title url))
    end

    it "should support Semantically-Interlinked Online Communities (SIOC)" do
      expect(RDF::SIOC).to be_a_vocabulary("http://rdfs.org/sioc/ns#")
      expect(RDF::SIOC).to have_properties("http://rdfs.org/sioc/ns#", %w(about account_of administrator_of attachment avatar container_of content content_encoded created_at creator_of description previous_version email email_sha1 feed first_name follows function_of group_of has_administrator has_container has_creator has_discussion has_function has_group has_host has_member has_moderator has_modifier has_owner has_parent has_part has_reply has_scope has_space has_subscriber has_usergroup host_of id ip_address last_activity_date last_item_date last_name last_reply_date latest_version link links_to member_of moderator_of modified_at modifier_of name next_by_date next_version note num_authors num_items num_replies num_threads num_views owner_of parent_of part_of previous_by_date previous_version reference related_to reply_of scope_of space_of subject subscriber_of title topic usergroup_of))
    end

    it "should support Simple Knowledge Organization System (SKOS)" do
      expect(RDF::SKOS).to be_a_vocabulary("http://www.w3.org/2004/02/skos/core#")
      expect(RDF::SKOS).to have_properties("http://www.w3.org/2004/02/skos/core#", %w(altLabel broadMatch broader broaderTransitive changeNote closeMatch definition editorialNote exactMatch example hasTopConcept hiddenLabel historyNote inScheme mappingRelation member memberList narrowMatch narrower narrowerTransitive notation note prefLabel related relatedMatch scopeNote semanticRelation topConceptOf))
    end

    it "should support Web of Trust (WOT)" do
      expect(RDF::WOT).to be_a_vocabulary("http://xmlns.com/wot/0.1/")
      expect(RDF::WOT).to have_properties("http://xmlns.com/wot/0.1/", %w(assurance encryptedTo encrypter fingerprint hasKey hex_id identity length pubkeyAddress sigdate signed signer sigtime))
    end

    it "should support Extensible HyperText Markup Language (XHTML)" do
      expect(RDF::XHTML).to be_a_vocabulary("http://www.w3.org/1999/xhtml#")
      expect(RDF::XHTML).to have_properties("http://www.w3.org/1999/xhtml#", %w()) # TODO
    end

    it "should support XML Schema (XSD)" do
      expect(RDF::XSD).to be_a_vocabulary("http://www.w3.org/2001/XMLSchema#")
      expect(RDF::XSD).to have_properties("http://www.w3.org/2001/XMLSchema#", %w(anyURI base64Binary boolean date dateTime decimal double duration float gDay gMonth gMonthDay gYear gYearMonth hexBinary string time NCName NMTOKEN Name byte int integer language long negativeInteger nonNegativeInteger nonPositiveInteger normalizedString positiveInteger short token unsignedByte unsignedInt unsignedLong unsignedShort))
    end

    it "should support VOID" do
      expect(RDF::VOID).to be_a_vocabulary("http://rdfs.org/ns/void#")
      expect(RDF::VOID).to have_properties("http://rdfs.org/ns/void#", %w(Dataset DatasetDescription Linkset TechnicalFeature dataDump objectsTarget subjectsTarget target uriSpace linkPredicate class classPartition classes distinctObjects distinctSubjects exampleResource feature uriRegexPattern sparqlEndpoint uriLookupEndpoint subset inDataset documents entities properties triples openSearchDescription property propertyPartition rootResource vocabulary uriSpace))
      expect(RDF::VOID.label_for("property")).to eq "property"
      expect(RDF::VOID.comment_for("property")).to eq %(The rdf:Property that is the predicate of all triples in a property-based partition.)
    end

    it "should support W3C Media Annotation Ontology" do
      expect(RDF::MA).to be_a_vocabulary("http://www.w3.org/ns/ma-ont#")
      expect(RDF::MA).to have_properties("http://www.w3.org/ns/ma-ont#", %w(isRatingOf alternativeTitle averageBitRate collectionName copyright createdIn creationDate date depictsFictionalLocation description duration editDate features fragmentName frameHeight frameRate frameSizeUnit frameWidth hasAccessConditions hasAudioDescription hasCaptioning hasChapter hasClassification hasClassificationSystem hasCompression hasContributor hasCreator hasFormat hasFragment hasGenre hasKeyword hasLanguage hasLocationCoordinateSystem hasNamedFragment hasPermissions hasPolicy hasPublished hasPublisher hasRating hasRatingSystem hasRelatedImage hasRelatedLocation hasRelatedResource hasSigning hasSource hasSubtitling hasTargetAudience hasTrack isChapterOf isCopyrightedBy isLocationRelatedTo isMemberOf isProvidedBy isRelatedTo isSourceOf isTargetAudienceOf locationAltitude locationLatitude locationLongitude locationName locator mainOriginalTitle numberOfTracks ratingScaleMax ratingScaleMin ratingValue recordDate releaseDate samplingRate title trackName))
    end

    describe "#properties" do
      context "when iterating over vocabularies" do
        it "includes properties only from the selected vocabulary" do
          [RDF::RDFS, RDF::FOAF].each do |v|
            v.properties.each do |p|
              expect(p.to_s).to start_with(v.to_s)
            end
          end
        end
      end
    end
  end

  context "ad-hoc vocabularies" do
    subject :test_vocab do
      Class.new(RDF::Vocabulary.create("http://example.com/test#")) do
        property :Class
        property :prop
        property :prop2, :label => "Test property label", :comment => " Test property comment"
      end
    end

    it "should have Vocabulary::method_missing" do
      expect {test_vocab.a_missing_method}.not_to raise_error
    end

    it "should respond to [] with properties that have been defined" do
      test_vocab[:prop].should be_a(RDF::URI)
      test_vocab["prop2"].should be_a(RDF::URI)
    end

    it "should respond to [] with properties that have not been defined" do
      test_vocab[:not_a_prop].should be_a(RDF::URI)
      test_vocab["not_a_prop"].should be_a(RDF::URI)
    end

    its(:property) {should eq RDF::URI("http://example.com/test#property")}
    its(:properties) {should include("http://example.com/test#Class", "http://example.com/test#prop", "http://example.com/test#prop2")}

    it "should respond to methods for which a property has been defined explicitly" do
      test_vocab.prop.should be_a(RDF::URI)
    end

    it "should respond to methods for which a class has been defined by a graph" do
      test_vocab.Class.should be_a(RDF::URI)
    end

    it "should respond to label_for from base RDFS" do
      test_vocab.label_for("prop2").should == "Test property label"
    end

    it "should respond to comment_for from base RDFS" do
      test_vocab.comment_for(:prop2).should == " Test property comment"
    end
  end

  describe RDF::Vocabulary::Term do
    subject {RDF::RDFS.comment}
    specify {should be_uri}
    specify {should respond_to(:type)}
    specify {should respond_to(:label)}
    specify {should respond_to(:comment)}
    specify {should respond_to(:domain)}
    specify {should respond_to(:range)}
    its(:label) {should eq RDF::RDFS.label_for("comment")}
    its(:comment) {should eq RDF::RDFS.comment_for("comment")}
  end
end
