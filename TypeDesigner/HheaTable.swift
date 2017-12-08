//
//  HheaTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/14/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class HheaTable: Table, Codable {
  var majorVersion: Int
  var minorVersion: Int
  var ascender: Int
  var descender: Int
  var lineGap: Int
  var advanceWidthMax: Int
  var minLeftSideBearing: Int
  var minRightSideBearing: Int
  var xMaxExtent: Int
  var caretSlopeRise: Int
  var caretSlopeRun: Int
  var caretOffset: Int
  var metricDataFormat: Int
  var numberOfHMetrics: Int

  override init() {
    majorVersion = 0
    minorVersion = 0
    ascender = 0
    descender = 0
    lineGap = 0
    advanceWidthMax = 0
    minLeftSideBearing = 0
    minRightSideBearing = 0
    xMaxExtent = 0
    caretSlopeRise = 0
    caretSlopeRun = 0
    caretOffset = 0
    metricDataFormat = 0
    numberOfHMetrics = 0
    super.init()
  }

  init(data: Data) {
    let dataInput = TCDataInput(data: data)
    majorVersion = Int(dataInput.readUInt16())
    minorVersion = Int(dataInput.readUInt16())
    ascender = Int(dataInput.readInt16())
    descender = Int(dataInput.readInt16())
    lineGap = Int(dataInput.readInt16())
    advanceWidthMax = Int(dataInput.readUInt16())
    minLeftSideBearing = Int(dataInput.readInt16())
    minRightSideBearing = Int(dataInput.readInt16())
    xMaxExtent = Int(dataInput.readInt16())
    caretSlopeRise = Int(dataInput.readInt16())
    caretSlopeRun = Int(dataInput.readInt16())
    caretOffset = Int(dataInput.readInt16())
    for _ in 0..<4 {
      _ = dataInput.readInt16()
    }
    metricDataFormat = Int(dataInput.readInt16())
    numberOfHMetrics = Int(dataInput.readUInt16())
    super.init()
  }

  override var description: String {
    get {
      return """
        'hhea' Table - Horizontal Header
        --------------------------------
                'hhea' version:       \(majorVersion).\(minorVersion)
                yAscender:            \(ascender)
                yDescender:           \(descender)
                yLineGap:             \(lineGap)
                advanceWidthMax:      \(advanceWidthMax)
                minLeftSideBearing:   \(minLeftSideBearing)
                minRightSideBearing:  \(minRightSideBearing)
                xMaxExtent:           \(xMaxExtent)
                horizCaretSlopeNum:   \(caretSlopeRise)
                horizCaretSlopeDenom: \(caretSlopeRun)
                horizCaretOffset:     \(caretOffset)
                reserved0:            0
                reserved1:            0
                reserved2:            0
                reserved3:            0
                metricDataFormat:     \(metricDataFormat)
                numOf_LongHorMetrics: \(numberOfHMetrics)
      """
    }
  }
}
