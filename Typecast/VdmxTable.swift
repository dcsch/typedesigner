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

  let version: Int
  let numRecs: Int
  let numRatios: Int
  var ratRange = [Ratio]()
  var offset = [Int]()
  var groups = [Group]()

  init(data: Data) {
    let dataInput = TCDataInput(data: data)
    version = Int(dataInput.readUInt16())
    numRecs = Int(dataInput.readUInt16())
    numRatios = Int(dataInput.readUInt16())
    ratRange.reserveCapacity(numRatios)
    for _ in 0..<numRatios {
      ratRange.append(Ratio(dataInput: dataInput))
    }
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

  override class var tag: Table.Tag {
    get {
      return .VDMX
    }
  }

  override var description: String {
    get {
      var str = "'VDMX' Table - Precomputed Vertical Device Metrics\n"
      str.append("--------------------------------------------------\n")
      str.append("  Version:                 \(version)\n")
      str.append("  Number of Hgt Records:   \(numRecs)\n")
      str.append("  Number of Ratio Records: \(numRatios)\n")
      for i in 0..<numRatios {
        str.append("\n    Ratio Record #\(i + 1)\n")
        str.append("\tCharSetId     \(ratRange[i].bCharSet)\n")
        str.append("\txRatio        \(ratRange[i].xRatio)\n")
        str.append("\tyStartRatio   \(ratRange[i].yStartRatio)\n")
        str.append("\tyEndRatio     \(ratRange[i].yEndRatio)\n")
        str.append("\tRecord Offset \(offset[i])\n")
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
