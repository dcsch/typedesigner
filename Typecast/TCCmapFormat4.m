//
//  TCCmapFormat4.m
//  Typecast
//
//  Created by David Schweinsberg on 4/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCCmapFormat4.h"
#import "TCDataInput.h"

@interface TCCmapFormat4 ()
{
    int _segCountX2;
    int _searchRange;
    int _entrySelector;
    int _rangeShift;
    NSMutableArray *_endCode;
    NSMutableArray *_startCode;
    NSMutableArray *_idDelta;
    NSMutableArray *_idRangeOffset;
    NSMutableArray *_glyphIdArray;
    int _segCount;
}

@end

@implementation TCCmapFormat4

- (id)initWithDataInput:(TCDataInput *)dataInput
{
    self = [super initWithDataInput:dataInput];
    if (self)
    {
        [self setFormat:4];
        _segCountX2 = [dataInput readUnsignedShort]; // +2 (8)
        _segCount = _segCountX2 / 2;
        _endCode = [[NSMutableArray alloc] initWithCapacity:_segCount];
        _startCode = [[NSMutableArray alloc] initWithCapacity:_segCount];
        _idDelta = [[NSMutableArray alloc] initWithCapacity:_segCount];
        _idRangeOffset = [[NSMutableArray alloc] initWithCapacity:_segCount];
        _searchRange = [dataInput readUnsignedShort]; // +2 (10)
        _entrySelector = [dataInput readUnsignedShort]; // +2 (12)
        _rangeShift = [dataInput readUnsignedShort]; // +2 (14)
        for (int i = 0; i < _segCount; i++) {
            [_endCode addObject:[NSNumber numberWithUnsignedShort:[dataInput readUnsignedShort]]];
        } // + 2*segCount (2*segCount + 14)
        [dataInput readUnsignedShort]; // reservePad  +2 (2*segCount + 16)
        for (int i = 0; i < _segCount; i++) {
            [_startCode addObject:[NSNumber numberWithUnsignedShort:[dataInput readUnsignedShort]]];
        } // + 2*segCount (4*segCount + 16)
        for (int i = 0; i < _segCount; i++) {
            [_idDelta addObject:[NSNumber numberWithUnsignedShort:[dataInput readUnsignedShort]]];
        } // + 2*segCount (6*segCount + 16)
        for (int i = 0; i < _segCount; i++) {
            [_idRangeOffset addObject:[NSNumber numberWithUnsignedShort:[dataInput readUnsignedShort]]];
        } // + 2*segCount (8*segCount + 16)

        // Whatever remains of this header belongs in glyphIdArray
        int count = ([self length] - (8 * _segCount + 16)) / 2;
        _glyphIdArray = [[NSMutableArray alloc] initWithCapacity:count];
        for (int i = 0; i < count; i++) {
            [_glyphIdArray addObject:[NSNumber numberWithUnsignedShort:[dataInput readUnsignedShort]]];
        } // + 2*count (8*segCount + 2*count + 18)

        // Are there any padding bytes we need to consume?
//        int leftover = length - (8*segCount + 2*count + 18);
//        if (leftover > 0) {
//            [dataInput skipByteount:leftover];
//        }

        // Determines the ranges
        NSMutableArray *ranges = [NSMutableArray arrayWithCapacity:_segCount];
        for (int index = 0; index < _segCount; ++index)
        {
            NSUInteger startCode = [_startCode[index] unsignedIntegerValue];
            NSUInteger endCode = [_endCode[index] unsignedIntegerValue];
            NSRange range = NSMakeRange(startCode, endCode - startCode + 1);
            [ranges addObject:[NSValue valueWithRange:range]];
        }
        [self setRanges:ranges];
    }
    return self;
}

@end
