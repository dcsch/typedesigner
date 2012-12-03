//
//  TCLocaTable.m
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCLocaTable.h"
#import "TCDirectoryEntry.h"
#import "TCDataInput.h"
#import "TCHeadTable.h"
#import "TCMaxpTable.h"

@implementation TCLocaTable

- (id)initWithDataInput:(TCDataInput *)dataInput
         directoryEntry:(TCDirectoryEntry *)entry
              headTable:(TCHeadTable *)head
              maxpTable:(TCMaxpTable *)maxp
{
    self = [super init];
    if (self)
    {
        self.directoryEntry = [entry copy];
        NSMutableArray *offsets = [[NSMutableArray alloc] initWithCapacity:[maxp numGlyphs] + 1];
        BOOL shortEntries = [head indexToLocFormat] == 0;
        if (shortEntries)
        {
            _factor = 2;
            for (int i = 0; i <= [maxp numGlyphs]; ++i)
                [offsets addObject:[NSNumber numberWithUnsignedShort:[dataInput readUnsignedShort]]];
        }
        else
        {
            _factor = 1;
            for (int i = 0; i <= [maxp numGlyphs]; ++i)
                [offsets addObject:[NSNumber numberWithInt:[dataInput readInt]]];
        }
        _offsets = offsets;
    }
    return self;
}

- (int32_t)offsetAtIndex:(NSUInteger)index
{
    return [_offsets[index] unsignedIntValue] * _factor;
}

- (NSString *)description
{
    NSMutableString *str = [NSMutableString stringWithFormat:
                            @"'loca' Table - Index To Location Table\n--------------------------------------\n"
                            @"Size = %d bytes, %ld entries\n",
                            [[self directoryEntry] length],
                            [_offsets count]];
    NSUInteger i = 0;
    for (NSNumber *offset in _offsets)
    {
        [str appendFormat:@"        Idx %ld  -> glyfOff 0x%x\n", i, [self offsetAtIndex:i]];
        ++i;
    }
    return str;
}

@end
