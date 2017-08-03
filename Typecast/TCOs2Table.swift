//
//  TCOs2Table.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/1/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCPanose {
  let bFamilyType: UInt8
  let bSerifStyle: UInt8
  let bWeight: UInt8
  let bProportion: UInt8
  let bContrast: UInt8
  let bStrokeVariation: UInt8
  let bArmStyle: UInt8
  let bLetterform: UInt8
  let bMidline: UInt8
  let bXHeight: UInt8

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

class TCOs2Table: TCTable {
  let version: UInt16
  let xAvgCharWidth: Int16
  let usWeightClass: UInt16
  let usWidthClass: UInt16
  let fsType: Int16
  let ySubscriptXSize: Int16
  let ySubscriptYSize: Int16
  let ySubscriptXOffset: Int16
  let ySubscriptYOffset: Int16
  let ySuperscriptXSize: Int16
  let ySuperscriptYSize: Int16
  let ySuperscriptXOffset: Int16
  let ySuperscriptYOffset: Int16
  let yStrikeoutSize: Int16
  let yStrikeoutPosition: Int16
  let sFamilyClass: Int16
  let panose: TCPanose
  let ulUnicodeRange1: Int32
  let ulUnicodeRange2: Int32
  let ulUnicodeRange3: Int32
  let ulUnicodeRange4: Int32
  let achVendorID: Int32
  let fsSelection: Int16
  let usFirstCharIndex: UInt16
  let usLastCharIndex: UInt16
  let sTypoAscender: Int16
  let sTypoDescender: Int16
  let sTypoLineGap: Int16
  let usWinAscent: UInt16
  let usWinDescent: UInt16
  let ulCodePageRange1: Int32
  let ulCodePageRange2: Int32
  let sxHeight: Int16
  let sCapHeight: Int16
  let usDefaultChar: UInt16
  let usBreakChar: UInt16
  let usMaxContext: UInt16

  init(dataInput: TCDataInput, directoryEntry entry: TCDirectoryEntry) {
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
    panose = TCPanose(bytes: dataInput.read(length: 10))
    ulUnicodeRange1 = dataInput.readInt32()
    ulUnicodeRange2 = dataInput.readInt32()
    ulUnicodeRange3 = dataInput.readInt32()
    ulUnicodeRange4 = dataInput.readInt32()
    achVendorID = dataInput.readInt32()
    fsSelection = dataInput.readInt16()
    usFirstCharIndex = dataInput.readUInt16()
    usLastCharIndex = dataInput.readUInt16()
    sTypoAscender = dataInput.readInt16()
    sTypoDescender = dataInput.readInt16()
    sTypoLineGap = dataInput.readInt16()
    usWinAscent = dataInput.readUInt16()
    usWinDescent = dataInput.readUInt16()
    ulCodePageRange1 = dataInput.readInt32()
    ulCodePageRange2 = dataInput.readInt32()

    // OpenType 1.3
    if version == 2 {
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
    super.init()
    self.directoryEntry = entry.copy() as! TCDirectoryEntry
  }

  override var type: UInt32 {
    get {
      return TCTableType.OS_2.rawValue
    }
  }

  override var description: String {
    get {
      return String(format:
          "'OS/2' Table - OS/2 and Windows Metrics\n---------------------------------------" +
          "\n  'OS/2' version:      %d" +
          "\n  xAvgCharWidth:       %d" +
          "\n  usWeightClass:       %d" +
          "\n  usWidthClass:        %d" +
          "\n  fsType:              0x%X" +
          "\n  ySubscriptXSize:     %d" +
          "\n  ySubscriptYSize:     %d" +
          "\n  ySubscriptXOffset:   %d" +
          "\n  ySubscriptYOffset:   %d" +
          "\n  ySuperscriptXSize:   %d" +
          "\n  ySuperscriptYSize:   %d" +
          "\n  ySuperscriptXOffset: %d" +
          "\n  ySuperscriptYOffset: %d" +
          "\n  yStrikeoutSize:      %d" +
          "\n  yStrikeoutPosition:  %d" +
          "\n  sFamilyClass:        %d" +
          "    subclass = %d" +
          "\n  PANOSE:              %s" +
          "\n  Unicode Range 1( Bits 0 - 31 ): %X" +
          "\n  Unicode Range 2( Bits 32- 63 ): %X" +
          "\n  Unicode Range 3( Bits 64- 95 ): %X" +
          "\n  Unicode Range 4( Bits 96-127 ): %X" +
          "\n  achVendID:           '%c%c%c%c" +
          "'\n  fsSelection:         0x%X" +
          "\n  usFirstCharIndex:    0x%X" +
          "\n  usLastCharIndex:     0x%X" +
          "\n  sTypoAscender:       %d" +
          "\n  sTypoDescender:      %d" +
          "\n  sTypoLineGap:        %d" +
          "\n  usWinAscent:         %d" +
          "\n  usWinDescent:        %d" +
          "\n  CodePage Range 1( Bits 0 - 31 ): %X" +
          "\n  CodePage Range 2( Bits 32- 63 ): %X",
          version,
          xAvgCharWidth,
          usWeightClass,
          usWidthClass,
          fsType,
          ySubscriptXSize,
          ySubscriptYSize,
          ySubscriptXOffset,
          ySubscriptYOffset,
          ySuperscriptXSize,
          ySuperscriptYSize,
          ySuperscriptXOffset,
          ySuperscriptYOffset,
          yStrikeoutSize,
          yStrikeoutPosition,
          sFamilyClass >> 8,
          sFamilyClass & 0xff,
          panose.description,
          ulUnicodeRange1,
          ulUnicodeRange2,
          ulUnicodeRange3,
          ulUnicodeRange4,
          (achVendorID >> 24) & 0xff,
          (achVendorID >> 16) & 0xff,
          (achVendorID >> 8) & 0xff,
          achVendorID & 0xff,
          fsSelection,
          usFirstCharIndex,
          usLastCharIndex,
          sTypoAscender,
          sTypoDescender,
          sTypoLineGap,
          usWinAscent,
          usWinDescent,
          ulCodePageRange1,
          ulCodePageRange2)
    }
  }
}
