//
//  ViewController.swift
//  UFOSample
//
//  Created by David Schweinsberg on 12/18/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import AppKit
import UFOKit

class ViewController: NSViewController {

  @IBOutlet weak var glyphView: GlyphView!
  @IBOutlet weak var popUpButton: NSPopUpButton!

  var fontBounds = CGRect(x: 0, y: 0, width: 0, height: 0)

  override func viewDidLoad() {
    super.viewDidLoad()

    NotificationCenter.default.addObserver(forName: NSWindow.didResizeNotification,
                                           object: view.window,
                                           queue: nil, using: windowResized)

  }

  func windowResized(_ notification: Notification) {
    sizeToFit()
  }

  func sizeToFit() {
    if let path = glyphView.glyphPath {
      let boundingBox = fontBounds.union(path.boundingBox)
      calculateBounds(containing: boundingBox)
      glyphView.needsDisplay = true
    }
  }

  func calculateBounds(containing rect: CGRect) {
    let margin: CGFloat = 20.0
    let bounds = rect
    let boundsAspectRatio = bounds.width / bounds.height
    let frame = glyphView.frame
    let frameAspectRatio = frame.width / frame.height
    let scale = frameAspectRatio < boundsAspectRatio ?
      bounds.width / frame.width :
      bounds.height / frame.height
    let width = frame.size.width * scale
    let height = frame.size.height * scale
    glyphView.bounds = bounds.insetBy(dx: (bounds.width - width) / 2.0 - 2.0 * margin,
                                      dy: (bounds.height - height) / 2.0 - 2.0 * margin)
  }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }
}
