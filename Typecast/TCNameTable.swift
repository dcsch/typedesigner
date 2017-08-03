//
//  TCNameTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/1/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCNameRecord {
  let platformId: Int16
  let encodingId: Int16
  let languageId: Int16
  let nameId: Int16
  let stringLength: Int16
  let stringOffset: Int16
  var record: String?

  init(dataInput: TCDataInput, stringData: Data) {
    platformId = dataInput.readInt16()
    encodingId = dataInput.readInt16()
    languageId = dataInput.readInt16()
    nameId = dataInput.readInt16()
    stringLength = dataInput.readInt16()
    stringOffset = dataInput.readInt16()

    let stringSubData = stringData.subdata(in: Int(stringOffset)..<Int(stringOffset+stringLength))
    switch platformId {
    case TCPlatformUnicode:
      // Unicode (big-endian)
      record = String(data: stringSubData, encoding: .utf16BigEndian)
    case TCPlatformMacintosh:
      // Macintosh encoding, ASCII
      record = String(data: stringSubData, encoding: .ascii)
    case TCPlatformISO:
      // ISO encoding, ASCII
      record = String(data: stringSubData, encoding: .ascii)
    case TCPlatformMicrosoft:
      // Microsoft encoding, Unicode
      record = String(data: stringSubData, encoding: .utf16LittleEndian)
    default:
      record = nil
    }
  }
}

class TCNameTable: TCTable {
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
    super.init()
    self.directoryEntry = entry.copy() as! TCDirectoryEntry
  }

  override var type: UInt32 {
    get {
      return TCTableType.name.rawValue
    }
  }

  func record(nameId: Int16) -> TCNameRecord? {
    // Search for the first instance of this name ID
    for record in nameRecords {
      if record.nameId == nameId {
        return record
      }
    }
    return nil
  }
}
