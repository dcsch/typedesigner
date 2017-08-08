//
//  TCCmapFormat0.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

/**
 * Simple Macintosh cmap table, mapping only the ASCII character set to glyphs.
 */
class TCCmapFormat0: TCCmapFormat {
  let length: Int
  let language: Int
  let glyphIdArray: [Int]

  init(dataInput: TCDataInput) {
    length = Int(dataInput.readUInt16())
    language = Int(dataInput.readUInt16())
    var glyphIdArray = [Int]()
    for _ in 0...255 {
      glyphIdArray.append(Int(dataInput.readUInt8()))
    }
    self.glyphIdArray = glyphIdArray
  }

  var format: Int {
    get {
      return 0
    }
  }

  var ranges: [CountableClosedRange<Int>] {
    return [0...255]
  }

  func glyphCode(characterCode: Int) -> Int {
    if characterCode < 256 {
      return glyphIdArray[characterCode]
    } else {
      return 0
    }
  }
}
