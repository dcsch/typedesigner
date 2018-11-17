//
//  FontDocumentWindowController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 9/1/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import os.log

class FontDocumentWindowController: NSWindowController, NSWindowDelegate {

  override func windowDidLoad() {
    super.windowDidLoad()

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.shouldCloseDocument = true
  }

  func windowDidChangeOcclusionState(_ notification: Notification) {
    let window = notification.object as! NSWindow
    if window.occlusionState.contains(NSWindow.OcclusionState.visible) {
    }
  }

  var fontController: FontController? {
    willSet {
      fontController?.removeSubscriber(self)
    }

    didSet {

      // We want to abstractly push state down the view controller hierarchy; we walk down the chain and assign the controller to the children that need it
      func propagateToChildren(of parent: NSViewController) {
        if var fontControllerConsumer: FontControllerConsumer = parent as? FontControllerConsumer {
          fontControllerConsumer.fontController = fontController
        }
        for childVC in parent.children {
          propagateToChildren(of: childVC)
        }
      }

      // Push down from our contentViewController to all children
      propagateToChildren(of: contentViewController!)

//      // Push to our titlebar accessory view controllers
//      effectsAccessoryViewController.fontController = fontController

      // Subscribe to font changes
      fontController?.addSubscriber(self)
    }
  }

  override var document: AnyObject? {
    didSet {
      guard let fontDocument = document as? UFODocument else { return }
      if fontDocument.font == nil {
        fontDocument.font = UFOFont()
      }
      fontController = FontController(font: fontDocument.font!)
    }
  }

  func windowWillReturnUndoManager(_ window: NSWindow) -> UndoManager? {
    return self.nextResponder?.undoManager
  }

  func windowDidEndSheet(_ notification: Notification) {
    os_log("windowDidEndSheet")
  }

  @IBAction func buildFont(_ sender: Any?) {
    guard let fontDocument = document as? OpenTypeDocument,
      let font = fontDocument.font else { return }
    let savePanel = NSSavePanel()
    savePanel.prompt = "Build"
    savePanel.message = "We're gonna build you a sweet font."
    savePanel.canCreateDirectories = true
    savePanel.isExtensionHidden = false
    savePanel.canSelectHiddenExtension = false
    savePanel.allowedFileTypes = ["ttf"]
    savePanel.allowsOtherFileTypes = false
    savePanel.beginSheetModal(for: window!) { (response: NSApplication.ModalResponse) in
      if response == .OK {
        do {
          try font.buildFont(url: savePanel.url!)
        }
        catch {
          os_log("Failed to build font")
        }
      }
    }
  }

}

// MARK: Font Subscriber Protocol

extension FontDocumentWindowController: FontSubscriber {

  func font(_ font: UFOFont, didChangeGlyphName glyphName: String) {
//    document?.updateChangeCount(.changeDone)
  }

}
