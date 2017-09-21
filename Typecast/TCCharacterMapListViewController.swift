//
//  TCCharacterMapListViewController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/7/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

class TCCharacterMapListViewController: NSViewController {
  weak var document: FontDocument?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
  }

  func showCharacterMaps(_ maps: [TCCmapIndexEntry]) {
    let windowController = TCCharacterMapWindowController(windowNibName: NSNib.Name(rawValue: "CharacterMapWindow"))
    document?.addWindowController(windowController)
    windowController.cmapIndexEntry = maps.last
    windowController.showWindow(self)
  }
}
