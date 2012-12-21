//
//  TCGlyphView.m
//  Type Designer
//
//  Created by David Schweinsberg on 19/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCGlyphView.h"
#import "TCGlyphPathFactory.h"

@interface TCGlyphView ()
{
    CGPathRef _glyphPath;
}

@end

@implementation TCGlyphView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];

    if (_glyph == nil)
        return;

    if (_glyphPath == NULL)
    {
        _glyphPath = [TCGlyphPathFactory buildPathWithGlyph:_glyph];
    }

    // Render the glyph path
    CGContextAddPath(context, _glyphPath);
    CGContextStrokePath(context);
}

@end
