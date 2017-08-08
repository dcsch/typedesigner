//
//  TCCffTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/7/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCCffTable: TCBaseTable {
  let major: Int
  let minor: Int
  let hdrSize: Int
  let offSize: Int
  let nameIndex: CFFNameIndex
  let topDictIndex: CFFTopDictIndex
  let stringIndex: CFFStringIndex
  let globalSubrIndex: CFFIndex

  init(data: Data, directoryEntry: TCDirectoryEntry) {
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
    var charStringsIndexArray = [CFFIndex]()
    var charsets = [CFFCharset]()
    var charstringsArray = [[CFFCharstring]]()
    for i in 0..<topDictIndex.count {

      // Charstrings INDEX
      // We load this before Charsets because we may need to know the number
      // of glyphs
      let topDict = topDictIndex.topDict(at: i)
      let charStringsOffset = topDict.value(forKey: 17) as! Int
      let charstringData = data.subdata(in: charStringsOffset..<data.count)
      let charstringDataInput = TCDataInput(data: charstringData)
      let charStringsIndex = CFFIndex(dataInput: charstringDataInput)
      charStringsIndexArray.append(charStringsIndex)
      let glyphCount = charStringsIndex.count

      // Charsets
      let charsetOffset = topDict.value(forKey: 15) as! Int
      let charsetData = data.subdata(in: charsetOffset..<data.count)
      let charsetDataInput = TCDataInput(data: charsetData)
      let format = charsetDataInput.readUInt8()
      var charset: CFFCharset?
      switch format {
      case 0:
        charset = CFFCharsetFormat0(dataInput:charsetDataInput, glyphCount: Int32(glyphCount))
      case 1:
        charset = CFFCharsetFormat1(dataInput:charsetDataInput, glyphCount: Int32(glyphCount))
      case 2:
        charset = CFFCharsetFormat2(dataInput:charsetDataInput, glyphCount: Int32(glyphCount))
      default:
        charset = nil
      }
      charsets.append(charset!)

      // Create the charstrings
      var charstrings = [CFFCharstringType2]()
      charstringsArray.append(charstrings)
      for j in 0..<glyphCount {
        let offset = charStringsIndex.offset[j] - 1
        let len = charStringsIndex.offset[j + 1] - offset - 1
        charstrings.append(
          CFFCharstringType2(index: Int32(i),
                             name:stringIndex.string(at: Int(charset!.sid(forGID: Int32(j)))),
                             data: charStringsIndex.data,
                             offset: Int32(offset),
                             length: Int32(len),
                             localSubrIndex: nil,
                             globalSubrIndex: nil))
      }
    }
    super.init(directoryEntry: directoryEntry)
  }

  override var type: UInt32 {
    get {
      return TCTableType.CFF.rawValue
    }
  }
}
