//
//  FontDocument.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import os.log

class FontDocument: NSDocument {
  var font: Font?

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
    let fontCollection = try FontCollection(data: data, isSuitcase: suitcase)
    if fontCollection.fonts.count > 1 {
//      self.fontCollection = fontCollection
    } else {
      self.font = fontCollection.fonts[0]
    }
  }

  override func read(from url: URL, ofType typeName: String) throws {
    try super.read(from: url, ofType: typeName)
  }

  override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
    let encoder = JSONEncoder()
    let data = try encoder.encode(font)
    return FileWrapper(regularFileWithContents: data)
  }

  override class var autosavesInPlace: Bool {
    return true
  }

  @IBAction func showTablesWindow(_ sender: Any?) {

//    // Show an existing tables window
//    for controller in windowControllers {
//      if controller is TCTablesWindowController {
//        controller.showWindow(self)
//        return
//      }
//    }
//
//    // Otherwise we create a new one
//    if let collection = fontCollection {
//
//      // TODO Manage collections
//      if collection.fonts.count == 1 {
//        let controller = TCTablesWindowController(windowNibName: "TablesWindow")
//        controller.font = collection.fonts[0]
//        addWindowController(controller)
//        controller.showWindow(self)
//      }
//    }
  }
}
