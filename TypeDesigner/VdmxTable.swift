//
//  VdmxTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/18/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

/**
 The Vertical Device Metrics table for TrueType outlines.
 */
class VdmxTable: Table, Codable {

  class Ratio: Codable {
    let bCharSet: Int
    let xRatio: Int
    let yStartRatio: Int
    let yEndRatio: Int

    init(dataInput: TCDataInput) {
      bCharSet = Int(dataInput.readInt8())
      xRatio = Int(dataInput.readInt8())
      yStartRatio = Int(dataInput.readInt8())
      yEndRatio = Int(dataInput.readInt8())
    }
  }

  class VTableRecord: Codable {
    let yPelHeight: Int
    let yMax: Int
    let yMin: Int

    init(dataInput: TCDataInput) {
      yPelHeight = Int(dataInput.readUInt16())
      yMax = Int(dataInput.readInt16())
      yMin = Int(dataInput.readInt16())
    }
  }

  class Group: Codable {
    let recs: Int
    let startsz: Int
    let endsz: Int
    var entry = [VTableRecord]()

    init(dataInput: TCDataInput) {
      recs = Int(dataInput.readUInt16())
      startsz = Int(dataInput.readUInt8())
      endsz = Int(dataInput.readUInt8())
      entry.reserveCapacity(recs)
      for _ in 0..<recs {
        entry.append(VTableRecord(dataInput: dataInput))
      }
    }
  }

  var ratRange = [Ratio]()
  var groups = [Group]()

  init(data: Data) {
    let dataInput = TCDataInput(data: data)
    _ = Int(dataInput.readUInt16()) // version
    let numRecs = Int(dataInput.readUInt16())
    let numRatios = Int(dataInput.readUInt16())
    ratRange.reserveCapacity(numRatios)
    for _ in 0..<numRatios {
      ratRange.append(Ratio(dataInput: dataInput))
    }
    var offset = [Int]()
    offset.reserveCapacity(numRatios)
    for _ in 0..<numRatios {
      offset.append(Int(dataInput.readUInt16()))
    }
    groups.reserveCapacity(numRecs)
    for _ in 0..<numRecs {
      groups.append(Group(dataInput: dataInput))
    }
    super.init()
  }

  override var description: String {
    get {
      var str = "'VDMX' Table - Precomputed Vertical Device Metrics\n"
      str.append("--------------------------------------------------\n")
      str.append("  Number of Hgt Records:   \(groups.count)\n")
      str.append("  Number of Ratio Records: \(ratRange.count)\n")
      for (i, range) in ratRange.enumerated() {
        str.append("\n    Ratio Record #\(i + 1)\n")
        str.append("\tCharSetId     \(range.bCharSet)\n")
        str.append("\txRatio        \(range.xRatio)\n")
        str.append("\tyStartRatio   \(range.yStartRatio)\n")
        str.append("\tyEndRatio     \(range.yEndRatio)\n")
      }
      str.append("\n   VDMX Height Record Groups\n")
      str.append("   -------------------------\n")
      for (i, group) in groups.enumerated() {
        str.append("   \(i + 1).   Number of Hgt Records  \(group.recs)\n")
        str.append("        Starting Y Pel Height  \(group.startsz)\n")
        str.append("        Ending Y Pel Height    \(group.endsz)\n")
        for (j, entry) in group.entry.enumerated() {
          str.append("\n            \(j + 1). Pel Height= \(entry.yPelHeight)\n")
          str.append("               yMax=       \(entry.yMax)\n")
          str.append("               yMin=       \(entry.yMin)\n")
        }
      }
      return str
    }
  }
}
