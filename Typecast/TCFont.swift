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

/**
 An OpenType font.
 */
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
  var cffTable: TCCffTable?
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

      let offset = entry.offset - tablesOrigin
      let tableData = data.subdata(in: offset..<offset + entry.length)
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
    if tableDirectory.hasEntry(tag: TCTableTag.glyf.rawValue) {
      glyfTable = try TCFont.table(tables: tables, tag: TCTableTag.glyf)
    }

    // If this is a CFF outline, then we'll have a 'CFF' table
    if tableDirectory.hasEntry(tag: TCTableTag.CFF.rawValue) {
      cffTable = try TCFont.table(tables: tables, tag: TCTableTag.CFF)
    }

    super.init()
  }

  /**
   Retrieve a glyph from this font. This works for both TrueType and CFF
   outlines.
   - returns: a glyph
   - parameter at: the glyph index
   */
  func glyph(at index: Int) -> TCGlyph? {
    if let glyfTable = self.glyfTable,
      let description = glyfTable.description(at: index) as? TCGlyphDescription {
      return TCTTGlyph(glyphDescription: description,
                       leftSideBearing: hmtxTable.leftSideBearing(at: index),
                       advanceWidth: hmtxTable.advanceWidth(at: index))
    } else if let cffTable = self.cffTable {

      let font = cffTable.fonts[0]
      let charstring = font.charstrings[index]
      let localSubrIndex = font.localSubrIndex
      let globalSubrIndex = cffTable.globalSubrIndex
      let glyph = TCT2Glyph(charstring: charstring,
                            localSubrIndex: localSubrIndex,
                            globalSubrIndex: globalSubrIndex,
                            leftSideBearing: 0, advanceWidth: 0)
      return glyph
    } else {
      return nil
    }
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
                          tag: TCTableTag, data: Data, tablesOrigin: Int) throws -> T {
    if let entry = directory.entry(tag: tag.rawValue) {
      let offset = entry.offset - tablesOrigin
      let tableData = data.subdata(in: offset..<offset + entry.length)
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
