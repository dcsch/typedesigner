//
//  CmapFormatUnknown.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

/**
 When we encounter a cmap format we don't understand, we can use this class
 to hold the bare minimum information about it.
 */ 
class CmapFormatUnknown: CmapFormat {
  let format: Int
  let length: Int
  let language: Int

  init(type formatType: Int, dataInput: TCDataInput) {
    format = formatType
    if format < 8 {
      length = Int(dataInput.readUInt16())
      language = Int(dataInput.readUInt16())

      // We don't know how to handle this data, so we'll just skip over it
      _ = dataInput.read(length: length - 6)
    } else {
      _ = dataInput.readUInt16();
      length = Int(dataInput.readInt32())
      language = Int(dataInput.readInt32())

      // We don't know how to handle this data, so we'll just skip over it
      _ = dataInput.read(length: length - 12)
    }
  }

  var ranges: [CountableClosedRange<Int>] {
    return []
  }

  func glyphCode(characterCode: Int) -> Int {
    return 0
  }
}
