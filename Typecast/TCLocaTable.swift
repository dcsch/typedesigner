//
//  TCLocaTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCLocaTable: TCBaseTable {
  let offsets: [Int]
  let factor: Int

  init(dataInput: TCDataInput,
       directoryEntry: TCDirectoryEntry,
       headTable: TCHeadTable,
       maxpTable: TCMaxpTable) {
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
    super.init(directoryEntry: directoryEntry)
  }

  func offset(at index: Int) -> Int {
    return offsets[index] * factor
  }

  override class var tag: UInt32 {
    get {
      return TCTableTag.loca.rawValue
    }
  }

  override var description: String {
    get {
      var str = String(format:
        "'loca' Table - Index To Location Table\n--------------------------------------\n" +
        "Size = %d bytes, %ld entries\n",
        directoryEntry.length,
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
