//
//  TCGlyfDescript.m
//  Typecast
//
//  Created by David Schweinsberg on 9/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCGlyfDescript.h"
#import "TCDataInput.h"

// flags
const uint8_t onCurve = 0x01;
const uint8_t xShortVector = 0x02;
const uint8_t yShortVector = 0x04;
const uint8_t repeat = 0x08;
const uint8_t xDual = 0x10;
const uint8_t yDual = 0x20;

@implementation TCGlyfDescript

- (id)initWithDataInput:(TCDataInput *)dataInput
            parentTable:(TCGlyfTable *)parentTable
             glyphIndex:(uint32_t)glyphIndex
       numberOfContours:(uint32_t)numberOfContours
{
    self = [super init];
    if (self)
    {
        _parentTable = parentTable;
        _numberOfContours = numberOfContours;
        _xMin = [dataInput readShort];
        _yMin = [dataInput readShort];
        _xMax = [dataInput readShort];
        _yMax = [dataInput readShort];
    }
    return self;
}

@end
