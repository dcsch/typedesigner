//
//  TCGlyphView.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/20/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

class TCGlyphView: NSView {

  var glyph: TCGlyph?
  var glyphPath: CGPath?
  var controlPointsVisible = true

  override class func initialize() {
    exposeBinding("glyph")
  }

  override init(frame: NSRect) {
    super.init(frame:frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)

    if glyph == nil {
      return
    }

    if let context = NSGraphicsContext.current()?.cgContext {

      //    if (_font)
      //    {
      //        int unitsPerEmBy2 = [[_font headTable] unitsPerEm] / 2;
      //        //_translate = NSMakePoint(1 * unitsPerEmBy2, 1 * unitsPerEmBy2);
      //        _translate = NSMakePoint(0, 0);
      //
      //        CGContextScaleCTM(context, _scaleFactor, _scaleFactor);
      //        CGContextTranslateCTM(context, _translate.x, _translate.y);
      //
      //        // Draw grid
      //        CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
      //        CGContextMoveToPoint(context, -unitsPerEmBy2, 0);
      //        CGContextAddLineToPoint(context, unitsPerEmBy2, 0);
      //        CGContextMoveToPoint(context, 0, -unitsPerEmBy2);
      //        CGContextAddLineToPoint(context, 0, unitsPerEmBy2);
      //        CGContextStrokePath(context);
      //
      //        // Draw guides
      //        CGContextSetRGBStrokeColor(context, 0.25, 0.25, 0.25, 1.0);
      //        CGContextMoveToPoint(context, -unitsPerEmBy2, [_font ascent]);
      //        CGContextAddLineToPoint(context, unitsPerEmBy2, [_font ascent]);
      //        CGContextMoveToPoint(context, -unitsPerEmBy2, [_font descent]);
      //        CGContextAddLineToPoint(context, unitsPerEmBy2, [_font descent]);
      //        CGContextMoveToPoint(context, [_glyph leftSideBearing], -unitsPerEmBy2);
      //        CGContextAddLineToPoint(context, [_glyph leftSideBearing], unitsPerEmBy2);
      //        CGContextMoveToPoint(context, [_glyph advanceWidth], -unitsPerEmBy2);
      //        CGContextAddLineToPoint(context, [_glyph advanceWidth], unitsPerEmBy2);
      //        CGContextStrokePath(context);
      //    }

      // Draw contours
      if glyphPath == nil {
        glyphPath = TCGlyphPathFactory.buildPath(with: glyph!)
      }

      // Render the glyph path
      context.addPath(glyphPath!)
      context.strokePath()
//      context.fillPath()

      // TODO Implement control points in a different layer, in a different place entirely
      if controlPointsVisible {

        // Draw control points
        for point in (glyph?.points)! {

          // Note: The original intention of scaling and translating the
          // following was to first restore the transformation matrix
          // so that no matter the scaling of the glyph, the control points
          // would appear as rects of a fixed size.
          //int x = (int) (_scaleFactor * ([point x] + _translate.x));
          //int y = (int) (_scaleFactor * ([point y] + _translate.y));
          let x = Int(point.x)
          let y = Int(point.y)

          // Set the point colour based on selection
          //            if (_selectedPoints.contains(_glyph.getPoint(i))) {
          //                g2d.setPaint(Color.blue);
          //            } else {
          //                g2d.setPaint(Color.black);
          //            }

          // Draw the point based on its type (on or off curve)
          context.addRect(CGRect(x: x - 2, y: y - 2, width: 5, height: 5))
          if point.onCurve {
            context.fillPath()
          } else {
            context.strokePath()
//            g2d.drawString(Integer.toString(i), x + 4, y - 4);
          }
        }
      }
    }
  }
}
