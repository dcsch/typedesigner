//
//  GlyphViewController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/30/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import os.log

class GlyphViewController: NSViewController, FontControllerConsumer {

  @IBOutlet weak var scrollView: NSScrollView?
  @IBOutlet weak var glyphView: GlyphView?

  var fontController: FontController? {
    didSet {
      if let old = oldValue { old.removeSubscriber(self) }
      if let new = fontController { new.addSubscriber(self) }
      updateGlyph()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    glyphView?.layerContentsRedrawPolicy = .onSetNeedsDisplay

    // Listen to view resize notifications
    view.postsFrameChangedNotifications = true
    let nc = NotificationCenter.default
    nc.addObserver(forName: .NSViewFrameDidChange,
                   object: view,
                   queue: nil) { (Notification) in
      self.calculateGlyphViewSize()
    }

//    scrollView!.hasHorizontalRuler = true
//    scrollView!.hasVerticalRuler = true
//    scrollView!.rulersVisible = true
  }

  func updateGlyph() {
    if let font = fontController?.font,
      let glyphIndex = fontController?.glyphIndex {
      glyphView?.glyph = font.glyph(at: glyphIndex)
      glyphView?.font = font
      calculateGlyphViewSize()
    }
  }

  func calculateGlyphViewSize() {

    // Calculate a space in which to place the glyph in font design units. This
    // will be limited by the xMin, yMin, xMax, and yMax values in the
    // head table.
    if let rect = scrollView?.bounds {
      glyphView?.frame = NSRect(x: -rect.size.width,
                                y: -rect.size.height,
                                width: rect.size.width,
                                height: rect.size.height)
    }

    if let font = fontController?.font {
      let head = font.headTable
      glyphView?.bounds = CGRect(x: Int(head.xMin), y: Int(head.yMin),
                                 width: Int(head.xMax) - Int(head.xMin),
                                 height: Int(head.yMax) - Int(head.yMin))
    }
    glyphView?.needsDisplay = true
  }
}

extension GlyphViewController: FontSubscriber {
  func font(_ font: Font, didChangeGlyphIndex glyphIndex: Int) {
    os_log("GlyphViewController:didChangeGlyphIndex:")
    updateGlyph()
  }
}
