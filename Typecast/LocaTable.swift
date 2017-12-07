//
//  TCLocaTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCLocaTable: TCTable {
  let offsets: [Int]

  init(data: Data, shortEntries: Bool, numGlyphs: Int) {
    let dataInput = TCDataInput(data: data)
    var offsets = [Int]()
    if shortEntries {
      for _ in 0...numGlyphs {
        offsets.append(2 * Int(dataInput.readUInt16()))
      }
    } else {
      for _ in 0...numGlyphs {
        offsets.append(Int(dataInput.readUInt32()))
      }
    }
    self.offsets = offsets;
    super.init()
  }

  override class var tag: TCTable.Tag {
    get {
      return .loca
    }
  }

  override var description: String {
    get {
      var str = """
      'loca' Table - Index To Location Table
      --------------------------------------
      \(offsets.count) entries
      offsets.count)

      """
      for (i, offset) in offsets.enumerated() {
        str += "        Idx \(i)  -> glyfOff 0x\(String(offset, radix: 16, uppercase: true))"
      }
      return str
    }
  }
}
