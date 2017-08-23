//
//  TCVheaTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/5/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCVheaTable: TCBaseTable {
  let version: UInt32
  let ascent: Int16
  let descent: Int16
  let lineGap: Int16
  let advanceHeightMax: Int16
  let minTopSideBearing: Int16
  let minBottomSideBearing: Int16
  let yMaxExtent: Int16
  let caretSlopeRise: Int16
  let caretSlopeRun: Int16
  let metricDataFormat: Int16
  let numberOfLongVerMetrics: Int

  init(data: Data) {
    let dataInput = TCDataInput(data: data)
    version = dataInput.readUInt32()
    ascent = dataInput.readInt16()
    descent = dataInput.readInt16()
    lineGap = dataInput.readInt16()
    advanceHeightMax = dataInput.readInt16()
    minTopSideBearing = dataInput.readInt16()
    minBottomSideBearing = dataInput.readInt16()
    yMaxExtent = dataInput.readInt16()
    caretSlopeRise = dataInput.readInt16()
    caretSlopeRun = dataInput.readInt16()
    for _ in 0..<5 {
      _ = dataInput.readInt16()
    }
    metricDataFormat = dataInput.readInt16()
    numberOfLongVerMetrics = Int(dataInput.readUInt16())
    super.init()
  }

  override class var tag: UInt32 {
    get {
      return TCTableTag.vhea.rawValue
    }
  }

  override var description: String {
    get {
      return String(format:
        "'vhea' Table - Vertical Header\n------------------------------" +
        "\n        'vhea' version:       %x" +
        "\n        xAscender:            %d" +
        "\n        xDescender:           %d" +
        "\n        xLineGap:             %d" +
        "\n        advanceHeightMax:     %d" +
        "\n        minTopSideBearing:    %d" +
        "\n        minBottomSideBearing: %d" +
        "\n        yMaxExtent:           %d" +
        "\n        horizCaretSlopeNum:   %d" +
        "\n        horizCaretSlopeDenom: %d" +
        "\n        reserved0:            0" +
        "\n        reserved1:            0" +
        "\n        reserved2:            0" +
        "\n        reserved3:            0" +
        "\n        reserved4:            0" +
        "\n        metricDataFormat:     %d" +
        "\n        numOf_LongVerMetrics: %d",
        version,
        ascent,
        descent,
        lineGap,
        advanceHeightMax,
        minTopSideBearing,
        minBottomSideBearing,
        yMaxExtent,
        caretSlopeRise,
        caretSlopeRun,
        metricDataFormat,
        numberOfLongVerMetrics)
    }
  }
}
