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
                         directoryEntry: TCDirectoryEntry) throws -> TCTable {
    var table: TCTable

    if let tableTag = TCTableTag(rawValue: directoryEntry.tag) {

      // Create the table
      switch tableTag {
//        case BASE:
//            table = new BaseTable(de, dis);
//            break;
      case .CFF:
        table = TCCffTable(data: data)
      case .DSIG:
        table = TCDsigTable(data: data)
      case .EBDT:
        throw TCTableError.unimplementedTableType(tag: directoryEntry.tag)
      case .EBLC:
        throw TCTableError.unimplementedTableType(tag: directoryEntry.tag)
      case .EBSC:
        throw TCTableError.unimplementedTableType(tag: directoryEntry.tag)
      case .GDEF:
        throw TCTableError.unimplementedTableType(tag: directoryEntry.tag)
//        case Table.GPOS:
//            t = new GposTable(de, dis);
//            break;
//        case Table.GSUB:
//            t = new GsubTable(de, dis);
//            break;
      case .JSTF:
        throw TCTableError.unimplementedTableType(tag: directoryEntry.tag)
//        case Table.LTSH:
//            t = new LtshTable(de, dis);
//            break;
      case .MMFX:
        throw TCTableError.unimplementedTableType(tag: directoryEntry.tag)
      case .MMSD:
        throw TCTableError.unimplementedTableType(tag: directoryEntry.tag)
      case .OS_2:
        table = TCOs2Table(data: data)
//        case Table.PCLT:
//            t = new PcltTable(de, dis);
//            break;
      case .VDMX:
        table = TCVdmxTable(data: data)
      case .cmap:
        table = try TCCmapTable(data: data)
      case .cvt:
        table = TCCvtTable(data: data)
      case .fpgm:
        table = TCFpgmTable(data: data)
      case .fvar:
        throw TCTableError.unimplementedTableType(tag: directoryEntry.tag)
//        case Table.gasp:
//            t = new GaspTable(de, dis);
//            break;
      case .glyf:
        let maxpTable: TCMaxpTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.maxp)
        let locaTable: TCLocaTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.loca)
        let postTable: TCPostTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.post)
        table = TCGlyfTable(data: data,
                            maxpTable: maxpTable,
                            locaTable: locaTable,
                            postTable: postTable)
      case .hdmx:
        let maxpTable: TCMaxpTable = try TCTableFactory.table(tables: tables,
                                                              tag: TCTableTag.maxp)
        table = TCHdmxTable(data: data, maxpTable: maxpTable)
      case .head:
        table = TCHeadTable(data: data)
      case .hhea:
        table = TCHheaTable(data: data)
      case .hmtx:
        let hheaTable: TCHheaTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.hhea)
        let maxpTable: TCMaxpTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.maxp)
        table = TCHmtxTable(data: data, hheaTable: hheaTable, maxpTable: maxpTable)
//        case Table.kern:
//            t = new KernTable(de, dis);
//            break;
      case .loca:
        let headTable: TCHeadTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.head)
        let maxpTable: TCMaxpTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.maxp)
        table = TCLocaTable(data: data,
                            headTable: headTable,
                            maxpTable: maxpTable)
      case .maxp:
        table = TCMaxpTable(data: data)
      case .name:
        table = TCNameTable(data: data)
      case .prep:
        table = TCPrepTable(data: data)
      case .post:
        table = TCPostTable(data: data)
      case .vhea:
        table = TCVheaTable(data: data)
      case .vmtx:
        let vheaTable: TCVheaTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.vhea)
        let maxpTable: TCMaxpTable = try TCTableFactory.table(tables: tables, tag: TCTableTag.maxp)
        table = TCVmtxTable(data: data, vheaTable: vheaTable, maxpTable: maxpTable)
      default:
        throw TCTableError.unrecognizedTableType(tag: directoryEntry.tag)
      }
    } else {
      throw TCTableError.unrecognizedTableType(tag: directoryEntry.tag)
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
    throw TCTableError.missingTable(tag: tag.rawValue)
  }
}
