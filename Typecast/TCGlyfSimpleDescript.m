//
//  TCGlyfSimpleDescript.m
//  Typecast
//
//  Created by David Schweinsberg on 9/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCGlyfSimpleDescript.h"
#import "Type_Designer-Swift.h"
#import "TCDisassembler.h"

@interface TCGlyfSimpleDescript ()

- (void)readFlagsWithDataInput:(TCDataInput *)dataInput length:(NSUInteger)length;
- (void)readCoordsWithDataInput:(TCDataInput *)dataInput length:(NSUInteger)length;

@end


@implementation TCGlyfSimpleDescript

- (id)initWithDataInput:(TCDataInput *)dataInput
            parentTable:(TCGlyfTable *)parentTable
             glyphIndex:(uint32_t)glyphIndex
       numberOfContours:(uint32_t)numberOfContours
{
    self = [super initWithDataInput:dataInput
                        parentTable:parentTable
                         glyphIndex:glyphIndex
                   numberOfContours:numberOfContours];
    if (self)
    {
        // Simple glyph description
        NSMutableArray *endPtsOfContours = [[NSMutableArray alloc] initWithCapacity:numberOfContours];
        for (int i = 0; i < numberOfContours; ++i)
            [endPtsOfContours addObject:[NSNumber numberWithShort:[dataInput readInt16]]];
        _endPtsOfContours = endPtsOfContours;

        // The last end point index reveals the total number of points
        _count = [_endPtsOfContours[numberOfContours - 1] shortValue] + 1;

        int instructionCount = [dataInput readInt16];
        [self readInstructionsWithDataInput:dataInput length:instructionCount];
        [self readFlagsWithDataInput:dataInput length:_count];
        [self readCoordsWithDataInput:dataInput length:_count];
    }
    return self;
}

- (void)readFlagsWithDataInput:(TCDataInput *)dataInput length:(NSUInteger)length
{
    NSMutableArray *flags = [[NSMutableArray alloc] initWithCapacity:length];

    for (int index = 0; index < length; ++index)
    {
        uint8_t flagByte = [dataInput readInt8];
        [flags addObject:[NSNumber numberWithChar:flagByte]];
        if ((flagByte & repeat) != 0) {
            int repeats = [dataInput readInt8];
            for (int i = 1; i <= repeats; ++i)
                [flags addObject:[NSNumber numberWithChar:flagByte]];
            index += repeats;
        }
    }

    _flags = flags;
}

- (void)readCoordsWithDataInput:(TCDataInput *)dataInput length:(NSUInteger)length
{
    NSMutableArray *xCoordinates = [[NSMutableArray alloc] initWithCapacity:length];
    NSMutableArray *yCoordinates = [[NSMutableArray alloc] initWithCapacity:length];

    short x = 0;
    short y = 0;
    for (int i = 0; i < length; ++i)
    {
        if (([_flags[i] charValue] & xDual) != 0)
        {
            if (([_flags[i] charValue] & xShortVector) != 0)
                x += (short) [dataInput readUInt8];
        }
        else
        {
            if (([_flags[i] charValue] & xShortVector) != 0)
                x += (short) -((short) [dataInput readUInt8]);
            else
                x += [dataInput readInt16];
        }
        [xCoordinates addObject:[NSNumber numberWithShort:x]];
    }

    for (int i = 0; i < length; ++i)
    {
        if (([_flags[i] charValue] & yDual) != 0)
        {
            if (([_flags[i] charValue] & yShortVector) != 0)
                y += (short) [dataInput readUInt8];
        }
        else
        {
            if (([_flags[i] charValue] & yShortVector) != 0)
                y += (short) -((short) [dataInput readUInt8]);
            else
                y += [dataInput readInt16];
        }
        [yCoordinates addObject:[NSNumber numberWithShort:y]];
    }

    _xCoordinates = xCoordinates;
    _yCoordinates = yCoordinates;
}

- (NSString *)description
{
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendString:[super description]];

    [str appendString:@"\n        EndPoints\n        ---------"];
    for (int i = 0; i < [_endPtsOfContours count]; ++i)
        [str appendFormat:@"\n          %d: %d", i, [_endPtsOfContours[i] intValue]];

    [str appendFormat:@"\n\n          Length of Instructions: %ld\n", [[self instructions] length]];
    [str appendString:[TCDisassembler disassembleInstructions:[self instructions] leadingSpaceCount:8]];

    [str appendString:@"\n        Flags\n        -----"];
    for (int i = 0; i < [_flags count]; ++i)
    {
        char flags = [_flags[i] charValue];
        [str appendFormat:
         @"\n          %d: %@%@%@%@%@%@",
         i,
         ((flags & 0x20) != 0) ? @"YDual " : @"      ",
         ((flags & 0x10) != 0) ? @"XDual " : @"      ",
         ((flags & 0x08) != 0) ? @"Repeat " : @"       ",
         ((flags & 0x04) != 0) ? @"Y-Short " : @"        ",
         ((flags & 0x02) != 0) ? @"X-Short " : @"        ",
         ((flags & 0x01) != 0) ? @"On" : @"  "];
    }

    [str appendString:@"\n\n        Coordinates\n        -----------"];
    short oldX = 0;
    short oldY = 0;
    for (int i = 0; i < [_xCoordinates count]; ++i)
    {
        [str appendFormat:
         @"\n          %d: Rel (%d, %d)  ->  Abs (%d, %d)",
         i,
         [_xCoordinates[i] shortValue] - oldX,
         [_yCoordinates[i] shortValue] - oldY,
         [_xCoordinates[i] shortValue],
         [_yCoordinates[i] shortValue]];
        oldX = [_xCoordinates[i] shortValue];
        oldY = [_yCoordinates[i] shortValue];
    }
    return str;
}

#pragma mark - TCGlyphDescription Methods

//- (int)glyphIndex
//{
//    return [self glyphIndex];
//}

- (int)endPtOfContoursAtIndex:(int)index
{
    return [_endPtsOfContours[index] intValue];
}

- (char)flagsAtIndex:(int)index
{
    return [_flags[index] charValue];
}

- (short)xCoordinateAtIndex:(int)index
{
    return [_xCoordinates[index] shortValue];
}

- (short)yCoordinateAtIndex:(int)index
{
    return [_yCoordinates[index] shortValue];
}

- (short)xMaximum
{
    return [self xMax];
}

- (short)xMinimum
{
    return [self xMin];
}

- (short)yMaximum
{
    return [self yMax];
}

- (short)yMinimum
{
    return [self yMin];
}

- (BOOL)isComposite
{
    return NO;
}

- (int)pointCount
{
    return _count;
}

- (int)contourCount
{
    return [self numberOfContours];
}

@end
