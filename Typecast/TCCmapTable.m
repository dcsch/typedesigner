//
//  TCCmapTable.m
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCCmapTable.h"
#import "Type_Designer-Swift.h"
#import "TCCmapIndexEntry.h"
#import "TCCmapFormat.h"

@implementation TCCmapTable

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry
{
    self = [super init];
    if (self)
    {
        self.directoryEntry = [entry copy];
        _version = [dataInput readUInt16];
        _numTables = [dataInput readUInt16];
        long bytesRead = 4;
        NSMutableArray *entries = [[NSMutableArray alloc] initWithCapacity:_numTables];

        // Get each of the index entries
        for (int i = 0; i < _numTables; ++i)
        {
            [entries addObject:[[TCCmapIndexEntry alloc] initWithDataInput:dataInput]];
            bytesRead += 8;
        }

        // Sort into their order of offset
        _entries = [entries sortedArrayUsingSelector:@selector(compare:)];

        // Get each of the tables
        int lastOffset = 0;
        TCCmapFormat *lastFormat = nil;
        for (TCCmapIndexEntry *entry in _entries)
        {
            if ([entry offset] == lastOffset)
            {
                // This is a multiple entry
                [entry setFormat:lastFormat];
                continue;
            }
            else if ([entry offset] > bytesRead)
            {
                NSArray *array = [dataInput readWithLength:[entry offset] - bytesRead];
//                [dataInput skipWithByteCount:[entry offset] - bytesRead];
            }
            else if ([entry offset] != bytesRead)
            {
                // Something is amiss
                NSException *exception = [NSException exceptionWithName:@"TCCmapIndexEntryBad"
                                                                 reason:@"TCCmapIndexEntry offset is bad"
                                                               userInfo:nil];
                @throw exception;
            }
            int formatType = [dataInput readUInt16];
            lastFormat = [TCCmapFormat cmapFormatOfType:formatType dataInput:dataInput];
            lastOffset = [entry offset];
            [entry setFormat:lastFormat];
            bytesRead += [lastFormat length];
        }
    }
    return self;
}

- (uint32_t)type
{
    return TCTable_cmap;
}

- (NSString *)description
{
    NSMutableString *str = [NSMutableString stringWithString:@"cmap\n"];

    // Get each of the index entries
    for (TCCmapIndexEntry *entry in _entries)
        [str appendFormat:@"%@\n", [entry description]];

    return str;
}

@end
