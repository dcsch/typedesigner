//
//  FontDocumentController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 9/1/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

class FontDocumentController: NSDocumentController {

  override init() {
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

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
}
