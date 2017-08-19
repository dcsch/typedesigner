//
//  TCDumpViewController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/18/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

class TCDumpViewController: NSViewController {
  weak var document: TCDocument?
  @IBOutlet weak var textView: NSTextView?

  override func viewDidLoad() {
    super.viewDidLoad()

    // For whatever reason, Interface Builder isn't letting us set the font,
    // so we do it here
    textView?.font = NSFont(name: "Courier", size: 12)
  }
    
}
