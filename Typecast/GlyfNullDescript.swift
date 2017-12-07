//
//  TCGlyfNullDescript.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/4/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCGlyfNullDescript: TCGlyfDescript, Codable {

  override var description: String {
    get {
      return "Null Glyph"
    }
  }
}
