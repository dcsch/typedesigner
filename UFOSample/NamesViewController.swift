//
//  NamesViewController.swift
//  UFOSample
//
//  Created by David Schweinsberg on 5/21/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Cocoa

class NamesViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

  @IBOutlet var tableView: NSTableView!
  var names = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
  }

  func numberOfRows(in tableView: NSTableView) -> Int {
    return names.count
  }

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cellId = NSUserInterfaceItemIdentifier(rawValue: "TableViewCell")
    let view = tableView.makeView(withIdentifier: cellId, owner: self) as! NSTableCellView
    view.textField!.stringValue = names[row]
    return view
  }

  func tableViewSelectionDidChange(_ notification: Notification) {

  }
}
