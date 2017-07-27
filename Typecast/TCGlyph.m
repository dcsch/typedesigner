//
//  TCGlyph.m
//  Type Designer
//
//  Created by David Schweinsberg on 20/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCGlyph.h"
#import "TCGlyphDescription.h"
#import "TCGlyfDescript.h"
#import "Type_Designer-Swift.h"

@interface TCGlyph ()

- (void)readDescription:(id<TCGlyphDescription>)description;

@end

@implementation TCGlyph

- (id)initWithGlyphDescription:(id<TCGlyphDescription>)description
               leftSideBearing:(short)leftSideBearing
                  advanceWidth:(int)advanceWidth
{
    self = [super init];
    if (self)
    {
        _leftSideBearing = leftSideBearing;
        _advanceWidth = advanceWidth;
        [self readDescription:description];
    }
    return self;
}

- (id)initWithCharstring:(TCCharstring *)charstring
         leftSideBearing:(short)leftSideBearing
            advanceWidth:(int)advanceWidth
{
    self = [super init];
    if (self)
    {
        _leftSideBearing = leftSideBearing;
        _advanceWidth = advanceWidth;
//        if ([charstring isKindOf:[CharstringType2 class]])
//        {
//            T2Interpreter t2i = new T2Interpreter();
//            _points = t2i.execute((CharstringType2) cs);
//        }
//        else
//        {
//            //throw unsupported charstring type
//        }
    }
    return self;
}

- (void)readDescription:(id<TCGlyphDescription>)description
{
    int endPtIndex = 0;
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:[description pointCount] + 2];
    for (int i = 0; i < [description pointCount]; ++i)
    {
        BOOL endPt = [description endPtOfContoursAtIndex:endPtIndex] == i;
        if (endPt)
            ++endPtIndex;

        TCPoint *point = [[TCPoint alloc] initWithX:[description xCoordinateAtIndex:i]
                                                  y:[description yCoordinateAtIndex:i]
                                            onCurve:([description flagsAtIndex:i] & onCurve) != 0
                                       endOfContour:endPt
                                            touched:NO];
        [points addObject:point];
    }

    // Append the origin and advanceWidth points (n & n+1)
    TCPoint *point = [[TCPoint alloc] initWithX:0
                                              y:0
                                        onCurve:YES
                                   endOfContour:YES
                                        touched:NO];
    [points addObject:point];

    point = [[TCPoint alloc] initWithX:_advanceWidth
                                     y:0
                               onCurve:YES
                          endOfContour:YES
                               touched:NO];
    [points addObject:point];

    _points = points;
}

@end
