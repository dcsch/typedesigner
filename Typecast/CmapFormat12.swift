//
//  TCCmapFormat12.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/10/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

/**
 Segmented coverage.
 */
class TCCmapFormat12: TCCmapFormat {
  let length: Int
  let language: Int
  let startGlyphIDs: [Int]
  let ranges: [CountableClosedRange<Int>]

  init(dataInput: TCDataInput) {
    _ = dataInput.readUInt16()  // reserved
    length = Int(dataInput.readInt32())
    language = Int(dataInput.readInt32())
    let nGroups = Int(dataInput.readInt32())
    var startGlyphIDs = [Int]()
    var ranges = [CountableClosedRange<Int>]()
    for _ in 0..<nGroups {
      let startCharCode = Int(dataInput.readInt32())
      let endCharCode = Int(dataInput.readInt32())
      ranges.append(startCharCode...endCharCode)
      startGlyphIDs.append(Int(dataInput.readInt32()))
    }
    self.startGlyphIDs = startGlyphIDs
    self.ranges = ranges
  }

  var format: Int {
    get {
      return 12
    }
  }

  func glyphCode(characterCode: Int) -> Int {
    for (index, range) in ranges.enumerated() {
      if range.contains(characterCode) {
        return characterCode - range.lowerBound + startGlyphIDs[index]
      }
    }
    return 0
  }
}
