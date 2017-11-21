//
//  TCGlyfNullDescript.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/4/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCGlyfNullDescript: TCGlyfDescript {

  override init(glyphIndex: Int) {
    super.init(glyphIndex: glyphIndex)
  }

  var description: String {
    get {
      return "Null Glyph"
    }
  }

  private enum CodingKeys: CodingKey {
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let superDecoder = try container.superDecoder()
    try super.init(from: superDecoder)
  }

  override func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    let superEncoder = container.superEncoder()
    try super.encode(to: superEncoder)
  }
}
