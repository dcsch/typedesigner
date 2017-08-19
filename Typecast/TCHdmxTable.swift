//
//  TCHdmxTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/18/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

/**
 The Horizontal Device Metrics table for TrueType outlines.  This stores
 integer advance widths scaled to specific pixel sizes.
 */
class TCHdmxTable: TCBaseTable {

  class DeviceRecord {
    let pixelSize: Int
    let maxWidth: Int
    var widths = [Int]()

    init(numGlyphs: Int, dataInput: TCDataInput) {
      pixelSize = Int(dataInput.readInt8())
      maxWidth = Int(dataInput.readInt8())
      widths.reserveCapacity(numGlyphs)
      for _ in 0..<numGlyphs {
        widths.append(Int(dataInput.readInt8()))
      }
    }
  }

  let version: Int
  let numRecords: Int
  let sizeDeviceRecords: Int
  var records = [DeviceRecord]()

  init(dataInput: TCDataInput, directoryEntry: TCDirectoryEntry, maxpTable: TCMaxpTable) {
    version = Int(dataInput.readUInt16())
    numRecords = Int(dataInput.readInt16())
    sizeDeviceRecords = Int(dataInput.readInt32())
    records.reserveCapacity(numRecords)

    // Read the device records
    for _ in 0..<numRecords {
      records.append(DeviceRecord(numGlyphs: maxpTable.numGlyphs,
                                  dataInput: dataInput))
    }
    super.init(directoryEntry: directoryEntry)
  }

  override class var tag: UInt32 {
    get {
      return TCTableTag.hdmx.rawValue
    }
  }

  override var description: String {
    get {
      var str =
        "'hdmx' Table - Horizontal Device Metrics\n----------------------------------------\n" +
        "Size = \(directoryEntry.length) bytes\n" +
        "\t'hdmx' version:         \(version)\n" +
        "\t# device records:       \(numRecords)\n" +
        "\tRecord length:          \(sizeDeviceRecords)\n"
      for (i, record) in records.enumerated() {
        str.append("\tDevRec \(i): ppem = \(record.pixelSize), maxWid = \(record.maxWidth)\n")
        for (j, width) in record.widths.enumerated() {
          str.append("    \(j).   \(width)\n")
        }
        str.append("\n\n")
      }
      return str
    }
  }
}
