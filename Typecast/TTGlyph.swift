//
//  TTGlyph.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/11/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

/**
 An individual TrueType glyph within a font.
 */
class TTGlyph: NSObject, Glyph {
  var glyphIndex: Int
  var leftSideBearing: Int
  var advanceWidth: Int
  var points = [Point]()

  /**
   Construct a Glyph from a TrueType outline described by
   a GlyphDescription.
   - parameter glyphDescription: The Glyph Description describing the glyph.
   - parameter leftSideBearing: The Left Side Bearing.
   - parameter advanceWidth: The advance width.
   */
  init(glyphDescription description: TCGlyphDescription,
       leftSideBearing: Int,
       advanceWidth: Int) {
    self.leftSideBearing = leftSideBearing
    self.advanceWidth = advanceWidth
    self.glyphIndex = -1
    super.init()
    self.read(description: description)
  }

  func read(description: TCGlyphDescription) {
    self.glyphIndex = description.glyphIndex
    var endPtIndex = 0
    points.removeAll()
    for i in 0..<description.pointCount {
      let endPt = description.endPtOfContours(at: endPtIndex) == i
      if endPt {
        endPtIndex += 1
      }
      let point = Point(x: description.xCoordinate(at: i),
                          y: description.yCoordinate(at: i),
                          onCurve: Int(description.flags(index: i) & TCGlyphFlag.onCurvePoint.rawValue) != 0,
                          endOfContour: endPt)
      points.append(point)
    }

    // Append the origin and advanceWidth points (n & n+1)
    let oPoint = Point(x: 0, y: 0, onCurve: true, endOfContour: true)
    points.append(oPoint)

    let awPoint = Point(x: advanceWidth, y: 0, onCurve: true, endOfContour: true)
    points.append(awPoint)
  }
}
