//
//  TCGlyfSimpleDescript.m
//  Typecast
//
//  Created by David Schweinsberg on 9/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCGlyfSimpleDescript.h"
#import "TCDataInput.h"

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
            [endPtsOfContours addObject:[NSNumber numberWithShort:[dataInput readShort]]];
        _endPtsOfContours = endPtsOfContours;

        // The last end point index reveals the total number of points
        _count = [_endPtsOfContours[numberOfContours - 1] shortValue] + 1;

        int instructionCount = [dataInput readShort];
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
        uint8_t flagByte = [dataInput readByte];
        [flags addObject:[NSNumber numberWithChar:flagByte]];
        if ((flagByte & repeat) != 0) {
            int repeats = [dataInput readByte];
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
                x += (short) [dataInput readUnsignedByte];
        }
        else
        {
            if (([_flags[i] charValue] & xShortVector) != 0)
                x += (short) -((short) [dataInput readUnsignedByte]);
            else
                x += [dataInput readShort];
        }
        [xCoordinates addObject:[NSNumber numberWithShort:x]];
    }

    for (int i = 0; i < length; ++i)
    {
        if (([_flags[i] charValue] & yDual) != 0)
        {
            if (([_flags[i] charValue] & yShortVector) != 0)
                y += (short) [dataInput readUnsignedByte];
        }
        else
        {
            if (([_flags[i] charValue] & yShortVector) != 0)
                y += (short) -((short) [dataInput readUnsignedByte]);
            else
                y += [dataInput readShort];
        }
        [yCoordinates addObject:[NSNumber numberWithShort:y]];
    }

    _xCoordinates = xCoordinates;
    _yCoordinates = yCoordinates;
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
