//
//  CFFCharstringType2.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/9/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log

public enum CFFCharstringType2Error: Error {
  case noOperand
}

/**
 CFF Type 2 Charstring
 */
public class CFFCharstringType2: NSObject, CFFCharstring {

  static let oneByteOperators: [String] = [
    "-Reserved-",
    "hstem",
    "-Reserved-",
    "vstem",
    "vmoveto",
    "rlineto",
    "hlineto",
    "vlineto",
    "rrcurveto",
    "-Reserved-",
    "callsubr",
    "return",
    "escape",
    "-Reserved-",
    "endchar",
    "-Reserved-",
    "-Reserved-",
    "-Reserved-",
    "hstemhm",
    "hintmask",
    "cntrmask",
    "rmoveto",
    "hmoveto",
    "vstemhm",
    "rcurveline",
    "rlinecurve",
    "vvcurveto",
    "hhcurveto",
    "shortint",
    "callgsubr",
    "vhcurveto",
    "hvcurveto"
  ]
  static let twoByteOperators: [String] = [
    "-Reserved- (dotsection)",
    "-Reserved-",
    "-Reserved-",
    "and",
    "or",
    "not",
    "-Reserved-",
    "-Reserved-",
    "-Reserved-",
    "abs",
    "add",
    "sub",
    "div",
    "-Reserved-",
    "neg",
    "eq",
    "-Reserved-",
    "-Reserved-",
    "drop",
    "-Reserved-",
    "put",
    "get",
    "ifelse",
    "random",
    "mul",
    "-Reserved-",
    "sqrt",
    "dup",
    "exch",
    "index",
    "roll",
    "-Reserved-",
    "-Reserved-",
    "-Reserved-",
    "hflex",
    "flex",
    "hflex1",
    "flex1",
    "-Reserved-"
  ]

  public let index: Int
  public let name: String
  let data: [UInt8]
  let offset: Int
  let length: Int

  init(index: Int, name: String, data: [UInt8], offset: Int, length: Int) {
    self.index = index
    self.name = name
    self.data = data
    self.offset = offset
    self.length = length
  }

  override init() {
    self.index = 0
    self.name = "Empty"
    self.data = []
    self.offset = 0
    self.length = 0
  }

  func disassemble(at startIP: Int) throws -> (Int, String) {
    var ip = startIP
    var str = ""
    while isOperand(at: ip) {
      let op = try operand(at: ip)
      switch op {
      case let opp as Int:
        str.append("\(opp) ")
      case let opp as Float:
        str.append("\(opp) ")
      default:
        os_log("Inexpected operand type")
      }
//      if let opp = op as! Int {
//        str.append(opp)
//      } else if let opp = op as! Float {
//        str.append(opp)
//      }
      ip = nextOperandIndex(ip)
    }
    var opr = Int(byte(at: ip))
    ip += 1
    let mnemonic: String
    if (opr == 12) {
      opr = Int(byte(at: ip))
      ip += 1

      // Check we're not exceeding the upper limit of our mnemonics
      if opr > 38 {
        opr = 38
      }
      mnemonic = CFFCharstringType2.twoByteOperators[opr]
    } else {
      mnemonic = CFFCharstringType2.oneByteOperators[opr]
    }
    str.append(mnemonic)
    return (ip, str)
  }

  var firstIndex: Int {
    get {
      return offset
    }
  }

  func isOperand(at ip: Int) -> Bool {
    let b0 = data[ip]
    return (32 <= b0 && b0 <= 255) || b0 == 28
  }

  func operand(at ip: Int) throws -> NSNumber {
    let b0 = Int(data[ip])
    if 32 <= b0 && b0 <= 246 {

      // 1 byte integer
      return NSNumber(value: b0 - 139)
    } else if 247 <= b0 && b0 <= 250 {

      // 2 byte integer
      let b1 = Int(data[ip + 1])
      return NSNumber(value: (b0 - 247) * 256 + b1 + 108)
    } else if 251 <= b0 && b0 <= 254 {

      // 2 byte integer
      let b1 = Int(data[ip + 1])
      let value = -(b0 - 251) * 256 - b1 - 108
      return NSNumber(value: value)
    } else if b0 == 28 {

      // 3 byte integer
      let b1 = Int(data[ip + 1])
      let b2 = Int(data[ip + 2])
      return NSNumber(value: b1 << 8 | b2)
    } else if b0 == 255 {

      // 16-bit signed integer with 16 bits of fraction
      let b1 = Int(Int8(bitPattern: data[ip + 1]))
      let b2 = Int(data[ip + 2])
      let b3 = Int(data[ip + 3])
      let b4 = Int(data[ip + 4])
      return NSNumber(value: Float(Int(b1) << 8 | Int(b2)) + Float(Int(b3) << 8 | Int(b4)) / 65536.0)
    } else {
      throw CFFCharstringType2Error.noOperand
    }
  }

  func nextOperandIndex(_ ip: Int) -> Int {
    let b0 = data[ip]
    if 32 <= b0 && b0 <= 246 {

      // 1 byte integer
      return ip + 1
    } else if 247 <= b0 && b0 <= 250 {

      // 2 byte integer
      return ip + 2
    } else if 251 <= b0 && b0 <= 254 {

      // 2 byte integer
      return ip + 2
    } else if b0 == 28 {

      // 3 byte integer
      return ip + 3
    } else if b0 == 255 {

      return ip + 5
    } else {
      return ip
    }
  }

  func byte(at ip: Int) -> UInt8 {
    return data[ip]
  }

  func moreBytes(from ip: Int) -> Bool {
    return ip < offset + length
  }

//  public String toString() {
//    StringBuilder sb = new StringBuilder();
//    int ip = getFirstIndex();
//    while (moreBytes(ip)) {
//      //            sb.append(ip);
//      //            sb.append(": ");
//      ip = disassemble(ip, sb);
//      sb.append("\n");
//    }
//    return sb.toString();
//  }
}
