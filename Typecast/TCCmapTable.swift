//
//  TCCmapTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCCmapTable: TCBaseTable {
  let version: UInt16
  let numTables: Int
  let entries: [TCCmapIndexEntry]

  init(dataInput: TCDataInput, directoryEntry: TCDirectoryEntry) throws {
    version = dataInput.readUInt16()
    numTables = Int(dataInput.readUInt16())
    var bytesRead = 4
    var entries = [TCCmapIndexEntry]()

    // Get each of the index entries
    for _ in 0..<numTables {
      entries.append(TCCmapIndexEntry(dataInput: dataInput))
      bytesRead += 8
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
    }
    self.entries = entries
    super.init(directoryEntry: directoryEntry)
  }

  override var type: UInt32 {
    get {
      return TCTableType.cmap.rawValue
    }
  }

  override var description: String {
    get {
      var str = "cmap\n"

      // Get each of the index entries
      for entry in entries {
        str.append(entry.description)
        str.append("\n")
      }

      return str;
    }
  }
}
