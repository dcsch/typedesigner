//
//  CFFCharset.m
//  Type Designer
//
//  Created by David Schweinsberg on 4/01/13.
//  Copyright (c) 2013 David Schweinsberg. All rights reserved.
//

#import "CFFCharset.h"
#import "TCDataInput.h"

@implementation CFFCharset

- (int)format
{
    return -1;
}

- (int)SIDForGID:(int)gid
{
    return 0;
}

@end


@interface CFFCharsetFormat0 ()
{
    NSMutableArray *_glyphs;
}

@end

@implementation CFFCharsetFormat0

- (id)initWithDataInput:(TCDataInput *)dataInput glyphCount:(int)glyphCount
{
    self = [super init];
    if (self)
    {
        _glyphs = [[NSMutableArray alloc] initWithCapacity:glyphCount - 1]; // minus 1 because .notdef is omitted
        for (int i = 0; i < glyphCount - 1; ++i)
            [_glyphs addObject:[NSNumber numberWithUnsignedShort:[dataInput readUnsignedShort]]];
    }
    return self;
}

- (int)format
{
    return 0;
}

- (int)SIDForGID:(int)gid
{
    if (gid == 0)
        return 0;
    return [_glyphs[gid - 1] intValue];
}

@end


@interface CFFCharsetFormat1 ()
{
    NSMutableArray *_charsetRanges;
}

@end

@implementation CFFCharsetFormat1

- (id)initWithDataInput:(TCDataInput *)dataInput glyphCount:(int)glyphCount
{
    self = [super init];
    if (self)
    {
        _charsetRanges = [[NSMutableArray alloc] init];

        int glyphsCovered = glyphCount - 1;  // minus 1 because .notdef is omitted
        while (glyphsCovered > 0)
        {
            int first = [dataInput readUnsignedShort];
            int left = [dataInput readUnsignedByte];
            NSRange range = NSMakeRange(first, left);
            [_charsetRanges addObject:[NSValue valueWithRange:range]];
            glyphsCovered -= left + 1;
        }
    }
    return self;
}

- (int)format
{
    return 1;
}

- (int)SIDForGID:(int)gid
{
    if (gid == 0)
        return 0;

    // Count through the ranges to find the one of interest
    int count = 0;
    for (NSValue *rangeValue in _charsetRanges)
    {
        NSUInteger first = [rangeValue rangeValue].location;
        NSUInteger left = [rangeValue rangeValue].length;
        if (gid < left + count)
        {
            NSUInteger sid = gid - count + first - 1;
            return (int)sid;
        }
        count += left;
    }
    return 0;
}

@end


@interface CFFCharsetFormat2 ()
{
    NSMutableArray *_charsetRanges;
}

@end

@implementation CFFCharsetFormat2

- (id)initWithDataInput:(TCDataInput *)dataInput glyphCount:(int)glyphCount
{
    self = [super init];
    if (self)
    {
        _charsetRanges = [[NSMutableArray alloc] init];

        int glyphsCovered = glyphCount - 1;  // minus 1 because .notdef is omitted
        while (glyphsCovered > 0)
        {
            int first = [dataInput readUnsignedShort];
            int left = [dataInput readUnsignedShort];
            NSRange range = NSMakeRange(first, left);
            [_charsetRanges addObject:[NSValue valueWithRange:range]];
            glyphsCovered -= left + 1;
        }
    }
    return self;
}

- (int)format
{
    return 2;
}

- (int)SIDForGID:(int)gid
{
    if (gid == 0)
        return 0;

    // Count through the ranges to find the one of interest
    int count = 0;
    for (NSValue *rangeValue in _charsetRanges)
    {
        NSUInteger first = [rangeValue rangeValue].location;
        NSUInteger left = [rangeValue rangeValue].length;
        if (gid < left + count)
        {
            NSUInteger sid = gid - count + first - 1;
            return (int)sid;
        }
        count += left;
    }
    return 0;
}

@end
