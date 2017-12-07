//
//  HmtxTable.swift
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
class HmtxTable: Table, Codable {

  struct Metric: CustomStringConvertible, Codable {
    var advanceWidth: Int
    var lsb: Int

    var description: String {
      get {
        return "advWid: \(advanceWidth), LSdBear: \(lsb)"
      }
    }
  }

  var hMetrics = [Metric]()
  var leftSideBearings = [Int]()

  override init() {
    super.init()
  }

  init(data: Data, hheaTable: HheaTable, maxpTable: MaxpTable) {
    let dataInput = TCDataInput(data: data)
    for _ in 0..<hheaTable.numberOfHMetrics {
      let advanceWidth = Int(dataInput.readUInt16())
      let lsb = Int(dataInput.readInt16())
      hMetrics.append(Metric(advanceWidth: advanceWidth, lsb: lsb))
    }
    let lsbCount = maxpTable.numGlyphs - hheaTable.numberOfHMetrics
    for _ in 0..<lsbCount {
      leftSideBearings.append(Int(dataInput.readInt16()))
    }
    super.init()
  }

  func advanceWidth(at index: Int) -> Int {
    if index < hMetrics.count {
      return hMetrics[index].advanceWidth
    } else {
      return hMetrics.last?.advanceWidth ?? 0
    }
  }

  func leftSideBearing(at index: Int) -> Int {
    if index < hMetrics.count {
      return hMetrics[index].lsb
    } else {
      return hMetrics.last?.lsb ?? 0
    }
  }

  override class var tag: Table.Tag {
    get {
      return .hmtx
    }
  }

  override var description: String {
    get {
      var str = """
      'hmtx' Table - Horizontal Metrics
      ---------------------------------
      \(hMetrics.count) entries
      
      """
      for (i, metric) in hMetrics.enumerated() {
        str += "        \(i). \(metric)\n"
      }
      for (i, lsb) in leftSideBearings.enumerated() {
        str += "        LSdBear \(i + hMetrics.count): \(lsb)\n"
      }
      return str
    }
  }
}
