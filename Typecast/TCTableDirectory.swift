//
//  TCTableDirectory.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/31/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCTableDirectory: NSObject {
  let version: UInt32
  let numTables: Int
  let searchRange: UInt16
  let entrySelector: UInt16
  let rangeShift: UInt16
  let entries: [TCDirectoryEntry]

  init(dataInput: TCDataInput) {
    version = dataInput.readUInt32()
    numTables = Int(dataInput.readUInt16())
    searchRange = dataInput.readUInt16()
    entrySelector = dataInput.readUInt16()
    rangeShift = dataInput.readUInt16()
    var m_entries: [TCDirectoryEntry] = []
    for _ in 0 ..< numTables {
      m_entries.append(TCDirectoryEntry(dataInput: dataInput))
    }
    entries = m_entries
  }

  func entry(tag: UInt32) -> TCDirectoryEntry? {
    for entry in entries {
      if entry.tag == tag {
        return entry
      }
    }
    return nil
  }

  func hasEntry(tag: UInt32) -> Bool {
    for entry in entries {
      if entry.tag == tag {
        return true
      }
    }
    return false
  }

  override var description: String {
    get {
      var str = String(format:
        "Offset Table\n------ -----" +
        "\n  sfnt version:     %d" +
        "\n  numTables =       %d" +
        "\n  searchRange =     %d" +
        "\n  entrySelector =   %d" +
        "\n  rangeShift =      %d\n\n",
        version,
        numTables,
        searchRange,
        entrySelector,
        rangeShift)
      for i in 0 ..< numTables {
        str.append(String(format: "%d. %s\n", i, entries[i].description))
      }
      return str;
    }
  }
}
