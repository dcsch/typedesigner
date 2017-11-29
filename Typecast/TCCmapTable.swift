//
//  TCCmapTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils
import os.log

class TCCmapTable: TCTable, Codable {

  class IndexEntry: Comparable, CustomStringConvertible {
    let platformID: TCID.Platform
    let encodingID: Encoding
    let offset: Int
    var format: TCCmapFormat?

    var platformDescription: String {
      get {
        return String(describing: platformID)
      }
    }

    var encodingDescription: String {
      get {
        return String(describing: encodingID)
      }
    }

    init(dataInput: TCDataInput) {
      platformID = TCID.Platform(rawValue: Int(dataInput.readUInt16())) ?? .unknown
      let encodingIDRawValue = Int(dataInput.readUInt16())
      encodingID = platformID.encoding(id: encodingIDRawValue) ?? TCID.CustomEncoding.unknown
      offset = Int(dataInput.readUInt32())
    }

    var description: String {
      get {
        return "platform id: \(platformID.rawValue) (\(platformDescription)), encoding id: \(encodingID.rawValue) (\(encodingDescription)), offset: \(offset)"
      }
    }

    static func ==(lhs: IndexEntry, rhs: IndexEntry) -> Bool {
      return lhs.offset == rhs.offset
    }

    static func <(lhs: IndexEntry, rhs: IndexEntry) -> Bool {
      return lhs.offset < rhs.offset
    }

    static func <=(lhs: IndexEntry, rhs: IndexEntry) -> Bool {
      return lhs.offset <= rhs.offset
    }

    static func >(lhs: IndexEntry, rhs: IndexEntry) -> Bool {
      return lhs.offset > rhs.offset
    }

    static func >=(lhs: IndexEntry, rhs: IndexEntry) -> Bool {
      return lhs.offset >= rhs.offset
    }
  }

  let version: UInt16
  let numTables: Int
  var mappings: [CharacterToGlyphMapping]

  override init() {
    version = 0
    numTables = 0
    mappings = []
    super.init()
  }

  init(data: Data) throws {
    let dataInput = TCDataInput(data: data)
    version = dataInput.readUInt16()
    numTables = Int(dataInput.readUInt16())
    var bytesRead = 4
    var entries = [IndexEntry]()
    mappings = []

    // Get each of the index entries
    for _ in 0..<numTables {
      let indexEntry = IndexEntry(dataInput: dataInput)
      entries.append(indexEntry)
      bytesRead += 8
      os_log("indexEntry: %@", String(describing: indexEntry))
    }

    // Sort into their order of offset
    entries.sort()

    // Get each of the tables
    var lastOffset = 0
    var lastFormat: TCCmapFormat? = nil
    for entry in entries {
      if entry.offset == lastOffset {
        // This is a multiple entry
        entry.format = lastFormat
        continue
      } else if entry.offset > bytesRead {
        _ = dataInput.read(length: entry.offset - bytesRead)
      } else if entry.offset != bytesRead {
        // Something is amiss
        throw TCTableError.badOffset(message: "IndexEntry offset is bad")
      }
      let formatType = Int(dataInput.readUInt16())
      lastFormat = TCCmapFormatFactory.cmapFormat(type: formatType, dataInput: dataInput)
      lastOffset = entry.offset
      entry.format = lastFormat
      bytesRead += (lastFormat?.length)!

      if let format = lastFormat {
        mappings.append(CharacterToGlyphMapping(encodedMap: format))
      }
    }
    super.init()
  }

  override class var tag: TCTable.Tag {
    get {
      return .cmap
    }
  }

  override var description: String {
    get {
      let str = "cmap\n"
//      for entry in entries {
//        str += "\(entry)\n"
//      }
      return str
    }
  }
}
