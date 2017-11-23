//
//  TCHeadTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/13/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCHeadTable: TCBaseTable, Codable {
  var majorVersion: Int
  var minorVersion: Int
  var fontRevision: UInt32
  var checkSumAdjustment: UInt32
  var magicNumber: UInt32
  var flags: UInt16
  var unitsPerEm: Int
  var created: Date
  var modified: Date
  var xMin: Int
  var yMin: Int
  var xMax: Int
  var yMax: Int
  var macStyle: UInt16
  var lowestRecPPEM: UInt16
  var fontDirectionHint: Int16
  var indexToLocFormat: Int16
  var glyphDataFormat: Int16

  // The OpenType epoch is 1904-1-1T00:00:00Z
  static let epoch = DateComponents(calendar: Calendar(identifier: .gregorian),
                                    timeZone: TimeZone(secondsFromGMT: 0),
                                    year: 1904).date!

  override init() {
    majorVersion = 0
    minorVersion = 0
    fontRevision = 0
    checkSumAdjustment = 0
    magicNumber = 0
    flags = 0
    unitsPerEm = 0
    created = Date()
    modified = Date()
    xMin = 0
    yMin = 0
    xMax = 0
    yMax = 0
    macStyle = 0
    lowestRecPPEM = 0
    fontDirectionHint = 0
    indexToLocFormat = 0
    glyphDataFormat = 0
    super.init()
  }

  init(data: Data) {
    let dataInput = TCDataInput(data: data)
    majorVersion = Int(dataInput.readUInt16())
    minorVersion = Int(dataInput.readUInt16())
    fontRevision = dataInput.readUInt32()
    checkSumAdjustment = dataInput.readUInt32()
    magicNumber = dataInput.readUInt32()
    flags = dataInput.readUInt16()
    unitsPerEm = Int(dataInput.readUInt16())
    let createdSeconds = TimeInterval(dataInput.readUInt64())
    created = Date(timeInterval: createdSeconds, since: TCHeadTable.epoch)
    let modifiedSeconds = TimeInterval(dataInput.readUInt64())
    modified = Date(timeInterval: modifiedSeconds, since: TCHeadTable.epoch)
    xMin = Int(dataInput.readInt16())
    yMin = Int(dataInput.readInt16())
    xMax = Int(dataInput.readInt16())
    yMax = Int(dataInput.readInt16())
    macStyle = dataInput.readUInt16()
    lowestRecPPEM = dataInput.readUInt16()
    fontDirectionHint = dataInput.readInt16()
    indexToLocFormat = dataInput.readInt16()
    glyphDataFormat = dataInput.readInt16()
    super.init()
  }

  override class var tag: UInt32 {
    get {
      return TCTableTag.head.rawValue
    }
  }

  override var description: String {
    get {
      let formatter = ISO8601DateFormatter()
      return String.localizedStringWithFormat("""
          'head' Table - Font Header
          --------------------------
            'head' version:      %d.%d
            fontRevision:        %x
            checkSumAdjustment:  0x%X
            magicNumber:         0x%X
            flags:               0x%X
            unitsPerEm:          %d
            created:             %@
            modified:            %@
            xMin:                %d
            yMin:                %d
            xMax:                %d
            yMax:                %d
            macStyle bits:       %X
            lowestRecPPEM:       %d
            fontDirectionHint:   %d
            indexToLocFormat:    %d
            glyphDataFormat:     %d
          """,
          majorVersion,
          minorVersion,
          fontRevision,
          checkSumAdjustment,
          magicNumber,
          flags,
          unitsPerEm,
          formatter.string(from: created),
          formatter.string(from: modified),
          xMin,
          yMin,
          xMax,
          yMax,
          macStyle,
          lowestRecPPEM,
          fontDirectionHint,
          indexToLocFormat,
          glyphDataFormat)
    }
  }
}
