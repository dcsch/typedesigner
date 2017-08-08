//
//  CFFIndex.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/7/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class CFFIndex: NSObject {
  let count: Int
  let offSize: Int
  let offset: [Int]
  let data: Data? = nil

  init(dataInput: TCDataInput) {
    count = Int(dataInput.readUInt16())
    var offset = [Int]()
    offSize = Int(dataInput.readUInt8())
    for _ in 0...count {
      var thisOffset = 0
      for j in 0..<offSize {
        thisOffset |= Int(dataInput.readUInt8()) << ((offSize - j - 1) * 8)
      }
      offset.append(thisOffset)
    }
    self.offset = offset
  }

  var dataLength: Int {
    get {
      return offset.last! - 1
    }
  }
}

class CFFTopDictIndex: CFFIndex {

  func topDict(at index: Int) -> CFFDict {
    let offset = self.offset[index] - 1
    let len = self.offset[index + 1] - offset - 1
    return CFFDict(data: data, offset: Int32(offset), length: Int32(len))
  }
}

class CFFNameIndex: CFFIndex {

}

class CFFStringIndex: CFFIndex {

  func string(at index: Int) -> String? {
    if index < Int(CFFStandardStrings.stringCount()) {
      return CFFStandardStrings.string(at: UInt(index))
    } else {
      let shiftedIndex = index - Int(CFFStandardStrings.stringCount())
      if shiftedIndex >= self.count {
        return nil
      }

      let begin = self.offset[index] - 1
      let end = self.offset[index + 1] - 1

      let stringData = self.data?.subdata(in: begin..<end)
      return String(data: stringData!, encoding: .ascii)
    }
  }
}
