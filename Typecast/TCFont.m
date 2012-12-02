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

@property (strong) TCTable *head;
@property (strong) TCTable *hhea;

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

    _head = [self readTableWithTag:TCTable_head fromDataInput:dataInput];
    _hhea = [self readTableWithTag:TCTable_hhea fromDataInput:dataInput];

    NSLog(@"'hhea': %@", _hhea);

    [tables addObject:_head];
    [tables addObject:_hhea];
}

- (TCTable *)readTableWithTag:(uint32_t)tag fromDataInput:(TCDataInput *)dataInput
{
    [dataInput reset];
    TCDirectoryEntry *entry = [_tableDirectory entryWithTag:tag];
    [dataInput skipByteCount:[entry offset]];
    return [TCTableFactory createTableForFont:self withDataInput:dataInput directoryEntry:entry];
}

@end
