//
//  CharacterMapItem.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/24/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import os.log

class CharacterMapItem: NSCollectionViewItem {
  var characterMapViewController: FontViewController?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
  }

  override func mouseDown(with event: NSEvent) {
    if event.clickCount == 2,
      let controller = characterMapViewController {
      controller.performSegue(withIdentifier: "ShowGlyph", sender: self)
    } else {
      super.mouseDown(with: event)
    }
  }

}
