# This file generated automatically using vocab-fetch from http://www.w3.org/2003/12/exif/ns#
require 'rdf'
module RDF
  class EXIF < StrictVocabulary("http://www.w3.org/2003/12/exif/ns#")

    # Class definitions
    property :IFD, :label => 'IFD', :comment =>
      %(An Image File Directory)

    # Property definitions
    property :apertureValue, :label => 'ApertureValue', :comment =>
      %(The lens aperture. The unit is the APEX value.)
    property :artist, :label => 'Artist', :comment =>
      %(Person who created the image)
    property :bitsPerSample, :label => 'BitsPerSample', :comment =>
      %(The number of bits per image component. In this standard each
        component of the image is 8 bits, so the value for this tag is
        8. See also SamplesPerPixel. In JPEG compressed data a JPEG
        marker is used instead of this tag.)
    property :brightnessValue, :label => 'BrightnessValue', :comment =>
      %(The value of brightness. The unit is the APEX value.
        Ordinarily it is given in the range of -99.99 to 99.99. Note
        that if the numerator of the recorded value is FFFFFFFF.H,
        Unknown shall be indicated.)
    property :cfaPattern, :label => 'CFAPattern', :comment =>
      %(The color filter array \(CFA\) geometric pattern of the image
        sensor when a one-chip color area sensor is used. It does not
        apply to all sensing methods.)
    property :colorSpace, :label => 'ColorSpace', :comment =>
      %(The color space information tag \(ColorSpace\) is always
        recorded as the color space specifier. Normally sRGB \(=1\) is
        used to define the color space based on the PC monitor
        conditions and environment.)
    property :componentsConfiguration, :label => 'ComponentsConfiguration', :comment =>
      %(Information specific to compressed data. The channels of each
        component are arranged in order from the 1st component to the
        4th. For uncompressed data the data arrangement is given in
        the PhotometricInterpretation tag. However, since
        PhotometricInterpretation can only express the order of Y,Cb
        and Cr, this tag is provided for cases when compressed data
        uses components other than Y, Cb, and Cr and to enable support
        of other sequences.)
    property :compressedBitsPerPixel, :label => 'CompressedBitsPerPixel', :comment =>
      %(Information specific to compressed data. The compression mode
        used for a compressed image is indicated in unit bits per
        pixel.)
    property :compression, :label => 'Compression', :comment =>
      %(The compression scheme used for the image data. When a primary
        image is JPEG compressed, this designation is not necessary
        and is omitted. When thumbnails use JPEG compression, this tag
        value is set to 6.)
    property :contrast, :label => 'Contrast', :comment =>
      %(The direction of contrast processing applied by the camera
        when the image was shot.)
    property :copyright, :label => 'Copyright', :comment =>
      %(Copyright information. In this standard the tag is used to
        indicate both the photographer and editor copyrights. It is
        the copyright notice of the person or organization claiming
        rights to the image.)
    property :customRendered, :label => 'CustomRendered', :comment =>
      %(The use of special processing on image data, such as rendering
        geared to output. When special processing is performed, the
        reader is expected to disable or minimize any further
        processing.)
    property :datatype, :label => 'Data Type', :comment =>
      %(The Exif field data type, such as ascii, byte, short etc.)
    property :date, :label => 'Date', :comment =>
      %(a date information. Usually saved as YYYY:MM:DD \(HH:MM:SS\)
        format in Exif data, but represented here as W3C-DTF format)
    property :dateAndOrTime, :label => 'Date and/or Time', :comment =>
      %(An attribute relating to Date and/or Time)
    property :dateTime, :label => 'DateTime', :comment =>
      %(The date and time of image creation. In this standard it is
        the date and time the file was changed.)
    property :dateTimeDigitized, :label => 'DateTimeDigitized', :comment =>
      %(The date and time when the image was stored as digital data.
        If, for example, an image was captured by DSC and at the same
        time the file was recorded, then the DateTimeOriginal and
        DateTimeDigitized will have the same contents.)
    property :dateTimeOriginal, :label => 'DateTimeOriginal', :comment =>
      %(The date and time when the original image data was generated.
        For a DSC the date and time the picture was taken are
        recorded.)
    property :deviceSettingDescription, :label => 'DeviceSettingDescription', :comment =>
      %(Information on the picture-taking conditions of a particular
        camera model. The tag is used only to indicate the
        picture-taking conditions in the reader.)
    property :digitalZoomRatio, :label => 'DigitalZoomRatio', :comment =>
      %(The digital zoom ratio when the image was shot. If the
        numerator of the recorded value is 0, this indicates that
        digital zoom was not used.)
    property :exifAttribute, :label => 'Exif Attribute', :comment =>
      %(A property that connects an IFD to one of its entries. Super
        property which integrates all Exif tags.)
    property :exif_IFD_Pointer, :label => 'Exif IFD Pointer', :comment =>
      %(A pointer to the Exif IFD, which is a set of tags for
        recording Exif-specific attribute information.)
    property :exifdata, :label => 'Exif data', :comment =>
      %(An Exif IFD data entry)
    property :exifVersion, :label => 'ExifVersion', :comment =>
      %(Exif Version)
    property :exposureBiasValue, :label => 'ExposureBiasValue', :comment =>
      %(The exposure bias. The unit is the APEX value. Ordinarily it
        is given in the range of -99.99 to 99.99.)
    property :exposureIndex, :label => 'ExposureIndex', :comment =>
      %(The exposure index selected on the camera or input device at
        the time the image is captured.)
    property :exposureMode, :label => 'ExposureMode', :comment =>
      %(the exposure mode set when the image was shot. In
        auto-bracketing mode, the camera shoots a series of frames of
        the same scene at different exposure settings.)
    property :exposureProgram, :label => 'ExposureProgram', :comment =>
      %(The class of the program used by the camera to set exposure
        when the picture is taken.)
    property :exposureTime, :label => 'ExposureTime', :comment =>
      %(Exposure time, given in seconds \(sec\).)
    property :fNumber, :label => 'FNumber', :comment =>
      %(F number)
    property :fileSource, :label => 'FileSource', :comment =>
      %(The image source. If a DSC recorded the image, this tag value
        of this tag always be set to 3, indicating that the image was
        recorded on a DSC.)
    property :flash, :label => 'Flash', :comment =>
      %(The status of flash when the image was shot.)
    property :flashEnergy, :label => 'FlashEnergy', :comment =>
      %(The strobe energy at the time the image is captured, as
        measured in Beam Candle Power Seconds \(BCPS\).)
    property :flashpixVersion, :label => 'FlashpixVersion', :comment =>
      %(The Flashpix format version supported by a FPXR file. If the
        FPXR function supports Flashpix format Ver. 1.0, this is
        indicated similarly to ExifVersion by recording "0100" as
        4-byte ASCII.)
    property :focalLength, :label => 'FocalLength', :comment =>
      %(The actual focal length of the lens, in mm. Conversion is not
        made to the focal length of a 35 mm film camera.)
    property :focalLengthIn35mmFilm, :label => 'FocalLengthIn35mmFilm', :comment =>
      %(The equivalent focal length assuming a 35mm film camera, in
        mm. A value of 0 means the focal length is unknown. Note that
        this tag differs from the FocalLength tag.)
    property :focalPlaneResolutionUnit, :label => 'FocalPlaneResolutionUnit', :comment =>
      %(The unit for measuring FocalPlaneXResolution and
        FocalPlaneYResolution. This value is the same as the
        ResolutionUnit.)
    property :focalPlaneXResolution, :label => 'FocalPlaneXResolution', :comment =>
      %(The number of pixels in the image width \(X\) direction per
        FocalPlaneResolutionUnit on the camera focal plane.)
    property :focalPlaneYResolution, :label => 'FocalPlaneYResolution', :comment =>
      %(The number of pixels in the image height \(Y\) direction per
        FocalPlaneResolutionUnit on the camera focal plane.)
    property :gpsInfo, :label => 'GPS Info', :comment =>
      %(An attribute relating to GPS information)
    property :gpsAltitude, :label => 'GPSAltitude', :comment =>
      %(The altitude based on the reference in GPSAltitudeRef.
        Altitude is expressed as one RATIONAL value. The reference
        unit is meters.)
    property :gpsAltitudeRef, :label => 'GPSAltitudeRef', :comment =>
      %(Indicates the altitude used as the reference altitude. If the
        reference is sea level and the altitude is above sea level, 0
        is given. If the altitude is below sea level, a value of 1 is
        given and the altitude is indicated as an absolute value in
        the GPSAltitude tag. The reference unit is meters.)
    property :gpsAreaInformation, :label => 'GPSAreaInformation', :comment =>
      %(A character string recording the name of the GPS area. The
        first byte indicates the character code used, and this is
        followed by the name of the GPS area.)
    property :gpsDOP, :label => 'GPSDOP', :comment =>
      %(The GPS DOP \(data degree of precision\). An HDOP value is
        written during two-dimensional measurement, and PDOP during
        three-dimensional measurement.)
    property :gpsDateStamp, :label => 'GPSDateStamp', :comment =>
      %(date and time information relative to UTC \(Coordinated
        Universal Time\). The record format is "YYYY:MM:DD" while
        converted to W3C-DTF to use in RDF)
    property :gpsDestBearing, :label => 'GPSDestBearing', :comment =>
      %(The bearing to the destination point. The range of values is
        from 0.00 to 359.99.)
    property :gpsDestBearingRef, :label => 'GPSDestBearingRef', :comment =>
      %(Indicates the reference used for giving the bearing to the
        destination point. 'T' denotes true direction and 'M' is
        magnetic direction.)
    property :gpsDestDistance, :label => 'GPSDestDistance', :comment =>
      %(The distance to the destination point.)
    property :gpsDestDistanceRef, :label => 'GPSDestDistanceRef', :comment =>
      %(Indicates the unit used to express the distance to the
        destination point. 'K', 'M' and 'N' represent kilometers,
        miles and knots.)
    property :gpsDestLatitude, :label => 'GPSDestLatitude', :comment =>
      %(Latitude of destination, expressed as three values giving the
        degrees, minutes, and seconds, respectively.)
    property :gpsDestLatitudeRef, :label => 'GPSDestLatitudeRef', :comment =>
      %(Reference for latitude of destination)
    property :gpsDestLongitude, :label => 'GPSDestLongitude', :comment =>
      %(Longitude of destination, expressed as three values giving the
        degrees, minutes, and seconds, respectively.)
    property :gpsDestLongitudeRef, :label => 'GPSDestLongitudeRef', :comment =>
      %(Reference for longitude of destination)
    property :gpsDifferential, :label => 'GPSDifferential', :comment =>
      %(Indicates whether differential correction is applied to the
        GPS receiver.)
    property :gpsImgDirection, :label => 'GPSImgDirection', :comment =>
      %(The direction of the image when it was captured. The range of
        values is from 0.00 to 359.99.)
    property :gpsImgDirectionRef, :label => 'GPSImgDirectionRef', :comment =>
      %(The reference for giving the direction of the image when it is
        captured. 'T' denotes true direction and 'M' is magnetic
        direction.)
    property :gpsInfo_IFD_Pointer, :label => 'GPSInfo IFD Pointer', :comment =>
      %(A pointer to the GPS IFD, which is a set of tags for recording
        GPS information.)
    property :gpsLatitude, :label => 'GPSLatitude', :comment =>
      %(The latitude, expressed as three values giving the degrees,
        minutes, and seconds, respectively.)
    property :gpsLatitudeRef, :label => 'GPSLatitudeRef', :comment =>
      %(Indicates whether the latitude is north or south latitude. The
        ASCII value 'N' indicates north latitude, and 'S' is south
        latitude.)
    property :gpsLongitude, :label => 'GPSLongitude', :comment =>
      %(The longitude, expressed as three values giving the degrees,
        minutes, and seconds, respectively.)
    property :gpsLongitudeRef, :label => 'GPSLongitudeRef', :comment =>
      %(Indicates whether the longitude is east or west longitude.
        ASCII 'E' indicates east longitude, and 'W' is west longitude.)
    property :gpsMapDatum, :label => 'GPSMapDatum', :comment =>
      %(The geodetic survey data used by the GPS receiver. If the
        survey data is restricted to Japan, the value of this tag is
        'TOKYO' or 'WGS-84'. If a GPS Info tag is recorded, it is
        strongly recommended that this tag be recorded.)
    property :gpsMeasureMode, :label => 'GPSMeasureMode', :comment =>
      %(The GPS measurement mode. '2' means two-dimensional
        measurement and '3' means three-dimensional measurement is in
        progress.)
    property :gpsProcessingMethod, :label => 'GPSProcessingMethod', :comment =>
      %(A character string recording the name of the method used for
        location finding. The first byte indicates the character code
        used, and this is followed by the name of the method.)
    property :gpsSatellites, :label => 'GPSSatellites', :comment =>
      %(The GPS satellites used for measurements. This tag can be used
        to describe the number of satellites, their ID number, angle
        of elevation, azimuth, SNR and other information in ASCII
        notation. The format is not specified. If the GPS receiver is
        incapable of taking measurements, value of the tag shall be
        set to NULL.)
    property :gpsSpeed, :label => 'GPSSpeed', :comment =>
      %(The speed of GPS receiver movement.)
    property :gpsSpeedRef, :label => 'GPSSpeedRef', :comment =>
      %(The unit used to express the GPS receiver speed of movement.
        'K' 'M' and 'N' represents kilometers per hour, miles per
        hour, and knots.)
    property :gpsStatus, :label => 'GPSStatus', :comment =>
      %(The status of the GPS receiver when the image is recorded. 'A'
        means measurement is in progress, and 'V' means the
        measurement is Interoperability.)
    property :gpsTimeStamp, :label => 'GPSTimeStamp', :comment =>
      %(The time as UTC \(Coordinated Universal Time\). TimeStamp is
        expressed as three RATIONAL values giving the hour, minute,
        and second.)
    property :gpsTrack, :label => 'GPSTrack', :comment =>
      %(The direction of GPS receiver movement. The range of values is
        from 0.00 to 359.99.)
    property :gpsTrackRef, :label => 'GPSTrackRef', :comment =>
      %(The reference for giving the direction of GPS receiver
        movement. 'T' denotes true direction and 'M' is magnetic
        direction.)
    property :gpsVersionID, :label => 'GPSVersionID', :comment =>
      %(The version of GPSInfoIFD. The version is given as 2.2.0.0.
        This tag is mandatory when GPSInfo tag is present.)
    property :gainControl, :label => 'GainControl', :comment =>
      %(The degree of overall image gain adjustment.)
    property :geo, :label => 'Geometric data', :comment =>
      %(Geometric data such as latitude, longitude and altitude.
        Usually saved as rational number.)
    property :height, :label => 'Height', :comment =>
      %(Height of an object)
    property :ifdPointer, :label => 'IFD Pointer', :comment =>
      %(A tag that refers a child IFD)
    property :isoSpeedRatings, :label => 'ISOSpeedRatings', :comment =>
      %(Indicates the ISO Speed and ISO Latitude of the camera or
        input device as specified in ISO 12232.)
    property :imageConfig, :label => 'Image Config', :comment =>
      %(An attribute relating to Image Configuration)
    property :imageDataCharacter, :label => 'Image Data Character', :comment =>
      %(An attribute relating to image data characteristics)
    property :imageDataStruct, :label => 'Image Data Structure', :comment =>
      %(An attribute relating to image data structure)
    property :imageDescription, :label => 'ImageDescription', :comment =>
      %(A character string giving the title of the image. It may be a
        comment such as "1988 company picnic" or the like. Two-byte
        character codes cannot be used. When a 2-byte code is
        necessary, the Exif Private tag UserComment is to be used.)
    property :imageLength, :label => 'ImageLength', :comment =>
      %(Image height. The number of rows of image data. In JPEG
        compressed data a JPEG marker is used.)
    property :imageUniqueID, :label => 'ImageUniqueID', :comment =>
      %(An identifier assigned uniquely to each image. It is recorded
        as an ASCII string equivalent to hexadecimal notation and
        128-bit fixed length.)
    property :imageWidth, :label => 'ImageWidth', :comment =>
      %(Image width. The number of columns of image data, equal to the
        number of pixels per row. In JPEG compressed data a JPEG
        marker is used instead of this tag.)
    property :interoperability_IFD_Pointer, :label => 'Interoperability IFD Pointer', :comment =>
      %(A pointer to the Interoperability IFD, which is composed of
        tags storing the information to ensure the Interoperability)
    property :interopInfo, :label => 'Interoperability Info', :comment =>
      %(An attribute relating to Interoperability. Tags stored in
        Interoperability IFD may be defined dependently to each
        Interoperability rule.)
    property :interoperabilityIndex, :label => 'InteroperabilityIndex', :comment =>
      %(Indicates the identification of the Interoperability rule.
        'R98' = conforming to R98 file specification of Recommended
        Exif Interoperability Rules \(ExifR98\) or to DCF basic file
        stipulated by Design Rule for Camera File System. 'THM' =
        conforming to DCF thumbnail file stipulated by Design rule for
        Camera File System.)
    property :interoperabilityVersion, :label => 'InteroperabilityVersion', :comment =>
      %(Interoperability Version)
    property :jpegInterchangeFormat, :label => 'JPEGInterchangeFormat', :comment =>
      %(The offset to the start byte \(SOI\) of JPEG compressed
        thumbnail data. This is not used for primary image JPEG data.)
    property :jpegInterchangeFormatLength, :label => 'JPEGInterchangeFormatLength', :comment =>
      %(The number of bytes of JPEG compressed thumbnail data. This is
        not used for primary image JPEG data.)
    property :length, :label => 'Length', :comment =>
      %(Length of an object. Could be a subProperty of other general
        schema.)
    property :lightSource, :label => 'LightSource', :comment =>
      %(Light source such as Daylight, Tungsten, Flash etc.)
    property :make, :label => 'Make', :comment =>
      %(Manufacturer of image input equipment)
    property :makerNote, :label => 'MakerNote', :comment =>
      %(Manufacturer notes)
    property :maxApertureValue, :label => 'MaxApertureValue', :comment =>
      %(The smallest F number of the lens. The unit is the APEX value.
        Ordinarily it is given in the range of 00.00 to 99.99, but it
        is not limited to this range.)
    property :meter, :label => 'Meter', :comment =>
      %(A length with unit of meter)
    property :meteringMode, :label => 'MeteringMode', :comment =>
      %(Metering mode, such as CenterWeightedAverage, Spot,
        MultiSpot,Pattern, Partial etc.)
    property :mm, :label => 'Milimeter', :comment =>
      %(A length with unit of mm)
    property :model, :label => 'Model', :comment =>
      %(Model of image input equipment)
    property :oecf, :label => 'OECF', :comment =>
      %(Indicates the Opto-Electric Conversion Function \(OECF\)
        specified in ISO 14524. OECF is the relationship between the
        camera optical input and the image values.)
    property :orientation, :label => 'Orientation', :comment =>
      %(The image orientation viewed in terms of rows and columns.)
    property :pimInfo, :label => 'PIM Info', :comment =>
      %(An attribute relating to print image matching)
    property :photometricInterpretation, :label => 'PhotometricInterpretation', :comment =>
      %(Pixel composition. In JPEG compressed data a JPEG marker is
        used instead of this tag.)
    property :pictTaking, :label => 'PictTaking', :comment =>
      %(An attribute relating to Picture-Taking Conditions)
    property :pixelXDimension, :label => 'PixelXDimension', :comment =>
      %(Information specific to compressed data. When a compressed
        file is recorded, the valid width of the meaningful image
        shall be recorded in this tag, whether or not there is padding
        data or a restart marker. This tag should not exist in an
        uncompressed file.)
    property :pixelYDimension, :label => 'PixelYDimension', :comment =>
      %(Information specific to compressed data. When a compressed
        file is recorded, the valid height of the meaningful image
        shall be recorded in this tag, whether or not there is padding
        data or a restart marker. This tag should not exist in an
        uncompressed file. Since data padding is unnecessary in the
        vertical direction, the number of lines recorded in this valid
        image height tag will in fact be the same as that recorded in
        the SOF.)
    property :planarConfiguration, :label => 'PlanarConfiguration', :comment =>
      %(Indicates whether pixel components are recorded in chunky or
        planar format. In JPEG compressed files a JPEG marker is used
        instead of this tag. If this field does not exist, the TIFF
        default of 1 \(chunky\) is assumed.)
    property :primaryChromaticities, :label => 'PrimaryChromaticities', :comment =>
      %(The chromaticity of the three primary colors of the image.
        Normally this tag is not necessary, since color space is
        specified in the color space information tag \(ColorSpace\).)
    property :pimBrightness, :label => 'PrintIM Brightness', :comment =>
      %(Brightness info for print image matching)
    property :pimColorBalance, :label => 'PrintIM ColorBalance', :comment =>
      %(ColorBalance info for print image matching)
    property :pimContrast, :label => 'PrintIM Contrast', :comment =>
      %(Contrast info for print image matching)
    property :pimSaturation, :label => 'PrintIM Saturation', :comment =>
      %(Saturation info for print image matching)
    property :pimSharpness, :label => 'PrintIM Sharpness', :comment =>
      %(Sharpness info for print image matching)
    property :printImageMatching_IFD_Pointer, :label => 'PrintImageMatching IFD Pointer', :comment =>
      %(A pointer to the print image matching IFD)
    property :recOffset, :label => 'Recording Offset', :comment =>
      %(An attribute relating to recording offset)
    property :referenceBlackWhite, :label => 'ReferenceBlackWhite', :comment =>
      %(The reference black point value and reference white point
        value. The color space is declared in a color space
        information tag, with the default being the value that gives
        the optimal image characteristics Interoperability these
        conditions.)
    property :relatedFile, :label => 'Related File', :comment =>
      %(Tag Relating to Related File Information)
    property :relatedImageFileFormat, :label => 'RelatedImageFileFormat', :comment =>
      %(Related image file format)
    property :relatedImageLength, :label => 'RelatedImageLength', :comment =>
      %(Related image length)
    property :relatedImageWidth, :label => 'RelatedImageWidth', :comment =>
      %(Related image width)
    property :relatedSoundFile, :label => 'RelatedSoundFile', :comment =>
      %(Related audio file)
    property :resolution, :label => 'Resolution', :comment =>
      %(a rational number representing a resolution. Could be a
        subProperty of other general schema.)
    property :resolutionUnit, :label => 'ResolutionUnit', :comment =>
      %(The unit for measuring XResolution and YResolution. The same
        unit is used for both XResolution and YResolution. If the
        image resolution in unknown, 2 \(inches\) is designated.)
    property :rowsPerStrip, :label => 'RowsPerStrip', :comment =>
      %(The number of rows per strip. This is the number of rows in
        the image of one strip when an image is divided into strips.
        With JPEG compressed data this designation is not needed and
        is omitted.)
    property :samplesPerPixel, :label => 'SamplesPerPixel', :comment =>
      %(The number of components per pixel. Since this standard
        applies to RGB and YCbCr images, the value set for this tag is
        3. In JPEG compressed data a JPEG marker is used instead of
        this tag.)
    property :saturation, :label => 'Saturation', :comment =>
      %(The direction of saturation processing applied by the camera
        when the image was shot.)
    property :sceneCaptureType, :label => 'SceneCaptureType', :comment =>
      %(The type of scene that was shot. It can also be used to record
        the mode in which the image was shot, such as Landscape,
        Portrait etc. Note that this differs from the scene type
        \(SceneType\) tag.)
    property :sceneType, :label => 'SceneType', :comment =>
      %(The type of scene. If a DSC recorded the image, this tag value
        shall always be set to 1, indicating that the image was
        directly photographed.)
    property :seconds, :label => 'Seconds', :comment =>
      %(a mesurement of time length with unit of second)
    property :sensingMethod, :label => 'SensingMethod', :comment =>
      %(The image sensor type on the camera or input device, such as
        One-chip color area sensor etc.)
    property :sharpness, :label => 'Sharpness', :comment =>
      %(The direction of sharpness processing applied by the camera
        when the image was shot.)
    property :shutterSpeedValue, :label => 'ShutterSpeedValue', :comment =>
      %(Shutter speed. The unit is the APEX \(Additive System of
        Photographic Exposure\) setting)
    property :software, :label => 'Software', :comment =>
      %(The name and version of the software or firmware of the camera
        or image input device used to generate the image.)
    property :spatialFrequencyResponse, :label => 'SpatialFrequencyResponse', :comment =>
      %(This tag records the camera or input device spatial frequency
        table and SFR values in the direction of image width, image
        height, and diagonal direction, as specified in ISO 12233.)
    property :spectralSensitivity, :label => 'SpectralSensitivity', :comment =>
      %(Indicates the spectral sensitivity of each channel of the
        camera used. The tag value is an ASCII string compatible with
        the standard developed by the ASTM Technical committee.)
    property :stripByteCounts, :label => 'StripByteCounts', :comment =>
      %(The total number of bytes in each strip. With JPEG compressed
        data this designation is not needed and is omitted.)
    property :stripOffsets, :label => 'StripOffsets', :comment =>
      %(For each strip, the byte offset of that strip. With JPEG
        compressed data this designation is not needed and is omitted.)
    property :subSecTime, :label => 'SubSecTime', :comment =>
      %(DateTime subseconds)
    property :subSecTimeDigitized, :label => 'SubSecTimeDigitized', :comment =>
      %(DateTimeDigitized subseconds)
    property :subSecTimeOriginal, :label => 'SubSecTimeOriginal', :comment =>
      %(DateTimeOriginal subseconds)
    property :subjectArea, :label => 'SubjectArea', :comment =>
      %(The location and area of the main subject in the overall
        scene.)
    property :subjectDistance, :label => 'SubjectDistance', :comment =>
      %(The distance to the subject, given in meters. Note that if the
        numerator of the recorded value is FFFFFFFF.H, Infinity shall
        be indicated; and if the numerator is 0, Distance unknown
        shall be indicated.)
    property :subjectDistanceRange, :label => 'SubjectDistanceRange', :comment =>
      %(The distance to the subject, such as Macro, Close View or
        Distant View.)
    property :subjectLocation, :label => 'SubjectLocation', :comment =>
      %(The location of the main subject in the scene. The value of
        this tag represents the pixel at the center of the main
        subject relative to the left edge, prior to rotation
        processing as per the Rotation tag. The first value indicates
        the X column number and second indicates the Y row number.)
    property :subseconds, :label => 'Subseconds', :comment =>
      %(A tag used to record fractions of seconds for a date property)
    property :tagid, :label => 'Tag ID', :comment =>
      %(The Exif tag number with context prefix, such as IFD type or
        maker name)
    property :tag_number, :label => 'Tag number', :comment =>
      %(The Exif tag number)
    property :transferFunction, :label => 'TransferFunction', :comment =>
      %(A transfer function for the image, described in tabular style.
        Normally this tag is not necessary, since color space is
        specified in the color space information tag \(ColorSpace\).)
    property :_unknown, :label => 'Unknown tag', :comment =>
      %(An Exif tag whose meaning is not known)
    property :userInfo, :label => 'User Info', :comment =>
      %(An attribute relating to User Information)
    property :userComment, :label => 'UserComment', :comment =>
      %(A tag for Exif users to write keywords or comments on the
        image besides those in ImageDescription, and without the
        character code limitations of the ImageDescription tag. The
        character code used in the UserComment tag is identified based
        on an ID code in a fixed 8-byte area at the start of the tag
        data area.)
    property :versionInfo, :label => 'Version Info', :comment =>
      %(An attribute relating to Version)
    property :whiteBalance, :label => 'WhiteBalance', :comment =>
      %(The white balance mode set when the image was shot.)
    property :whitePoint, :label => 'WhitePoint', :comment =>
      %(The chromaticity of the white point of the image. Normally
        this tag is not necessary, since color space is specified in
        the color space information tag \(ColorSpace\).)
    property :width, :label => 'Width', :comment =>
      %(Width of an object)
    property :xResolution, :label => 'XResolution', :comment =>
      %(The number of pixels per ResolutionUnit in the ImageWidth
        direction. When the image resolution is unknown, 72 [dpi] is
        designated.)
    property :yCbCrCoefficients, :label => 'YCbCrCoefficients', :comment =>
      %(The matrix coefficients for transformation from RGB to YCbCr
        image data.)
    property :yCbCrPositioning, :label => 'YCbCrPositioning', :comment =>
      %(The position of chrominance components in relation to the
        luminance component. This field is designated only for JPEG
        compressed data or uncompressed YCbCr data.)
    property :yCbCrSubSampling, :label => 'YCbCrSubSampling', :comment =>
      %(The sampling ratio of chrominance components in relation to
        the luminance component. In JPEG compressed data a JPEG marker
        is used instead of this tag.)
    property :yResolution, :label => 'YResolution', :comment =>
      %(The number of pixels per ResolutionUnit in the ImageLength
        direction. The same value as XResolution is designated.)
  end
end
