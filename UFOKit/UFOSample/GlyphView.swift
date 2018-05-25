//
//  GlyphView.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/20/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

class GlyphView: NSView {

  struct ControlPoint {
    var position: CGPoint
    var onCurve: Bool
  }

  var unitsPerEm = 1024
  var xMin = 0
  var xMax = 0
  var yMin = 0
  var yMax = 0
  var ascent = 0
  var descent = 0
  var leftSideBearing = 0
  var advanceWidth = 0
  var glyphPath: CGPath?
  var controlPoints = [ControlPoint]()
  private var translate = CGPoint(x: 0, y: 0)
  private var scale: CGFloat = 1.0
//  private var scale: CGFloat = 0.2
  var controlPointsVisible = true

  override init(frame: NSRect) {
    super.init(frame:frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func draw(_ dirtyRect: NSRect) {
    guard let context = NSGraphicsContext.current?.cgContext else {
      return
    }

    context.setFillColor(CGColor.white)
    context.fill(self.bounds)

    context.scaleBy(x: CGFloat(scale), y: scale)
    context.translateBy(x: translate.x, y: translate.y)
    context.setLineWidth(2)

    // Draw grid
    let unitsPerEmBy2 = unitsPerEm / 2
    context.setStrokeColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
    context.move(to: CGPoint(x: -unitsPerEmBy2, y: 0))
    context.addLine(to: CGPoint(x: unitsPerEmBy2, y: 0))
    context.move(to: CGPoint(x: 0, y: -unitsPerEmBy2))
    context.addLine(to: CGPoint(x: 0, y: unitsPerEmBy2))
    context.strokePath()

    context.setStrokeColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
    context.move(to: CGPoint(x: xMin, y: yMin))
    context.addLine(to: CGPoint(x: xMax, y: yMin))
    context.addLine(to: CGPoint(x: xMax, y: yMax))
    context.addLine(to: CGPoint(x: xMin, y: yMax))
    context.addLine(to: CGPoint(x: xMin, y: yMin))
    context.strokePath()

    // Draw guides
    context.setStrokeColor(red: 0.25, green: 0.25, blue: 1.0, alpha: 1.0)
    context.move(to: CGPoint(x: -unitsPerEmBy2, y: ascent))
    context.addLine(to: CGPoint(x: unitsPerEmBy2, y: ascent))
    context.move(to: CGPoint(x: -unitsPerEmBy2, y: descent))
    context.addLine(to: CGPoint(x: unitsPerEmBy2, y: descent))
    context.move(to: CGPoint(x: leftSideBearing, y: -unitsPerEmBy2))
    context.addLine(to: CGPoint(x: leftSideBearing, y: unitsPerEmBy2))
    context.move(to: CGPoint(x: advanceWidth, y: -unitsPerEmBy2))
    context.addLine(to: CGPoint(x: advanceWidth, y: unitsPerEmBy2))
    context.strokePath()

    // Render the glyph path
    if let path = glyphPath {
      context.addPath(path)
    }

    context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    context.strokePath()
//    context.fillPath()

    if controlPointsVisible {

      // Draw control points
      for cp in controlPoints {

        // Note: The original intention of scaling and translating the
        // following was to first restore the transformation matrix
        // so that no matter the scaling of the glyph, the control points
        // would appear as rects of a fixed size.
        //int x = (int) (_scaleFactor * ([point x] + _translate.x));
        //int y = (int) (_scaleFactor * ([point y] + _translate.y));
        let x = cp.position.x
        let y = cp.position.y

        // Set the point colour based on selection
        //            if (_selectedPoints.contains(_glyph.getPoint(i))) {
        //                g2d.setPaint(Color.blue);
        //            } else {
        //                g2d.setPaint(Color.black);
        //            }

        // Draw the point based on its type (on or off curve)
        context.addRect(CGRect(x: x - 2, y: y - 2, width: 5, height: 5))
        if cp.onCurve {
          context.fillPath()
        } else {
          context.strokePath()
          //            g2d.drawString(Integer.toString(i), x + 4, y - 4);
        }
      }
    }
  }
}

