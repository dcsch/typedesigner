//
//  TCFont.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log

class TCFont: NSObject {
  var tableDirectory: TCTableDirectory
  var tables: [TCTable]
  var headTable: TCHeadTable?
  var hheaTable: TCHheaTable?
  var maxpTable: TCMaxpTable?
  var locaTable: TCLocaTable?
  var vheaTable: TCVheaTable?
  var cmapTable: TCCmapTable?
  var hmtxTable: TCHmtxTable?
  var nameTable: TCNameTable?
  var os2Table: TCOs2Table?
  var postTable: TCPostTable?
  var glyfTable: TCGlyfTable?
  var ascent: Int {
    get {
      return Int(hheaTable!.ascender)
    }
  }
  var descent: Int {
    get {
      return Int(hheaTable!.descender)
    }
  }
  var name: String {
    get {
      return nameTable!.record(nameId: TCNameFullFontName)!.record!
    }
  }

  init?(data: Data, tablesOrigin: UInt) {

    // Load the table directory
    let dataInput = TCDataInput(data: data)
    tableDirectory = TCTableDirectory(dataInput: dataInput)
    tables = []

    super.init()

    // Load some prerequisite tables
    // (These are tables that are referenced by other tables, so we need to load
    // them first)
    headTable = readTable(type: .head, data: data, tablesOrigin: tablesOrigin) as? TCHeadTable
    hheaTable = readTable(type: .hhea, data: data, tablesOrigin: tablesOrigin) as? TCHheaTable
    maxpTable = readTable(type: .maxp, data: data, tablesOrigin: tablesOrigin) as? TCMaxpTable
    locaTable = readTable(type: .loca, data: data, tablesOrigin: tablesOrigin) as? TCLocaTable
    vheaTable = readTable(type: .vhea, data: data, tablesOrigin: tablesOrigin) as? TCVheaTable
    postTable = readTable(type: .post, data: data, tablesOrigin: tablesOrigin) as? TCPostTable

    if headTable == nil || hheaTable == nil || maxpTable == nil ||
      postTable == nil {
      return nil
    }

    tables.append(headTable!)
    tables.append(hheaTable!)
    tables.append(maxpTable!)
    if locaTable != nil {
      tables.append(locaTable!)
    }
    if vheaTable != nil {
      tables.append(vheaTable!)
    }
    tables.append(postTable!)

    // Load all other tables
    for entry in tableDirectory.entries {
      if entry.tag == TCTableType.head.rawValue ||
        entry.tag == TCTableType.hhea.rawValue ||
        entry.tag == TCTableType.maxp.rawValue ||
        entry.tag == TCTableType.loca.rawValue ||
        entry.tag == TCTableType.vhea.rawValue ||
        entry.tag == TCTableType.post.rawValue {
        continue;
      }

      let offset = UInt(entry.offset) - tablesOrigin
      let tableData = data.subdata(in:
        Int(offset)..<Int(offset + UInt(entry.length)))
      if let table = TCTableFactory.createTable(font: self,
                                                data: tableData,
                                                directoryEntry: entry) {
        tables.append(table)
      }
    }

    // Get references to commonly used tables (these happen to be all the
    // required tables)
    cmapTable = table(type: TCTableType.cmap) as? TCCmapTable
    hmtxTable = table(type: TCTableType.hmtx) as? TCHmtxTable
    nameTable = table(type: TCTableType.name) as? TCNameTable
    os2Table = table(type: TCTableType.OS_2) as? TCOs2Table

    // If this is a TrueType outline, then we'll have at least the
    // 'glyf' table (along with the 'loca' table)
    glyfTable = table(type: TCTableType.glyf) as? TCGlyfTable
  }

  func table(type: TCTableType) -> TCTable? {
    for table in tables {
      if table.type == type.rawValue {
        return table
      }
    }
    return nil
  }

  func readTable(type: TCTableType, data: Data, tablesOrigin: UInt) -> TCTable? {
    if let entry = tableDirectory.entry(tag: type.rawValue) {
      let offset = UInt(entry.offset) - tablesOrigin
      let tableData = data.subdata(in:
        Int(offset)..<Int(offset + UInt(entry.length)))
      return TCTableFactory.createTable(font: self,
                                        data: tableData,
                                        directoryEntry: entry)
    }
    return nil
  }


}
