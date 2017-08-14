//
//  TCFont.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log

enum TCFontError: Error {
  case missingTable
}

class TCFont: NSObject {
  var tableDirectory: TCTableDirectory
  var tables: [TCTable]
  var headTable: TCHeadTable
  var hheaTable: TCHheaTable
  var maxpTable: TCMaxpTable
  var locaTable: TCLocaTable?
  var vheaTable: TCVheaTable?
  var cmapTable: TCCmapTable
  var hmtxTable: TCHmtxTable
  var nameTable: TCNameTable
  var os2Table: TCOs2Table
  var postTable: TCPostTable
  var glyfTable: TCGlyfTable?
  var ascent: Int {
    get {
      return Int(hheaTable.ascender)
    }
  }
  var descent: Int {
    get {
      return Int(hheaTable.descender)
    }
  }
  var name: String {
    get {
      return nameTable.record(nameId: TCID.nameFullFontName)!.record!
    }
  }

  init(data: Data, tablesOrigin: UInt) throws {

    // Load the table directory
    let dataInput = TCDataInput(data: data)
    tableDirectory = TCTableDirectory(dataInput: dataInput)
    tables = []

    // Load some prerequisite tables
    // (These are tables that are referenced by other tables, so we need to load
    // them first)
    headTable = try TCFont.readTable(directory: tableDirectory, tables: tables,
                                     type: .head, data: data,
                                     tablesOrigin: tablesOrigin)
    tables.append(headTable)
    hheaTable = try TCFont.readTable(directory: tableDirectory, tables: tables,
                                     type: .hhea, data: data,
                                     tablesOrigin: tablesOrigin)
    tables.append(hheaTable)
    maxpTable = try TCFont.readTable(directory: tableDirectory, tables: tables,
                                     type: .maxp, data: data,
                                     tablesOrigin: tablesOrigin)
    tables.append(maxpTable)
    if tableDirectory.hasEntry(tag: TCTableType.loca.rawValue) {
      locaTable = try TCFont.readTable(directory: tableDirectory, tables: tables,
                                       type: .loca, data: data,
                                       tablesOrigin: tablesOrigin)
      tables.append(locaTable!)
    }
    if tableDirectory.hasEntry(tag: TCTableType.vhea.rawValue) {
      vheaTable = try TCFont.readTable(directory: tableDirectory, tables: tables,
                                       type: .vhea, data: data,
                                       tablesOrigin: tablesOrigin)
      tables.append(vheaTable!)
    }
    postTable = try TCFont.readTable(directory: tableDirectory, tables: tables,
                                     type: .post, data: data,
                                     tablesOrigin: tablesOrigin)
    tables.append(postTable)

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
      do {
        let table = try TCTableFactory.createTable(tables: tables,
                                                   data: tableData,
                                                   directoryEntry: entry)
        tables.append(table)
      } catch {
//        os_log("Ignorning table")
      }
    }

    // Get references to commonly used tables (these happen to be all the
    // required tables)
    cmapTable = try TCFont.table(tables: tables, type: TCTableType.cmap)
    hmtxTable = try TCFont.table(tables: tables, type: TCTableType.hmtx)
    nameTable = try TCFont.table(tables: tables, type: TCTableType.name)
    os2Table = try TCFont.table(tables: tables, type: TCTableType.OS_2)

    // If this is a TrueType outline, then we'll have at least the
    // 'glyf' table (along with the 'loca' table)
    glyfTable = try TCFont.table(tables: tables, type: TCTableType.glyf)

    super.init()
  }

  class func table<T>(tables: [TCTable], type: TCTableType) throws -> T {
    for table in tables {
      if table.type == type.rawValue {
        if let actualTable = table as? T {
          return actualTable
        }
      }
    }
    throw TCFontError.missingTable
  }

  class func readTable<T>(directory: TCTableDirectory, tables: [TCTable],
                          type: TCTableType, data: Data, tablesOrigin: UInt) throws -> T {
    if let entry = directory.entry(tag: type.rawValue) {
      let offset = UInt(entry.offset) - tablesOrigin
      let tableData = data.subdata(in:
        Int(offset)..<Int(offset + UInt(entry.length)))
      let table = try TCTableFactory.createTable(tables: tables,
                                                 data: tableData,
                                                 directoryEntry: entry)
      if let actualTable = table as? T {
        return actualTable
      }
    }
    throw TCFontError.missingTable
  }
}
