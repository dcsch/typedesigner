//
//  TCVmtxTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/18/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

/**
 Vertical Metrics
 */
class TCVmtxTable: TCBaseTable {
  var vMetrics: [UInt32] = []
  var topSideBearings: [Int16] = []
  let dataCount: Int

  init(data: Data, vheaTable: TCVheaTable, maxpTable: TCMaxpTable) {
    dataCount = data.count
    let dataInput = TCDataInput(data: data)
    for _ in 0..<vheaTable.numberOfLongVerMetrics {
      let metric =
        UInt32(dataInput.readUInt8()) << 24
          | UInt32(dataInput.readUInt8()) << 16
          | UInt32(dataInput.readUInt8()) << 8
          | UInt32(dataInput.readUInt8())
      vMetrics.append(metric)
    }
    let tsbCount = maxpTable.numGlyphs - vheaTable.numberOfLongVerMetrics
    for _ in 0..<tsbCount {
      topSideBearings.append(dataInput.readInt16())
    }
    super.init()
  }

  func advanceHeight(at index: Int) -> Int {
    if index < vMetrics.count {
      return Int(vMetrics[index] >> 16)
    } else if let last = vMetrics.last {
      return Int(last >> 16)
    } else {
      return Int(vMetrics[vMetrics.count - 1] >> 16)
    }
  }

  func topSideBearing(at index: Int) -> Int {
    if index < vMetrics.count {
      return Int(vMetrics[index] & 0xffff)
    } else if let last = vMetrics.last {
      return Int(last)
    } else {
      return Int(topSideBearings[index - vMetrics.count])
    }
  }

  override class var tag: UInt32 {
    get {
      return TCTableTag.vmtx.rawValue
    }
  }

  override var description: String {
    get {
      var str =
        "'vmtx' Table - Vertical Metrics\n-------------------------------\n" +
        "Size = \(dataCount) bytes, \(vMetrics.count) entries\n"
      for i in 0..<vMetrics.count {
        str.append("        \(i). advHeight: \(advanceHeight(at: i)), TSdBear: \(topSideBearing(at: i))\n")
      }
      for i in 0..<topSideBearings.count {
        str.append("        TSdBear \(i + vMetrics.count): \(topSideBearing(at: i))\n")
      }
      return str
    }
  }
}
