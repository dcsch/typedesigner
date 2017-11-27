//
//  TCFpgmTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/3/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCFpgmTable: TCTable, Codable {
  var instructions = [UInt8]()

  init(data: Data) {
    let dataInput = TCDataInput(data: data)
    instructions = dataInput.read(length: data.count)
  }

  override class var tag: TCTable.Tag {
    get {
      return .fpgm
    }
  }

  override var description: String {
    get {
      return TCDisassembler.disassemble(instructions: instructions,
                                        leadingSpaceCount: 0)
    }
  }
}
