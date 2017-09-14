//
//  ImportViewController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 9/1/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import os.log

class ImportViewController: NSViewController, NSTableViewDelegate,
    NSTableViewDataSource {
  @IBOutlet weak var tableView: NSTableView?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
  }

  override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
    os_log("prepare for segue")
  }
}
