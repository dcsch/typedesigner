//
//  TCID.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

protocol Encoding: CustomStringConvertible, Codable {
  var rawValue: Int { get }
}

class TCID: Codable {

  // Platform IDs
  enum Platform: Int, CustomStringConvertible, Codable {
    case unknown = -1
    case unicode = 0
    case macintosh = 1
    case iso = 2
    case microsoft = 3

    func encoding(id: Int) -> Encoding? {
      switch self {
      case .unicode:
        return UnicodeEncoding(rawValue: id)
      case .macintosh:
        return MacintoshEncoding(rawValue: id)
      case .iso:
        return ISOEncoding(rawValue: id)
      case .microsoft:
        return MicrosoftEncoding(rawValue: id)
      default:
        return CustomEncoding.unknown
      }
    }

    var description: String {
      get {
        switch self {
        case .unicode:   return "Unicode"
        case .macintosh: return "Macintosh"
        case .iso:       return "ISO"
        case .microsoft: return "Microsoft"
        default:         return "Custom"
        }
      }
    }
  }

  // Unicode Encoding IDs
  enum UnicodeEncoding: Int, Encoding, CustomStringConvertible, Codable {
    case unknown = -1
    case unicode10Semantics = 0
    case unicode11Semantics = 1
    case iso10646Semantics = 2
    case unicode20Semantics = 3

    var description: String {
      get {
        switch self {
        case .unicode10Semantics: return "Unicode 1.0 semantics"
        case .unicode11Semantics: return "Unicode 1.1 semantics"
        case .iso10646Semantics:  return "ISO 10646:1993 semantics"
        case .unicode20Semantics: return "Unicode 2.0 and onwards semantics"
        default:                  return "unknown"
        }
      }
    }
  }

  // Microsoft Encoding IDs
  enum MicrosoftEncoding: Int, Encoding, CustomStringConvertible, Codable {
    case unknown = -1
    case symbol = 0
    case unicode = 1
    case shiftJIS = 2
    case prc = 3
    case big5 = 4
    case wansung = 5
    case johab = 6
    case ucs4 = 10

    var description: String {
      get {
        switch self {
        case .symbol:   return "Symbol"
        case .unicode:  return "Unicode"
        case .shiftJIS: return "ShiftJIS"
        case .prc:      return "PRC"
        case .big5:     return "Big5"
        case .wansung:  return "Wansung"
        case .johab:    return "Johab"
        case .ucs4:     return "UCS-4"
        default:        return "unknown"
        }
      }
    }
  }

  // Macintosh Encoding IDs
  enum MacintoshEncoding: Int, Encoding, CustomStringConvertible, Codable {
    case unknown = -1
    case roman = 0
    case japanese = 1
    case chinese = 2
    case korean = 3
    case arabic = 4
    case hebrew = 5
    case greek = 6
    case russian = 7
    case rSymbol = 8
    case devanagari = 9
    case gurmukhi = 10
    case gujarati = 11
    case oriya = 12
    case bengali = 13
    case tamil = 14
    case telugu = 15
    case kannada = 16
    case malayalam = 17
    case sinhalese = 18
    case burmese = 19
    case khmer = 20
    case thai = 21
    case laotian = 22
    case georgian = 23
    case armenian = 24
    case maldivian = 25
    case tibetan = 26
    case mongolian = 27
    case geez = 28
    case slavic = 29
    case vietnamese = 30
    case sindhi = 31
    case uninterp = 32

    var description: String {
      get {
        switch self {
        case .roman:      return "Roman"
        case .japanese:   return "Japanese"
        case .chinese:    return "Chinese"
        case .korean:     return "Korean"
        case .arabic:     return "Arabic"
        case .hebrew:     return "Hebrew"
        case .greek:      return "Greek"
        case .russian:    return "Russian"
        case .rSymbol:    return "RSymbol"
        case .devanagari: return "Devanagari"
        case .gurmukhi:   return "Gurmukhi"
        case .gujarati:   return "Gujarati"
        case .oriya:      return "Oriya"
        case .bengali:    return "Bengali"
        case .tamil:      return "Tamil"
        case .telugu:     return "Telugu"
        case .kannada:    return "Kannada"
        case .malayalam:  return "Malayalam"
        case .sinhalese:  return "Sinhalese"
        case .burmese:    return "Burmese"
        case .khmer:      return "Khmer"
        case .thai:       return "Thai"
        case .laotian:    return "Laotian"
        case .georgian:   return "Georgian"
        case .armenian:   return "Armenian"
        case .maldivian:  return "Maldivian"
        case .tibetan:    return "Tibetan"
        case .mongolian:  return "Mongolian"
        case .geez:       return "Geez"
        case .slavic:     return "Slavic"
        case .vietnamese: return "Vietnamese"
        case .sindhi:     return "Sindhi"
        case .uninterp:   return "Uninterpreted"
        default:          return "unknown"
        }
      }
    }
  }

  // ISO Encoding IDs
  enum ISOEncoding: Int, Encoding, CustomStringConvertible, Codable {
    case unknown = -1
    case ascii = 0
    case iso10646 = 1
    case iso8859_1 = 2

    var description: String {
      get {
        switch self {
        case .ascii:     return "7-bit ASCII"
        case .iso10646:  return "ISO 10646"
        case .iso8859_1: return "ISO 8859-1"
        default:         return "unknown"
        }
      }
    }
  }

  // Custom Encoding
  enum CustomEncoding: Int, Encoding, CustomStringConvertible, Codable {
    case unknown = -1

    var description: String {
      get {
        return "Custom encoding (\(rawValue))"
      }
    }
  }
}
