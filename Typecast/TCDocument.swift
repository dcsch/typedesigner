//
//  TCDocument.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import os.log

class TCDocument: NSDocument {

  var fontCollection: TCFontCollection?

  override func makeWindowControllers() {

//    if let collection = fontCollection {
//
//      // If this is a font collection, show the collection window, otherwise,
//      // show the character map window
//      if collection.fonts.count > 1 {
//        let controller = TCCollectionWindowController(windowNibName: "CollectionWindow")
//        addWindowController(controller)
//      } else if collection.fonts.count == 1 {
//        let controller = TCCharacterMapWindowController(windowNibName: "CharacterMapWindow")
//        let font = collection.fonts[0]
//        controller.cmapIndexEntry = font.cmapTable.entries.first
//        addWindowController(controller)
//      }
//    }

    // Returns the Storyboard that contains your Document window.
    let storyboard = NSStoryboard(name: "Main", bundle: nil)
    let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
    self.addWindowController(windowController)

    // Set the document
    if let viewController = windowController.contentViewController as? CharacterMapViewController {
      viewController.document = self
    }
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
    fontCollection = try TCFontCollection(data: data, isSuitcase: suitcase)
  }

  override func read(from url: URL, ofType typeName: String) throws {
    if typeName == "Font Suitcase"  {
      // The font data is in the resource fork, so load that
      let resourceURL = url.appendingPathComponent("..namedfork/rsrc")
      try super.read(from: resourceURL, ofType: typeName)
    } else {
      try super.read(from: url, ofType: typeName)
    }
  }

  override class func autosavesInPlace() -> Bool {
    return true
  }

  @IBAction func showTablesWindow(_ sender: Any?) {

    // Show an existing tables window
    for controller in windowControllers {
      if controller is TCTablesWindowController {
        controller.showWindow(self)
        return
      }
    }

    // Otherwise we create a new one
    if let collection = fontCollection {

      // TODO Manage collections
      if collection.fonts.count == 1 {
        let controller = TCTablesWindowController(windowNibName: "TablesWindow")
        controller.font = collection.fonts[0]
        addWindowController(controller)
        controller.showWindow(self)
      }
    }
  }

  func showGlyphWindow(fontIndex: Int, glyphIndex: Int) {

    // TODO We need to uniquely identify glyphs without them being instantiated
//    // Show an existing glyph window of this glyph
//    for controller in windowControllers {
//      if let glyphWindowController as? TCGlyphWindowController {
//        if glyphWindowController something something {
//          glyphWindowController.showWindow(self)
//          return
//        }
//      }
//    }

    // Otherwise create a new window
    let glyph = fontCollection?.fonts[fontIndex].glyph(at: glyphIndex)
    let controller = TCGlyphWindowController(windowNibName: "GlyphWindow")
    controller.glyph = glyph
    addWindowController(controller)
    controller.showWindow(self)
  }
}
