//
//  TCGlyphView.m
//  Type Designer
//
//  Created by David Schweinsberg on 19/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCGlyphView.h"
#import "TCGlyphPathFactory.h"
#import "TCHeadTable.h"

@interface TCGlyphView ()
{
    CGPathRef _glyphPath;
}

- (void)internalInit;

@end

@implementation TCGlyphView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self internalInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self internalInit];
    }
    return self;
}

- (void)internalInit
{
    _scaleFactor = 1.0;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (_glyph == nil)
        return;

    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];

    int unitsPerEmBy2 = [[_font headTable] unitsPerEm] / 2;
    //_translate = NSMakePoint(1 * unitsPerEmBy2, 1 * unitsPerEmBy2);
    _translate = NSMakePoint(0, 0);

    CGContextScaleCTM(context, _scaleFactor, _scaleFactor);
    CGContextTranslateCTM(context, _translate.x, _translate.y);

    // Draw grid
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
    CGContextMoveToPoint(context, -unitsPerEmBy2, 0);
    CGContextAddLineToPoint(context, unitsPerEmBy2, 0);
    CGContextMoveToPoint(context, 0, -unitsPerEmBy2);
    CGContextAddLineToPoint(context, 0, unitsPerEmBy2);
    CGContextStrokePath(context);

    // Draw guides
    CGContextSetRGBStrokeColor(context, 0.25, 0.25, 0.25, 1.0);
    CGContextMoveToPoint(context, -unitsPerEmBy2, [_font ascent]);
    CGContextAddLineToPoint(context, unitsPerEmBy2, [_font ascent]);
    CGContextMoveToPoint(context, -unitsPerEmBy2, [_font descent]);
    CGContextAddLineToPoint(context, unitsPerEmBy2, [_font descent]);
    CGContextMoveToPoint(context, [_glyph leftSideBearing], -unitsPerEmBy2);
    CGContextAddLineToPoint(context, [_glyph leftSideBearing], unitsPerEmBy2);
    CGContextMoveToPoint(context, [_glyph advanceWidth], -unitsPerEmBy2);
    CGContextAddLineToPoint(context, [_glyph advanceWidth], unitsPerEmBy2);
    CGContextStrokePath(context);

    // Draw contours
    if (_glyphPath == NULL)
        _glyphPath = [TCGlyphPathFactory buildPathWithGlyph:_glyph];

    // Render the glyph path
    CGContextAddPath(context, _glyphPath);
//    CGContextStrokePath(context);
    CGContextFillPath(context);
}

@end
