//
//  NamesViewController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 11/25/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import os.log

class NamesViewController: NSViewController, FontControllerConsumer {

  @IBOutlet var familyName: NSTextField?

  var fontController: FontController? {
    didSet {
      if let old = oldValue {
        old.removeSubscriber(self)
      }
      if let new = fontController {
        new.addSubscriber(self)
      }
      if let font = fontController?.font {
//        familyName?.stringValue = font.nameTable.record(nameID: .fullFontName)!.record
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

}

extension NamesViewController: FontSubscriber {

  func font(_ font: UFOFont, didChangeGlyphName glyphName: String) {
    os_log("NamesViewController: didChangeGlyphName:")
  }

}
