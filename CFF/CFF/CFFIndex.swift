//
//  CFFIndex.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/7/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

public class CFFIndex {
  public let count: Int
  let offSize: Int
  let offset: [Int]
  let data: [UInt8]

  public init(dataInput: TCDataInput) {
    self.count = Int(dataInput.readUInt16())
    var offset = [Int]()
    offSize = Int(dataInput.readUInt8())
    for _ in 0...self.count {
      var thisOffset = 0
      for j in 0..<offSize {
        thisOffset |= Int(dataInput.readUInt8()) << ((offSize - j - 1) * 8)
      }
      offset.append(thisOffset)
    }
    self.offset = offset
    let count = offset.last! - 1
    self.data = dataInput.read(length: count)
  }

  var dataLength: Int {
    get {
      return offset.last! - 1
    }
  }
}

public class CFFTopDictIndex: CFFIndex {

  public func topDict(at index: Int) -> CFFDict {
    let off = offset[index] - 1
    let len = offset[index + 1] - off - 1
    return CFFDict(data: data, offset: off, length: len)
  }

}

public class CFFNameIndex: CFFIndex {

}

public class CFFStringIndex: CFFIndex {

  public func string(at index: Int) -> String {
    if index < CFFStandardStrings.standardStrings.count {
      return CFFStandardStrings.standardStrings[index]
    } else {
      let shiftedIndex = index - CFFStandardStrings.standardStrings.count
      if shiftedIndex >= self.count {
        return "<empty name>"
      }

      let begin = self.offset[shiftedIndex] - 1
      let end = self.offset[shiftedIndex + 1] - 1

      let stringSlice = self.data[begin..<end]
      return String(bytes: stringSlice, encoding: .ascii) ?? "<malformed name>"
    }
  }

}
