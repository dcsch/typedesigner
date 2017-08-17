//
//  CFFDict.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/9/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

enum CFFDictError: Error {
  case badRealNumber
  case noOperand
}

public class CFFDict: NSObject {
  var entries: [Int:Any]
  let data: [UInt8]
  var index: Int

  public init(data: [UInt8], offset: Int, length: Int) {
    self.entries = [:]
    self.data = data
    self.index = offset
    super.init()
    while self.index < offset + length {
      addKeyAndValueEntry()
    }
  }

  public init(dataInput: TCDataInput, length: Int) {
    self.entries = [:]
    self.data = dataInput.read(length: length)
    self.index = 0
    super.init()
    while self.index < length {
      addKeyAndValueEntry()
    }
  }

  func value(key: Int) -> Any? {
    return entries[key]
  }

  func addKeyAndValueEntry() {
    var operands = [Any]()
    var operand: Any

    do {
      while isOperandAtCurrentIndex() {
        operand = try nextOperand()
        operands.append(operand)
      }
    } catch {
      return
    }
    var opr = Int(data[index])
    index += 1
    if (opr == 12) {
      opr <<= 8
      opr |= Int(data[index])
      index += 1
    }
    if operands.count == 1 {
      entries[opr] = operands[0]
    } else {
      entries[opr] = operands
    }
  }

  func isOperandAtCurrentIndex() -> Bool {
    let b0 = data[index]
    return (32 <= b0 && b0 <= 254) || b0 == 28 || b0 == 29 || b0 == 30
  }

  func nextOperand() throws -> Any {
    let b0 = Int(data[index])
    if 32 <= b0 && b0 <= 246 {
      // 1 byte integer
      index += 1
      return b0 - 139
    } else if 247 <= b0 && b0 <= 250 {
      // 2 byte integer
      let b1 = Int(data[index + 1])
      index += 2;
      return (b0 - 247) * 256 + b1 + 108
    } else if 251 <= b0 && b0 <= 254 {
      // 2 byte integer
      let b1 = Int(data[index + 1])
      index += 2
      return -(b0 - 251) * 256 - b1 - 108
    } else if b0 == 28 {
      // 3 byte integer
      let b1 = Int(data[index + 1])
      let b2 = Int(data[index + 2])
      index += 3
      return b1 << 8 | b2
    } else if b0 == 29 {
      // 5 byte integer
      let b1 = Int(data[index + 1])
      let b2 = Int(data[index + 2])
      let b3 = Int(data[index + 3])
      let b4 = Int(data[index + 4])
      index += 5
      return b1 << 24 | b2 << 16 | b3 << 8 | b4
    } else if b0 == 30 {
      // Real number
      var fString = ""
      var nibble1: UInt8 = 0
      var nibble2: UInt8 = 0
      index += 1
      while (nibble1 != 0xf) && (nibble2 != 0xf) {
        nibble1 = data[index] >> 4
        nibble2 = data[index] & 0xf
        index += 1
        fString.append(decodeRealNibble(nibble1))
        fString.append(decodeRealNibble(nibble2))
      }
      if let float = Float(fString) {
        return float
      } else {
        throw CFFDictError.badRealNumber
      }
    } else {
      throw CFFDictError.noOperand
    }
  }

  func decodeRealNibble(_ nibble: UInt8) -> String  {
    let nibbles = [
      "0",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      ".",
      "E",
      "E-",
      "",
      "-",
      ""
    ]
    return nibbles[Int(nibble % 0x10)]
  }
}
