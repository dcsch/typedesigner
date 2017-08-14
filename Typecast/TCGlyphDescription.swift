//
//  TCGlyphDescription.swift
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

/**
 Specifies access to glyph description classes, simple and composite.
 */
@objc protocol TCGlyphDescription {

  var glyphIndex: Int { get }

  func endPtOfContours(index: Int) -> Int

  func flags(index: Int) -> UInt8

  func xCoordinate(index: Int) -> Int

  func yCoordinate(index: Int) -> Int

  var xMaximum: Int { get }

  var xMinimum: Int { get }

  var yMaximum: Int { get }

  var yMinimum: Int { get }

  var isComposite: Bool { get }

  var pointCount: Int { get }
  
  var contourCount: Int { get }
}
