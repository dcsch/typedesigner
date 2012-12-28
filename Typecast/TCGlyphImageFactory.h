//
//  TCGlyphImageFactory.h
//  Type Designer
//
//  Created by David Schweinsberg on 27/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCGlyph;

@interface TCGlyphImageFactory : NSObject

+ (NSImage *)buildImageWithGlyph:(TCGlyph *)glyph;

@end
