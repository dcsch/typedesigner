//
//  GlyphView.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/20/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import FontScript
import os.log

class GlyphView: NSView {

  var unitsPerEm = 2048
  var xMin = 0
  var xMax = 0
  var yMin = 0
  var yMax = 0
  var ascent = 0
  var descent = 0
  var leftSideBearing = 0
  var advanceWidth = 0
  var glyphPaths = [CGPath]()
  var transforms = [CGAffineTransform]()
  var points = [Point]()
  var pointsVisible = true
  var pointSize: CGFloat = 8

  override init(frame: NSRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override var isOpaque: Bool {
    get {
      return true
    }
  }

  override var wantsDefaultClipping: Bool {
    get {
      return true
    }
  }

  override func draw(_ dirtyRect: NSRect) {
    // TODO: Only draw inside the dirtyRect

    guard let context = NSGraphicsContext.current?.cgContext else {
      return
    }

    context.setFillColor(.white)
    context.fill(dirtyRect)

    let scaleToOne = 1.0 / context.ctm.a
    context.setLineWidth(scaleToOne)

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
    for (path, transform) in zip(glyphPaths, transforms) {
      context.saveGState()
      context.concatenate(transform)
      context.addPath(path)
      context.restoreGState()
    }

    context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    context.strokePath()

    if pointsVisible {

      // Draw points
      for point in points {
        if point.type == .curve && point.smooth {
          drawSmoothNode(context: context, at: point.cgPoint, scale: scaleToOne)
        } else if point.type == .offCurve {
          drawControlPoint(context: context, at: point.cgPoint, scale: scaleToOne)
        } else {
          drawSharpNode(context: context, at: point.cgPoint, scale: scaleToOne)
        }
      }
    }
  }

  func drawSmoothNode(context: CGContext, at point: CGPoint, scale: CGFloat) {
    let halfPointSize = pointSize / 2.0
    context.setStrokeColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
    context.addEllipse(in: CGRect(x: point.x - halfPointSize * scale,
                                  y: point.y - halfPointSize * scale,
                                  width: pointSize * scale,
                                  height: pointSize * scale))
    context.strokePath()
  }

  func drawSharpNode(context: CGContext, at point: CGPoint, scale: CGFloat) {
    let halfPointSize = pointSize / 2.0
    context.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    context.addRect(CGRect(x: point.x - halfPointSize * scale,
                           y: point.y - halfPointSize * scale,
                           width: pointSize * scale,
                           height: pointSize * scale))
    context.strokePath()
  }

  func drawControlPoint(context: CGContext, at point: CGPoint, scale: CGFloat) {
    let halfPointSize = pointSize / 2.0
    context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    context.addRect(CGRect(x: point.x - halfPointSize * scale,
                           y: point.y - halfPointSize * scale,
                           width: pointSize * scale,
                           height: pointSize * scale))
    context.strokePath()
  }

}
