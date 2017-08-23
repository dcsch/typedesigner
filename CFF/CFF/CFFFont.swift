//
//  CFFFont.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/9/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

enum CFFFontError: Error {
  case missingLocalSubrsIndex
  case unsupportedCharsetFormat
}

public class CFFFont: NSObject {
  let data: Data
  let topDict: CFFDict
  let charStringsIndex: CFFIndex
  let privateDict: CFFDict
  public let localSubrIndex: CFFIndex
  let charset: CFFCharset
  public var charstrings: [CFFCharstring]

  public init(data: Data, index: Int, topDict: CFFDict, stringIndex: CFFStringIndex) throws {
    self.data = data
    self.topDict = topDict

    // Charstrings INDEX
    // We load this before Charsets because we may need to know the number
    // of glyphs
    let charStringsOffset = topDict.value(key: 17) as! Int
    let charstringData = data.subdata(in: charStringsOffset..<data.count)
    let charstringDataInput = TCDataInput(data: charstringData)
    self.charStringsIndex = CFFIndex(dataInput: charstringDataInput)
    let glyphCount = charStringsIndex.count

    // Private DICT
    let privateSizeAndOffset = topDict.value(key: 18) as! [Int]
    let privateDictData = data.subdata(in: privateSizeAndOffset[1]..<data.count)
    let privateDictDataInput = TCDataInput(data: privateDictData)
    privateDict = CFFDict(dataInput: privateDictDataInput,
                          length: privateSizeAndOffset[0])

    // Local Subrs INDEX
    if let localSubrsOffset = privateDict.value(key: 19) as? Int {
      let localSubrIndexData = data.subdata(in: privateSizeAndOffset[1] + localSubrsOffset..<data.count)
      let localSubrIndexDataInput = TCDataInput(data: localSubrIndexData)
      localSubrIndex = CFFIndex(dataInput: localSubrIndexDataInput)
    } else {
      throw CFFFontError.missingLocalSubrsIndex
    }

    // Charsets
    let charsetOffset = topDict.value(key: 15) as! Int
    let charsetData = data.subdata(in: charsetOffset..<data.count)
    let charsetDataInput = TCDataInput(data: charsetData)
    let format = charsetDataInput.readUInt8()
    var charset: CFFCharset
    switch format {
    case 0:
      charset = CFFCharsetFormat0(dataInput: charsetDataInput, glyphCount: glyphCount)
    case 1:
      charset = CFFCharsetFormat1(dataInput: charsetDataInput, glyphCount: glyphCount)
    case 2:
      charset = CFFCharsetFormat2(dataInput: charsetDataInput, glyphCount: glyphCount)
    default:
      throw CFFFontError.unsupportedCharsetFormat
    }
    self.charset = charset

    // Create the charstrings
    charstrings = [CFFCharstringType2]()

    super.init()

    for i in 0..<glyphCount {
      let sid = charset.sid(gid: i)
      let name = stringIndex.string(at: sid)
      let start = charStringsIndex.offset[i] - 1
      let end = charStringsIndex.offset[i + 1] - 1
      charstrings.append(
        CFFCharstringType2(index: index,
                           name: name,
                           data: charStringsIndex.data[start..<end]))
    }
  }
}
