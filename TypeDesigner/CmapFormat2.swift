//
//  CmapFormat2.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

/**
 High-byte mapping through table cmap format.
 */
class CmapFormat2: CmapFormat {

  class SubHeader {
    let firstCode: UInt16
    let entryCount: UInt16
    let idDelta: Int16
    let idRangeOffset: UInt16
    var arrayIndex = 0

    init(firstCode: UInt16,
         entryCount: UInt16,
         idDelta: Int16,
         idRangeOffset: UInt16) {
      self.firstCode = firstCode
      self.entryCount = entryCount
      self.idDelta = idDelta
      self.idRangeOffset = idRangeOffset
    }
  }

  let length: Int
  let language: Int
  var subHeaderKeys = [Int]()
  var subHeaders = [SubHeader]()
  var glyphIndexArray = [Int]()
  var ranges: [CountableClosedRange<Int>]

  init(dataInput: TCDataInput) {
    length = Int(dataInput.readUInt16())
    language = Int(dataInput.readUInt16())

    var pos = 6

    // Read the subheader keys, noting the highest value, as this will
    // determine the number of subheaders to read.
    var highest = 0
    for _ in 0..<256 {
      let subheaderKey = Int(dataInput.readUInt16())
      subHeaderKeys.append(subheaderKey)
      highest = max(highest, subheaderKey)
      pos += 2
    }
    let subHeaderCount = highest / 8 + 1

    // Read the subheaders, once again noting the highest glyphIndexArray
    // index range.
    let indexArrayOffset = 8 * subHeaderCount + 518;
    highest = 0
    for _ in 0..<subHeaderCount {
      let firstCode = dataInput.readUInt16()
      let entryCount = dataInput.readUInt16()
      let idDelta = dataInput.readInt16()
      let idRangeOffset = dataInput.readUInt16()
      let subHeader = SubHeader(firstCode: firstCode,
                                entryCount: entryCount,
                                idDelta: idDelta,
                                idRangeOffset: idRangeOffset)

      // Calculate the offset into the _glyphIndexArray
      pos += 8
      subHeader.arrayIndex = (pos - 2 + Int(subHeader.idRangeOffset) - indexArrayOffset) / 2

      // What is the highest range within the glyphIndexArray?
      highest = max(highest, Int(subHeader.arrayIndex) + Int(subHeader.entryCount))

      subHeaders.append(subHeader)
    }

    // Read the glyphIndexArray
    for _ in 0..<highest {
      glyphIndexArray.append(Int(dataInput.readUInt16()))
    }

    // Determines the ranges
    var ranges = [CountableClosedRange<Int>]()
    for index in 0..<subHeaders.count {
      // Find the high-byte (if any)
      var highByte: UInt16 = 0
      if index != 0 {
        for i in 0..<256 {
          if subHeaderKeys[i] / 8 == index {
            highByte = UInt16(i << 8)
            break
          }
        }
      }

      let subHeader = subHeaders[index]
      let range = Int(highByte | subHeader.firstCode)...Int(highByte | subHeader.firstCode + subHeader.entryCount - 1)
      ranges.append(range)
    }
    self.ranges = ranges
  }

  var format: Int {
    get {
      return 2
    }
  }

  func glyphCode(characterCode: Int) -> Int {

    // Get the appropriate subheader
    var index = 0
    let highByte = characterCode >> 8
    if highByte != 0 {
      index = subHeaderKeys[highByte] / 8
    }
    let sh = subHeaders[index]

    // Is the charCode out-of-range?
    let lowByte = characterCode & 0xff
    if lowByte < Int(sh.firstCode) ||
      lowByte >= Int(sh.firstCode) + Int(sh.entryCount) {
      return 0
    }

    // Now calculate the glyph index
    var glyphIndex = glyphIndexArray[sh.arrayIndex + (lowByte - Int(sh.firstCode))]
    if glyphIndex != 0 {
      glyphIndex += Int(sh.idDelta)
      glyphIndex %= 65536
    }
    return glyphIndex
  }
}
