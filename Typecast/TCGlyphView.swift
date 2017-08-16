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
  var font: TCFont?
  var glyphPath: CGPath?
  var translate = CGPoint(x: 0, y: 0)
  var scale: CGFloat = 1.0
  var controlPointsVisible = true

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

      if let font = self.font {
        let unitsPerEmBy2 = Int(font.headTable.unitsPerEm) / 2
        //_translate = NSMakePoint(1 * unitsPerEmBy2, 1 * unitsPerEmBy2);

        context.scaleBy(x: CGFloat(scale), y: scale)
        context.translateBy(x: translate.x, y: translate.y)

        context.setLineWidth(2)

        // Draw grid
        context.setStrokeColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
        context.move(to: CGPoint(x: -unitsPerEmBy2, y: 0))
        context.addLine(to: CGPoint(x: unitsPerEmBy2, y: 0))
        context.move(to: CGPoint(x: 0, y: -unitsPerEmBy2))
        context.addLine(to: CGPoint(x: 0, y: unitsPerEmBy2))
        context.strokePath()

        context.setStrokeColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        context.move(to: CGPoint(x: Int(font.headTable.xMin), y: Int(font.headTable.yMin)))
        context.addLine(to: CGPoint(x: Int(font.headTable.xMax), y: Int(font.headTable.yMin)))
        context.addLine(to: CGPoint(x: Int(font.headTable.xMax), y: Int(font.headTable.yMax)))
        context.addLine(to: CGPoint(x: Int(font.headTable.xMin), y: Int(font.headTable.yMax)))
        context.addLine(to: CGPoint(x: Int(font.headTable.xMin), y: Int(font.headTable.yMin)))
        context.strokePath()

        if let glyph = self.glyph {

          // Draw guides
          context.setStrokeColor(red: 0.25, green: 0.25, blue: 1.0, alpha: 1.0)
          context.move(to: CGPoint(x: -unitsPerEmBy2, y: font.ascent))
          context.addLine(to: CGPoint(x: unitsPerEmBy2, y: font.ascent))
          context.move(to: CGPoint(x: -unitsPerEmBy2, y: font.descent))
          context.addLine(to: CGPoint(x: unitsPerEmBy2, y: font.descent))
          context.move(to: CGPoint(x: glyph.leftSideBearing, y: -unitsPerEmBy2))
          context.addLine(to: CGPoint(x: glyph.leftSideBearing, y: unitsPerEmBy2))
          context.move(to: CGPoint(x: glyph.advanceWidth, y: -unitsPerEmBy2))
          context.addLine(to: CGPoint(x: glyph.advanceWidth, y: unitsPerEmBy2))
          context.strokePath()
        }
      }

      // Draw contours
      if glyphPath == nil {
        glyphPath = TCGlyphPathFactory.buildPath(with: glyph!)
      }

      // Render the glyph path
      context.addPath(glyphPath!)

      context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
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
