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
  var versionNumber: UInt32
  var fontRevision: UInt32
  var checkSumAdjustment: UInt32
  var magicNumber: UInt32
  var flags: UInt16
  var unitsPerEm: Int
  var created: UInt64
  var modified: UInt64
  var xMin: Int
  var yMin: Int
  var xMax: Int
  var yMax: Int
  var macStyle: UInt16
  var lowestRecPPEM: UInt16
  var fontDirectionHint: Int16
  var indexToLocFormat: Int16
  var glyphDataFormat: Int16

  override init() {
    versionNumber = 0
    fontRevision = 0
    checkSumAdjustment = 0
    magicNumber = 0
    flags = 0
    unitsPerEm = 0
    created = 0
    modified = 0
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
    versionNumber = dataInput.readUInt32()
    fontRevision = dataInput.readUInt32()
    checkSumAdjustment = dataInput.readUInt32()
    magicNumber = dataInput.readUInt32()
    flags = dataInput.readUInt16()
    unitsPerEm = Int(dataInput.readUInt16())
    created = dataInput.readUInt64()
    modified = dataInput.readUInt64()
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
      return String.localizedStringWithFormat(
          "'head' Table - Font Header\n--------------------------" +
          "\n  'head' version:      %x" +  //  //).append(Fixed.floatValue(_versionNumber))
          "\n  fontRevision:        %x" +  //  //).append(Fixed.roundedFloatValue(_fontRevision, 8))
          "\n  checkSumAdjustment:  0x%x" +  //).append(Integer.toHexString(_checkSumAdjustment).toUpperCase())
          "\n  magicNumber:         0x%x" +  //).append(Integer.toHexString(_magicNumber).toUpperCase())
          "\n  flags:               0x%x" +  //).append(Integer.toHexString(_flags).toUpperCase())
          "\n  unitsPerEm:          %d" +  //).append(_unitsPerEm)
          "\n  created:             %lld" +  //).append(_created)
          "\n  modified:            %lld" +  //).append(_modified)
          "\n  xMin:                %d" +  //).append(_xMin)
          "\n  yMin:                %d" +  //).append(_yMin)
          "\n  xMax:                %d" +  //).append(_xMax)
          "\n  yMax:                %d" +  //).append(_yMax)
          "\n  macStyle bits:       %X" +  //).append(Integer.toHexString(_macStyle).toUpperCase())
          "\n  lowestRecPPEM:       %d" +  //).append(_lowestRecPPEM)
          "\n  fontDirectionHint:   %d" +  //).append(_fontDirectionHint)
          "\n  indexToLocFormat:    %d" +  //).append(_indexToLocFormat)
          "\n  glyphDataFormat:     %d",  //).append(_glyphDataFormat)
          versionNumber,
          fontRevision,
          checkSumAdjustment,
          magicNumber,
          flags,
          unitsPerEm,
          created,
          modified,
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
