//
//  TCGlyphView.h
//  Type Designer
//
//  Created by David Schweinsberg on 19/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "TCGlyphDescription.h"
#import "TCGlyph.h"

@interface TCGlyphView : NSView

//@property (weak) id <TCGlyphDescription> glyphDescription;
@property (strong) TCGlyph *glyph;

@end
