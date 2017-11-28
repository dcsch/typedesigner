//
//  TableWriter.swift
//  Type Designer
//
//  Created by David Schweinsberg on 11/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TableWriter {
//  var data: Data
//
//  init(data: Data) {
//
//  }

  class func write(directory: TCTableDirectory, to data: inout Data) {
    let sfntVersion = UInt32(0x00010000)
    data.append(sfntVersion)
    data.append(UInt16(directory.entries.count))
    data.append(UInt16(directory.searchRange))
    data.append(UInt16(directory.entrySelector))
    data.append(UInt16(directory.rangeShift))
  }

  class func write(head: TCHeadTable) -> Data {
    let magicNumber: UInt32 = 0x5F0F3CF5
    var data = Data()
    data.append(UInt16(1))
    data.append(UInt16(0))
    data.append(UInt32(head.fontRevision))
    data.append(magicNumber)
    data.append(UInt16(head.flags))
    data.append(UInt16(head.unitsPerEm))
    data.append(UInt64(head.created.timeIntervalSince(TCHeadTable.epoch)))
    data.append(UInt64(head.modified.timeIntervalSince(TCHeadTable.epoch)))
    data.append(Int16(head.xMin))
    data.append(Int16(head.yMin))
    data.append(Int16(head.xMax))
    data.append(Int16(head.yMax))
    data.append(UInt16(head.macStyle))
    data.append(UInt16(head.lowestRecPPEM))
    data.append(Int16(head.fontDirectionHint))
    data.append(Int16(head.indexToLocFormat))
    data.append(Int16(head.glyphDataFormat))
    data.append(UInt16(0))
    return data
  }

  class func write(hhea: TCHheaTable) -> Data {
    var data = Data()
    data.append(UInt16(1))
    data.append(UInt16(0))
    data.append(Int16(hhea.ascender))
    data.append(Int16(hhea.descender))
    data.append(Int16(hhea.lineGap))
    data.append(UInt16(hhea.advanceWidthMax))
    data.append(Int16(hhea.minLeftSideBearing))
    data.append(Int16(hhea.minRightSideBearing))
    data.append(Int16(hhea.xMaxExtent))
    data.append(Int16(hhea.caretSlopeRise))
    data.append(Int16(hhea.caretSlopeRun))
    data.append(Int16(hhea.caretOffset))
    data.append(Int16(0))
    data.append(Int16(0))
    data.append(Int16(0))
    data.append(Int16(0))
    data.append(Int16(hhea.metricDataFormat))
    data.append(UInt16(hhea.numberOfHMetrics))
    return data
  }
}

extension Data {

  mutating func append<T: FixedWidthInteger>(_ integer: T) {
    var bigEndian = integer.bigEndian
    append(UnsafeBufferPointer(start: &bigEndian, count: 1))
  }

  var checksum: UInt32 {
    get {
      return withUnsafeBytes { (dataPtr: UnsafePointer<UInt32>) -> UInt32 in
        var ptr = dataPtr
        var sum: UInt32 = 0
        for _ in 0..<(count / 4) {
          (sum, _) = sum.addingReportingOverflow(ptr.pointee.bigEndian)
          ptr += 1
        }
        return sum
      }
    }
  }
}
