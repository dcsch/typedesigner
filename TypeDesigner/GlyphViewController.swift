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
    let glyphs = font.defaultLayer.glyphs
    if let glyph = glyphs[glyphName] as? UFOGlyph {
      glyphView.glyph = glyph
      sizeGlyphView()
    }
  }

  func sizeGlyphView() {
    var boundingBox = fontController?.font.bounds ?? CGRect.zero
    boundingBox = boundingBox.union(glyphView.glyphBoundingBox)
    glyphView.setBoundsOrigin(boundingBox.origin)
    glyphView.frame = boundingBox
  }

}

extension GlyphViewController: FontSubscriber {

  func font(_ font: UFOFont, didChangeGlyphName glyphName: String) {
    updateGlyph()
  }

}
