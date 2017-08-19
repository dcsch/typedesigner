//
//  TCGlyphWindowController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/26/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import os.log
import CFF

class TCGlyphWindowController: NSWindowController {

  var glyphDescription: TCGlyphDescription?
  var charstring: CFFCharstring?
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

//    scrollView!.hasHorizontalRuler = true
//    scrollView!.hasVerticalRuler = true
//    scrollView!.rulersVisible = true

    let fontCollection = (self.document as! TCDocument).fontCollection

    // TODO: Don't just select the first font
    if let font = fontCollection?.fonts[0] {

      if let glyphDescription = self.glyphDescription {

        // TrueType glyph outline
        let glyphIndex = glyphDescription.glyphIndex
        let glyph = TCTTGlyph(glyphDescription: glyphDescription,
                              leftSideBearing: font.hmtxTable.leftSideBearing(at: glyphIndex),
                              advanceWidth: font.hmtxTable.advanceWidth(at: glyphIndex))
        glyphView?.glyph = glyph
      } else if let charstring = self.charstring {

        // CFF glyph outline
        do {
          let cffTable = try font.table() as TCCffTable
          let globalSubrIndex = cffTable.globalSubrIndex
          let font = cffTable.fonts[0]
          let localSubrIndex = font.localSubrIndex
          let glyph = TCT2Glyph(charstring: charstring,
                                localSubrIndex: localSubrIndex,
                                globalSubrIndex: globalSubrIndex,
                                leftSideBearing: 0, advanceWidth: 0)
          glyphView?.glyph = glyph
        } catch {
          os_log("Error loading CFF glyph")
        }
      }
      glyphView?.font = font

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
    // will be limited by the xMin, yMin, xMax, and yMax values in the
    // head table.

    let fontCollection = (self.document as! TCDocument).fontCollection

    if let rect = scrollView?.bounds {
      glyphView?.frame = NSRect(x: -rect.size.width,
                                y: -rect.size.height,
                                width: rect.size.width,
                                height: rect.size.height)
    }

    // TODO: Don't just select the first font
    if let font = fontCollection?.fonts[0] {
      let head = font.headTable
      glyphView?.bounds = CGRect(x: Int(head.xMin), y: Int(head.yMin),
                                 width: Int(head.xMax) - Int(head.xMin),
                                 height: Int(head.yMax) - Int(head.yMin))
    }
    glyphView?.needsDisplay = true
  }
}