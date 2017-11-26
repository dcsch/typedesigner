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
class TCHmtxTable: TCBaseTable, Codable {
  var hMetrics: [UInt32] = []
  var leftSideBearings: [Int16] = []
  let dataCount: Int

  override init() {
    dataCount = 0
    super.init()
  }

  init(data: Data, hheaTable: TCHheaTable, maxpTable: TCMaxpTable) {
    dataCount = data.count
    let dataInput = TCDataInput(data: data)
    for _ in 0 ..< hheaTable.numberOfHMetrics {
      let v1 = UInt32(dataInput.readUInt8()) << 24
      let v2 = UInt32(dataInput.readUInt8()) << 16
      let v3 = UInt32(dataInput.readUInt8()) << 8
      let v4 = UInt32(dataInput.readUInt8())
      let metric = v1 | v2 | v3 | v4
      hMetrics.append(metric)
    }
    let lsbCount = maxpTable.numGlyphs - hheaTable.numberOfHMetrics
    for _ in 0..<lsbCount {
      leftSideBearings.append(dataInput.readInt16())
    }
    super.init()
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

  override class var tag: TCTableTag {
    get {
      return .hmtx
    }
  }

  override var description: String {
    get {
      var str = String.localizedStringWithFormat(
        "'hmtx' Table - Horizontal Metrics\n---------------------------------\n" +
        "Size = %d bytes, %ld entries\n",
        dataCount,
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
