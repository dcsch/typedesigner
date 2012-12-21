//
//  TCGlyphPathFactory.h
//  Type Designer
//
//  Created by David Schweinsberg on 21/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCGlyph;

@interface TCGlyphPathFactory : NSObject

+ (CGPathRef)buildPathWithGlyph:(TCGlyph *)glyph;

@end
