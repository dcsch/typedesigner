//
//  TCFpgmTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/3/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCFpgmTable: TCBaseTable, Codable {
  var instructions = [UInt8]()

  init(data: Data) {
    let dataInput = TCDataInput(data: data)
    instructions = dataInput.read(length: data.count)
  }

  override class var tag: UInt32 {
    get {
      return TCTableTag.fpgm.rawValue
    }
  }

  override var name: String {
    get {
      let tag = type(of: self).tag
      return String(format: "%c%c%c%c",
                    CChar(truncatingIfNeeded:tag >> 24),
                    CChar(truncatingIfNeeded:tag >> 16),
                    CChar(truncatingIfNeeded:tag >> 8),
                    CChar(truncatingIfNeeded:tag))
    }
  }

  override var description: String {
    get {
      return TCDisassembler.disassemble(instructions: instructions,
                                        leadingSpaceCount: 0)
    }
  }
}
