//
//  GlyphView.swift
//  UFOSample
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

  var unitsPerEm = 2048
  var xMin = 0
  var xMax = 0
  var yMin = 0
  var yMax = 0
  var ascent = 0
  var descent = 0
  var leftSideBearing = 0
  var advanceWidth = 0
  var glyphPath: CGPath?
  private var translate = CGPoint(x: 0, y: 0)
  private var scale: CGFloat = 1.0

  override init(frame: NSRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func draw(_ dirtyRect: NSRect) {
    guard let context = NSGraphicsContext.current?.cgContext else {
      return
    }

    context.setFillColor(NSColor.textBackgroundColor.cgColor)
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

    context.setStrokeColor(NSColor.textColor.cgColor)
    context.strokePath()
//    context.fillPath()
  }

}
