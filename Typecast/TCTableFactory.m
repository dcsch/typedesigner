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
#import "TCCffTable.h"
#import "TCFpgmTable.h"
#import "TCGlyfTable.h"
#import "TCHeadTable.h"
#import "TCHheaTable.h"
#import "TCHmtxTable.h"
#import "TCLocaTable.h"
#import "TCMaxpTable.h"
#import "TCNameTable.h"
#import "TCOs2Table.h"
#import "TCPostTable.h"
#import "TCPrepTable.h"
#import "TCVheaTable.h"

@implementation TCTableFactory

+ (id<TCTable>)createTableForFont:(TCFont *)font
                    withDataInput:(TCDataInput *)dataInput
                   directoryEntry:(TCDirectoryEntry *)entry;
{
    id<TCTable> table = nil;

    // Create the table
    switch ([entry tag])
    {
//        case BASE:
//            table = new BaseTable(de, dis);
//            break;
        case TCTable_CFF:
            table = [[TCCffTable alloc] initWithDataInput:dataInput directoryEntry:entry];
            break;
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
        case TCTable_OS_2:
            table = [[TCOs2Table alloc] initWithDataInput:dataInput directoryEntry:entry];
            break;
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
        case TCTable_fpgm:
            table = [[TCFpgmTable alloc] initWithDataInput:dataInput directoryEntry:entry];
            break;
//        case Table.fvar:
//            break;
//        case Table.gasp:
//            t = new GaspTable(de, dis);
//            break;
        case TCTable_glyf:
            table = [[TCGlyfTable alloc] initWithDataInput:dataInput directoryEntry:entry maxpTable:[font maxpTable] locaTable:[font locaTable] postTable:[font postTable]];
            break;
//        case Table.hdmx:
//            t = new HdmxTable(de, dis, font.getMaxpTable());
//            break;
        case TCTable_head:
            table = [[TCHeadTable alloc] initWithDataInput:dataInput directoryEntry:entry];
            break;
        case TCTable_hhea:
            table = [[TCHheaTable alloc] initWithDataInput:dataInput directoryEntry:entry];
            break;
        case TCTable_hmtx:
            table = [[TCHmtxTable alloc] initWithDataInput:dataInput directoryEntry:entry hheaTable:[font hheaTable] maxpTable:[font maxpTable]];
            break;
//        case Table.kern:
//            t = new KernTable(de, dis);
//            break;
        case TCTable_loca:
            table = [[TCLocaTable alloc] initWithDataInput:dataInput directoryEntry:entry headTable:[font headTable] maxpTable:[font maxpTable]];
            break;
        case TCTable_maxp:
            table = [[TCMaxpTable alloc] initWithDataInput:dataInput directoryEntry:entry];
            break;
        case TCTable_name:
            table = [[TCNameTable alloc] initWithDataInput:dataInput directoryEntry:entry];
            break;
        case TCTable_prep:
            table = [[TCPrepTable alloc] initWithDataInput:dataInput directoryEntry:entry];
            break;
        case TCTable_post:
            table = [[TCPostTable alloc] initWithDataInput:dataInput directoryEntry:entry];
            break;
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
