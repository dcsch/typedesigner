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
  var names = [String]()
  var importDocument: OpenTypeCollectionDocument? {
    didSet {
      if let converter = importDocument?.converter {
        names = converter.fontNames
        tableView?.reloadData()
      }
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
      let converter = importDocument?.converter,
      let selectedRow = tableView?.selectedRow,
      selectedRow > -1 {
      do {
        docController.importFont = try converter.convert(index: selectedRow)
        docController.newDocument(self)
      } catch {
        os_log("Failed to convert font")
      }
      importDocument?.close()
    }
  }

  @IBAction func cancel(_ sender: Any?) {
    importDocument?.close()
  }
}

extension ImportViewController: NSTableViewDelegate, NSTableViewDataSource {

  func numberOfRows(in tableView: NSTableView) -> Int {
    return names.count
  }

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    guard let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Name"), owner: self) as? NSTableCellView
      else { return nil }
    view.textField?.stringValue = names[row]
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
