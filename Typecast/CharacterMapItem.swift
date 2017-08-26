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

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
  }

  override func mouseDown(with event: NSEvent) {
    if event.clickCount == 2 {
      let (document, fontIndex, glyphIndex) = representedObject as! (TCDocument, Int, Int)
      document.showGlyphWindow(fontIndex: fontIndex, glyphIndex: glyphIndex)
    } else {
      super.mouseDown(with: event)
    }
  }
}
