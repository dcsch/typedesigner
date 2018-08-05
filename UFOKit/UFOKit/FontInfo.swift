//
//  FontInfo.swift
//  UFOKit
//
//  Created by David Schweinsberg on 5/17/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Foundation

let fontStyleToName = [64: "regular",
                       1: "italic",
                       32: "bold",
                       33: "bold italic"]

let widthNameToClass = ["Ultra-condensed": 1,
                        "Extra-condensed": 2,
                        "Condensed": 3,
                        "Semi-condensed": 4,
                        "Medium (normal)": 5,
                        "Semi-expanded": 6,
                        "Expanded": 7,
                        "Extra-expanded": 8,
                        "Ultra-expanded": 9]

let msCharSetToWindowsCharacterSet = [0: 1,
                                      1: 2,
                                      2: 3,
                                      77: 4,
                                      128: 5,
                                      129: 6,
                                      130: 7,
                                      134: 8,
                                      136: 9,
                                      161: 10,
                                      162: 11,
                                      163: 12,
                                      177: 13,
                                      178: 14,
                                      186: 15,
                                      200: 16,
                                      204: 17,
                                      222: 18,
                                      238: 19,
                                      255: 20]

struct FontInfoV1: Codable {
  var ascender: Double?
  var capHeight: Double?
  var copyright: String?
  var createdBy: String?
  var descender: Double?
  var defaultWidth: Double?
  var designer: String?
  var designerURL: String?
  var familyName: String?
  var fondID: Int?
  var fondName: String?
  var fontName: String?
  var fontStyle: Int?
  var fullName: String?
  var italicAngle: Double?
  var license: String?
  var licenseURL: String?
  var menuName: String?
  var msCharSet: Int?
  var note: String?
  var notice: String?
  var otFamilyName: String?
  var otStyleName: String?
  var otMacName: String?
  var slantAngle: Double?
  var styleName: String?
  var trademark: String?
  var ttUniqueID: String?
  var ttVendor: String?
  var ttVersion: String?
  var uniqueID: Int?
  var unitsPerEm: Double?
  var vendorURL: String?
  var versionMajor: Int?
  var versionMinor: Int?
  var weightName: String?
  var weightValue: Int?
  var widthName: String?
}

public struct FontInfo: Codable {

  // Generic Identification Information
  public var familyName: String?
  public var styleName: String?
  public var styleMapFamilyName: String?
  public var styleMapStyleName: String?
  public var versionMajor: Int?
  public var versionMinor: Int?
  public var year: Int?

  // Generic Legal Information
  public var copyright: String?
  public var trademark: String?

  // Generic Dimension Information
  public var unitsPerEm: Double?
  public var descender: Double?
  public var xHeight: Double?
  public var capHeight: Double?
  public var ascender: Double?
  public var italicAngle: Double?

  // Generic Miscellaneous Information
  public var note: String?

  // OpenType head Table Fields
  public var openTypeHeadCreated: String?
  public var openTypeHeadLowestRecPPEM: Double?
  public var openTypeHeadFlags: [Int]?

  // OpenType hhea Table Fields
  public var openTypeHheaAscender: Double?
  public var openTypeHheaDescender: Double?
  public var openTypeHheaLineGap: Double?
  public var openTypeHheaCaretSlopeRise: Int?
  public var openTypeHheaCaretSlopeRun: Int?
  public var openTypeHheaCaretOffset: Double?

  // OpenType Name Table Fields
  public var openTypeNameDesigner: String?
  public var openTypeNameDesignerURL: String?
  public var openTypeNameManufacturer: String?
  public var openTypeNameManufacturerURL: String?
  public var openTypeNameLicense: String?
  public var openTypeNameLicenseURL: String?
  public var openTypeNameVersion: String?
  public var openTypeNameUniqueID: String?
  public var openTypeNameDescription: String?
  public var openTypeNamePreferredFamilyName: String?
  public var openTypeNamePreferredSubfamilyName: String?
  public var openTypeNameCompatibleFullName: String?
  public var openTypeNameSampleText: String?
  public var openTypeNameWWSFamilyName: String?
  public var openTypeNameWWSSubfamilyName: String?

  // OpenType OS/2 Table Fields
  public var openTypeOS2WidthClass: Int?
  public var openTypeOS2WeightClass: Int?
  public var openTypeOS2Selection: [Int]?
  public var openTypeOS2VendorID: String?
  public var openTypeOS2Panose: [Int]?
  public var openTypeOS2FamilyClass: [Int]?
  public var openTypeOS2UnicodeRanges: [Int]?
  public var openTypeOS2CodePageRanges: [Int]?
  public var openTypeOS2TypoAscender: Double?
  public var openTypeOS2TypoDescender: Double?
  public var openTypeOS2TypoLineGap: Double?
  public var openTypeOS2WinAscent: Double?
  public var openTypeOS2WinDescent: Double?
  public var openTypeOS2Type: [Int]?
  public var openTypeOS2SubscriptXSize: Double?
  public var openTypeOS2SubscriptYSize: Double?
  public var openTypeOS2SubscriptXOffset: Double?
  public var openTypeOS2SubscriptYOffset: Double?
  public var openTypeOS2SuperscriptXSize: Double?
  public var openTypeOS2SuperscriptYSize: Double?
  public var openTypeOS2SuperscriptXOffset: Double?
  public var openTypeOS2SuperscriptYOffset: Double?
  public var openTypeOS2StrikeoutSize: Double?
  public var openTypeOS2StrikeoutPosition: Double?

  // OpenType vhea Table Fields
  public var openTypeVheaVertTypoAscender: Double?
  public var openTypeVheaVertTypoDescender: Double?
  public var openTypeVheaVertTypoLineGap: Double?
  public var openTypeVheaCaretSlopeRise: Int?
  public var openTypeVheaCaretSlopeRun: Int?
  public var openTypeVheaCaretOffset: Double?

  // PostScript Specific Data
  public var postscriptFontName: String?
  public var postscriptFullName: String?
  public var postscriptSlantAngle: Double?
  public var postscriptUniqueID: Int?
  public var postscriptUnderlineThickness: Double?
  public var postscriptUnderlinePosition: Double?
  public var postscriptIsFixedPitch: Bool?
  public var postscriptBlueValues: [Int]?
  public var postscriptOtherBlues: [Int]?
  public var postscriptFamilyBlues: [Int]?
  public var postscriptFamilyOtherBlues: [Int]?
  public var postscriptStemSnapH: [Int]?
  public var postscriptStemSnapV: [Int]?
  public var postscriptBlueFuzz: Double?
  public var postscriptBlueShift: Double?
  public var postscriptBlueScale: Double?
  public var postscriptForceBold: Bool?
  public var postscriptDefaultWidthX: Double?
  public var postscriptNominalWidthX: Double?
  public var postscriptWeightName: String?
  public var postscriptDefaultCharacter: String?
  public var postscriptWindowsCharacterSet: Int?

  // Macintosh FOND Resource Data
  public var macintoshFONDFamilyID: Int?
  public var macintoshFONDName: String?

  public init() {
  }

  init(fontInfoV1: FontInfoV1) throws {
    self.ascender = fontInfoV1.ascender
    self.capHeight = fontInfoV1.capHeight
    self.copyright = fontInfoV1.copyright
    self.openTypeNameManufacturer = fontInfoV1.createdBy
    self.descender = fontInfoV1.descender
    self.postscriptDefaultWidthX = fontInfoV1.defaultWidth
    self.openTypeNameDesigner = fontInfoV1.designer
    self.openTypeNameDesignerURL = fontInfoV1.designerURL
    self.familyName = fontInfoV1.familyName
    self.macintoshFONDFamilyID = fontInfoV1.fondID
    self.postscriptFontName = fontInfoV1.fondName
    self.postscriptFontName = fontInfoV1.fontName
    if let fontStyle = fontInfoV1.fontStyle {
      if fontStyleToName.keys.contains(fontStyle) {
        self.styleMapStyleName = fontStyleToName[fontStyle]
      } else {
        throw UFOError.cannotConvertValue
      }
    }
    self.postscriptFullName = fontInfoV1.fullName
    self.italicAngle = fontInfoV1.italicAngle
    self.openTypeNameLicense = fontInfoV1.license
    self.openTypeNameLicenseURL = fontInfoV1.licenseURL
    self.styleMapFamilyName = fontInfoV1.menuName
    if let msCharSet = fontInfoV1.msCharSet {
      if msCharSetToWindowsCharacterSet.keys.contains(msCharSet) {
        self.self.postscriptWindowsCharacterSet = msCharSetToWindowsCharacterSet[msCharSet]
      } else {
        throw UFOError.cannotConvertValue
      }
    }
    self.note = fontInfoV1.note
    self.openTypeNameDescription = fontInfoV1.notice
    self.openTypeNamePreferredFamilyName = fontInfoV1.otFamilyName
    self.openTypeNamePreferredSubfamilyName = fontInfoV1.otStyleName
    self.openTypeNameCompatibleFullName = fontInfoV1.otMacName
    self.postscriptSlantAngle = fontInfoV1.slantAngle
    self.styleName = fontInfoV1.styleName
    self.trademark = fontInfoV1.trademark
    self.openTypeNameUniqueID = fontInfoV1.ttUniqueID
    self.openTypeOS2VendorID = fontInfoV1.ttVendor
    self.openTypeNameVersion = fontInfoV1.ttVersion
    self.postscriptUniqueID = fontInfoV1.uniqueID
    self.unitsPerEm = fontInfoV1.unitsPerEm
    self.openTypeNameManufacturerURL = fontInfoV1.vendorURL
    self.versionMajor = fontInfoV1.versionMajor
    self.versionMinor = fontInfoV1.versionMinor
    self.postscriptWeightName = fontInfoV1.weightName
    self.openTypeOS2WeightClass = fontInfoV1.weightValue
    if let widthName = fontInfoV1.widthName {
      if widthNameToClass.keys.contains(widthName) {
        self.openTypeOS2WidthClass = widthNameToClass[widthName]
      } else {
        throw UFOError.cannotConvertValue
      }
    }
  }

//  public var bounds: CGRect {
//    get {
//      if let descender = self.descender,
//        let ascender = self.ascender {
//        return CGRect(x: 0.0, y: descender,
//                      width: 0.0, height: ascender - descender)
//      } else {
//        return CGRect.zero
//      }
//    }
//  }
}
