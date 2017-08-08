//
//  TCGlyfNullDescript.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/4/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCGlyfNullDescript: NSObject, TCGlyfDescript {

  let glyphIndex: Int

  init(glyphIndex: Int) {
    self.glyphIndex = glyphIndex
    super.init()
  }

  var name: String {
    get {
        return "Null Glyph"
    }
  }

  override var description: String {
    get {
      return self.name
    }
  }
}
