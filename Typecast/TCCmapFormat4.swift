//
//  TCCmapFormat4.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

/**
 Segment mapping to delta values.
 */
class TCCmapFormat4: TCCmapFormat {
  let length: Int
  let language: Int
  let segCountX2: Int
  let searchRange: Int
  let entrySelector: Int
  let rangeShift: Int
  var endCode: [Int]
  var startCode: [Int]
  var idDelta: [Int]
  var idRangeOffset: [Int]
  var glyphIdArray: [Int]
  let segCount: Int
  let ranges: [CountableClosedRange<Int>]

  init(dataInput: TCDataInput) {
    length = Int(dataInput.readUInt16())
    language = Int(dataInput.readUInt16())
    segCountX2 = Int(dataInput.readUInt16()) // +2 (8)
    segCount = segCountX2 / 2
    endCode = []
    startCode = []
    idDelta = []
    idRangeOffset = []
    searchRange = Int(dataInput.readUInt16()) // +2 (10)
    entrySelector = Int(dataInput.readUInt16()) // +2 (12)
    rangeShift = Int(dataInput.readUInt16()) // +2 (14)
    for _ in 0..<segCount {
      endCode.append(Int(dataInput.readUInt16()))
    } // + 2*segCount (2*segCount + 14)
    _ = dataInput.readUInt16() // reservePad  +2 (2*segCount + 16)
    for _ in 0..<segCount {
      startCode.append(Int(dataInput.readUInt16()))
    } // + 2*segCount (4*segCount + 16)
    for _ in 0..<segCount {
      idDelta.append(Int(dataInput.readUInt16()))
    } // + 2*segCount (6*segCount + 16)
    for _ in 0..<segCount {
      idRangeOffset.append(Int(dataInput.readUInt16()))
    } // + 2*segCount (8*segCount + 16)

    // Whatever remains of this header belongs in glyphIdArray
    let count = (length - (8 * segCount + 16)) / 2
    glyphIdArray = []
    for _ in 0..<count {
      glyphIdArray.append(Int(dataInput.readUInt16()))
    } // + 2*count (8*segCount + 2*count + 18)

    // Are there any padding bytes we need to consume?
    //        int leftover = length - (8*segCount + 2*count + 18);
    //        if (leftover > 0) {
    //            [dataInput skipByteount:leftover];
    //        }

    // Determines the ranges
    var ranges = [CountableClosedRange<Int>]()
    for index in 0..<segCount {
      let startCode = self.startCode[index]
      let endCode = self.endCode[index]
      let range = startCode...endCode
      ranges.append(range)
    }
    self.ranges = ranges
  }

  class func encode(mapping: CharacterToGlyphMapping) -> Data {

    // Find the ranges
    let charCodes = mapping.glyphCodes.keys.sorted()
    var ranges = [CountableClosedRange<Int>]()
    var beginCharCode = -1
    var lastCharCode = -1
    for charCode in charCodes {
      if lastCharCode == -1 {
        beginCharCode = charCode
        lastCharCode = charCode
        continue
      }
      if charCode > lastCharCode + 1 {
        ranges.append(beginCharCode...lastCharCode)
        beginCharCode = charCode
      }
      lastCharCode = charCode
    }
    ranges.append(beginCharCode...lastCharCode)

    // Calculate pre-computed header values
    let segCountX2 = 2 * ranges.count
    let maxPow2 = Int(floor(log2(Double(ranges.count))))
    let searchRange = 2 << maxPow2
    let entrySelector = Int(log2(Double(searchRange / 2)))
    let rangeShift = segCountX2 - searchRange

    var data = Data()
    data.append(UInt16(4))
    data.append(UInt16(0))  // length - this will be written again below
    data.append(UInt16(mapping.language))
    data.append(UInt16(segCountX2))
    data.append(UInt16(searchRange))
    data.append(UInt16(entrySelector))
    data.append(UInt16(rangeShift))
    for range in ranges {
      data.append(UInt16(range.upperBound))
    }
    data.append(UInt16(0))
    for range in ranges {
      data.append(UInt16(range.lowerBound))
    }
    return data
  }

  var format: Int {
    get {
      return 4
    }
  }

  func glyphCode(characterCode: Int) -> Int {
    for i in 0..<segCount {
      if endCode[i] >= characterCode {
        if startCode[i] <= characterCode {
          let idRangeOffset = self.idRangeOffset[i]
          if idRangeOffset > 0 {
            let id = glyphIdArray[idRangeOffset / 2 + (characterCode - startCode[i]) - (segCount - i)]
            return id
          } else {
            return (idDelta[i] + characterCode) % 65536
          }
        } else {
          break
        }
      }
    }
    return 0
  }
}
