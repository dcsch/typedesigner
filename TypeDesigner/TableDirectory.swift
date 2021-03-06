//
//  TableDirectory.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/31/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TableDirectory: CustomStringConvertible {

  struct Entry: CustomStringConvertible {
    let tag: UInt32
    let checksum: UInt32
    let offset: Int
    let length: Int
    var tagAsString: String {
      get {
        return String(format: "%c%c%c%c",
                      CChar(truncatingIfNeeded: tag >> 24),
                      CChar(truncatingIfNeeded: tag >> 16),
                      CChar(truncatingIfNeeded: tag >> 8),
                      CChar(truncatingIfNeeded: tag))
      }
    }

    init(dataInput: TCDataInput) {
      tag = dataInput.readUInt32()
      checksum = dataInput.readUInt32()
      offset = Int(dataInput.readUInt32())
      length = Int(dataInput.readUInt32())
    }

    init(tag: Table.Tag, checksum: UInt32, offset: Int, length: Int) {
      self.tag = tag.rawValue
      self.checksum = checksum
      self.offset = offset
      self.length = length
    }

    var description: String {
      get {
        return String(format:"'%@' - chksm = 0x%x, off = 0x%x, len = %d",
                      tagAsString,
                      checksum,
                      offset,
                      length)
      }
    }
  }

  var version: UInt32
  var searchRange: UInt16
  var entrySelector: UInt16
  var rangeShift: UInt16
  var entries = [Entry]()

  init(isCFF: Bool) {
    version = isCFF ? 0x4F54544F : 0x00010000
    searchRange = 0
    entrySelector = 0
    rangeShift = 0
  }

  init(dataInput: TCDataInput) {
    version = dataInput.readUInt32()
    let numTables = Int(dataInput.readUInt16())
    searchRange = dataInput.readUInt16()
    entrySelector = dataInput.readUInt16()
    rangeShift = dataInput.readUInt16()
    for _ in 0..<numTables {
      entries.append(Entry(dataInput: dataInput))
    }
  }

  func calculateHeader() {
    let maxPow2 = Int(floor(log2(Double(entries.count))))
    searchRange = UInt16(16 * (2 << (maxPow2 - 1)))
    entrySelector = UInt16(log2(Double(2 << (maxPow2 - 1))))
    rangeShift = UInt16(16 * entries.count) - searchRange
  }

  func entry(tag: Table.Tag) -> Entry? {
    for entry in entries {
      if entry.tag == tag.rawValue {
        return entry
      }
    }
    return nil
  }

  func hasEntry(tag: Table.Tag) -> Bool {
    for entry in entries {
      if entry.tag == tag.rawValue {
        return true
      }
    }
    return false
  }

  func appendEntry(tag: Table.Tag, offset: Int, data: Data) -> Int {
    entries.append(TableDirectory.Entry(tag: tag,
                                        checksum: data.checksum,
                                        offset: offset,
                                        length: data.count))
    return offset + data.count
  }

  var description: String {
    get {
      var str = """
        Offset Table
        ------ -----
        sfnt version:     \(version)
        numTables =       \(entries.count)
        searchRange =     \(searchRange)
        entrySelector =   \(entrySelector)
        rangeShift =      \(rangeShift)


      """
      for (i, entry) in entries.enumerated() {
        str += "\(i). \(entry)\n"
      }
      return str
    }
  }
}
