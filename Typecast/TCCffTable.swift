//
//  TCCffTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/7/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log

/**
 * Compact Font Format Table
 */
class TCCffTable: TCBaseTable {
  let major: Int
  let minor: Int
  let hdrSize: Int
  let offSize: Int
  let nameIndex: CFFNameIndex
  let topDictIndex: CFFTopDictIndex
  let stringIndex: CFFStringIndex
  let globalSubrIndex: CFFIndex
  var fonts: [CFFFont]
  let data: Data

  init(data: Data, directoryEntry: TCDirectoryEntry) {
    self.data = data
    let di = TCDataInput(data: data)

    // Header
    major = Int(di.readUInt8())
    minor = Int(di.readUInt8())
    hdrSize = Int(di.readUInt8())
    offSize = Int(di.readUInt8())

    if hdrSize > 4 {
      _ = di.read(length: hdrSize - 4)
    }

    // Name INDEX
    nameIndex = CFFNameIndex(dataInput: di)

    // Top DICT INDEX
    topDictIndex = CFFTopDictIndex(dataInput: di)

    // String INDEX
    stringIndex = CFFStringIndex(dataInput: di)

    // Global Subr INDEX
    globalSubrIndex = CFFIndex(dataInput: di)

    // Encodings go here -- but since this is an OpenType font will this
    // not always be a CIDFont?  In which case there are no encodings
    // within the CFF data.

    // Load each of the fonts
    fonts = [CFFFont]()
    super.init(directoryEntry: directoryEntry)
    for i in 0..<topDictIndex.count {
      do {
        try fonts.append(CFFFont(table: self, index: i, topDict: topDictIndex.topDict(at: i)))
      } catch {
        os_log("Error loading font: %d, i")
      }
    }
  }

  func dataInput(at offset: Int) -> TCDataInput {
    let fontData = data.subdata(in: offset..<Int(directoryEntry.length))
    return TCDataInput(data: fontData)
  }

  override var type: UInt32 {
    get {
      return TCTableType.CFF.rawValue
    }
  }
}
