//
//  ImportViewController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 9/1/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import os.log

class ImportViewController: NSViewController {
  var importDocument: OpenTypeCollectionDocument? {
    didSet {
      tableView?.reloadData()
    }
  }
  @IBOutlet weak var tableView: NSTableView?
  @IBOutlet weak var openButton: NSButton?

  override func viewDidLoad() {
    super.viewDidLoad()
    openButton?.isEnabled = false
  }

  @IBAction func open(_ sender: Any?) {
    if let docController = NSDocumentController.shared as? FontDocumentController,
      let fonts = importDocument?.fontCollection?.fonts,
      let selectedRow = tableView?.selectedRow,
      selectedRow > -1 {
      docController.importFont = fonts[selectedRow]
      docController.newDocument(self)
      importDocument?.close()
    }
  }

  @IBAction func cancel(_ sender: Any?) {
    importDocument?.close()
  }
}

extension ImportViewController: NSTableViewDelegate, NSTableViewDataSource {

  func numberOfRows(in tableView: NSTableView) -> Int {
    if let count = importDocument?.fontCollection?.fonts.count {
      return count
    } else {
      return 0
    }
  }

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    guard let fonts = importDocument?.fontCollection?.fonts,
      let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Name"), owner: self) as? NSTableCellView
      else { return nil }
    view.textField?.stringValue = fonts[row].nameTable.record(nameID: .fullFontName)!.record
    return view
  }

  func tableViewSelectionDidChange(_ notification: Notification) {
    if let selectedRow = tableView?.selectedRow,
      selectedRow > -1 {
      openButton?.isEnabled = true
    } else {
      openButton?.isEnabled = false
    }
  }
}
