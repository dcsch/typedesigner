//
//  TCTableDirectory.m
//  Typecast
//
//  Created by David Schweinsberg on 1/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTableDirectory.h"
#import "TCDirectoryEntry.h"
#import "TCDataInput.h"

@implementation TCTableDirectory

- (id)initWithDataInput:(TCDataInput *)dataInput
{
    self = [super init];
    if (self)
    {
        _version = [dataInput readInt];
        _numTables = [dataInput readShort];
        _searchRange = [dataInput readShort];
        _entrySelector = [dataInput readShort];
        _rangeShift = [dataInput readShort];
        NSMutableArray *entries = [[NSMutableArray alloc] initWithCapacity:_numTables];
        for (int i = 0; i < _numTables; i++)
            [entries addObject:[[TCDirectoryEntry alloc] initWithDataInput:dataInput]];
        _entries = entries;
    }
    return self;
}

- (TCDirectoryEntry *)entryWithTag:(uint32_t)tag
{
    for (TCDirectoryEntry *entry in _entries)
        if ([entry tag] == tag)
            return entry;
    return nil;
}

@end