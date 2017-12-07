//
//  ImportWindowController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 9/14/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

class ImportWindowController: NSWindowController {

  override func windowDidLoad() {
    super.windowDidLoad()

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }

  override var document: AnyObject? {
    didSet {
      guard let importDocument = document as? ImportDocument,
        let importViewController = contentViewController as? ImportViewController
        else {
          return
      }
      importViewController.importDocument = importDocument
    }
  }
}
