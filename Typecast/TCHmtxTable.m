//
//  TCHmtxTable.m
//  Typecast
//
//  Created by David Schweinsberg on 4/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCHmtxTable.h"
#import "TCDirectoryEntry.h"
#import "TCDataInput.h"
#import "TCHheaTable.h"
#import "TCMaxpTable.h"

@interface TCHmtxTable ()
{
    NSMutableArray *_hMetrics;
    NSMutableArray *_leftSideBearing;
}

@end


@implementation TCHmtxTable

- (id)initWithDataInput:(TCDataInput *)dataInput
         directoryEntry:(TCDirectoryEntry *)entry
              hheaTable:(TCHheaTable *)hhea
              maxpTable:(TCMaxpTable *)maxp
{
    self = [super init];
    if (self)
    {
        self.directoryEntry = [entry copy];
        _hMetrics = [[NSMutableArray alloc] initWithCapacity:[hhea numberOfHMetrics]];
        for (int i = 0; i < [hhea numberOfHMetrics]; ++i)
        {
            uint32_t hMetrics =
            [dataInput readUnsignedByte] << 24
            | [dataInput readUnsignedByte] << 16
            | [dataInput readUnsignedByte] << 8
            | [dataInput readUnsignedByte];
            [_hMetrics addObject:[NSNumber numberWithUnsignedInt:hMetrics]];
        }
        int lsbCount = [maxp numGlyphs] - [hhea numberOfHMetrics];
        _leftSideBearing = [[NSMutableArray alloc] initWithCapacity:lsbCount];
        for (int i = 0; i < lsbCount; ++i)
            [_leftSideBearing addObject:[NSNumber numberWithShort:[dataInput readShort]]];
    }
    return self;
}

- (uint16_t)advanceWidthAtIndex:(int)index
{
    if (_hMetrics == nil)
        return 0;
    if (index < [_hMetrics count])
        return [_hMetrics[index] unsignedIntValue] >> 16;
    else
        return [[_hMetrics lastObject] unsignedIntValue] >> 16;
}

- (int16_t)leftSideBearingAtIndex:(int)index
{
    if (_hMetrics == nil)
        return 0;
    if (index < [_hMetrics count])
        return (int16_t)([_hMetrics[index] unsignedIntValue] & 0xffff);
    else
        return [[_hMetrics lastObject] unsignedIntValue];
}

- (uint32_t)type
{
    return TCTable_hmtx;
}

- (NSString *)description
{
    NSMutableString *str = [NSMutableString stringWithFormat:
                            @"'hmtx' Table - Horizontal Metrics\n---------------------------------\n"
                            @"Size = %d bytes, %ld entries\n",
                            [[self directoryEntry] length],
                            [_hMetrics count]];
    for (int i = 0; i < [_hMetrics count]; ++i)
        [str appendFormat:
         @"        %d. advWid: %d, LSdBear: %d\n",
         i,
         [self advanceWidthAtIndex:i],
         [self leftSideBearingAtIndex:i]];

    for (int i = 0; i < [_leftSideBearing count]; ++i)
        [str appendFormat:
         @"        LSdBear %ld: %d\n",
         i + [_hMetrics count],
         [self leftSideBearingAtIndex:i]];
    return str;
}

@end
