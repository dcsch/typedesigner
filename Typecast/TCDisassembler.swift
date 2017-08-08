//
//  TCDisassembler.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/7/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCDisassembler {

  /**
   * Advance the instruction pointer to the next executable opcode.
   * This will be the next byte, unless the current opcode is a push
   * instruction, in which case it will be the byte immediately beyond
   * the last data byte.
   * - parameters:
   *   - ip: The current instruction pointer
   *   - instructions: The program to advance through
   * - returns: The new instruction pointer
   */
  class func advance(ip: Int, instructions: [UInt8]) -> Int {

    // The high word specifies font, cvt, or glyph program
    var i = ip & 0xffff
    var nextIP = ip + 1
    if TCMnemonic.NPUSHB.rawValue == instructions[i] {

      // Next byte is the data byte count
      i += 1
      let dataCount = Int(instructions[i])
      nextIP += dataCount + 1
    } else if TCMnemonic.NPUSHW.rawValue == instructions[i] {

      // Next byte is the data word count
      i += 1
      let dataCount = Int(instructions[i])
      nextIP += dataCount * 2 + 1
    } else if TCMnemonic.PUSHB.rawValue == (instructions[i] & 0xf8) {
      let dataCount = Int((instructions[i] & 0x07) + 1)
      nextIP += dataCount
    } else if TCMnemonic.PUSHW.rawValue == (instructions[i] & 0xf8) {
      let dataCount = Int((instructions[i] & 0x07) + 1)
      nextIP += dataCount * 2
    }
    return nextIP
  }

  class func pushCount(ip: Int, instructions: [UInt8]) -> Int {
    let instr = instructions[ip & 0xffff]
    if TCMnemonic.NPUSHB.rawValue == instr ||
      TCMnemonic.NPUSHW.rawValue == instr {
      return Int(instructions[(ip & 0xffff) + 1])
    } else if TCMnemonic.PUSHB.rawValue == (instr & 0xf8) ||
      TCMnemonic.PUSHW.rawValue == (instr & 0xf8) {
      return Int((instr & 0x07) + 1)
    } else {
      return 0
    }
  }

  class func pushValues(ip: Int, instructions: [UInt8]) -> [Int] {
    let count = pushCount(ip: ip, instructions: instructions)
    var values = [Int]()
    let i = ip & 0xffff
    let instr = instructions[i]
    if TCMnemonic.NPUSHB.rawValue == instr {
      for j in 0..<count {
        values[j] = Int(instructions[i + j + 2])
      }
    } else if TCMnemonic.PUSHB.rawValue == (instr & 0xf8) {
      for j in 0..<count {
        values[j] = Int(instructions[i + j + 1])
      }
    } else if TCMnemonic.NPUSHW.rawValue == instr {
      for j in 0..<count {
        values[j] = Int(Int16(Int8(bitPattern: instructions[i + j*2 + 2])) << 8) | Int(instructions[i + j*2 + 3])
      }
    } else if TCMnemonic.PUSHW.rawValue == (instr & 0xf8) {
      for j in 0..<count {
        values[j] = Int(Int16(Int8(bitPattern: instructions[i + j*2 + 1])) << 8) | Int(instructions[i + j*2 + 2])
      }
    }
    return values;
  }

  class func disassemble(instructions: [UInt8], leadingSpaceCount: Int) -> String {
    var str = ""
    var ip = 0
    while ip < instructions.count {
      for _ in 0..<leadingSpaceCount {
        str.append(" ")
      }
      str.append("\(ip): \(TCMnemonic.mnemonic(opcode: instructions[ip]))")
      if pushCount(ip: ip, instructions: instructions) > 0 {
        let values = pushValues(ip: ip, instructions:instructions)
        for value in values {
          str.append(" \(value)")
        }
      }
      str.append("\n")
      ip = advance(ip: ip, instructions: instructions)
    }
    return str;
  }
}
