//
//  TCGlyphView.h
//  Type Designer
//
//  Created by David Schweinsberg on 19/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "TCFont.h"
#import "TCGlyph.h"

@interface TCGlyphView : NSView

//@property (strong) TCFont *font;
@property (strong) TCGlyph *glyph;
@property BOOL controlPointsVisible;

//@property NSPoint translate;
//@property double scaleFactor;

@end
