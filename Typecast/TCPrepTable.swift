//
//  TCPrepTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/3/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCPrepTable: TCProgram, TCTableProtocol {
  let entry: TCDirectoryEntry

  init(dataInput: TCDataInput, directoryEntry: TCDirectoryEntry) {
    self.entry = directoryEntry.copy() as! TCDirectoryEntry
    super.init()
    readInstructions(dataInput: dataInput, count: Int(entry.length))
  }

  func type() -> UInt32 {
    return TCTableType.prep.rawValue
  }

  func directoryEntry() -> TCDirectoryEntry {
    return self.entry
  }

  var name: String {
    get {
      let type = self.type()
      return String(format: "%c%c%c%c",
                    CChar(Int(type) >> 24),
                    CChar(Int(type) >> 16),
                    CChar(Int(type) >> 8),
                    CChar(type))
    }
  }

  override var description: String {
    get {
//      return TCDisassembler.disassemble(instructions: instructions,
//                                        leadingSpaceCount: 0)
      return ""
    }
  }
}
