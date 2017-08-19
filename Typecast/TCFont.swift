//
//  TCFont.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log
import IOUtils

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
//  var glyfTable: TCGlyfTable?
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
                                     tag: .head, data: data,
                                     tablesOrigin: tablesOrigin)
    tables.append(headTable)
    // 'hhea' is required by 'hmtx'
    hheaTable = try TCFont.readTable(directory: tableDirectory, tables: tables,
                                     tag: .hhea, data: data,
                                     tablesOrigin: tablesOrigin)
    tables.append(hheaTable)
    // 'maxp' is required by 'glyf', 'hmtx', 'loca', and 'vmtx'
    maxpTable = try TCFont.readTable(directory: tableDirectory, tables: tables,
                                     tag: .maxp, data: data,
                                     tablesOrigin: tablesOrigin)
    tables.append(maxpTable)
    if tableDirectory.hasEntry(tag: TCTableTag.loca.rawValue) {
      // 'loca' is required by 'glyf'
      locaTable = try TCFont.readTable(directory: tableDirectory, tables: tables,
                                       tag: .loca, data: data,
                                       tablesOrigin: tablesOrigin)
      tables.append(locaTable!)
    }
    if tableDirectory.hasEntry(tag: TCTableTag.vhea.rawValue) {
      // 'vhea' is required by 'vmtx'
      vheaTable = try TCFont.readTable(directory: tableDirectory, tables: tables,
                                       tag: .vhea, data: data,
                                       tablesOrigin: tablesOrigin)
      tables.append(vheaTable!)
    }
    // 'post' is required by 'glyf'
    postTable = try TCFont.readTable(directory: tableDirectory, tables: tables,
                                     tag: .post, data: data,
                                     tablesOrigin: tablesOrigin)
    tables.append(postTable)

    // Load all other tables
    for entry in tableDirectory.entries {
      if entry.tag == TCTableTag.head.rawValue ||
        entry.tag == TCTableTag.hhea.rawValue ||
        entry.tag == TCTableTag.maxp.rawValue ||
        entry.tag == TCTableTag.loca.rawValue ||
        entry.tag == TCTableTag.vhea.rawValue ||
        entry.tag == TCTableTag.post.rawValue {
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
      } catch TCTableError.unimplementedTableType(let tag) {
        os_log("Unimplemented table: %@", TCTableError.tagAsString(tag))
      } catch TCTableError.unrecognizedTableType(let tag) {
        os_log("Unrecognized table: %@", TCTableError.tagAsString(tag))
      } catch {
//        os_log("Ignorning table")
      }
    }

    // Get references to commonly used tables (these happen to be all the
    // required tables)
    cmapTable = try TCFont.table(tables: tables, tag: TCTableTag.cmap)
    hmtxTable = try TCFont.table(tables: tables, tag: TCTableTag.hmtx)
    nameTable = try TCFont.table(tables: tables, tag: TCTableTag.name)
    os2Table = try TCFont.table(tables: tables, tag: TCTableTag.OS_2)

    // If this is a TrueType outline, then we'll have at least the
    // 'glyf' table (along with the 'loca' table)
//    if tableDirectory.hasEntry(tag: TCTableTag.glyf.rawValue) {
//      glyfTable = try TCFont.table(tables: tables, tag: TCTableTag.glyf)
//    }

    super.init()
  }

  class func table<T>(tables: [TCTable], tag: TCTableTag) throws -> T {
    for table in tables {
      if type(of: table).tag == tag.rawValue {
        if let actualTable = table as? T {
          return actualTable
        }
      }
    }
    throw TCFontError.missingTable
  }

  func table<T>() throws -> T {
    for table in tables {
      if let actualTable = table as? T {
        return actualTable
      }
    }
    throw TCFontError.missingTable
  }

  class func readTable<T>(directory: TCTableDirectory, tables: [TCTable],
                          tag: TCTableTag, data: Data, tablesOrigin: UInt) throws -> T {
    if let entry = directory.entry(tag: tag.rawValue) {
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
