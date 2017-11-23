//
//  Font.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log
import IOUtils

enum FontError: Error {
  case missingTable
}

/**
 An OpenType font.
 */
class Font: Codable, CustomStringConvertible {

  var headTable: TCHeadTable
  var hheaTable: TCHheaTable
  var maxpTable: TCMaxpTable
  var vheaTable: TCVheaTable?
  var cmapTable: TCCmapTable
  var hmtxTable: TCHmtxTable
  var nameTable: TCNameTable
  var os2Table: TCOs2Table
  var postTable: TCPostTable

  /**
   Create an empty font.
   */
  init() {
    headTable = TCHeadTable()
    hheaTable = TCHheaTable()
    maxpTable = TCMaxpTable()
    cmapTable = TCCmapTable()
    hmtxTable = TCHmtxTable()
    nameTable = TCNameTable()
    os2Table = TCOs2Table()
    postTable = TCPostTable()
  }

  /**
   - parameters:
     - data: OpenType/TrueType font file data.
     - directoryOffset: The Table Directory offset within the file.  For a
       regular TTF/OTF file this will be zero, but for a TTC (Font Collection)
       the offset is retrieved from the TTC header.  For a Mac font resource,
       offset is retrieved from the resource headers.
     - tablesOrigin: The point the table offsets are calculated from.
       In a regular TTF file, this will be zero.  In a TTC is is
       also zero, but within a Mac resource, it is the beginning of the
       individual font resource data.
   */
  init(data: Data, tablesOrigin: Int) throws {

    // Load the table directory
    let dataInput = TCDataInput(data: data)
    let tableDirectory = TCTableDirectory(dataInput: dataInput)

    // Load some prerequisite tables
    // (These are tables that are referenced by other tables, so we need to load
    // them first)
    var tableData = try Font.tableData(directory: tableDirectory, tag: .head,
                                       data: data, tablesOrigin: tablesOrigin)
    headTable = TCHeadTable(data: tableData)

    // 'hhea' is required by 'hmtx'
    tableData = try Font.tableData(directory: tableDirectory, tag: .hhea,
                                   data: data, tablesOrigin: tablesOrigin)
    hheaTable = TCHheaTable(data: tableData)

    // 'maxp' is required by 'glyf', 'hmtx', 'loca', and 'vmtx'
    tableData = try Font.tableData(directory: tableDirectory, tag: .maxp,
                                   data: data, tablesOrigin: tablesOrigin)
    maxpTable = TCMaxpTable(data: tableData)

    if tableDirectory.hasEntry(tag: TCTableTag.vhea.rawValue) {
      // 'vhea' is required by 'vmtx'
      tableData = try Font.tableData(directory: tableDirectory, tag: .vhea,
                                     data: data, tablesOrigin: tablesOrigin)
      vheaTable = TCVheaTable(data: tableData)
    }
    // 'post' is required by 'glyf'
    tableData = try Font.tableData(directory: tableDirectory, tag: .post,
                                   data: data, tablesOrigin: tablesOrigin)
    postTable = TCPostTable(data: tableData)

    // Load all the other required tables
    tableData = try Font.tableData(directory: tableDirectory, tag: .cmap,
                                   data: data, tablesOrigin: tablesOrigin)
    cmapTable = try TCCmapTable(data: tableData)
    tableData = try Font.tableData(directory: tableDirectory, tag: .hmtx,
                                   data: data, tablesOrigin: tablesOrigin)
    hmtxTable = TCHmtxTable(data: tableData, hheaTable: hheaTable, maxpTable: maxpTable)
    tableData = try Font.tableData(directory: tableDirectory, tag: .name,
                                   data: data, tablesOrigin: tablesOrigin)
    nameTable = TCNameTable(data: tableData)
    tableData = try Font.tableData(directory: tableDirectory, tag: .OS_2,
                                   data: data, tablesOrigin: tablesOrigin)
    os2Table = TCOs2Table(data: tableData)
  }

  class func tableData(directory: TCTableDirectory, tag: TCTableTag, data: Data, tablesOrigin: Int) throws -> Data {
    if let entry = directory.entry(tag: tag.rawValue) {
      let offset = entry.offset - tablesOrigin
      return data.subdata(in: offset..<offset + entry.length)
    }
    throw FontError.missingTable
  }

  var description: String {
    get {
      return headTable.description
    }
  }

  enum CodingKeys: String, CodingKey {
    case cmap
    case glyf
    case head
    case hhea
    case hmtx
    case maxp
    case name
    case OS_2 = "OS/2"
    case post
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    cmapTable = try container.decode(TCCmapTable.self, forKey: .cmap)
    headTable = try container.decode(TCHeadTable.self, forKey: .head)
    hheaTable = try container.decode(TCHheaTable.self, forKey: .hhea)
    hmtxTable = try container.decode(TCHmtxTable.self, forKey: .hmtx)
    maxpTable = try container.decode(TCMaxpTable.self, forKey: .maxp)
    nameTable = try container.decode(TCNameTable.self, forKey: .name)
    os2Table = try container.decode(TCOs2Table.self, forKey: .OS_2)
    postTable = try container.decode(TCPostTable.self, forKey: .post)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(cmapTable, forKey: .cmap)
    try container.encode(headTable, forKey: .head)
    try container.encode(hheaTable, forKey: .hhea)
    try container.encode(hmtxTable, forKey: .hmtx)
    try container.encode(maxpTable, forKey: .maxp)
    try container.encode(nameTable, forKey: .name)
    try container.encode(os2Table, forKey: .OS_2)
    try container.encode(postTable, forKey: .post)
  }
}
