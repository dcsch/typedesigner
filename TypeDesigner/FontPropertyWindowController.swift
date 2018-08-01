//
//  FontPropertyWindowController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 11/25/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

class FontPropertyWindowController: NSWindowController {

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
        for childVC in parent.childViewControllers {
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
}

// MARK: Font Subscriber Protocol

extension FontPropertyWindowController: FontSubscriber {
  func font(_ font: UFOFont, didChangeGlyphName glyphName: String) {
  }
}
