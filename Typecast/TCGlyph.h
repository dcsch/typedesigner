//
//  TCGlyph.h
//  Type Designer
//
//  Created by David Schweinsberg on 20/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCGlyphDescription;
@class TCCharstring;

@interface TCGlyph : NSObject

@property short leftSideBearing;
@property int advanceWidth;
@property (strong) NSArray *points;

/**
 * Construct a Glyph from a TrueType outline described by
 * a GlyphDescription.
 * @param description The Glyph Description describing the glyph.
 * @param leftSideBearing The Left Side Bearing.
 * @param advanceWidth The advance width.
 */
- (id)initWithGlyphDescription:(id<TCGlyphDescription>)description
               leftSideBearing:(short)leftSideBearing
                  advanceWidth:(int)advanceWidth;

/**
 * Construct a Glyph from a PostScript outline described by a Charstring.
 * @param charstring The Charstring describing the glyph.
 * @param leftSideBearing The Left Side Bearing.
 * @param advanceWidth The advance width.
 */
- (id)initWithCharstring:(TCCharstring *)charstring
         leftSideBearing:(short)leftSideBearing
            advanceWidth:(int)advanceWidth;

@end
