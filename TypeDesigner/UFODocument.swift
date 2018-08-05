//
//  UFODocument.swift
//  Type Designer
//
//  Created by David Schweinsberg on 5/25/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Cocoa
import UFOKit

class UFODocument: NSDocument {
  var font: UFOFont?

  override init() {
    super.init()
    hasUndoManager = true
  }

  override func makeWindowControllers() {
    let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
    let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Document Window Controller")) as! NSWindowController

    // This will set the window controller's document property, so the data
    // must be set up by that point
    self.addWindowController(windowController)
  }

  override func windowControllerDidLoadNib(_ aController: NSWindowController) {
    super.windowControllerDidLoadNib(aController)
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
  }

  override func data(ofType typeName: String) throws -> Data {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
  }

  override func read(from data: Data, ofType typeName: String) throws {
    var suitcase = false
    if typeName == "Font Suitcase" || typeName == "Datafork TrueType font" {
      suitcase = true
    }
    let converter = try OpenTypeConverter(openTypeData: data, isSuitcase: suitcase)
    font = try converter.convert(index: 0)
  }

  override func read(from url: URL, ofType typeName: String) throws {
    if typeName == "Unified Font Object" {
      let ufoReader = try UFOReader(url: url)
      font = try UFOFont(reader: ufoReader)
    } else {
      try super.read(from: url, ofType: typeName)
    }
  }

  override class var autosavesInPlace: Bool {
    return true
  }
}
