//
//  TCTableFactory.m
//  Typecast
//
//  Created by David Schweinsberg on 2/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTableFactory.h"
#import "TCFont.h"
#import "TCDirectoryEntry.h"
#import "TCDataInput.h"
#import "TCCmapTable.h"
#import "TCHeadTable.h"
#import "TCHheaTable.h"
#import "TCLocaTable.h"
#import "TCMaxpTable.h"
#import "TCVheaTable.h"

@implementation TCTableFactory

+ (TCTable *)createTableForFont:(TCFont *)font
                  withDataInput:(TCDataInput *)dataInput
                 directoryEntry:(TCDirectoryEntry *)entry;
{
    TCTable *table = nil;

    // Create the table
    switch ([entry tag])
    {
//        case BASE:
//            table = new BaseTable(de, dis);
//            break;
//        case Table.CFF:
//            t = new CffTable(de, dis);
//            break;
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
//        case Table.OS_2:
//            t = new Os2Table(de, dis);
//            break;
//        case Table.PCLT:
//            t = new PcltTable(de, dis);
//            break;
//        case Table.VDMX:
//            t = new VdmxTable(de, dis);
//            break;
        case TCTable_cmap:
            table = [[TCCmapTable alloc] initWithDataInput:dataInput directoryEntry:entry];
            break;
//        case Table.cvt:
//            t = new CvtTable(de, dis);
//            break;
//        case Table.fpgm:
//            t = new FpgmTable(de, dis);
//            break;
//        case Table.fvar:
//            break;
//        case Table.gasp:
//            t = new GaspTable(de, dis);
//            break;
//        case Table.glyf:
//            t = new GlyfTable(de, dis, font.getMaxpTable(), font.getLocaTable());
//            break;
//        case Table.hdmx:
//            t = new HdmxTable(de, dis, font.getMaxpTable());
//            break;
        case TCTable_head:
            table = [[TCHeadTable alloc] initWithDataInput:dataInput directoryEntry:entry];
            break;
        case TCTable_hhea:
            table = [[TCHheaTable alloc] initWithDataInput:dataInput directoryEntry:entry];
            break;
//        case Table.hmtx:
//            t = new HmtxTable(de, dis, font.getHheaTable(), font.getMaxpTable());
//            break;
//        case Table.kern:
//            t = new KernTable(de, dis);
//            break;
        case TCTable_loca:
            table = [[TCLocaTable alloc] initWithDataInput:dataInput directoryEntry:entry headTable:[font head] maxpTable:[font maxp]];
            break;
        case TCTable_maxp:
            table = [[TCMaxpTable alloc] initWithDataInput:dataInput directoryEntry:entry];
            break;
//        case Table.name:
//            t = new NameTable(de, dis);
//            break;
//        case Table.prep:
//            t = new PrepTable(de, dis);
//            break;
//        case Table.post:
//            t = new PostTable(de, dis);
//            break;
        case TCTable_vhea:
            table = [[TCVheaTable alloc] initWithDataInput:dataInput directoryEntry:entry];
            break;
//        case Table.vmtx:
//            t = new VmtxTable(de, dis, font.getVheaTable(), font.getMaxpTable());
//            break;
    }

    return table;
}

@end
