//
//  TCNameTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/1/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCNameTable: TCBaseTable, Codable {

  enum NameID: Int, Codable {
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
  }

  class Record: Codable {
    let platformID: Int
    let encodingID: Int
    let languageID: Int
    let nameID: NameID
    let stringLength: Int
    let stringOffset: Int
    var record: String

    init(dataInput: TCDataInput, stringData: Data) {
      platformID = Int(dataInput.readInt16())
      encodingID = Int(dataInput.readInt16())
      languageID = Int(dataInput.readInt16())
      nameID = NameID(rawValue: Int(dataInput.readInt16())) ?? .unknown
      stringLength = Int(dataInput.readInt16())
      stringOffset = Int(dataInput.readInt16())

      let stringSubData = stringData.subdata(in: stringOffset..<(stringOffset + stringLength))
      switch platformID {
      case TCID.platformUnicode:
        // Unicode (big-endian)
        record = String(data: stringSubData, encoding: .utf16BigEndian) ?? "(UTF-16 decoding error)"
      case TCID.platformMacintosh:
        // Macintosh encoding, ASCII
        record = String(data: stringSubData, encoding: .ascii) ?? "(ASCII decoding error)"
      case TCID.platformISO:
        // ISO encoding, ASCII
        record = String(data: stringSubData, encoding: .ascii) ?? "(ASCII decoding error)"
      case TCID.platformMicrosoft:
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
    _ = dataInput.readInt16() // formatSelector
    let numberOfNameRecords = Int(dataInput.readInt16())
    let stringStorageOffset = Int(dataInput.readInt16())
    nameRecords = []

    // Load the records, which contain the encoding information and string
    // offsets
    let stringData = data.subdata(in: stringStorageOffset..<data.count)
    for _ in 0..<numberOfNameRecords {
      nameRecords.append(Record(dataInput: dataInput, stringData: stringData))
    }
    super.init()
  }

  override class var tag: UInt32 {
    get {
      return TCTableTag.name.rawValue
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
