//
//  TCHheaTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/14/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCHheaTable: TCTable {
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
    ascender = dataInput.readShort()
    descender = dataInput.readShort()
    lineGap = dataInput.readShort()
    advanceWidthMax = dataInput.readShort()
    minLeftSideBearing = dataInput.readShort()
    minRightSideBearing = dataInput.readShort()
    xMaxExtent = dataInput.readShort()
    caretSlopeRise = dataInput.readShort()
    caretSlopeRun = dataInput.readShort()
    for _ in 0..<5 {
      dataInput.readShort()
    }
    metricDataFormat = dataInput.readShort()
    numberOfHMetrics = dataInput.readUnsignedShort()
    super.init()
    self.directoryEntry = directoryEntry.copy() as? TCDirectoryEntry
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
