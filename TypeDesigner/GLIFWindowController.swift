//
//  GLIFWindowController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/31/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Cocoa

class GLIFWindowController: NSWindowController {

  override func windowDidLoad() {
    super.windowDidLoad()

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
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
        for child in parent.children {
          propagateToChildren(of: child)
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

}

// MARK: Font Subscriber Protocol

extension GLIFWindowController: FontSubscriber {

  func font(_ font: UFOFont, didChangeGlyphName glyphName: String) {
    //    document?.updateChangeCount(.changeDone)
  }

}
