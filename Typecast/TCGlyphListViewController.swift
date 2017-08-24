//
//  TCGlyphListViewController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/7/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

class TCGlyphListViewController: NSViewController {
  weak var document: TCDocument?

  override func viewDidLoad() {
    super.viewDidLoad()
      // Do view setup here.
  }

  func showGlyphs(_ glyphs: [TCGlyphDescription]) {
//    let windowController = TCGlyphWindowController(windowNibName: "GlyphWindow")
//    document?.addWindowController(windowController)
//    windowController.glyphDescription = glyphs.last
//    windowController.showWindow(self)
  }
}
