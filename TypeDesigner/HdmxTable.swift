//
//  HdmxTable.swift
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
class HdmxTable: Table, Codable {

  class DeviceRecord: Codable {
    let pixelSize: Int
    let maxWidth: Int
    var widths = [Int]()

    init(numGlyphs: Int, dataInput: TCDataInput) {
      pixelSize = Int(dataInput.readUInt8())
      maxWidth = Int(dataInput.readUInt8())
      widths.reserveCapacity(numGlyphs)
      var bytesRead = 2
      for _ in 0..<numGlyphs {
        widths.append(Int(dataInput.readUInt8()))
        bytesRead += 1
      }
      let remainingBytes = bytesRead % 4
      _ = dataInput.read(length: remainingBytes)
    }
  }

  var records = [DeviceRecord]()

  init(data: Data, numGlyphs: Int) {
    let dataInput = TCDataInput(data: data)
    _ = Int(dataInput.readUInt16()) // version
    let numRecords = Int(dataInput.readInt16())
    _ = Int(dataInput.readInt32()) // sizeDeviceRecords
    records.reserveCapacity(numRecords)

    // Read the device records
    for _ in 0..<numRecords {
      records.append(DeviceRecord(numGlyphs: numGlyphs,
                                  dataInput: dataInput))
    }
    super.init()
  }

  override var description: String {
    get {
      var str = """
      'hdmx' Table - Horizontal Device Metrics
      ----------------------------------------

      """
      for (i, record) in records.enumerated() {
        str += "\tDevRec \(i): ppem = \(record.pixelSize), maxWid = \(record.maxWidth)\n"
        for (j, width) in record.widths.enumerated() {
          str += "    \(j).   \(width)\n"
        }
        str += "\n\n"
      }
      return str
    }
  }
}
