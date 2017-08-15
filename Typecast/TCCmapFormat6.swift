//
//  TCCmapFormat6.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

/**
 Format 6: Trimmed table mapping
 */
class TCCmapFormat6: TCCmapFormat {
  let length: Int
  let language: Int
  let firstCode: Int
  let entryCount: Int
  let glyphIDs: [Int]

  init(dataInput: TCDataInput) {
    length = Int(dataInput.readUInt16())
    language = Int(dataInput.readUInt16())
    firstCode = Int(dataInput.readUInt16())
    entryCount = Int(dataInput.readUInt16())
    var glyphIDs = [Int]()
    for _ in 0..<entryCount {
        glyphIDs.append(Int(dataInput.readUInt16()))
    }
    self.glyphIDs = glyphIDs
  }

  var format: Int {
    get {
      return 6
    }
  }

  var ranges: [CountableClosedRange<Int>] {
    return [firstCode...firstCode + entryCount - 1]
  }

  func glyphCode(characterCode: Int) -> Int {
    if firstCode <= characterCode && characterCode < firstCode + entryCount {
      return glyphIDs[characterCode - firstCode]
    } else {
      return 0
    }
  }
}
