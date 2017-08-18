//
//  TCCharstringListViewController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/17/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import CFF

class TCCharstringListViewController: NSViewController {
  weak var document: TCDocument?

  override func viewDidLoad() {
      super.viewDidLoad()
      // Do view setup here.
  }

  func showGlyphs(_ charstrings: [CFFCharstring]) {
    let windowController = TCGlyphWindowController(windowNibName: "GlyphWindow")
    document?.addWindowController(windowController)
    windowController.charstring = charstrings.last
    windowController.showWindow(self)
  }
}
