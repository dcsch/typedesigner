//
//  TCTableFactory.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/31/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCTableFactory {

  class func createTable(font: TCFont, data: Data,
                         directoryEntry entry: TCDirectoryEntry) -> TCTableProtocol?
  {
    var table: TCTableProtocol?

    if let tableType = TCTableType(rawValue: entry.tag) {

      // Create the table
      switch tableType {
        //        case BASE:
        //            table = new BaseTable(de, dis);
      //            break;
//      case .CFF:
//        let dataInput = TCDataInput(data: data)
//        table = TCCffTable(dataInput: dataInput, directoryEntry: entry)
        //        case Table.DSIG:
        //            t = new DsigTable(de, dis);
        //            break;
        //        case Table.EBDT:
        //            break;
        //        case Table.EBLC:
        //            break;
        //        case Table.EBSC:
        //            break;
        //        case Table.GDEF:
        //            break;
        //        case Table.GPOS:
        //            t = new GposTable(de, dis);
        //            break;
        //        case Table.GSUB:
        //            t = new GsubTable(de, dis);
        //            break;
        //        case Table.JSTF:
        //            break;
        //        case Table.LTSH:
        //            t = new LtshTable(de, dis);
        //            break;
        //        case Table.MMFX:
        //            break;
        //        case Table.MMSD:
      //            break;
      case .OS_2:
        let dataInput = TCDataInput(data: data)
        table = TCOs2Table(dataInput: dataInput, directoryEntry:entry)
        //        case Table.PCLT:
        //            t = new PcltTable(de, dis);
        //            break;
        //        case Table.VDMX:
        //            t = new VdmxTable(de, dis);
      //            break;
      case .cmap:
        let dataInput = TCDataInput(data: data)
        table = TCCmapTable(dataInput: dataInput, directoryEntry:entry)
        //        case Table.cvt:
        //            t = new CvtTable(de, dis);
      //            break;
      case .fpgm: break
//        let dataInput = TCDataInput(data: data)
//        table = TCFpgmTable(dataInput: dataInput, directoryEntry:entry)
        //        case Table.fvar:
        //            break;
        //        case Table.gasp:
        //            t = new GaspTable(de, dis);
      //            break;
      case .glyf:
        table = TCGlyfTable(data: data,
                            directoryEntry: entry,
                            maxpTable: font.maxpTable!,
                            locaTable: font.locaTable!,
                            postTable: font.postTable!)
        break;
        //        case Table.hdmx:
        //            t = new HdmxTable(de, dis, font.getMaxpTable());
      //            break;
      case .head:
        let dataInput = TCDataInput(data: data)
        table = TCHeadTable(dataInput: dataInput, directoryEntry: entry)
      case .hhea:
        let dataInput = TCDataInput(data: data)
        table = TCHheaTable(dataInput: dataInput, directoryEntry: entry)
      case .hmtx:
        let dataInput = TCDataInput(data: data)
        table = TCHmtxTable(dataInput: dataInput,
                            directoryEntry: entry,
                            hheaTable: font.hheaTable!,
                            maxpTable: font.maxpTable!)
        //        case Table.kern:
        //            t = new KernTable(de, dis);
      //            break;
      case .loca:
        let dataInput = TCDataInput(data: data)
        table = TCLocaTable(dataInput: dataInput,
                            directoryEntry: entry,
                            headTable: font.headTable!,
                            maxpTable: font.maxpTable!)
      case .maxp:
        let dataInput = TCDataInput(data: data)
        table = TCMaxpTable(dataInput: dataInput, directoryEntry: entry)
      case .name:
        table = TCNameTable(data: data, directoryEntry: entry)
      case .prep: break
//        let dataInput = TCDataInput(data: data)
//        table = TCPrepTable(dataInput: dataInput, directoryEntry: entry)
      case .post:
        let dataInput = TCDataInput(data: data)
        table = TCPostTable(dataInput: dataInput, directoryEntry: entry)
      case .vhea:
        let dataInput = TCDataInput(data: data)
        table = TCVheaTable(dataInput: dataInput, directoryEntry: entry)
        //        case Table.vmtx:
        //            t = new VmtxTable(de, dis, font.getVheaTable(), font.getMaxpTable());
        //            break;
      default:
        table = nil
      }
    }

    return table;
  }
}
