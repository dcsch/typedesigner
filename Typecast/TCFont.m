//
//  TCFont.m
//  Typecast
//
//  Created by David Schweinsberg on 1/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCFont.h"
#import "TCTable.h"
#import "TCTableDirectory.h"
#import "TCDirectoryEntry.h"
#import "TCTableFactory.h"
#import "TCDataInput.h"

@interface TCFont ()

- (void)loadFromData:(NSData *)fontData;

@end


@implementation TCFont

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        [self loadFromData:data];
    }
    return self;
}

- (TCTable *)tableWithType:(NSUInteger)tableType
{
    for (TCTable *table in _tables)
        if ([table type] == tableType)
            return table;
    return nil;
}

- (void)loadFromData:(NSData *)fontData
{
    TCDataInput *dataInput = [[TCDataInput alloc] initWithData:fontData];

    // Load the table directory
    _tableDirectory = [[TCTableDirectory alloc] initWithDataInput:dataInput];
    NSMutableArray *tables = [[NSMutableArray alloc] initWithCapacity:[_tableDirectory numTables]];

    // Load some prerequisite tables
    _head = (TCHeadTable *)[self readTableWithTag:TCTable_head fromDataInput:dataInput];
    _hhea = (TCHheaTable *)[self readTableWithTag:TCTable_hhea fromDataInput:dataInput];
    _maxp = (TCMaxpTable *)[self readTableWithTag:TCTable_maxp fromDataInput:dataInput];
    _loca = (TCLocaTable *)[self readTableWithTag:TCTable_loca fromDataInput:dataInput];
    _vhea = (TCVheaTable *)[self readTableWithTag:TCTable_vhea fromDataInput:dataInput];

    [tables addObject:_head];
    [tables addObject:_hhea];
    [tables addObject:_maxp];
    if (_loca)
        [tables addObject:_loca];
    if (_vhea)
        [tables addObject:_vhea];

    // Load all other tables
    for (TCDirectoryEntry *entry in [_tableDirectory entries])
    {
        if ([entry tag] == TCTable_head ||
            [entry tag] == TCTable_hhea ||
            [entry tag] == TCTable_maxp ||
            [entry tag] == TCTable_loca ||
            [entry tag] == TCTable_vhea)
            continue;

        [dataInput reset];
        [dataInput skipByteCount:[entry offset]];
        TCTable *table = [TCTableFactory createTableForFont:self
                                              withDataInput:dataInput
                                             directoryEntry:entry];
        if (table)
            [tables addObject:table];
    }
    _tables = tables;

    // Get references to commonly used tables (these happen to be all the
    // required tables)
    _cmap = (TCCmapTable *)[self tableWithType:TCTable_cmap];
    _hmtx = (TCHmtxTable *)[self tableWithType:TCTable_hmtx];
    _name = (TCNameTable *)[self tableWithType:TCTable_name];
    _os2 = (TCOs2Table *)[self tableWithType:TCTable_OS_2];
    _post = (TCPostTable *)[self tableWithType:TCTable_post];

    // If this is a TrueType outline, then we'll have at least the
    // 'glyf' table (along with the 'loca' table)
//    _glyf = (GlyfTable) getTable(Table.glyf);

    NSLog(@"'post': %@", _post);
}

- (TCTable *)readTableWithTag:(uint32_t)tag fromDataInput:(TCDataInput *)dataInput
{
    [dataInput reset];
    TCDirectoryEntry *entry = [_tableDirectory entryWithTag:tag];
    if (entry)
    {
        [dataInput skipByteCount:[entry offset]];
        return [TCTableFactory createTableForFont:self
                                    withDataInput:dataInput
                                   directoryEntry:entry];
    }
    return nil;
}

@end
