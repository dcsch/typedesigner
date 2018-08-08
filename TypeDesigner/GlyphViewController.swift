//
//  GlyphViewController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/30/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import FontScript
import os.log

class GlyphViewController: NSViewController, FontControllerConsumer {

  @IBOutlet weak var scrollView: NSScrollView!
  @IBOutlet weak var glyphView: GlyphView!

  var fontController: FontController? {
    didSet {
      if let old = oldValue {
        old.removeSubscriber(self)
      }
      if let new = fontController {
        new.addSubscriber(self)
      }
      updateGlyph()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    glyphView?.layerContentsRedrawPolicy = .onSetNeedsDisplay

    // Listen to view resize notifications
    view.postsFrameChangedNotifications = true
    let nc = NotificationCenter.default
    nc.addObserver(forName: NSView.frameDidChangeNotification,
                   object: view,
                   queue: nil) { (Notification) in
      self.sizeToFit()
    }

//    scrollView!.hasHorizontalRuler = true
//    scrollView!.hasVerticalRuler = true
//    scrollView!.rulersVisible = true
  }

  func updateGlyph() {
    guard let font = fontController?.font,
      let glyphName = fontController?.glyphName,
      let glyphView = glyphView else { return }

    glyphView.unitsPerEm = font.unitsPerEm
    glyphView.xMin = Int(font.bounds.minX)
    glyphView.xMax = Int(font.bounds.maxX)
    glyphView.yMin = Int(font.bounds.minY)
    glyphView.yMax = Int(font.bounds.maxY)
    glyphView.ascent = Int(font.ufoInfo.ascender ?? 100)
    glyphView.descent = Int(font.ufoInfo.descender ?? 100)
//    glyphView.leftSideBearing = font.hmtxTable.leftSideBearing(at: glyphIndex)
//    glyphView.advanceWidth = font.hmtxTable.advanceWidth(at: glyphIndex)

    glyphView.transforms.removeAll()
    glyphView.glyphPaths.removeAll()
    glyphView.controlPoints.removeAll()

    let glyphs = font.defaultLayer.glyphs
    if let glyph = glyphs[glyphName] as? FontScript.Glyph {
      let pen = QuartzPen(layer: font.defaultLayer)
      glyph.draw(with: pen)

      glyphView.transforms.append(CGAffineTransform.identity)
      glyphView.glyphPaths.append(pen.path)

      sizeToFit()
    }
    glyphView.needsDisplay = true
  }

  func sizeToFit() {
    var boundingBox = fontController?.font.bounds ?? CGRect.zero
    for path in glyphView.glyphPaths {
      boundingBox = boundingBox.union(path.boundingBox)
    }
    calculateBounds(containing: boundingBox)
    glyphView.needsDisplay = true
  }

  func calculateBounds(containing rect: CGRect) {
    let margin: CGFloat = 20.0
    let bounds = rect
    let boundsAspectRatio = bounds.width / bounds.height
    let frame = glyphView.frame
    let frameAspectRatio = frame.width / frame.height
    let scale = frameAspectRatio < boundsAspectRatio ?
      bounds.width / frame.width :
      bounds.height / frame.height
    let width = frame.size.width * scale
    let height = frame.size.height * scale
    glyphView.bounds = bounds.insetBy(dx: (bounds.width - width) / 2.0 - 2.0 * margin,
                                      dy: (bounds.height - height) / 2.0 - 2.0 * margin)
  }

}

extension GlyphViewController: FontSubscriber {

  func font(_ font: UFOFont, didChangeGlyphName glyphName: String) {
    updateGlyph()
  }

}
