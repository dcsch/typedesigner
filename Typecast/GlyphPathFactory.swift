//
//  GlyphPathFactory.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/25/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log
import CFF

/**
 A factory for generating a CGPath from a glyph outline.
 */
class GlyphPathFactory {

  /**
   Build a [CGPath](https://developer.apple.com/documentation/coregraphics/cgpath)
   from a Glyph.  This glyph path can then be transformed and rendered.
   - returns: The glyph path
   - parameter glyph: The glyph for which to build a path
   */
  class func buildPath(with glyph: Glyph) -> CGPath {

    let glyphPath = CGMutablePath()

    // Iterate through all of the points in the glyph.  Each time we find a
    // contour end point, add the point range to the path.
    if let ttGlyph = glyph as? TTGlyph {
      var firstIndex = 0
      var count = 0
      for i in 0 ..< ttGlyph.points.count {
        count += 1
        if ttGlyph.points[i].endOfContour {
          addContourToPath(path: glyphPath, glyph: ttGlyph,
                           startIndex: firstIndex, count: count)
          firstIndex = i + 1
          count = 0
        }
      }
    } else if let t2Glyph = glyph as? T2Glyph {
      var firstIndex = 0
      var count = 0
      for i in 0 ..< t2Glyph.points.count {
        count += 1
        if t2Glyph.points[i].endOfContour {
          addContourToPath(path: glyphPath, glyph: t2Glyph,
                           startIndex: firstIndex, count: count)
          firstIndex = i + 1
          count = 0
        }
      }
    }
    return glyphPath
  }

  private class func midValue(_ a: Int, _ b: Int) -> Int {
    return a + (b - a) / 2
  }

  private class func addContourToPath(path: CGMutablePath, glyph: TTGlyph,
                                      startIndex: Int, count: Int) {
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
        os_log("addContourToPath case not catered for!!")
      }
    }
  }

  private class func addContourToPath(path: CGMutablePath, glyph: T2Glyph,
                                      startIndex: Int, count: Int) {
    var offset = 0
    while offset < count {
      let point = glyph.points[startIndex + offset % count]
      let point_plus1 = glyph.points[startIndex + (offset + 1) % count]
      let point_plus2 = glyph.points[startIndex + (offset + 2) % count]
      let point_plus3 = glyph.points[startIndex + (offset + 3) % count]

      if offset == 0 {
        path.move(to: CGPoint(x: point.x, y: point.y))
      }

      if point.onCurve && point_plus1.onCurve {
        path.addLine(to: CGPoint(x: point_plus1.x, y: point_plus1.y))
        offset += 1
      } else if (point.onCurve && !point_plus1.onCurve && !point_plus2.onCurve && point_plus3.onCurve) {
        path.addCurve(to: CGPoint(x: point_plus3.x, y: point_plus3.y),
                      control1: CGPoint(x: point_plus1.x, y: point_plus1.y),
                      control2: CGPoint(x: point_plus2.x, y: point_plus2.y))
        offset += 3
      } else {
        os_log("addContourToPath case not catered for!!")
        break
      }
    }
  }
}
