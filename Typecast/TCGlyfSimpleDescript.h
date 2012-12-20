//
//  TCGlyfSimpleDescript.h
//  Typecast
//
//  Created by David Schweinsberg on 9/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCGlyfDescript.h"
#import "TCGlyphDescription.h"

@interface TCGlyfSimpleDescript : TCGlyfDescript <TCGlyphDescription>

@property (strong) NSArray *endPtsOfContours;
@property (strong) NSArray *flags;
@property (strong) NSArray *xCoordinates;
@property (strong) NSArray *yCoordinates;
@property uint32_t count;

@end
