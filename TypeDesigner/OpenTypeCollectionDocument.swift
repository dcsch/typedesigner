//
//  OpenTypeCollectionDocument.swift
//  Type Designer
//
//  Created by David Schweinsberg on 9/14/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

class OpenTypeCollectionDocument: NSDocument {
  var converter: FontConverter?

  override init() {
    super.init()
    hasUndoManager = false
  }

  override func makeWindowControllers() {
    let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
    let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Document Import Controller")) as! NSWindowController
    self.addWindowController(windowController)
  }

  override func windowControllerDidLoadNib(_ aController: NSWindowController) {
    super.windowControllerDidLoadNib(aController)
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
  }

  override func data(ofType typeName: String) throws -> Data {
    throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
  }

  override func read(from data: Data, ofType typeName: String) throws {
    var suitcase = false
    if typeName == "Font Suitcase" || typeName == "Datafork TrueType font" {
      suitcase = true
    }
    converter = try OpenTypeConverter(openTypeData: data, isSuitcase: suitcase)
  }

  override class var autosavesInPlace: Bool {
    return false
  }
}
