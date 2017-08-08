//
//  TCHheaTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/14/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCHheaTable: TCBaseTable {
  var version: UInt32
  var ascender: Int16
  var descender: Int16
  var lineGap: Int16
  var advanceWidthMax: Int16
  var minLeftSideBearing: Int16
  var minRightSideBearing: Int16
  var xMaxExtent: Int16
  var caretSlopeRise: Int16
  var caretSlopeRun: Int16
  var metricDataFormat: Int16
  var numberOfHMetrics: UInt16

  init(dataInput: TCDataInput, directoryEntry: TCDirectoryEntry) {
    version = dataInput.readUInt32()
    ascender = dataInput.readInt16()
    descender = dataInput.readInt16()
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
    numberOfHMetrics = dataInput.readUInt16()
    super.init(directoryEntry: directoryEntry)
  }

  override var type: UInt32 {
    get {
      return TCTableType.hhea.rawValue
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
