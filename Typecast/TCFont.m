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
#import "TCHheaTable.h"
#import "TCNameTable.h"
#import "TCID.h"

@interface TCFont ()

@end


@implementation TCFont

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        TCDataInput *dataInput = [[TCDataInput alloc] initWithData:data];
        [self readFromDataInput:dataInput directoryOffset:0 tablesOrigin:0];
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

- (void)readFromDataInput:(TCDataInput *)dataInput
          directoryOffset:(NSUInteger)directoryOffset
             tablesOrigin:(NSUInteger)tablesOrigin;
{
    // Load the table directory
    [dataInput reset];
    [dataInput skipByteCount:directoryOffset];
    _tableDirectory = [[TCTableDirectory alloc] initWithDataInput:dataInput];
    NSMutableArray *tables = [[NSMutableArray alloc] initWithCapacity:[_tableDirectory numTables]];

    // Load some prerequisite tables
    _headTable = (TCHeadTable *)[self readTableWithTag:TCTable_head fromDataInput:dataInput tablesOrigin:tablesOrigin];
    _hheaTable = (TCHheaTable *)[self readTableWithTag:TCTable_hhea fromDataInput:dataInput tablesOrigin:tablesOrigin];
    _maxpTable = (TCMaxpTable *)[self readTableWithTag:TCTable_maxp fromDataInput:dataInput tablesOrigin:tablesOrigin];
    _locaTable = (TCLocaTable *)[self readTableWithTag:TCTable_loca fromDataInput:dataInput tablesOrigin:tablesOrigin];
    _vheaTable = (TCVheaTable *)[self readTableWithTag:TCTable_vhea fromDataInput:dataInput tablesOrigin:tablesOrigin];

    _postTable = (TCPostTable *)[self readTableWithTag:TCTable_post fromDataInput:dataInput tablesOrigin:tablesOrigin];

    [tables addObject:_headTable];
    [tables addObject:_hheaTable];
    [tables addObject:_maxpTable];
    if (_locaTable)
        [tables addObject:_locaTable];
    if (_vheaTable)
        [tables addObject:_vheaTable];
    [tables addObject:_postTable];

    // Load all other tables
    for (TCDirectoryEntry *entry in [_tableDirectory entries])
    {
        if ([entry tag] == TCTable_head ||
            [entry tag] == TCTable_hhea ||
            [entry tag] == TCTable_maxp ||
            [entry tag] == TCTable_loca ||
            [entry tag] == TCTable_vhea ||
            [entry tag] == TCTable_post)
            continue;

        [dataInput reset];
        [dataInput skipByteCount:tablesOrigin + [entry offset]];
        id<TCTable> table = [TCTableFactory createTableForFont:self
                                                 withDataInput:dataInput
                                                directoryEntry:entry];
        if (table)
            [tables addObject:table];
    }
    _tables = tables;

    // Get references to commonly used tables (these happen to be all the
    // required tables)
    _cmapTable = (TCCmapTable *)[self tableWithType:TCTable_cmap];
    _hmtxTable = (TCHmtxTable *)[self tableWithType:TCTable_hmtx];
    _nameTable = (TCNameTable *)[self tableWithType:TCTable_name];
    _os2Table = (TCOs2Table *)[self tableWithType:TCTable_OS_2];
    //_postTable = (TCPostTable *)[self tableWithType:TCTable_post];

    // If this is a TrueType outline, then we'll have at least the
    // 'glyf' table (along with the 'loca' table)
    _glyfTable = (TCGlyfTable *)[self tableWithType:TCTable_glyf];

    NSLog(@"%@", _tableDirectory);
}

- (id<TCTable>)readTableWithTag:(uint32_t)tag
                  fromDataInput:(TCDataInput *)dataInput
                   tablesOrigin:(NSUInteger)tablesOrigin
{
    [dataInput reset];
    TCDirectoryEntry *entry = [_tableDirectory entryWithTag:tag];
    if (entry)
    {
        [dataInput skipByteCount:tablesOrigin + [entry offset]];
        return [TCTableFactory createTableForFont:self
                                    withDataInput:dataInput
                                   directoryEntry:entry];
    }
    return nil;
}

- (int)ascent
{
    return [_hheaTable ascender];
}

- (int)descent
{
    return [_hheaTable descender];
}

- (NSString *)name
{
    return [[_nameTable recordWithID:TCNameFullFontName] record];
}

@end
