//
//  TCOs2Table.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/1/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class Os2Table: Table, Codable {

  class Panose: CustomStringConvertible, Codable {
    var bFamilyType: UInt8
    var bSerifStyle: UInt8
    var bWeight: UInt8
    var bProportion: UInt8
    var bContrast: UInt8
    var bStrokeVariation: UInt8
    var bArmStyle: UInt8
    var bLetterform: UInt8
    var bMidline: UInt8
    var bXHeight: UInt8

    init() {
      bFamilyType = 0
      bSerifStyle = 0
      bWeight = 0
      bProportion = 0
      bContrast = 0
      bStrokeVariation = 0
      bArmStyle = 0
      bLetterform = 0
      bMidline = 0
      bXHeight = 0
    }

    init(bytes: [UInt8]) {
      bFamilyType = bytes[0]
      bSerifStyle = bytes[1]
      bWeight = bytes[2]
      bProportion = bytes[3]
      bContrast = bytes[4]
      bStrokeVariation = bytes[5]
      bArmStyle = bytes[6]
      bLetterform = bytes[7]
      bMidline = bytes[8]
      bXHeight = bytes[9]
    }

    var description: String {
      get {
        return String(format:
          "%d %d %d %d %d %d %d %d %d %d",
                      bFamilyType,
                      bSerifStyle,
                      bWeight,
                      bProportion,
                      bContrast,
                      bStrokeVariation,
                      bArmStyle,
                      bLetterform,
                      bMidline,
                      bXHeight)
      }
    }
  }

  var version: UInt16
  var xAvgCharWidth: Int16
  var usWeightClass: UInt16
  var usWidthClass: UInt16
  var fsType: Int16
  var ySubscriptXSize: Int16
  var ySubscriptYSize: Int16
  var ySubscriptXOffset: Int16
  var ySubscriptYOffset: Int16
  var ySuperscriptXSize: Int16
  var ySuperscriptYSize: Int16
  var ySuperscriptXOffset: Int16
  var ySuperscriptYOffset: Int16
  var yStrikeoutSize: Int16
  var yStrikeoutPosition: Int16
  var sFamilyClass: Int16
  var panose: Panose
  var ulUnicodeRange1: UInt32
  var ulUnicodeRange2: UInt32
  var ulUnicodeRange3: UInt32
  var ulUnicodeRange4: UInt32
  var achVendorID: Int32
  var fsSelection: Int16
  var usFirstCharIndex: UInt16
  var usLastCharIndex: UInt16
  var sTypoAscender: Int16
  var sTypoDescender: Int16
  var sTypoLineGap: Int16
  var usWinAscent: UInt16
  var usWinDescent: UInt16
  var ulCodePageRange1: UInt32
  var ulCodePageRange2: UInt32
  var sxHeight: Int16
  var sCapHeight: Int16
  var usDefaultChar: UInt16
  var usBreakChar: UInt16
  var usMaxContext: UInt16
  var usLowerOpticalPointSize: UInt16
  var usUpperOpticalPointSize: UInt16

  override init() {
    version = 0
    xAvgCharWidth = 0
    usWeightClass = 0
    usWidthClass = 0
    fsType = 0
    ySubscriptXSize = 0
    ySubscriptYSize = 0
    ySubscriptXOffset = 0
    ySubscriptYOffset = 0
    ySuperscriptXSize = 0
    ySuperscriptYSize = 0
    ySuperscriptXOffset = 0
    ySuperscriptYOffset = 0
    yStrikeoutSize = 0
    yStrikeoutPosition = 0
    sFamilyClass = 0
    panose = Panose()
    ulUnicodeRange1 = 0
    ulUnicodeRange2 = 0
    ulUnicodeRange3 = 0
    ulUnicodeRange4 = 0
    achVendorID = 0
    fsSelection = 0
    usFirstCharIndex = 0
    usLastCharIndex = 0
    sTypoAscender = 0
    sTypoDescender = 0
    sTypoLineGap = 0
    usWinAscent = 0
    usWinDescent = 0
    ulCodePageRange1 = 0
    ulCodePageRange2 = 0
    sxHeight = 0
    sCapHeight = 0
    usDefaultChar = 0
    usBreakChar = 0
    usMaxContext = 0
    usLowerOpticalPointSize = 0
    usUpperOpticalPointSize = 0
    super.init()
  }

  init(data: Data) {
    let dataInput = TCDataInput(data: data)
    version = dataInput.readUInt16()
    xAvgCharWidth = dataInput.readInt16()
    usWeightClass = dataInput.readUInt16()
    usWidthClass = dataInput.readUInt16()
    fsType = dataInput.readInt16()
    ySubscriptXSize = dataInput.readInt16()
    ySubscriptYSize = dataInput.readInt16()
    ySubscriptXOffset = dataInput.readInt16()
    ySubscriptYOffset = dataInput.readInt16()
    ySuperscriptXSize = dataInput.readInt16()
    ySuperscriptYSize = dataInput.readInt16()
    ySuperscriptXOffset = dataInput.readInt16()
    ySuperscriptYOffset = dataInput.readInt16()
    yStrikeoutSize = dataInput.readInt16()
    yStrikeoutPosition = dataInput.readInt16()
    sFamilyClass = dataInput.readInt16()
    panose = Panose(bytes: dataInput.read(length: 10))
    ulUnicodeRange1 = dataInput.readUInt32()
    ulUnicodeRange2 = dataInput.readUInt32()
    ulUnicodeRange3 = dataInput.readUInt32()
    ulUnicodeRange4 = dataInput.readUInt32()
    achVendorID = dataInput.readInt32()
    fsSelection = dataInput.readInt16()
    usFirstCharIndex = dataInput.readUInt16()
    usLastCharIndex = dataInput.readUInt16()
    sTypoAscender = dataInput.readInt16()
    sTypoDescender = dataInput.readInt16()
    sTypoLineGap = dataInput.readInt16()
    usWinAscent = dataInput.readUInt16()
    usWinDescent = dataInput.readUInt16()

    if version > 0 {
      ulCodePageRange1 = dataInput.readUInt32()
      ulCodePageRange2 = dataInput.readUInt32()
    } else {
      ulCodePageRange1 = 0
      ulCodePageRange2 = 0
    }
    if version > 1 {
      sxHeight = dataInput.readInt16()
      sCapHeight = dataInput.readInt16()
      usDefaultChar = dataInput.readUInt16()
      usBreakChar = dataInput.readUInt16()
      usMaxContext = dataInput.readUInt16()
    } else {
      sxHeight = 0
      sCapHeight = 0
      usDefaultChar = 0
      usBreakChar = 0
      usMaxContext = 0
    }
    if version > 4 {
      usLowerOpticalPointSize = dataInput.readUInt16()
      usUpperOpticalPointSize = dataInput.readUInt16()
    } else {
      usLowerOpticalPointSize = 0
      usUpperOpticalPointSize = 0
    }
    super.init()
  }

  override class var tag: Table.Tag {
    get {
      return .OS_2
    }
  }

  override var description: String {
    get {
      let vendorID = String(format: "%c%c%c%c",
                            (achVendorID >> 24) & 0xff,
                            (achVendorID >> 16) & 0xff,
                            (achVendorID >> 8) & 0xff,
                            achVendorID & 0xff)
      return """
      'OS/2' Table - OS/2 and Windows Metrics
      ---------------------------------------
        'OS/2' version:      \(version)
        xAvgCharWidth:       \(xAvgCharWidth)
        usWeightClass:       \(usWeightClass)
        usWidthClass:        \(usWidthClass)
        fsType:              0x\(String(fsType, radix: 16, uppercase: true))
        ySubscriptXSize:     \(ySubscriptXSize)
        ySubscriptYSize:     \(ySubscriptYSize)
        ySubscriptXOffset:   \(ySubscriptXOffset)
        ySubscriptYOffset:   \(ySubscriptYOffset)
        ySuperscriptXSize:   \(ySuperscriptXSize)
        ySuperscriptYSize:   \(ySuperscriptYSize)
        ySuperscriptXOffset: \(ySuperscriptXOffset)
        ySuperscriptYOffset: \(ySuperscriptYOffset)
        yStrikeoutSize:      \(yStrikeoutSize)
        yStrikeoutPosition:  \(yStrikeoutPosition)
        sFamilyClass:        \(sFamilyClass >> 8) subclass = \(sFamilyClass & 0xff)
        PANOSE:              \(panose)
        Unicode Range 1( Bits 0 - 31 ): \(String(ulUnicodeRange1, radix: 16, uppercase: true))
        Unicode Range 2( Bits 32- 63 ): \(String(ulUnicodeRange2, radix: 16, uppercase: true))
        Unicode Range 3( Bits 64- 95 ): \(String(ulUnicodeRange3, radix: 16, uppercase: true))
        Unicode Range 4( Bits 96-127 ): \(String(ulUnicodeRange4, radix: 16, uppercase: true))
        achVendID:           '\(vendorID)'
        fsSelection:         0x\(String(fsSelection, radix: 16, uppercase: true))
        usFirstCharIndex:    0x\(String(usFirstCharIndex, radix: 16, uppercase: true))
        usLastCharIndex:     0x\(String(usLastCharIndex, radix: 16, uppercase: true))
        sTypoAscender:       \(sTypoAscender)
        sTypoDescender:      \(sTypoDescender)
        sTypoLineGap:        \(sTypoLineGap)
        usWinAscent:         \(usWinAscent)
        usWinDescent:        \(usWinDescent)
        CodePage Range 1( Bits 0 - 31 ): \(String(ulCodePageRange1, radix: 16, uppercase: true))
        CodePage Range 2( Bits 32- 63 ): \(String(ulCodePageRange2, radix: 16, uppercase: true))
      """
    }
  }
}
