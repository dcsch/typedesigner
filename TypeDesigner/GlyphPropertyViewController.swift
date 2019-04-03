//
//  GlyphPropertyViewController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 12/17/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Cocoa

class GlyphPropertyViewController: NSViewController, FontControllerConsumer {
  var fontController: FontController?

  @IBOutlet var nameTextField: NSTextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
  }
    
}

extension GlyphPropertyViewController: FontSubscriber {

  func font(_ font: UFOFont, didChangeGlyphName glyphName: String) {
  }

}
