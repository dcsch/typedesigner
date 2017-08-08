//
//  TCTablesWindowController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/7/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

class TCTablesWindowController: NSWindowController, NSTableViewDelegate {
  var font: TCFont?
  var containedViewController: NSViewController?
  @IBOutlet weak var containerView: NSView?
  @IBOutlet weak var tableArrayController: NSArrayController?

  override func windowDidLoad() {
    super.windowDidLoad()

    if let fontCollection = (document as! TCDocument).fontCollection {

      if font == nil {

        // Select the first font in the collection
        font = fontCollection.fonts[0]
      }

      // If this is the only font in the collection, then closing this
      // window should close the document
      if fontCollection.fonts.count == 1 {
        self.shouldCloseDocument = true
      }
    }
  }

  override func windowTitle(forDocumentDisplayName displayName: String) -> String {
    return "\(font!.name) (\(displayName))"
  }

  func tableViewSelectionDidChange(_ notification: Notification) {
    containedViewController?.view.removeFromSuperview()
    containerView?.removeConstraints((containerView?.constraints)!)
    containedViewController = nil

    if let table = (tableArrayController?.selectedObjects as! [TCTable]).last {
      if table.type == TCTableType.glyf.rawValue {
        if let vc = TCGlyphListViewController(nibName: "GlyphListView", bundle: nil) {
          vc.representedObject = table
          vc.document = document as? TCDocument
          containedViewController = vc
        }
      } else if table.type == TCTableType.cmap.rawValue {
        if let vc = TCCharacterMapListViewController(nibName: "CharacterMapListView", bundle: nil) {
          vc.representedObject = table
          vc.document = document as? TCDocument
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
}
