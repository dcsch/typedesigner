//
//  TCGlyphListViewController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/7/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

class TCGlyphListViewController: NSViewController, NSTableViewDelegate,
    NSTableViewDataSource {
  @IBOutlet weak var tableView: NSTableView?

  override func viewDidLoad() {
    super.viewDidLoad()
      // Do view setup here.
  }

  func numberOfRows(in tableView: NSTableView) -> Int {
    if let (_, table) = representedObject as? (TCDocument, TCGlyfTable) {
      return table.descript.count
    } else {
      return 0
    }
  }

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    if let (_, table) = representedObject as? (TCDocument, TCGlyfTable),
      let tableColumn = tableColumn {
      if tableColumn.identifier == "GlyphIndex",
        let view = tableView.make(withIdentifier: "GlyphIndex", owner: self) as? NSTableCellView {
        let descript = table.description(at: row)
        view.textField?.stringValue = String(descript.glyphIndex)
        return view
      } else if tableColumn.identifier == "GlyphName",
        let view = tableView.make(withIdentifier: "GlyphName", owner: self) as? NSTableCellView {
        let descript = table.description(at: row)
        view.textField?.stringValue = descript.name
        return view
      }
    }
    return nil
  }

  @IBAction func showGlyphWindow(_ sender: Any?) {
    if let (document, _) = representedObject as? (TCDocument, TCGlyfTable),
      let tableView = tableView,
      tableView.selectedRow >= 0 {
        document.showGlyphWindow(fontIndex: 0, glyphIndex: tableView.selectedRow)
    }
  }
}
