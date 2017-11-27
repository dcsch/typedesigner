//
//  TCTableDirectory.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/31/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCTableDirectory: CustomStringConvertible {
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

  func entry(tag: TCTable.Tag) -> TCDirectoryEntry? {
    for entry in entries {
      if entry.tag == tag.rawValue {
        return entry
      }
    }
    return nil
  }

  func hasEntry(tag: TCTable.Tag) -> Bool {
    for entry in entries {
      if entry.tag == tag.rawValue {
        return true
      }
    }
    return false
  }

  var description: String {
    get {
      var str = """
        Offset Table
        ------ -----
        sfnt version:     \(version)
        numTables =       \(numTables)
        searchRange =     \(searchRange)
        entrySelector =   \(entrySelector)
        rangeShift =      \(rangeShift)


      """
      for (i, entry) in entries.enumerated() {
        str += String(format: "%d. %@\n", i, String(describing: entry))
      }
      return str
    }
  }
}
