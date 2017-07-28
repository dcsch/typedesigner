//
//  TCGlyph.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/26/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

/**
 An individual glyph.
 */
class TCGlyph: NSObject {
  var leftSideBearing: Int
  var advanceWidth: Int
  var points: [TCPoint] = []

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
    super.init()
    self.read(description: description)
  }

  /**
   Construct a Glyph from a PostScript outline described by a Charstring.
   - parameter charstring: The Charstring describing the glyph.
   - parameter leftSideBearing: The Left Side Bearing.
   - parameter advanceWidth: The advance width.
   */
//  init(withCharstring charstring: TCCharstring,
//       leftSideBearing: Int,
//       advanceWidth: Int) {
//    super.init()
//    self.leftSideBearing = leftSideBearing
//    self.advanceWidth = advanceWidth
////        if ([charstring isKindOf:[CharstringType2 class]])
////        {
////            T2Interpreter t2i = new T2Interpreter();
////            _points = t2i.execute((CharstringType2) cs);
////        }
////        else
////        {
////            //throw unsupported charstring type
////        }
//  }

  func read(description: TCGlyphDescription) {
    var endPtIndex = 0
    points.removeAll()
    for i in 0 ..< description.pointCount() {
      let endPt = description.endPtOfContours(at: Int32(endPtIndex)) == i
      if endPt {
        endPtIndex += 1
      }
      let point = TCPoint(x: Int(description.xCoordinate(at: i)),
                          y: Int(description.yCoordinate(at: i)),
                          onCurve: (UInt8(description.flags(at: i)) & onCurve) != 0,
                          endOfContour: endPt)
      points.append(point)
    }

    // Append the origin and advanceWidth points (n & n+1)
    let oPoint = TCPoint(x: 0, y: 0, onCurve: true, endOfContour: true)
    points.append(oPoint)

    let awPoint = TCPoint(x: advanceWidth, y: 0, onCurve: true, endOfContour: true)
    points.append(awPoint)
  }
}
