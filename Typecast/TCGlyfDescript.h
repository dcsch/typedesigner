//
//  TCGlyfDescript.h
//  Typecast
//
//  Created by David Schweinsberg on 9/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCProgram.h"
#import "TCGlyphDescription.h"

@class TCGlyfTable;

// flags
extern const uint8_t onCurve;
extern const uint8_t xShortVector;
extern const uint8_t yShortVector;
extern const uint8_t repeat;
extern const uint8_t xDual;
extern const uint8_t yDual;


@interface TCGlyfDescript : TCProgram <TCGlyphDescription>

@property (weak) TCGlyfTable *parentTable;
@property int glyphIndex;
@property int numberOfContours;
@property short xMin;
@property short yMin;
@property short xMax;
@property short yMax;

- (id)initWithDataInput:(TCDataInput *)dataInput
            parentTable:(TCGlyfTable *)parentTable
             glyphIndex:(uint32_t)glyphIndex
       numberOfContours:(uint32_t)numberOfContours;

@end
