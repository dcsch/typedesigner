//
//  TCNameTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/1/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCNameRecord {
  let platformId: Int
  let encodingId: Int
  let languageId: Int
  let nameId: Int
  let stringLength: Int
  let stringOffset: Int
  var record: String?

  init(dataInput: TCDataInput, stringData: Data) {
    platformId = Int(dataInput.readInt16())
    encodingId = Int(dataInput.readInt16())
    languageId = Int(dataInput.readInt16())
    nameId = Int(dataInput.readInt16())
    stringLength = Int(dataInput.readInt16())
    stringOffset = Int(dataInput.readInt16())

    let stringSubData = stringData.subdata(in: stringOffset..<(stringOffset + stringLength))
    switch platformId {
    case TCID.platformUnicode:
      // Unicode (big-endian)
      record = String(data: stringSubData, encoding: .utf16BigEndian)
    case TCID.platformMacintosh:
      // Macintosh encoding, ASCII
      record = String(data: stringSubData, encoding: .ascii)
    case TCID.platformISO:
      // ISO encoding, ASCII
      record = String(data: stringSubData, encoding: .ascii)
    case TCID.platformMicrosoft:
      // Microsoft encoding, Unicode
      record = String(data: stringSubData, encoding: .utf16LittleEndian)
    default:
      record = nil
    }
  }
}

class TCNameTable: TCBaseTable {
  let formatSelector: Int16
  let numberOfNameRecords: Int16
  let stringStorageOffset: Int16
  var nameRecords: [TCNameRecord]

  init(data: Data, directoryEntry entry: TCDirectoryEntry) {
    let dataInput = TCDataInput(data: data)
    formatSelector = dataInput.readInt16()
    numberOfNameRecords = dataInput.readInt16()
    stringStorageOffset = dataInput.readInt16()
    nameRecords = []

    // Load the records, which contain the encoding information and string
    // offsets
    let stringData = data.subdata(in: Int(stringStorageOffset)..<data.count)
    for _ in 0..<numberOfNameRecords {
      nameRecords.append(TCNameRecord(dataInput: dataInput, stringData: stringData))
    }
    super.init(directoryEntry: entry)
  }

  override class var tag: UInt32 {
    get {
      return TCTableTag.name.rawValue
    }
  }

  func record(nameId: Int) -> TCNameRecord? {
    // Search for the first instance of this name ID
    for record in nameRecords {
      if record.nameId == nameId {
        return record
      }
    }
    return nil
  }
}
