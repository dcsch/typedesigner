//
//  TableWriter.swift
//  Type Designer
//
//  Created by David Schweinsberg on 11/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TableWriter {
//  var data: Data
//
//  init(data: Data) {
//
//  }

  class func write(directory: TCTableDirectory) -> Data {
    var data = Data()
    data.append(UInt32(directory.version))
    data.append(UInt16(directory.entries.count))
    data.append(UInt16(directory.searchRange))
    data.append(UInt16(directory.entrySelector))
    data.append(UInt16(directory.rangeShift))
    for entry in directory.entries {
      data.append(UInt32(entry.tag))
      data.append(UInt32(entry.checksum))
      data.append(UInt32(entry.offset))
      data.append(UInt32(entry.length))
    }
    return data
  }

  class func write(table: TCHeadTable) -> Data {
    let magicNumber: UInt32 = 0x5F0F3CF5
    var data = Data()
    data.append(UInt16(1))  // Version 1.0
    data.append(UInt16(0))
    data.append(UInt32(table.fontRevision))
    data.append(magicNumber)
    data.append(UInt16(table.flags))
    data.append(UInt16(table.unitsPerEm))
    data.append(UInt64(table.created.timeIntervalSince(TCHeadTable.epoch)))
    data.append(UInt64(table.modified.timeIntervalSince(TCHeadTable.epoch)))
    data.append(Int16(table.xMin))
    data.append(Int16(table.yMin))
    data.append(Int16(table.xMax))
    data.append(Int16(table.yMax))
    data.append(UInt16(table.macStyle))
    data.append(UInt16(table.lowestRecPPEM))
    data.append(Int16(table.fontDirectionHint))
    data.append(Int16(table.indexToLocFormat))
    data.append(Int16(table.glyphDataFormat))
    data.append(UInt16(0))
    return data
  }

  class func write(table: TCHheaTable) -> Data {
    var data = Data()
    data.append(UInt16(1))  // Version 1.0
    data.append(UInt16(0))
    data.append(Int16(table.ascender))
    data.append(Int16(table.descender))
    data.append(Int16(table.lineGap))
    data.append(UInt16(table.advanceWidthMax))
    data.append(Int16(table.minLeftSideBearing))
    data.append(Int16(table.minRightSideBearing))
    data.append(Int16(table.xMaxExtent))
    data.append(Int16(table.caretSlopeRise))
    data.append(Int16(table.caretSlopeRun))
    data.append(Int16(table.caretOffset))
    data.append(Int16(0))
    data.append(Int16(0))
    data.append(Int16(0))
    data.append(Int16(0))
    data.append(Int16(table.metricDataFormat))
    data.append(UInt16(table.numberOfHMetrics))
    return data
  }

  class func write(table: TCMaxpTable) -> Data {
    var data = Data()
    data.append(UInt32(table.versionNumber))
    data.append(UInt16(table.numGlyphs))
    if table.versionNumber == 0x00010000 {
      data.append(UInt16(table.maxPoints))
      data.append(UInt16(table.maxContours))
      data.append(UInt16(table.maxCompositePoints))
      data.append(UInt16(table.maxCompositeContours))
      data.append(UInt16(table.maxZones))
      data.append(UInt16(table.maxTwilightPoints))
      data.append(UInt16(table.maxStorage))
      data.append(UInt16(table.maxFunctionDefs))
      data.append(UInt16(table.maxInstructionDefs))
      data.append(UInt16(table.maxStackElements))
      data.append(UInt16(table.maxSizeOfInstructions))
      data.append(UInt16(table.maxComponentElements))
      data.append(UInt16(table.maxComponentDepth))
    }
    return data
  }

  class func write(table: TCOs2Table) -> Data {
    var data = Data()
    data.append(UInt16(5))  // Version 5
    data.append(table.xAvgCharWidth)
    data.append(table.usWeightClass)
    data.append(table.usWidthClass)
    data.append(table.fsType)
    data.append(table.ySubscriptXSize)
    data.append(table.ySubscriptYSize)
    data.append(table.ySubscriptXOffset)
    data.append(table.ySubscriptYOffset)
    data.append(table.ySuperscriptXSize)
    data.append(table.ySuperscriptYSize)
    data.append(table.ySuperscriptXOffset)
    data.append(table.ySuperscriptYOffset)
    data.append(table.yStrikeoutSize)
    data.append(table.yStrikeoutPosition)
    data.append(table.sFamilyClass)
    data.append(table.panose.bFamilyType)
    data.append(table.panose.bSerifStyle)
    data.append(table.panose.bWeight)
    data.append(table.panose.bProportion)
    data.append(table.panose.bContrast)
    data.append(table.panose.bStrokeVariation)
    data.append(table.panose.bArmStyle)
    data.append(table.panose.bLetterform)
    data.append(table.panose.bMidline)
    data.append(table.panose.bXHeight)
    data.append(table.ulUnicodeRange1)
    data.append(table.ulUnicodeRange2)
    data.append(table.ulUnicodeRange3)
    data.append(table.ulUnicodeRange4)
    data.append(table.achVendorID)
    data.append(table.fsSelection)
    data.append(table.usFirstCharIndex)
    data.append(table.usLastCharIndex)
    data.append(table.sTypoAscender)
    data.append(table.sTypoDescender)
    data.append(table.sTypoLineGap)
    data.append(table.usWinAscent)
    data.append(table.usWinDescent)
    data.append(table.ulCodePageRange1)
    data.append(table.ulCodePageRange2)
    data.append(table.sxHeight)
    data.append(table.sCapHeight)
    data.append(table.usDefaultChar)
    data.append(table.usBreakChar)
    data.append(table.usMaxContext)
    data.append(table.usLowerOpticalPointSize)
    data.append(table.usUpperOpticalPointSize)
    return data
  }

  class func write(table: TCHmtxTable) -> Data {
    var data = Data()
    for metric in table.hMetrics {
      data.append(UInt16(metric.advanceWidth))
      data.append(Int16(metric.lsb))
    }
    for lsb in table.leftSideBearings {
      data.append(Int16(lsb))
    }
    return data
  }

  class func write(table: TCCmapTable) -> Data {
    var data = Data()
    data.append(TCCmapFormat4.encode(mapping: table.mappings[0]))
    return data
  }
}

extension Data {

  mutating func append<T: FixedWidthInteger>(_ integer: T) {
    var bigEndian = integer.bigEndian
    append(UnsafeBufferPointer(start: &bigEndian, count: 1))
  }

  var checksum: UInt32 {
    get {
      return withUnsafeBytes { (dataPtr: UnsafePointer<UInt32>) -> UInt32 in
        var ptr = dataPtr
        var sum: UInt32 = 0
        for _ in 0..<(count / 4) {
          (sum, _) = sum.addingReportingOverflow(ptr.pointee.bigEndian)
          ptr += 1
        }
        return sum
      }
    }
  }
}
