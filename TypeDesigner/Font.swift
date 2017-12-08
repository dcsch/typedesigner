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

  var headTable: HeadTable
  var hheaTable: HheaTable
  var maxpTable: MaxpTable
  var vheaTable: VheaTable?
  var cmapTable: CmapTable
  var hmtxTable: HmtxTable
  var nameTable: NameTable
  var os2Table: Os2Table
  var postTable: PostTable

  /**
   Create an empty font.
   */
  init() {
    headTable = HeadTable()
    hheaTable = HheaTable()
    maxpTable = MaxpTable()
    cmapTable = CmapTable()
    hmtxTable = HmtxTable()
    nameTable = NameTable()
    os2Table = Os2Table()
    postTable = PostTable()
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
    let tableDirectory = TableDirectory(dataInput: dataInput)
    os_log("%@", String(describing: tableDirectory))

    // Load some prerequisite tables
    // (These are tables that are referenced by other tables, so we need to load
    // them first)
    var tableData = try Font.tableData(directory: tableDirectory, tag: .head,
                                       data: data, tablesOrigin: tablesOrigin)
    headTable = HeadTable(data: tableData)

    // 'hhea' is required by 'hmtx'
    tableData = try Font.tableData(directory: tableDirectory, tag: .hhea,
                                   data: data, tablesOrigin: tablesOrigin)
    hheaTable = HheaTable(data: tableData)

    // 'maxp' is required by 'glyf', 'hmtx', 'loca', and 'vmtx'
    tableData = try Font.tableData(directory: tableDirectory, tag: .maxp,
                                   data: data, tablesOrigin: tablesOrigin)
    maxpTable = MaxpTable(data: tableData)

    if tableDirectory.hasEntry(tag: .vhea) {
      // 'vhea' is required by 'vmtx'
      tableData = try Font.tableData(directory: tableDirectory, tag: .vhea,
                                     data: data, tablesOrigin: tablesOrigin)
      vheaTable = VheaTable(data: tableData)
    }
    // 'post' is required by 'glyf'
    tableData = try Font.tableData(directory: tableDirectory, tag: .post,
                                   data: data, tablesOrigin: tablesOrigin)
    postTable = PostTable(data: tableData)

    // Load all the other required tables
    tableData = try Font.tableData(directory: tableDirectory, tag: .cmap,
                                   data: data, tablesOrigin: tablesOrigin)
    cmapTable = try CmapTable(data: tableData)
    tableData = try Font.tableData(directory: tableDirectory, tag: .hmtx,
                                   data: data, tablesOrigin: tablesOrigin)
    hmtxTable = HmtxTable(data: tableData, hheaTable: hheaTable, maxpTable: maxpTable)
    tableData = try Font.tableData(directory: tableDirectory, tag: .name,
                                   data: data, tablesOrigin: tablesOrigin)
    nameTable = NameTable(data: tableData)
    tableData = try Font.tableData(directory: tableDirectory, tag: .OS_2,
                                   data: data, tablesOrigin: tablesOrigin)
    os2Table = Os2Table(data: tableData)
    os_log("%@", String(describing: hmtxTable))
  }

  class func tableData(directory: TableDirectory, tag: Table.Tag, data: Data, tablesOrigin: Int) throws -> Data {
    if let entry = directory.entry(tag: tag) {
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

  private enum CodingKeys: String, CodingKey {
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
    cmapTable = try container.decode(CmapTable.self, forKey: .cmap)
    headTable = try container.decode(HeadTable.self, forKey: .head)
    hheaTable = try container.decode(HheaTable.self, forKey: .hhea)
    hmtxTable = try container.decode(HmtxTable.self, forKey: .hmtx)
    maxpTable = try container.decode(MaxpTable.self, forKey: .maxp)
    nameTable = try container.decode(NameTable.self, forKey: .name)
    os2Table = try container.decode(Os2Table.self, forKey: .OS_2)
    postTable = try container.decode(PostTable.self, forKey: .post)
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

  func buildFont(url: URL) throws {
  }
}
