//
//  TCGlyfNullDescript.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/4/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCGlyfNullDescript: TCGlyfDescript {
//  var xMaximum: Int {
//    get {
//      return 0
//    }
//  }
//
//  var xMinimum: Int {
//    get {
//      return 0
//    }
//  }
//
//  var yMaximum: Int {
//    get {
//      return 0
//    }
//  }
//
//  var yMinimum: Int {
//    get {
//      return 0
//    }
//  }
//
//  var isComposite: Bool {
//    get {
//      return false
//    }
//  }
//
//  let glyphIndex: Int
//
//  init(glyphIndex: Int) {
//    self.glyphIndex = glyphIndex
//  }

  var description: String {
    get {
      return "Null Glyph"
    }
  }

  enum CodingKeys: String, CodingKey {
    case glyphIndex
    case xMaximum
    case xMinimum
    case yMaximum
    case yMinimum
  }

  override func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(glyphIndex, forKey: .glyphIndex)
    try container.encode(xMaximum, forKey: .xMaximum)
    try container.encode(xMinimum, forKey: .xMinimum)
    try container.encode(yMaximum, forKey: .yMaximum)
    try container.encode(yMinimum, forKey: .yMinimum)
  }
}
