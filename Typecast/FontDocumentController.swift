//
//  FontDocumentController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 9/1/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import os.log

class FontDocumentController: NSDocumentController {
  var importFont: Font?

  override init() {
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func openUntitledDocumentAndDisplay(_ displayDocument: Bool) throws -> NSDocument {
    let document = try super.openUntitledDocumentAndDisplay(displayDocument)
    return document
  }

//  func openUntitledDocument(withFont font: Font, displayDocument: Bool) throws -> NSDocument {
//    let document = try makeDocument(withFont: font)
//    addDocument(document)
//    if displayDocument {
//      document.makeWindowControllers()
//    }
//    return document
//  }

  override func makeDocument(withContentsOf url: URL, ofType typeName: String) throws -> NSDocument {
    let resourceURL: URL
    if typeName == "Font Suitcase"  {
      // The font data is in the resource fork, so load that
      resourceURL = url.appendingPathComponent("..namedfork/rsrc")
    } else {
      resourceURL = url
    }
    return try super.makeDocument(withContentsOf: resourceURL, ofType: typeName)
  }

  override func makeUntitledDocument(ofType typeName: String) throws -> NSDocument {
    let document = try super.makeUntitledDocument(ofType: typeName)
    if let fontDocument = document as? FontDocument {
      fontDocument.font = importFont
      importFont = nil
    }
    return document
  }

//  func makeDocument(withFont font: Font) throws -> NSDocument {
//    let document = try makeUntitledDocument(ofType: "TrueType font")
//    return document
//  }
}
