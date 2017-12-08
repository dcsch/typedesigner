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

  class func write(directory: TableDirectory) -> Data {
    directory.calculateHeader()
    let entries = directory.entries.sorted { $0.tag < $1.tag }
    var data = Data()
    data.append(UInt32(directory.version))
    data.append(UInt16(directory.entries.count))
    data.append(UInt16(directory.searchRange))
    data.append(UInt16(directory.entrySelector))
    data.append(UInt16(directory.rangeShift))
    for entry in entries {
      assert(entry.offset % 4 == 0, "\(entry.tagAsString) offset is not a multiple of 4")
      data.append(UInt32(entry.tag))
      data.append(UInt32(entry.checksum))
      data.append(UInt32(entry.offset))
      data.append(UInt32(entry.length))
    }
    data.pad32()
    return data
  }

  class func write(table: HeadTable) -> Data {
    let magicNumber: UInt32 = 0x5F0F3CF5
    var data = Data()
    data.append(UInt16(1))  // Version 1.0
    data.append(UInt16(0))
    data.append(UInt32(0))  // Check sum adjustment, to be computed at end of encode
    data.append(UInt32(table.fontRevision))
    data.append(magicNumber)
    data.append(UInt16(table.flags))
    data.append(UInt16(table.unitsPerEm))
    data.append(UInt64(table.created.timeIntervalSince(HeadTable.epoch)))
    data.append(UInt64(table.modified.timeIntervalSince(HeadTable.epoch)))
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
    data.pad32()
    return data
  }

  class func write(table: HheaTable) -> Data {
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
    data.pad32()
    return data
  }

  class func write(table: MaxpTable) -> Data {
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
    data.pad32()
    return data
  }

  class func write(table: Os2Table) -> Data {
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
    data.pad32()
    return data
  }

  class func write(table: HmtxTable) -> Data {
    var data = Data()
    for metric in table.hMetrics {
      data.append(UInt16(metric.advanceWidth))
      data.append(Int16(metric.lsb))
    }
    for lsb in table.leftSideBearings {
      data.append(Int16(lsb))
    }
    data.pad32()
    return data
  }

  class func write(table: HdmxTable) -> Data {
    var deviceData = Data()
    var sizeDeviceRecord = 0
    for record in table.records {
      deviceData.append(UInt8(record.pixelSize))
      deviceData.append(UInt8(record.maxWidth))
      for width in record.widths {
        deviceData.append(UInt8(width))
      }
      deviceData.pad32()
      if sizeDeviceRecord == 0 {
        sizeDeviceRecord = deviceData.count
      }
    }
    var data = Data()
    data.append(UInt16(0)) // version
    data.append(Int16(table.records.count))
    data.append(Int32(sizeDeviceRecord))
    data.append(deviceData)
    return data
  }

  class func write(table: CmapTable) -> Data {

    // Sort mappings in order of platform, endoding, language
    let entries = table.entries.sorted {
      (lhs: CmapTable.IndexEntry, rhs: CmapTable.IndexEntry) -> Bool in
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
      let data = CmapFormat4.encode(mapping: mapping)
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
    data.pad32()
    return data
  }

  class func writeLoca(offsets: [Int], shortEntries: Bool) -> Data {
    var data = Data()
    for offset in offsets {
      assert(offset % 2 == 0, "glyf offsets are misaligned")
      if shortEntries {
        data.append(UInt16(offset / 2))
      } else {
        data.append(UInt32(offset))
      }
    }
    data.pad32()
    return data
  }

  class func write(table: GlyfTable) -> (Data, [Int]) {
    var data = Data()
    var offsets = [Int]()
    for descript in table.descript {
      offsets.append(data.count)
      if let simpleDescript = descript as? GlyfSimpleDescript {
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

        // Encode absolute coords into relative coords
        var xFlags = [GlyfSimpleDescript.Flags]()
        var xRelCoords = [Int]()
        var x = 0
        for xCoord in simpleDescript.xCoordinates {
          let xRelCoord = xCoord - x
          x = xCoord
          if xRelCoord == 0 {
            xFlags.append(.xDual)
            xRelCoords.append(0) // This will be dropped when we encode to data
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
        var yFlags = [GlyfSimpleDescript.Flags]()
        var yRelCoords = [Int]()
        var y = 0
        for yCoord in simpleDescript.yCoordinates {
          let yRelCoord = yCoord - y
          y = yCoord
          if yRelCoord == 0 {
            yFlags.append(.yDual)
            yRelCoords.append(0) // This will be dropped when we encode to data
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
        var combinedFlags = [GlyfSimpleDescript.Flags]()
        for (xFlag, yFlag) in zip(xFlags, yFlags) {
          combinedFlags.append(xFlag.union(yFlag))
        }
        var unencodedFlags = [GlyfSimpleDescript.Flags]()
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
        for (index, unencodedFlag) in unencodedFlags.enumerated() {
          if index == 0 {
            lastValue = unencodedFlag.rawValue
            continue
          }
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
        if rep == 1 {
          repeats.append(0)
          repeats.append(0)
        } else {
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

        // Encode the coordinates
        for (xCoord, xFlag) in zip(xRelCoords, xFlags) {
          if xCoord == 0 {
            continue
          } else if xFlag.contains(.xShortVector) {
            data.append(UInt8(xCoord))
          } else {
            data.append(Int16(xCoord))
          }
        }
        for (yCoord, yFlag) in zip(yRelCoords, yFlags) {
          if yCoord == 0 {
            continue
          } else if yFlag.contains(.yShortVector) {
            data.append(UInt8(yCoord))
          } else {
            data.append(Int16(yCoord))
          }
        }

      } else if let compositeDescript = descript as? GlyfCompositeDescript {
        data.append(Int16(-1))
        data.append(Int16(compositeDescript.xMin))
        data.append(Int16(compositeDescript.yMin))
        data.append(Int16(compositeDescript.xMax))
        data.append(Int16(compositeDescript.yMax))

        for component in compositeDescript.components {

          // Translation flags
          var flags = GlyfCompositeDescript.Component.Flags.argsAreXYValues
          if component.xtranslate < Int8.min || component.xtranslate > Int8.max ||
            component.ytranslate < Int8.min || component.ytranslate > Int8.max {
            flags.insert(.arg1And2AreWords)
          }

          // Scale flags
          if component.scale01 == 0 && component.scale10 == 0 {
            if component.xscale == component.yscale {
              flags.insert(.weHaveAScale)
            } else {
              flags.insert(.weHaveAnXAndYScale)
            }
          } else {
            flags.insert(.weHaveATwoByTwo)
          }

          if component != compositeDescript.components.last! {
            flags.insert(.moreComponents)
          } else if !compositeDescript.instructions.isEmpty {
            flags.insert(.weHaveInstructions)
          }

          data.append(flags.rawValue)
          data.append(UInt16(component.glyphIndex))
          if flags.contains(.arg1And2AreWords) {
            data.append(Int16(component.xtranslate))
            data.append(Int16(component.ytranslate))
          } else {
            data.append(Int8(component.xtranslate))
            data.append(Int8(component.ytranslate))
          }
          if flags.contains(.weHaveAScale) {
            let scale = component.xscale * Double(0x4000)
            data.append(Int16(scale))
          } else if flags.contains(.weHaveAnXAndYScale) {
            let xscale = component.xscale * Double(0x4000)
            let yscale = component.yscale * Double(0x4000)
            data.append(Int16(xscale))
            data.append(Int16(yscale))
          } else if flags.contains(.weHaveATwoByTwo) {
            let xscale = component.xscale * Double(0x4000)
            let scale01 = component.scale01 * Double(0x4000)
            let scale10 = component.scale10 * Double(0x4000)
            let yscale = component.yscale * Double(0x4000)
            data.append(Int16(xscale))
            data.append(Int16(scale01))
            data.append(Int16(scale10))
            data.append(Int16(yscale))
          }
        }

        if !compositeDescript.instructions.isEmpty {
          data.append(UInt16(compositeDescript.instructions.count))
          data.append(contentsOf: compositeDescript.instructions)
        }
      }

      // Do we need to pad to 16-bit alignment?
      if data.count % 2 == 1 {
        data.append(UInt8(0))
      }
    }
    offsets.append(data.count)
    data.pad32()
    return (data, offsets)
  }

  class func write(table: KernTable) -> Data {
    var data = Data()
    data.append(UInt16(0)) // version
    data.append(UInt16(table.subtables.count))
    for subtable in table.subtables {
      data.append(UInt16(0)) // version
      let length = 6 * subtable.kerningPairs.count + 14
      data.append(UInt16(length))
      data.append(UInt8(0)) // format
      data.append(subtable.coverage.rawValue)
      data.append(UInt16(subtable.kerningPairs.count))

      let power = Int(floor(log2(Double(subtable.kerningPairs.count))))
      let maxPow2 = 2 << (power - 1)
      let searchRange = 6 * maxPow2
      let entrySelector = Int(log2(Double(maxPow2)))
      let rangeShift = 6 * (subtable.kerningPairs.count - maxPow2)
      data.append(UInt16(searchRange))
      data.append(UInt16(entrySelector))
      data.append(UInt16(rangeShift))
      for kerningPair in subtable.kerningPairs {
        data.append(UInt16(kerningPair.left))
        data.append(UInt16(kerningPair.right))
        data.append(Int16(kerningPair.value))
      }
    }
    data.pad32()
    return data
  }

  class func write(table: NameTable) -> Data {
    var stringData = Data()
    var lengthAndOffsets = [(Int, Int)]()
    var offset = 0
    for record in table.nameRecords {
      if record.platformID == .macintosh || record.platformID == .iso {

        // Encode as ASCII
        var codeUnits: [Unicode.ASCII.CodeUnit] = []
        let sink = { codeUnits.append($0) }
        _ = transcode(record.record.utf16.makeIterator(),
                      from: Unicode.UTF16.self, to: Unicode.ASCII.self,
                      stoppingOnError: false, into: sink)
        stringData.append(contentsOf: codeUnits)
        let length = codeUnits.count
        lengthAndOffsets.append((length, offset))
        offset += length
      } else if record.platformID == .microsoft {

        // Encode as little-endian UTF-16
        let utf16 = record.record.utf16
        let littlies = utf16.map { $0.littleEndian }
        for littlie in littlies {
          var mutable = littlie
          stringData.append(UnsafeBufferPointer(start: &mutable, count: 1))
        }
        let length = 2 * littlies.count
        lengthAndOffsets.append((length, offset))
        offset += length
      } else if record.platformID == .unicode {

        // Encode as big-endian UTF-16
        let utf16 = record.record.utf16
        let biggies = utf16.map { $0.bigEndian }
        for biggie in biggies {
          var mutable = biggie
          stringData.append(UnsafeBufferPointer(start: &mutable, count: 1))
        }
        let length = 2 * biggies.count
        lengthAndOffsets.append((length, offset))
        offset += length
      }
    }

    var data = Data()
    data.append(UInt16(0))  // TODO Support format 1
    data.append(UInt16(table.nameRecords.count))
    data.append(UInt16(12 * table.nameRecords.count + 6)) // This is only correct for format 0
    for (record, (length, offset)) in zip(table.nameRecords, lengthAndOffsets) {
      data.append(UInt16(record.platformID.rawValue))
      data.append(UInt16(record.encodingID))
      data.append(UInt16(record.languageID))
      data.append(UInt16(record.nameID.rawValue))
      data.append(UInt16(length))
      data.append(UInt16(offset))
    }
    data.append(stringData)
    data.pad32()
    return data
  }

  class func write(table: PostTable) -> Data {
    var data = Data()
    data.append(UInt32(0x00020000))
    data.append(UInt32(table.italicAngle))
    data.append(Int16(table.underlinePosition))
    data.append(Int16(table.underlineThickness))
    data.append(UInt32(table.isFixedPitch))
    data.append(UInt32(table.minMemType42))
    data.append(UInt32(table.maxMemType42))
    data.append(UInt32(table.minMemType1))
    data.append(UInt32(table.maxMemType1))

    data.append(UInt16(table.numGlyphs))
    for index in table.glyphNameIndex {
      data.append(UInt16(index))
    }
    for name in table.psGlyphName {
      var codeUnits: [Unicode.ASCII.CodeUnit] = []
      let sink = { codeUnits.append($0) }
      _ = transcode(name.utf16.makeIterator(),
                    from: Unicode.UTF16.self, to: Unicode.ASCII.self,
                    stoppingOnError: false, into: sink)
      data.append(UInt8(codeUnits.count))
      data.append(contentsOf: codeUnits)
    }
    data.pad32()
    return data
  }

  class func write(table: GaspTable) -> Data {
    var data = Data()
    data.append(UInt16(1))
    data.append(UInt16(table.gaspRanges.count))
    for gaspRange in table.gaspRanges {
      data.append(UInt16(gaspRange.rangeMaxPPEM))
      data.append(UInt16(gaspRange.rangeGaspBehavior))
    }
    data.pad32()
    return data
  }
}

extension Data {

  mutating func append<T: FixedWidthInteger>(_ integer: T) {
    var bigEndian = integer.bigEndian
    append(UnsafeBufferPointer(start: &bigEndian, count: 1))
  }

  mutating func pad32() {
    let paddingCount = 4 - count % 4
    if paddingCount < 4 {
      for _ in 0..<paddingCount {
        append(UInt8(0))
      }
    }
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
