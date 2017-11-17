//
//  TCGlyfDescript.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/3/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

enum TCGlyphFlag: UInt8 {
  case onCurvePoint = 0x01
  case xShortVector = 0x02
  case yShortVector = 0x04
  case repeatFlag = 0x08
  case xDual = 0x10
  case yDual = 0x20
}

//protocol TCGlyfDescript {
//  var glyphIndex: Int { get }
//
//  var xMaximum: Int { get }
//
//  var xMinimum: Int { get }
//
//  var yMaximum: Int { get }
//
//  var yMinimum: Int { get }
//
//  var isComposite: Bool { get }
//}

class TCGlyfDescript: Encodable {
  var glyphIndex: Int

  var xMaximum: Int {
    get {
      return 0
    }
  }

  var xMinimum: Int {
    get {
      return 0
    }
  }

  var yMaximum: Int {
    get {
      return 0
    }
  }

  var yMinimum: Int {
    get {
      return 0
    }
  }

  var isComposite: Bool {
    get {
      return false
    }
  }

  init(glyphIndex: Int) {
    self.glyphIndex = glyphIndex
  }

//  enum CodingKeys: String, CodingKey {
//    case glyphIndex
//    case xMaximum
//    case xMinimum
//    case yMaximum
//    case yMinimum
//  }

  func encode(to encoder: Encoder) throws {
//    var container = encoder.container(keyedBy: CodingKeys.self)
//    try container.encode(glyphIndex, forKey: .glyphIndex)
//    try container.encode(xMaximum, forKey: .xMaximum)
//    try container.encode(xMinimum, forKey: .xMinimum)
//    try container.encode(yMaximum, forKey: .yMaximum)
//    try container.encode(yMinimum, forKey: .yMinimum)
  }
}

