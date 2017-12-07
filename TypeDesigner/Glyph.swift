//
//  Glyph.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/26/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

/**
 An individual glyph within a font.
 */
protocol Glyph {
  var glyphIndex: Int { get }
  var advanceWidth: Int { get }
  var leftSideBearing: Int { get }
//  var points: [TCPoint] { get }
}
