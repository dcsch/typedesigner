//
//  TCTableFactory.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/31/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCTableFactory {

  class func createTable(tables: [TCTable], data: Data,
                         directoryEntry entry: TCDirectoryEntry) throws -> TCTable {
    var table: TCTable

    if let tableTag = TCTableTag(rawValue: entry.tag) {

      // Create the table
      switch tableTag {
//        case BASE:
//            table = new BaseTable(de, dis);
//            break;
      case .CFF:
        table = TCCffTable(data: data, directoryEntry: entry)
//        case Table.DSIG:
//            t = new DsigTable(de, dis);
//            break;
      case .EBDT:
        throw TCTableError.unimplementedTableType(tag: entry.tag)
      case .EBLC:
        throw TCTableError.unimplementedTableType(tag: entry.tag)
      case .EBSC:
        throw TCTableError.unimplementedTableType(tag: entry.tag)
      case .GDEF:
        throw TCTableError.unimplementedTableType(tag: entry.tag)
//        case Table.GPOS:
//            t = new GposTable(de, dis);
//            break;
//        case Table.GSUB:
//            t = new GsubTable(de, dis);
//            break;
      case .JSTF:
        throw TCTableError.unimplementedTableType(tag: entry.tag)
//        case Table.LTSH:
//            t = new LtshTable(de, dis);
//            break;
      case .MMFX:
        throw TCTableError.unimplementedTableType(tag: entry.tag)
      case .MMSD:
        throw TCTableError.unimplementedTableType(tag: entry.tag)
      case .OS_2:
        let dataInput = TCDataInput(data: data)
        table = TCOs2Table(dataInput: dataInput, directoryEntry:entry)
//        case Table.PCLT:
//            t = new PcltTable(de, dis);
//            break;
      case .VDMX:
        let dataInput = TCDataInput(data: data)
        table = TCVdmxTable(dataInput: dataInput, directoryEntry:entry)
      case .cmap:
        let dataInput = TCDataInput(data: data)
        table = try TCCmapTable(dataInput: dataInput, directoryEntry:entry)
      case .cvt:
        let dataInput = TCDataInput(data: data)
        table = TCCvtTable(dataInput: dataInput, directoryEntry:entry)
      case .fpgm:
        let dataInput = TCDataInput(data: data)
        table = TCFpgmTable(dataInput: dataInput, directoryEntry:entry)
      case .fvar:
        throw TCTableError.unimplementedTableType(tag: entry.tag)
//        case Table.gasp:
//            t = new GaspTable(de, dis);
//            break;
      case .glyf:
        let maxpTable: TCMaxpTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.maxp)
        let locaTable: TCLocaTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.loca)
        let postTable: TCPostTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.post)
        table = TCGlyfTable(data: data,
                            directoryEntry: entry,
                            maxpTable: maxpTable,
                            locaTable: locaTable,
                            postTable: postTable)
      case .hdmx:
        let dataInput = TCDataInput(data: data)
        let maxpTable: TCMaxpTable = try TCTableFactory.table(tables: tables,
                                                              tag: TCTableTag.maxp)
        table = TCHdmxTable(dataInput: dataInput,
                            directoryEntry: entry,
                            maxpTable: maxpTable)
      case .head:
        let dataInput = TCDataInput(data: data)
        table = TCHeadTable(dataInput: dataInput, directoryEntry: entry)
      case .hhea:
        let dataInput = TCDataInput(data: data)
        table = TCHheaTable(dataInput: dataInput, directoryEntry: entry)
      case .hmtx:
        let dataInput = TCDataInput(data: data)
        let hheaTable: TCHheaTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.hhea)
        let maxpTable: TCMaxpTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.maxp)
        table = TCHmtxTable(dataInput: dataInput,
                            directoryEntry: entry,
                            hheaTable: hheaTable,
                            maxpTable: maxpTable)
//        case Table.kern:
//            t = new KernTable(de, dis);
//            break;
      case .loca:
        let dataInput = TCDataInput(data: data)
        let headTable: TCHeadTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.head)
        let maxpTable: TCMaxpTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.maxp)
        table = TCLocaTable(dataInput: dataInput,
                            directoryEntry: entry,
                            headTable: headTable,
                            maxpTable: maxpTable)
      case .maxp:
        let dataInput = TCDataInput(data: data)
        table = TCMaxpTable(dataInput: dataInput, directoryEntry: entry)
      case .name:
        table = TCNameTable(data: data, directoryEntry: entry)
      case .prep:
        let dataInput = TCDataInput(data: data)
        table = TCPrepTable(dataInput: dataInput, directoryEntry: entry)
      case .post:
        let dataInput = TCDataInput(data: data)
        table = TCPostTable(dataInput: dataInput, directoryEntry: entry)
      case .vhea:
        let dataInput = TCDataInput(data: data)
        table = TCVheaTable(dataInput: dataInput, directoryEntry: entry)
      case .vmtx:
        let dataInput = TCDataInput(data: data)
        let vheaTable: TCVheaTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.vhea)
        let maxpTable: TCMaxpTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.maxp)
        table = TCVmtxTable(dataInput: dataInput, directoryEntry: entry,
                            vheaTable: vheaTable, maxpTable: maxpTable)
      default:
        throw TCTableError.unrecognizedTableType(tag: entry.tag)
      }
    } else {
      throw TCTableError.unrecognizedTableType(tag: entry.tag)
    }
    return table
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
}
