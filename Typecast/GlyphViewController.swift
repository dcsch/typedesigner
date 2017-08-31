//
//  GlyphViewController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/30/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

class GlyphViewController: NSViewController {
  @IBOutlet weak var scrollView: NSScrollView?
  @IBOutlet weak var glyphView: TCGlyphView?

  override func viewDidLoad() {
    super.viewDidLoad()

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

  var glyphReference: (TCFont?, TCGlyph?) {
    didSet {
      if let font = glyphReference.0 {
        glyphView?.glyph = glyphReference.1
        glyphView?.font = font
        calculateGlyphViewSize()
      }
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

    if let font = glyphReference.0 {
      let head = font.headTable
      glyphView?.bounds = CGRect(x: Int(head.xMin), y: Int(head.yMin),
                                 width: Int(head.xMax) - Int(head.xMin),
                                 height: Int(head.yMax) - Int(head.yMin))
    }
    glyphView?.needsDisplay = true
  }
}
