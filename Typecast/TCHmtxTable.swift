//
//  TCHmtxTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/14/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCHmtxTable: TCBaseTable {
  var hMetrics: [UInt32] = []
  var leftSideBearings: [Int16] = []

  init(dataInput: TCDataInput, directoryEntry: TCDirectoryEntry, hheaTable: TCHheaTable, maxpTable: TCMaxpTable) {
    for _ in 0 ..< hheaTable.numberOfHMetrics {
      let metric =
        UInt32(dataInput.readUInt8()) << 24
          | UInt32(dataInput.readUInt8()) << 16
          | UInt32(dataInput.readUInt8()) << 8
          | UInt32(dataInput.readUInt8())
      hMetrics.append(metric)
    }
    let lsbCount = maxpTable.numGlyphs - hheaTable.numberOfHMetrics
    for _ in 0..<lsbCount {
      leftSideBearings.append(dataInput.readInt16())
    }
    super.init(directoryEntry: directoryEntry)
  }

  func advanceWidth(index: Int) -> UInt16 {
    if index < hMetrics.count {
      return UInt16(hMetrics[index] >> 16)
    } else if let last = hMetrics.last {
      return UInt16(last >> 16)
    } else {
      return UInt16(hMetrics[hMetrics.count - 1] >> 16)
    }
  }

  func leftSideBearing(index: Int) -> UInt16 {
    if index < hMetrics.count {
      return UInt16(hMetrics[index] & 0xffff)
    } else if let last = hMetrics.last {
      return UInt16(last)
    } else {
      return UInt16(leftSideBearings[index - hMetrics.count])
    }
  }

  override class var tag: UInt32 {
    get {
      return TCTableTag.hmtx.rawValue
    }
  }

  override var description: String {
    get {
      var str = String.localizedStringWithFormat(
        "'hmtx' Table - Horizontal Metrics\n---------------------------------\n" +
        "Size = %d bytes, %ld entries\n",
        directoryEntry.length,
        hMetrics.count)
      for i in 0..<hMetrics.count {
        str.append("        \(i). advWid: \(advanceWidth(index: i)), LSdBear: \(leftSideBearing(index: i))\n")
      }
      for i in 0..<leftSideBearings.count {
        str.append("        LSdBear \(i + hMetrics.count): \(leftSideBearing(index: i))\n")
      }
      return str;
    }
  }
}
