//
//  TCNameTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/1/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils
import os.log

class TCNameTable: TCTable, Codable {

  enum NameID: Int, CustomStringConvertible, Codable {
    case unknown = -1
    case copyrightNotice = 0
    case fontFamilyName = 1
    case fontSubfamilyName = 2
    case uniqueFontIdentifier = 3
    case fullFontName = 4
    case versionString = 5
    case postscriptName = 6
    case trademark = 7
    case manufacturerName = 8
    case designer = 9
    case description = 10
    case urlVendor = 11
    case urlDesigner = 12
    case licenseDescription = 13
    case licenseInfoURL = 14
    case preferredFamily = 16
    case preferredSubfamily = 17
    case compatibleFull = 18
    case sampleText = 19
    case postScriptCIDFindfontName = 20

    var description: String {
      get {
        switch self {
        case .copyrightNotice: return "Copyright notice"
        case .fontFamilyName: return "Font Family name"
        case .fontSubfamilyName: return "Font Subfamily name"
        case .uniqueFontIdentifier: return "Unique font identifier"
        case .fullFontName: return "Full font name"
        case .versionString: return "Version string"
        case .postscriptName: return "Postscript name"
        case .trademark: return "Trademark"
        case .manufacturerName: return "Manufacturer Name"
        case .designer: return "Designer"
        case .description: return "Description"
        case .urlVendor: return "URL Vendor"
        case .urlDesigner: return "URL Designer"
        case .licenseDescription: return "License Description"
        case .licenseInfoURL: return "License Info URL"
        case .preferredFamily: return "Preferred Family"
        case .preferredSubfamily: return "Preferred Subfamily"
        case .compatibleFull: return "Compatible Full"
        case .sampleText: return "Sample text"
        case .postScriptCIDFindfontName: return "PostScript CID findfont name"
        default: return "unknown"
        }
      }
    }
  }

  class Record: Codable {
    let platformID: TCID.Platform
    let encodingID: Int
    let languageID: Int
    let nameID: NameID
    var record: String

    init(dataInput: TCDataInput, stringData: Data) {
      platformID = TCID.Platform(rawValue: Int(dataInput.readInt16())) ?? .unknown
      encodingID = Int(dataInput.readInt16())
      languageID = Int(dataInput.readInt16())
      nameID = NameID(rawValue: Int(dataInput.readInt16())) ?? .unknown
      let stringLength = Int(dataInput.readInt16())
      let stringOffset = Int(dataInput.readInt16())

      let stringSubData = stringData.subdata(in: stringOffset..<(stringOffset + stringLength))
      switch platformID {
      case .unicode:
        // Unicode (big-endian)
        record = String(data: stringSubData, encoding: .utf16BigEndian) ?? "(UTF-16 decoding error)"
      case .macintosh:
        // Macintosh encoding, ASCII
        record = String(data: stringSubData, encoding: .ascii) ?? "(ASCII decoding error)"
      case .iso:
        // ISO encoding, ASCII
        record = String(data: stringSubData, encoding: .ascii) ?? "(ASCII decoding error)"
      case .microsoft:
        // Microsoft encoding, Unicode
        record = String(data: stringSubData, encoding: .utf16LittleEndian) ?? "(UTF-16 decoding error)"
      default:
        record = "(Unsupported encoding)"
      }
    }
  }

  var nameRecords: [Record]

  override init() {
    nameRecords = []
    super.init()
  }

  init(data: Data) {
    let dataInput = TCDataInput(data: data)
    let format = dataInput.readInt16()
    let numberOfNameRecords = Int(dataInput.readInt16())
    let stringStorageOffset = Int(dataInput.readInt16())
    nameRecords = []

    // Load the records, which contain the encoding information and string
    // offsets
    let stringData = data.subdata(in: stringStorageOffset..<data.count)
    for _ in 0..<numberOfNameRecords {
      nameRecords.append(Record(dataInput: dataInput, stringData: stringData))
    }

    if format == 1 {
      os_log("Naming table format 1")
    }
    super.init()
  }

  override class var tag: TCTable.Tag {
    get {
      return .name
    }
  }

  func record(nameID: NameID) -> Record? {
    // Search for the first instance of this name ID
    for record in nameRecords {
      if record.nameID == nameID {
        return record
      }
    }
    return nil
  }
}
