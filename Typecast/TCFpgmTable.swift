//
//  TCFpgmTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/3/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCFpgmTable: TCProgram, TCTable {

  let entry: TCDirectoryEntry

  init(dataInput: TCDataInput, directoryEntry: TCDirectoryEntry) {
    self.entry = directoryEntry
    super.init()
    readInstructions(dataInput: dataInput, count: Int(entry.length))
  }

  var type: UInt32 {
    get {
      return TCTableType.fpgm.rawValue
    }
  }

  var directoryEntry: TCDirectoryEntry {
    get {
      return self.entry
    }
  }

  var name: String {
    get {
      let type = self.type
      return String(format: "%c%c%c%c",
                    CChar(truncatingBitPattern:type >> 24),
                    CChar(truncatingBitPattern:type >> 16),
                    CChar(truncatingBitPattern:type >> 8),
                    CChar(truncatingBitPattern:type))
    }
  }

  override var description: String {
    get {
      return TCDisassembler.disassemble(instructions: instructions,
                                        leadingSpaceCount: 0)
    }
  }
}
