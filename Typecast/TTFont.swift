//
//  TTFont.swift
//  Type Designer
//
//  Created by David Schweinsberg on 11/16/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

/**
 An OpenType font with TrueType outlines.
 */
class TTFont: Font {
  var locaTable: TCLocaTable
  var glyfTable: TCGlyfTable

  override init(data: Data, tablesOrigin: Int) throws {

    // Load the table directory
    let dataInput = TCDataInput(data: data)
    let tableDirectory = TCTableDirectory(dataInput: dataInput)

    // We need to look ahead at the head and maxp tables
    var tableData = try Font.tableData(directory: tableDirectory, tag: .head,
                                       data: data, tablesOrigin: tablesOrigin)
    let headTable = TCHeadTable(data: tableData)
    tableData = try Font.tableData(directory: tableDirectory, tag: .maxp,
                                   data: data, tablesOrigin: tablesOrigin)
    let maxpTable = TCMaxpTable(data: tableData)

    // 'loca' is required by 'glyf'
    tableData = try Font.tableData(directory: tableDirectory, tag: .loca,
                                   data: data, tablesOrigin: tablesOrigin)
    locaTable = TCLocaTable(data: tableData, headTable: headTable, maxpTable: maxpTable)

    // If this is a TrueType outline, then we'll have at least the
    // 'glyf' table (along with the 'loca' table)
    tableData = try Font.tableData(directory: tableDirectory, tag: .glyf,
                                   data: data, tablesOrigin: tablesOrigin)
    glyfTable = TCGlyfTable(data: tableData, maxpTable: maxpTable, locaTable: locaTable)

    try super.init(data: data, tablesOrigin: tablesOrigin)
  }

  private enum CodingKeys: String, CodingKey {
    case loca
    case glyf
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    locaTable = try container.decode(TCLocaTable.self, forKey: .loca)
    glyfTable = try container.decode(TCGlyfTable.self, forKey: .glyf)
    try super.init(from: container.superDecoder())
  }

  override func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(locaTable, forKey: .loca)
    try container.encode(glyfTable, forKey: .glyf)
    try super.encode(to: container.superEncoder())
  }
}
