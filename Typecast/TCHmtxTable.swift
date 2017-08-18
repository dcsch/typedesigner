//
//  TCHmtxTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/14/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

/**
 Horizontal Metrics
 */
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

  func advanceWidth(at index: Int) -> Int {
    if index < hMetrics.count {
      return Int(hMetrics[index] >> 16)
    } else if let last = hMetrics.last {
      return Int(last >> 16)
    } else {
      return Int(hMetrics[hMetrics.count - 1] >> 16)
    }
  }

  func leftSideBearing(at index: Int) -> Int {
    if index < hMetrics.count {
      return Int(hMetrics[index] & 0xffff)
    } else if let last = hMetrics.last {
      return Int(last)
    } else {
      return Int(leftSideBearings[index - hMetrics.count])
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
        str.append("        \(i). advWid: \(advanceWidth(at: i)), LSdBear: \(leftSideBearing(at: i))\n")
      }
      for i in 0..<leftSideBearings.count {
        str.append("        LSdBear \(i + hMetrics.count): \(leftSideBearing(at: i))\n")
      }
      return str;
    }
  }
}
