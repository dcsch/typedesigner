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

@objc protocol GlyphViewDelegate {
  @objc func undoManager(for view: GlyphView) -> UndoManager?
}

class GlyphView: NSView {
  @IBOutlet var delegate: GlyphViewDelegate?
  private var unitsPerEm = 2048
  private var xMin = 0
  private var xMax = 0
  private var yMin = 0
  private var yMax = 0
  private var ascent = 0
  private var descent = 0
  private var leftSideBearing = 0
  private var advanceWidth = 0
  private var glyphPath: CGPath?
  private var scaleToOne: CGFloat = 1.0
  private var bPoints = [BPoint]()
  private var selection = [BPoint]()
  private var mouseDownLocation = CGPoint.zero
  private var mouseDraggedLocation = CGPoint.zero
  var pointsVisible = true
  var pointSize: CGFloat = 8

  var glyph: UFOGlyph? {
    didSet {
      updateGlyphPath()

      // Cache the bPoints
      bPoints.removeAll()
      if let glyph = self.glyph {
        for contour in glyph.contours {
          bPoints.append(contentsOf: contour.bPoints)
        }
      }
      self.needsDisplay = true
    }
  }

  var glyphBoundingBox: CGRect {
    get {
      return glyphPath?.boundingBox ?? CGRect.zero
    }
  }

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

    context.setFillColor(NSColor.textBackgroundColor.cgColor)
    context.fill(dirtyRect)

    scaleToOne = 1.0 / context.ctm.a
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
    if let path = glyphPath {
      context.addPath(path)
      context.setStrokeColor(NSColor.textColor.cgColor)
      context.strokePath()
    }

    if pointsVisible {

      // Draw points
      for bPoint in bPoints {
        if bPoint.type == .curve {
          drawSmoothNode(context: context, at: bPoint.anchor, scale: scaleToOne)
        } else {
          drawSharpNode(context: context, at: bPoint.anchor, scale: scaleToOne)
        }

        let bcpIn = bPoint.bcpIn
        if bcpIn != CGPoint.zero {
          let absoluteControlPoint = CGPoint(x: bPoint.anchor.x + bcpIn.x,
                                             y: bPoint.anchor.y + bcpIn.y)
          context.move(to: bPoint.anchor)
          context.addLine(to: absoluteControlPoint)
          context.setStrokeColor(CGColor(gray: 0.6, alpha: 1.0))
          context.strokePath()
          drawControlPoint(context: context, at: absoluteControlPoint, scale: scaleToOne)
        }

        let bcpOut = bPoint.bcpOut
        if bcpOut != CGPoint.zero {
          let absoluteControlPoint = CGPoint(x: bPoint.anchor.x + bcpOut.x,
                                             y: bPoint.anchor.y + bcpOut.y)
          context.move(to: bPoint.anchor)
          context.addLine(to: absoluteControlPoint)
          context.setStrokeColor(CGColor(gray: 0.6, alpha: 1.0))
          context.strokePath()
          drawControlPoint(context: context, at: absoluteControlPoint, scale: scaleToOne)
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

  func updateGlyphPath() {
    if let glyph = self.glyph {
      if let font = glyph.font as? UFOFont {
        unitsPerEm = font.unitsPerEm
        xMin = Int(font.bounds.minX)
        xMax = Int(font.bounds.maxX)
        yMin = Int(font.bounds.minY)
        yMax = Int(font.bounds.maxY)
        ascent = Int(font.ufoInfo.ascender ?? 100)
        descent = Int(font.ufoInfo.descender ?? 100)
      }
      let pen = QuartzPen(layer: glyph.layer)
      glyph.draw(with: pen)
      glyphPath = pen.path
    }
  }

  override func mouseDown(with event: NSEvent) {
    selection.removeAll()
    mouseDownLocation = convert(event.locationInWindow, from: nil)
    mouseDraggedLocation = mouseDownLocation
    let halfPointSize = pointSize / 2.0
    if pointsVisible {
      for bPoint in bPoints {
        let pointRect = CGRect(x: bPoint.anchor.x - halfPointSize * scaleToOne,
                               y: bPoint.anchor.y - halfPointSize * scaleToOne,
                               width: pointSize * scaleToOne,
                               height: pointSize * scaleToOne)
        if pointRect.contains(mouseDownLocation) {
          selection.append(bPoint)
        }
      }
    }
  }

  override func mouseUp(with event: NSEvent) {
    let newLocation = convert(event.locationInWindow, from: nil)
    let delta = CGPoint(x: newLocation.x - mouseDraggedLocation.x,
                        y: newLocation.y - mouseDraggedLocation.y)
    for bPoint in selection {
      bPoint.move(by: delta)
    }
    updateGlyphPath()
    self.needsDisplay = true

    if let undoManager = delegate?.undoManager(for: self) {
      let deltaToPrev = CGPoint(x: mouseDownLocation.x - newLocation.x,
                                y: mouseDownLocation.y - newLocation.y)
      for bPoint in selection {
        undoManager.registerUndo(withTarget: bPoint) {
          $0.move(by: deltaToPrev)
        }
      }
    }
  }

  override func mouseDragged(with event: NSEvent) {
    let newLocation = convert(event.locationInWindow, from: nil)
    let delta = CGPoint(x: newLocation.x - mouseDraggedLocation.x,
                        y: newLocation.y - mouseDraggedLocation.y)
    for bPoint in selection {
      bPoint.move(by: delta)
    }
    mouseDraggedLocation = newLocation
    updateGlyphPath()
    self.needsDisplay = true
  }

}
