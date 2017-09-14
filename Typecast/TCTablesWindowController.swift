//
//  TCTablesWindowController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/7/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

class TCTablesWindowController: NSWindowController, NSTableViewDelegate,
    NSTableViewDataSource {
  var font: Font?
  var containedViewController: NSViewController?
  @IBOutlet weak var containerView: NSView?
  @IBOutlet weak var tableView: NSTableView?

  override func windowDidLoad() {
    super.windowDidLoad()

    if let font = (document as! FontDocument).font {

      if self.font == nil {

        // Select the first font in the collection
        self.font = font
      }
      configureDetailView()

      // If this is the only font in the collection, then closing this
      // window should close the document
//      if fontCollection.fonts.count == 1 {
//        self.shouldCloseDocument = true
//      }
    }
  }

  override func windowTitle(forDocumentDisplayName displayName: String) -> String {
    return "\(font!.name) (\(displayName))"
  }

  func configureDetailView() {
    containedViewController?.view.removeFromSuperview()
    containerView?.removeConstraints((containerView?.constraints)!)
    containedViewController = nil

    if let tableView = self.tableView,
      tableView.selectedRow >= 0,
      let table = font?.tables[tableView.selectedRow] {
      let tag = type(of: table).tag
      if tag == TCTableTag.glyf.rawValue {
        if let vc = TCGlyphListViewController(nibName: "GlyphListView", bundle: nil) {
          vc.representedObject = (document, table)
          containedViewController = vc
        }
      } else if tag == TCTableTag.CFF.rawValue {
          if let vc = TCCharstringListViewController(nibName: "CharstringListView", bundle: nil) {
            vc.representedObject = (table as! TCCffTable).fonts[0]
            vc.document = document as? FontDocument
            containedViewController = vc
          }
      } else if tag == TCTableTag.cmap.rawValue {
        if let vc = TCCharacterMapListViewController(nibName: "CharacterMapListView", bundle: nil) {
          vc.representedObject = table
          vc.document = document as? FontDocument
          containedViewController = vc
        }
      } else {
        if let vc = TCDumpViewController(nibName: "DumpView", bundle: nil) {
          vc.representedObject = table
          vc.document = document as? FontDocument
          containedViewController = vc
        }
      }
    }

    if let vc = containedViewController {

      // Put into the container view
      vc.view.translatesAutoresizingMaskIntoConstraints = false
      containerView?.addSubview(vc.view)

      // Add constraints that fill the container view
      containerView?.addConstraint(
        NSLayoutConstraint(item: vc.view,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: containerView,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 0.0))

      containerView?.addConstraint(
        NSLayoutConstraint(item: vc.view,
                           attribute: .left,
                           relatedBy: .equal,
                           toItem: containerView,
                           attribute: .left,
                           multiplier: 1.0,
                           constant: 0.0))

      containerView?.addConstraint(
        NSLayoutConstraint(item: vc.view,
                           attribute: .right,
                           relatedBy: .equal,
                           toItem: containerView,
                           attribute: .right,
                           multiplier: 1.0,
                           constant: 0.0))

      containerView?.addConstraint(
        NSLayoutConstraint(item: vc.view,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: containerView,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 0.0))
    }
  }

  func numberOfRows(in tableView: NSTableView) -> Int {
    if let count = font?.tables.count {
      return count
    } else {
      return 0
    }
  }

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    if let view = tableView.make(withIdentifier: "TableName", owner: self) as? NSTableCellView,
      let font = self.font {
      let tag = type(of: font.tables[row]).tag
      let name = String(format: "%c%c%c%c",
                        CChar(truncatingBitPattern:tag >> 24),
                        CChar(truncatingBitPattern:tag >> 16),
                        CChar(truncatingBitPattern:tag >> 8),
                        CChar(truncatingBitPattern:tag))
      view.textField?.stringValue = name
      return view
    }
    return nil
  }

  func tableViewSelectionDidChange(_ notification: Notification) {
    configureDetailView()
  }
}
