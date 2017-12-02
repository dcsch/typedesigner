//
//  TableWriter.swift
//  Type Designer
//
//  Created by David Schweinsberg on 11/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log

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

    // Sort mappings in order of platform, endoding, language
    let entries = table.entries.sorted {
      (lhs: TCCmapTable.IndexEntry, rhs: TCCmapTable.IndexEntry) -> Bool in
      if lhs.platformID.rawValue == rhs.platformID.rawValue {
//        if lhs.encodingID.rawValue == rhs.encodingID.rawValue {
//          return lhs.language < rhs.language
//        } else {
          return lhs.encodingID.rawValue < rhs.encodingID.rawValue
//        }
      } else {
        return lhs.platformID.rawValue < rhs.platformID.rawValue
      }
    }

    // Encoded subtables first so we know how long each one is
    var mappingsData = [Data]()
    var offsets = [Int]()
    var offset = 8 * entries.count + 4
    for mapping in table.mappings {
      let data = TCCmapFormat4.encode(mapping: mapping)
      mappingsData.append(data)
      offsets.append(offset)
      offset += data.count
    }

    // Encode the table
    var data = Data()
    data.append(UInt16(0))  // Version 0
    data.append(UInt16(entries.count))
    for (entry, offset) in zip(entries, offsets) {
      data.append(UInt16(entry.platformID.rawValue))
      data.append(UInt16(entry.encodingID.rawValue))
      data.append(UInt32(offset))
    }

    // Append the subtables
    for mappingData in mappingsData {
      data.append(mappingData)
    }
    return data
  }

  // loca

  class func write(table: TCGlyfTable) -> (Data, [Int]) {
    var data = Data()
    var offsets = [Int]()
    for descript in table.descript {
      offsets.append(data.count)
      if let simpleDescript = descript as? TCGlyfSimpleDescript {
        data.append(Int16(simpleDescript.endPtsOfContours.count))
        data.append(Int16(simpleDescript.xMin))
        data.append(Int16(simpleDescript.yMin))
        data.append(Int16(simpleDescript.xMax))
        data.append(Int16(simpleDescript.yMax))
        for endPt in simpleDescript.endPtsOfContours {
          data.append(UInt16(endPt))
        }
        data.append(UInt16(simpleDescript.instructions.count))
        data.append(contentsOf: simpleDescript.instructions)

        // Encode absolute coords into compressed relative coords
        var xFlags = [TCGlyfSimpleDescript.Flags]()
        var xRelCoords = [Int]()
        var x = 0
        for xCoord in simpleDescript.xCoordinates {
          let xRelCoord = xCoord - x
          x = xCoord
          if xRelCoord == 0 {
            xFlags.append(.xDual)
          } else if abs(xRelCoord) < 256 {
            if xRelCoord >= 0 {
              xFlags.append([.xDual, .xShortVector])
            } else {
              xFlags.append([.xShortVector])
            }
            xRelCoords.append(abs(xRelCoord))
          } else {
            xFlags.append([])
            xRelCoords.append(xRelCoord)
          }
        }
        var yFlags = [TCGlyfSimpleDescript.Flags]()
        var yRelCoords = [Int]()
        var y = 0
        for yCoord in simpleDescript.yCoordinates {
          let yRelCoord = yCoord - y
          y = yCoord
          if yRelCoord == 0 {
            yFlags.append(.yDual)
          } else if abs(yRelCoord) < 256 {
            if yRelCoord >= 0 {
              yFlags.append([.yDual, .yShortVector])
            } else {
              yFlags.append([.yShortVector])
            }
            yRelCoords.append(abs(yRelCoord))
          } else {
            yFlags.append([])
            yRelCoords.append(yRelCoord)
          }
        }

        // Combine the flags
        var combinedFlags = [TCGlyfSimpleDescript.Flags]()
        for (xFlag, yFlag) in zip(xFlags, yFlags) {
          combinedFlags.append(xFlag.union(yFlag))
        }
        var unencodedFlags = [TCGlyfSimpleDescript.Flags]()
        for (combinedFlag, originalFlag) in zip(combinedFlags, simpleDescript.flags) {
          if originalFlag.contains(.onCurvePoint) {
            unencodedFlags.append(combinedFlag.union(.onCurvePoint))
          } else {
            unencodedFlags.append(combinedFlag)
          }
        }

        // Count any repeats that are longer than 1
        var repeats = [Int]()
        var lastValue: UInt8 = 255
        var rep = 0
        for unencodedFlag in unencodedFlags {
          if unencodedFlag.rawValue == lastValue {
            rep += 1
          } else if unencodedFlag.rawValue != lastValue && rep == 1 {
            repeats.append(0)
            repeats.append(0)
            rep = 0
          } else {
            repeats.append(rep)
            rep = 0
          }
          lastValue = unencodedFlag.rawValue
        }
        if rep > 0 {
          repeats.append(rep)
        }

        // And run-length encode them
        var repIter = repeats.makeIterator()
        var skip = 0
        for unencodedFlag in unencodedFlags {
          if skip > 0 {
            skip -= 1
            continue
          }
          var flag = unencodedFlag
          let rep = repIter.next()!
          if rep >= 2 {
            flag.insert(.repeatFlag)
            data.append(flag.rawValue)
            data.append(UInt8(rep))
            skip = rep
          } else {
            data.append(flag.rawValue)
          }
        }
      } else if let compositeDescript = descript as? TCGlyfCompositeDescript {
        data.append(Int16(-1))
        data.append(Int16(compositeDescript.xMin))
        data.append(Int16(compositeDescript.yMin))
        data.append(Int16(compositeDescript.xMax))
        data.append(Int16(compositeDescript.yMax))
      }
    }
    offsets.append(data.count)
    return (data, offsets)
  }

  // name
  // post
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
          sum = sum &+ ptr.pointee.bigEndian
          ptr += 1
        }
        return sum
      }
    }
  }
}
