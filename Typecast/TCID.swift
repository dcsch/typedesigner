//
//  TCID.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

// TODO Rework this as a fancy enum
class TCID {

  // Platform IDs
  static let platformUnicode = 0
  static let platformMacintosh = 1
  static let platformISO = 2
  static let platformMicrosoft = 3

  // Unicode Encoding IDs
  static let encodingUnicode10Semantics = 0
  static let encodingUnicode11Semantics = 1
  static let encodingISO10646Semantics = 2
  static let encodingUnicode20Semantics = 3

  // Microsoft Encoding IDs
  static let encodingSymbol = 0
  static let encodingUnicode = 1
  static let encodingShiftJIS = 2
  static let encodingPRC = 3
  static let encodingBig5 = 4
  static let encodingWansung = 5
  static let encodingJohab = 6
  static let encodingUCS4 = 10

  // Macintosh Encoding IDs
  static let encodingRoman = 0
  static let encodingJapanese = 1
  static let encodingChinese = 2
  static let encodingKorean = 3
  static let encodingArabic = 4
  static let encodingHebrew = 5
  static let encodingGreek = 6
  static let encodingRussian = 7
  static let encodingRSymbol = 8
  static let encodingDevanagari = 9
  static let encodingGurmukhi = 10
  static let encodingGujarati = 11
  static let encodingOriya = 12
  static let encodingBengali = 13
  static let encodingTamil = 14
  static let encodingTelugu = 15
  static let encodingKannada = 16
  static let encodingMalayalam = 17
  static let encodingSinhalese = 18
  static let encodingBurmese = 19
  static let encodingKhmer = 20
  static let encodingThai = 21
  static let encodingLaotian = 22
  static let encodingGeorgian = 23
  static let encodingArmenian = 24
  static let encodingMaldivian = 25
  static let encodingTibetan = 26
  static let encodingMongolian = 27
  static let encodingGeez = 28
  static let encodingSlavic = 29
  static let encodingVietnamese = 30
  static let encodingSindhi = 31
  static let encodingUninterp = 32

  // ISO Encoding IDs
  static let encodingASCII = 0
  static let encodingISO10646 = 1
  static let encodingISO8859_1 = 2

  // Name IDs
  static let nameCopyrightNotice = 0
  static let nameFontFamilyName = 1
  static let nameFontSubfamilyName = 2
  static let nameUniqueFontIdentifier = 3
  static let nameFullFontName = 4
  static let nameVersionString = 5
  static let namePostscriptName = 6
  static let nameTrademark = 7
  static let nameManufacturerName = 8
  static let nameDesigner = 9
  static let nameDescription = 10
  static let nameURLVendor = 11
  static let nameURLDesigner = 12
  static let nameLicenseDescription = 13
  static let nameLicenseInfoURL = 14
  static let namePreferredFamily = 16
  static let namePreferredSubfamily = 17
  static let nameCompatibleFull = 18
  static let nameSampleText = 19
  static let namePostScriptCIDFindfontName = 20

  class func platformName(platformID: Int) -> String {
    switch platformID {
    case platformUnicode:   return "Unicode"
    case platformMacintosh: return "Macintosh"
    case platformISO:       return "ISO"
    case platformMicrosoft: return "Microsoft"
    default:                return "Custom"
    }
  }

  class func encodingName(platformID: Int, encodingID: Int) -> String {
    if platformID == platformUnicode {
      // Unicode specific encodings
      switch encodingID {
      case encodingUnicode10Semantics: return "Unicode 1.0 semantics"
      case encodingUnicode11Semantics: return "Unicode 1.1 semantics"
      case encodingISO10646Semantics:  return "ISO 10646:1993 semantics"
      case encodingUnicode20Semantics: return "Unicode 2.0 and onwards semantics"
      default:                         return ""
      }
    } else if platformID == platformMacintosh {
      // Macintosh specific encodings
      switch encodingID {
      case encodingRoman:      return "Roman"
      case encodingJapanese:   return "Japanese"
      case encodingChinese:    return "Chinese"
      case encodingKorean:     return "Korean"
      case encodingArabic:     return "Arabic"
      case encodingHebrew:     return "Hebrew"
      case encodingGreek:      return "Greek"
      case encodingRussian:    return "Russian"
      case encodingRSymbol:    return "RSymbol"
      case encodingDevanagari: return "Devanagari"
      case encodingGurmukhi:   return "Gurmukhi"
      case encodingGujarati:   return "Gujarati"
      case encodingOriya:      return "Oriya"
      case encodingBengali:    return "Bengali"
      case encodingTamil:      return "Tamil"
      case encodingTelugu:     return "Telugu"
      case encodingKannada:    return "Kannada"
      case encodingMalayalam:  return "Malayalam"
      case encodingSinhalese:  return "Sinhalese"
      case encodingBurmese:    return "Burmese"
      case encodingKhmer:      return "Khmer"
      case encodingThai:       return "Thai"
      case encodingLaotian:    return "Laotian"
      case encodingGeorgian:   return "Georgian"
      case encodingArmenian:   return "Armenian"
      case encodingMaldivian:  return "Maldivian"
      case encodingTibetan:    return "Tibetan"
      case encodingMongolian:  return "Mongolian"
      case encodingGeez:       return "Geez"
      case encodingSlavic:     return "Slavic"
      case encodingVietnamese: return "Vietnamese"
      case encodingSindhi:     return "Sindhi"
      case encodingUninterp:   return "Uninterpreted"
      default:                   return ""
      }
    } else if platformID == platformISO {
      // ISO specific encodings
      switch encodingID {
      case encodingASCII:     return "7-bit ASCII"
      case encodingISO10646:  return "ISO 10646"
      case encodingISO8859_1: return "ISO 8859-1"
      default:                  return ""
      }
    } else if platformID == platformMicrosoft {
      // Windows specific encodings
      switch encodingID {
      case encodingSymbol:   return "Symbol"
      case encodingUnicode:  return "Unicode"
      case encodingShiftJIS: return "ShiftJIS"
      case encodingPRC:      return "PRC"
      case encodingBig5:     return "Big5"
      case encodingWansung:  return "Wansung"
      case encodingJohab:    return "Johab"
      case 7:                return "Reserved"
      case 8:                return "Reserved"
      case 9:                return "Reserved"
      case encodingUCS4:     return "UCS-4"
      default:               return ""
      }
    } else {
      return ""
    }
  }

  class func nameName(nameID: Int) -> String {
    switch nameID {
    case nameCopyrightNotice: return "Copyright notice"
    case nameFontFamilyName: return "Font Family name"
    case nameFontSubfamilyName: return "Font Subfamily name"
    case nameUniqueFontIdentifier: return "Unique font identifier"
    case nameFullFontName: return "Full font name"
    case nameVersionString: return "Version string"
    case namePostscriptName: return "Postscript name"
    case nameTrademark: return "Trademark"
    case nameManufacturerName: return "Manufacturer Name"
    case nameDesigner: return "Designer"
    case nameDescription: return "Description"
    case nameURLVendor: return "URL Vendor"
    case nameURLDesigner: return "URL Designer"
    case nameLicenseDescription: return "License Description"
    case nameLicenseInfoURL: return "License Info URL"
    case namePreferredFamily: return "Preferred Family"
    case namePreferredSubfamily: return "Preferred Subfamily"
    case nameCompatibleFull: return "Compatible Full"
    case nameSampleText: return "Sample text"
    case namePostScriptCIDFindfontName: return "PostScript CID findfont name"
    default: return ""
    }
  }
}
