//
//  TCGlyphPathFactory.m
//  Type Designer
//
//  Created by David Schweinsberg on 21/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCGlyphPathFactory.h"
#import "TCGlyph.h"
#import "TCPoint.h"
#import <ApplicationServices/ApplicationServices.h>

static int midValue(int a, int b)
{
    return a + (b - a) / 2;
}

static void addContourToPath(CGMutablePathRef path, TCGlyph *glyph, int startIndex, int count)
{
    int offset = 0;
    while (offset < count)
    {
        //TCPoint *point_minus1 = [glyph points][(offset == 0) ? startIndex + count - 1 : startIndex + (offset - 1) % count];
        TCPoint *point = [glyph points][startIndex + offset % count];
        TCPoint *point_plus1 = [glyph points][startIndex + (offset + 1) % count];
        TCPoint *point_plus2 = [glyph points][startIndex + (offset + 2) % count];

        if (offset == 0)
            CGPathMoveToPoint(path, NULL, [point x], [point y]);

        if (point.onCurve && point_plus1.onCurve)
        {
            CGPathAddLineToPoint(path, NULL, [point_plus1 x], [point_plus1 y]);
            offset++;
        }
        else if (point.onCurve && !point_plus1.onCurve && point_plus2.onCurve)
        {
            CGPathAddQuadCurveToPoint(path, NULL, [point_plus1 x], [point_plus1 y], [point_plus2 x], [point_plus2 y]);
            offset+=2;
        }
        else if (point.onCurve && !point_plus1.onCurve && !point_plus2.onCurve)
        {
            CGPathAddQuadCurveToPoint(path, NULL, [point_plus1 x], [point_plus1 y], midValue([point_plus1 x], [point_plus2 x]), midValue([point_plus1 y], [point_plus2 y]));
            offset+=2;
        }
        else if (!point.onCurve && !point_plus1.onCurve)
        {
            CGPathAddQuadCurveToPoint(path, NULL, [point x], [point y], midValue([point x], [point_plus1 x]), midValue([point y], [point_plus1 y]));
            offset++;
        }
        else if (!point.onCurve && point_plus1.onCurve)
        {
            CGPathAddQuadCurveToPoint(path, NULL, [point x], [point y], [point_plus1 x], [point_plus1 y]);
            offset++;
        }
        else
        {
            NSLog(@"drawGlyph case not catered for!!");
        }
    }
}

@implementation TCGlyphPathFactory

+ (CGPathRef)buildPathWithGlyph:(TCGlyph *)glyph
{
//    if (glyph == nil)
//        return nil;

    CGMutablePathRef glyphPath = CGPathCreateMutable();

    // Iterate through all of the points in the glyph.  Each time we find a
    // contour end point, add the point range to the path.
    int firstIndex = 0;
    int count = 0;
    for (int i = 0; i < [[glyph points] count]; ++i)
    {
        count++;
        if ([[glyph points][i] isEndOfContour]) {
            addContourToPath(glyphPath, glyph, firstIndex, count);
            firstIndex = i + 1;
            count = 0;
        }
    }
    return glyphPath;
}

@end
