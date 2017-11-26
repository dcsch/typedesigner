//
//  TCHheaTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/14/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCHheaTable: TCBaseTable, Codable {
  var version: UInt32
  var ascender: Int
  var descender: Int
  var lineGap: Int16
  var advanceWidthMax: Int16
  var minLeftSideBearing: Int16
  var minRightSideBearing: Int16
  var xMaxExtent: Int16
  var caretSlopeRise: Int16
  var caretSlopeRun: Int16
  var metricDataFormat: Int16
  var numberOfHMetrics: Int

  override init() {
    version = 0
    ascender = 0
    descender = 0
    lineGap = 0
    advanceWidthMax = 0
    minLeftSideBearing = 0
    minRightSideBearing = 0
    xMaxExtent = 0
    caretSlopeRise = 0
    caretSlopeRun = 0
    metricDataFormat = 0
    numberOfHMetrics = 0
    super.init()
  }

  init(data: Data) {
    let dataInput = TCDataInput(data: data)
    version = dataInput.readUInt32()
    ascender = Int(dataInput.readInt16())
    descender = Int(dataInput.readInt16())
    lineGap = dataInput.readInt16()
    advanceWidthMax = dataInput.readInt16()
    minLeftSideBearing = dataInput.readInt16()
    minRightSideBearing = dataInput.readInt16()
    xMaxExtent = dataInput.readInt16()
    caretSlopeRise = dataInput.readInt16()
    caretSlopeRun = dataInput.readInt16()
    for _ in 0 ..< 5 {
      _ = dataInput.readInt16()
    }
    metricDataFormat = dataInput.readInt16()
    numberOfHMetrics = Int(dataInput.readUInt16())
    super.init()
  }

  override class var tag: TCTableTag {
    get {
      return .hhea
    }
  }

  override var description: String {
    get {
      return "'hhea' Table - Horizontal Header\n--------------------------------" +
        "\n        'hhea' version:       \(version)" +  // .append(Fixed.floatValue(version))
        "\n        yAscender:            \(ascender)" +
        "\n        yDescender:           \(descender)" +
        "\n        yLineGap:             \(lineGap)" +
        "\n        advanceWidthMax:      \(advanceWidthMax)" +
        "\n        minLeftSideBearing:   \(minLeftSideBearing)" +
        "\n        minRightSideBearing:  \(minRightSideBearing)" +
        "\n        xMaxExtent:           \(xMaxExtent)" +
        "\n        horizCaretSlopeNum:   \(caretSlopeRise)" +
        "\n        horizCaretSlopeDenom: \(caretSlopeRun)" +
        "\n        reserved0:            0" +
        "\n        reserved1:            0" +
        "\n        reserved2:            0" +
        "\n        reserved3:            0" +
        "\n        reserved4:            0" +
        "\n        metricDataFormat:     \(metricDataFormat)" +
        "\n        numOf_LongHorMetrics: \(numberOfHMetrics)"
    }
  }
}
