//
//  TCGlyphWindowController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/26/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

class TCGlyphWindowController: NSWindowController {

  var glyphDescription: TCGlyphDescription?
  @IBOutlet weak var scrollView: NSScrollView?
  @IBOutlet weak var glyphView: TCGlyphView?

  override init(window: NSWindow?) {
    super.init(window: window)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func windowDidLoad() {
    super.windowDidLoad()

    // Listen to view resize notifications
    self.window?.contentView?.postsFrameChangedNotifications = true
    let nc = NotificationCenter.default
    nc.addObserver(forName: .NSViewFrameDidChange,
                   object: self.window?.contentView,
                   queue: nil) { (Notification) in
      self.calculateGlyphViewSize()
    }

    scrollView!.hasHorizontalRuler = true
    scrollView!.hasVerticalRuler = true
    scrollView!.rulersVisible = true

    let fontCollection = (self.document as! TCDocument).fontCollection

    // TODO: Don't just select the first font
    if let font = fontCollection?.fonts[0] {

      let glyphIndex = Int((glyphDescription?.glyphIndex)!)

      let glyph = TCGlyph(glyphDescription: glyphDescription!,
                          leftSideBearing: Int((font.hmtxTable?.leftSideBearing(index: glyphIndex))!),
                          advanceWidth: Int((font.hmtxTable?.advanceWidth(index: glyphIndex))!))
      glyphView?.glyph = glyph

      calculateGlyphViewSize()
    }
  }

  override func windowTitle(forDocumentDisplayName displayName: String) -> String {
    if let index = glyphDescription?.glyphIndex {
      return "\(displayName) – \(index)"
    } else {
      return "\(displayName)"
    }
  }

  func calculateGlyphViewSize() {

    // Calculate a space in which to place the glyph in font design units. This
    // will include a substantial blank space around the glyph.

    let fontCollection = (self.document as! TCDocument).fontCollection

    // TODO: Don't just select the first font
    if let font = fontCollection?.fonts[0] {

      // Visible height: head.yMax - 2 * hhea.yDescender
      let visibleBottom = Int(2 * (font.hheaTable?.descender)!)
      let visibleHeight = Int((font.headTable?.yMax)!) - visibleBottom
      let visibleLeft = visibleBottom
      let visibleWidth = visibleHeight

      glyphView?.bounds = CGRect(origin: CGPoint(x: visibleLeft, y: visibleBottom),
                                 size: CGSize(width: visibleWidth, height: visibleHeight))
    }

    if let rect = scrollView?.bounds {
      glyphView?.frame = NSRect(x: -rect.size.height,
                                y: -rect.size.height,
                                width: 3 * rect.size.height,
                                height: 3 * rect.size.height)
    }
    glyphView?.needsDisplay = true
  }
}
