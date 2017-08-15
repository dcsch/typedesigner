//
//  TCPrepTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/3/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCPrepTable: TCProgram, TCTable {
  let entry: TCDirectoryEntry

  init(dataInput: TCDataInput, directoryEntry: TCDirectoryEntry) {
    entry = directoryEntry
    super.init()
    readInstructions(dataInput: dataInput, count: Int(entry.length))
  }

  class var tag: UInt32 {
    get {
      return TCTableTag.prep.rawValue
    }
  }

  var directoryEntry: TCDirectoryEntry {
    get {
      return self.entry
    }
  }

  var name: String {
    get {
      let tag = type(of: self).tag
      return String(format: "%c%c%c%c",
                    CChar(truncatingBitPattern:tag >> 24),
                    CChar(truncatingBitPattern:tag >> 16),
                    CChar(truncatingBitPattern:tag >> 8),
                    CChar(truncatingBitPattern:tag))
    }
  }

  override var description: String {
    get {
      return TCDisassembler.disassemble(instructions: instructions,
                                        leadingSpaceCount: 0)
    }
  }
}
