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

class TCCmapTable: TCBaseTable, Codable {
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
    var entries = [TCCmapIndexEntry]()
    mappings = []

    // Get each of the index entries
    for _ in 0..<numTables {
      let indexEntry = TCCmapIndexEntry(dataInput: dataInput)
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
        throw TCTableError.badOffset(message: "TCCmapIndexEntry offset is bad")
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

  override class var tag: UInt32 {
    get {
      return TCTableTag.cmap.rawValue
    }
  }

  override var description: String {
    get {
      let str = "cmap\n"

      // Get each of the index entries
//      for entry in entries {
//        str.append(entry.description)
//        str.append("\n")
//      }

      return str;
    }
  }
}
