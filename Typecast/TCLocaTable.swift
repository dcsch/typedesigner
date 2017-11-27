//
//  TCLocaTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCLocaTable: TCTable, Codable {
  let offsets: [Int]
  let factor: Int
  let dataCount: Int

  init(data: Data, headTable: TCHeadTable, maxpTable: TCMaxpTable) {
    dataCount = data.count
    let dataInput = TCDataInput(data: data)
    var offsets = [Int]()
    let shortEntries = headTable.indexToLocFormat == 0
    if shortEntries {
      factor = 2
      for _ in 0...maxpTable.numGlyphs {
        offsets.append(Int(dataInput.readUInt16()))
      }
    } else {
      factor = 1
      for _ in 0...maxpTable.numGlyphs {
        offsets.append(Int(dataInput.readUInt32()))
      }
    }
    self.offsets = offsets;
    super.init()
  }

  func offset(at index: Int) -> Int {
    return offsets[index] * factor
  }

  override class var tag: TCTable.Tag {
    get {
      return .loca
    }
  }

  override var description: String {
    get {
      var str = String(format:
        "'loca' Table - Index To Location Table\n--------------------------------------\n" +
        "Size = %d bytes, %ld entries\n",
        dataCount,
        offsets.count)
      var i = 0
      for _ in offsets {
        str.append(String(format: "        Idx %ld  -> glyfOff 0x%x\n", i, offset(at: i)))
        i += 1
      }
      return str;
    }
  }
}
