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
  @IBOutlet weak var zoomPopUpButton: NSPopUpButton!

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
//      self.sizeGlyphView()
    }
  }

  @IBAction func changeZoom(_ sender: Any?) {
    switch zoomPopUpButton.indexOfSelectedItem {
    case 0:
      scrollView.magnify(toFit: glyphView.frame)
    case 1:
      scrollView.magnification = 0.25
    case 2:
      scrollView.magnification = 0.5
    case 3:
      scrollView.magnification = 0.75
    case 4:
      scrollView.magnification = 1.0
    case 5:
      scrollView.magnification = 1.5
    case 6:
      scrollView.magnification = 2.0
    default:
      break
    }
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
    glyphView.points.removeAll()

    let glyphs = font.defaultLayer.glyphs
    if let glyph = glyphs[glyphName] as? FontScript.Glyph {
      let pen = QuartzPen(layer: font.defaultLayer)
      glyph.draw(with: pen)

      // Add the path for the glyph
      glyphView.transforms.append(CGAffineTransform.identity)
      glyphView.glyphPaths.append(pen.path)

      // Add the glyph's points
      var points = [Point]()
      for contour in glyph.contours {
        for point in contour.points {
          points.append(point)
        }
      }
      glyphView.points = points
      sizeGlyphView()
    }
    glyphView.needsDisplay = true
  }

  func sizeGlyphView() {
    var boundingBox = fontController?.font.bounds ?? CGRect.zero
    for path in glyphView.glyphPaths {
      boundingBox = boundingBox.union(path.boundingBox)
    }
    glyphView.setBoundsOrigin(boundingBox.origin)
    glyphView.frame = boundingBox
  }

}

extension GlyphViewController: FontSubscriber {

  func font(_ font: UFOFont, didChangeGlyphName glyphName: String) {
    updateGlyph()
  }

}
