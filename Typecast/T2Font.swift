//
//  T2Font.swift
//  Type Designer
//
//  Created by David Schweinsberg on 11/16/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

/**
 An OpenType font with Type 2 (CFF) outlines.
 */
class T2Font: Font {
  var cffTable: TCCffTable

  override init(data: Data, tablesOrigin: Int) throws {

    // Load the table directory
    let dataInput = TCDataInput(data: data)
    let tableDirectory = TCTableDirectory(dataInput: dataInput)

    let tableData = try Font.tableData(directory: tableDirectory, tag: .CFF,
                                       data: data, tablesOrigin: tablesOrigin)
    cffTable = TCCffTable(data: tableData)

    try super.init(data: data, tablesOrigin: tablesOrigin)
  }

  /**
   Retrieve a glyph from this font.
   - returns: a glyph
   - parameter at: the glyph index
   */
  func glyph(at index: Int) -> Glyph? {
    let font = cffTable.fonts[0]
    let charstring = font.charstrings[index]
    let localSubrIndex = font.localSubrIndex
    let globalSubrIndex = cffTable.globalSubrIndex
    let glyph = T2Glyph(glyphIndex: index,
                        charstring: charstring,
                        localSubrIndex: localSubrIndex,
                        globalSubrIndex: globalSubrIndex,
                        leftSideBearing: 0, advanceWidth: 0)
    return glyph
  }
  enum T2CodingKeys: String, CodingKey {
    case cff
  }

  required init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: T2CodingKeys.self)
//    cffTable = try container.decode(TCCffTable.self, forKey: .cff)
    cffTable = TCCffTable(data: Data())
    try super.init(from: decoder)
  }

  override func encode(to encoder: Encoder) throws {
//    var container = encoder.container(keyedBy: T2CodingKeys.self)
//    try container.encode(cffTable, forKey: .cff)
    try super.encode(to: encoder)
  }
}
