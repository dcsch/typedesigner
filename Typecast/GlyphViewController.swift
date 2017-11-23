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
    nc.addObserver(forName: NSView.frameDidChangeNotification,
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
      glyphView?.unitsPerEm = font.headTable.unitsPerEm
      glyphView?.xMin = font.headTable.xMin
      glyphView?.xMax = font.headTable.xMax
      glyphView?.yMin = font.headTable.yMin
      glyphView?.yMax = font.headTable.yMax
      glyphView?.ascent = font.hheaTable.ascender
      glyphView?.descent = font.hheaTable.descender
      glyphView?.leftSideBearing = font.hmtxTable.leftSideBearing(at: glyphIndex)
      glyphView?.advanceWidth = font.hmtxTable.advanceWidth(at: glyphIndex)

      glyphView?.transforms.removeAll()
      glyphView?.glyphPaths.removeAll()

      if let ttFont = font as? TTFont {
        let descript = ttFont.glyfTable.descript[glyphIndex]
        if let simpleDescript = descript as? TCGlyfSimpleDescript {

          // Since this is a simple glyph, append the single glyph path, along with
          // the identity matrix for "no transformation"
          glyphView?.transforms.append(CGAffineTransform.identity)
          glyphView?.glyphPaths.append(GlyphPathFactory.buildPath(with: simpleDescript))
        } else if let compositeDescript = descript as? TCGlyfCompositeDescript {

          // Add a glyph path for each component of the composite glyph, building a
          // transformation matrix for each part
          for component in compositeDescript.components {
            let componentGlyphIndex = component.glyphIndex
            if let componentDescript = ttFont.glyfTable.descript[componentGlyphIndex] as? TCGlyfSimpleDescript {
              let transform = CGAffineTransform(a: CGFloat(component.xscale), b: CGFloat(component.scale01),
                                                c: CGFloat(component.scale10), d: CGFloat(component.yscale),
                                                tx: CGFloat(component.xtranslate), ty: CGFloat(component.ytranslate))
              glyphView?.transforms.append(transform)
              glyphView?.glyphPaths.append(GlyphPathFactory.buildPath(with: componentDescript))
            }
          }
        }
        os_log("updateGlyph: %@", String(describing: descript))
      }
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
//    os_log("GlyphViewController:didChangeGlyphIndex:")
    updateGlyph()
  }
}
