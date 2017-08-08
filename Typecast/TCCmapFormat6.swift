//
//  TCCmapFormat6.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCCmapFormat6: TCCmapFormat {
  let length: Int
  let language: Int

  init(dataInput: TCDataInput) {
    length = Int(dataInput.readUInt16())
    language = Int(dataInput.readUInt16())
  }

  var format: Int {
    get {
      return 6
    }
  }

  var ranges: [CountableClosedRange<Int>] {
    return []
  }

  func glyphCode(characterCode: Int) -> Int {
    return 0
  }
}
