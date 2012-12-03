//
//  TCFont.m
//  Typecast
//
//  Created by David Schweinsberg on 1/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCFont.h"
#import "TCHeadTable.h"
#import "TCHheaTable.h"
#import "TCMaxpTable.h"
#import "TCLocaTable.h"
#import "TCVheaTable.h"
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
    _tableDirectory = [[TCTableDirectory alloc] initWithDataInput:dataInput];
    NSMutableArray *tables = [[NSMutableArray alloc] initWithCapacity:[_tableDirectory numTables]];

    _head = (TCHeadTable *)[self readTableWithTag:TCTable_head fromDataInput:dataInput];
    _hhea = (TCHheaTable *)[self readTableWithTag:TCTable_hhea fromDataInput:dataInput];
    _maxp = (TCMaxpTable *)[self readTableWithTag:TCTable_maxp fromDataInput:dataInput];
    _loca = (TCLocaTable *)[self readTableWithTag:TCTable_loca fromDataInput:dataInput];
    _vhea = (TCVheaTable *)[self readTableWithTag:TCTable_vhea fromDataInput:dataInput];

    NSLog(@"'vhea': %@", _vhea);

    [tables addObject:_head];
    [tables addObject:_hhea];
    [tables addObject:_maxp];
    if (_loca)
        [tables addObject:_loca];
    if (_vhea)
        [tables addObject:_vhea];
}

- (TCTable *)readTableWithTag:(uint32_t)tag fromDataInput:(TCDataInput *)dataInput
{
    [dataInput reset];
    TCDirectoryEntry *entry = [_tableDirectory entryWithTag:tag];
    if (entry)
    {
        [dataInput skipByteCount:[entry offset]];
        return [TCTableFactory createTableForFont:self withDataInput:dataInput directoryEntry:entry];
    }
    return nil;
}

@end
