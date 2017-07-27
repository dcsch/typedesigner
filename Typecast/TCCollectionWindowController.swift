//
//  TCCollectionWindowController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/19/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

class TCCollectionWindowController: NSWindowController {

  override init(window: NSWindow?) {
    super.init(window: window)
    self.shouldCloseDocument = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func windowDidLoad() {
    super.windowDidLoad()

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }

  func showFonts(_ fonts: [TCFont]) {
    let windowController = TCTablesWindowController(windowNibName: "TablesWindow")
    self.document?.addWindowController(windowController)
    windowController.font = fonts.last
    windowController.showWindow(self)
  }
}
