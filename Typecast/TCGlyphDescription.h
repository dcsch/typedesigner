//
//  TCGlyphDescription.h
//  Typecast
//
//  Created by David Schweinsberg on 9/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCGlyphDescription <NSObject>

- (int)glyphIndex;

- (int)endPtOfContoursAtIndex:(int)index;

- (char)flagsAtIndex:(int)index;

- (short)xCoordinateAtIndex:(int)index;

- (short)yCoordinateAtIndex:(int)index;

- (short)xMaximum;

- (short)xMinimum;

- (short)yMaximum;

- (short)yMinimum;

- (BOOL)isComposite;

- (int)pointCount;

- (int)contourCount;

@end
