//
//  CFFFont.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/9/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

enum CFFFontError: Error {
  case missingLocalSubrsIndex
  case unsupportedCharsetFormat
}

class CFFFont: NSObject {
  let table: TCCffTable
  let topDict: CFFDict
  let charStringsIndex: CFFIndex
  let privateDict: CFFDict
  let localSubrIndex: CFFIndex
  let charset: CFFCharset?
  var charstrings: [CFFCharstring]

  // TODO Decouple CFFFont from TCCffTable, keeping in mind that future CFF2
  // support depends on OpenType tables

  init(table: TCCffTable, index: Int, topDict: CFFDict) throws {
    self.table = table
    self.topDict = topDict

    // Charstrings INDEX
    // We load this before Charsets because we may need to know the number
    // of glyphs
    let charStringsOffset = topDict.value(key: 17) as! Int
//    let charstringData = data.subdata(in: charStringsOffset..<data.count)
//    let charstringDataInput = TCDataInput(data: charstringData)
    var dataInput = table.dataInput(at: charStringsOffset)
    self.charStringsIndex = CFFIndex(dataInput: dataInput)
//    charStringsIndexArray.append(charStringsIndex)
    let glyphCount = charStringsIndex.count

    // Private DICT
    let privateSizeAndOffset = topDict.value(key: 18) as! [Int]
    dataInput = table.dataInput(at: privateSizeAndOffset[1])
    privateDict = CFFDict(dataInput: dataInput, length: privateSizeAndOffset[0])

    // Local Subrs INDEX
    if let localSubrsOffset = privateDict.value(key: 19) as? Int {
      dataInput = table.dataInput(at: privateSizeAndOffset[1] + localSubrsOffset)
      localSubrIndex = CFFIndex(dataInput: dataInput)
    } else {
      throw CFFFontError.missingLocalSubrsIndex
    }

    // Charsets
    let charsetOffset = topDict.value(key: 15) as! Int
//    let charsetData = data.subdata(in: charsetOffset..<data.count)
//    let charsetDataInput = TCDataInput(data: charsetData)
    let charsetDataInput = table.dataInput(at: charsetOffset)
    let format = charsetDataInput.readUInt8()
    var charset: CFFCharset
    switch format {
    case 0:
      charset = CFFCharsetFormat0(dataInput:charsetDataInput, glyphCount: glyphCount)
    case 1:
      charset = CFFCharsetFormat1(dataInput:charsetDataInput, glyphCount: glyphCount)
    case 2:
      charset = CFFCharsetFormat2(dataInput:charsetDataInput, glyphCount: glyphCount)
    default:
      throw CFFFontError.unsupportedCharsetFormat
    }
    self.charset = charset

    // Create the charstrings
    charstrings = [CFFCharstringType2]()

    super.init()

    for i in 0..<glyphCount {
      let name = table.stringIndex.string(at: charset.sid(gid: i))
      let offset = charStringsIndex.offset[i] - 1
      let len = charStringsIndex.offset[i + 1] - offset - 1
      charstrings.append(
        CFFCharstringType2(index: index,
                           name: name,
                           data: charStringsIndex.data,
                           offset: offset,
                           length: len))
    }
  }
}
