//
//  TCGlyphPathFactory.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/25/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log

class TCGlyphPathFactory {

  class func midValue(_ a: Int, _ b: Int) -> Int {
    return a + (b - a) / 2
  }

  class func addContourToPath(path: CGMutablePath, glyph: TCGlyph, startIndex: Int, count: Int) {
    var offset = 0
    while offset < count {
      let point = glyph.points[startIndex + offset % count]
      let point_plus1 = glyph.points[startIndex + (offset + 1) % count]
      let point_plus2 = glyph.points[startIndex + (offset + 2) % count]

      if offset == 0 {
        path.move(to: CGPoint(x: point.x, y: point.y))
      }

      if point.onCurve && point_plus1.onCurve {
        path.addLine(to: CGPoint(x: point_plus1.x, y: point_plus1.y))
        offset += 1
      } else if point.onCurve && !point_plus1.onCurve && point_plus2.onCurve {
        path.addQuadCurve(to: CGPoint(x: point_plus2.x, y: point_plus2.y),
                          control: CGPoint(x: point_plus1.x, y: point_plus1.y))
        offset += 2
      } else if point.onCurve && !point_plus1.onCurve && !point_plus2.onCurve {
        path.addQuadCurve(to: CGPoint(x: midValue(point_plus1.x, point_plus2.x),
                                      y: midValue(point_plus1.y, point_plus2.y)),
                          control: CGPoint(x: point_plus1.x, y: point_plus1.y))
        offset += 2
      } else if !point.onCurve && !point_plus1.onCurve  {
        path.addQuadCurve(to: CGPoint(x: midValue(point.x, point_plus1.x),
                                      y: midValue(point.y, point_plus1.y)),
                          control: CGPoint(x: point.x, y: point.y))
        offset += 1
      } else if !point.onCurve && point_plus1.onCurve {
        path.addQuadCurve(to: CGPoint(x: point_plus1.x, y: point_plus1.y),
                          control: CGPoint(x: point.x, y: point.y))
        offset += 1
      } else {
        os_log("drawGlyph case not catered for!!")
      }
    }
  }

  class func buildPath(with glyph: TCGlyph) -> CGPath {

    let glyphPath = CGMutablePath()

    // Iterate through all of the points in the glyph.  Each time we find a
    // contour end point, add the point range to the path.
    var firstIndex = 0
    var count = 0
    for i in 0 ..< glyph.points.count {
      count += 1
      if glyph.points[i].endOfContour {
        addContourToPath(path: glyphPath, glyph: glyph, startIndex: firstIndex,
                         count: count)
        firstIndex = i + 1
        count = 0;
      }
    }
    return glyphPath
  }
}
