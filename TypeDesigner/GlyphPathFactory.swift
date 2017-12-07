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
  class func buildPath(with glyph: GlyfSimpleDescript) -> CGPath {

    let glyphPath = CGMutablePath()

    var beginPt = 0
    for endPt in glyph.endPtsOfContours {
      addContourToPath(path: glyphPath, glyph: glyph, beginPt: beginPt, endPt: endPt)
      beginPt = endPt + 1
    }

    return glyphPath
  }

  private class func addContourToPath(path: CGMutablePath,
                                      glyph: GlyfSimpleDescript,
                                      beginPt: Int, endPt: Int) {
    let count = endPt - beginPt + 1  // add one to connect last point to first
    var offset = 0
    while offset < count {
      let x = glyph.xCoordinates[beginPt + offset % count]
      let y = glyph.yCoordinates[beginPt + offset % count]
      let onCurve = glyph.flags[beginPt + offset % count].contains(.onCurvePoint)
      let x_plus1 = glyph.xCoordinates[beginPt + (offset + 1) % count]
      let y_plus1 = glyph.yCoordinates[beginPt + (offset + 1) % count]
      let onCurve_plus1 = glyph.flags[beginPt + (offset + 1) % count].contains(.onCurvePoint)
      let x_plus2 = glyph.xCoordinates[beginPt + (offset + 2) % count]
      let y_plus2 = glyph.yCoordinates[beginPt + (offset + 2) % count]
      let onCurve_plus2 = glyph.flags[beginPt + (offset + 2) % count].contains(.onCurvePoint)

      if offset == 0 {
        path.move(to: CGPoint(x: x, y: y))
      }

      if onCurve && onCurve_plus1 {
        path.addLine(to: CGPoint(x: x_plus1, y: y_plus1))
        offset += 1
      } else if onCurve && !onCurve_plus1 && onCurve_plus2 {
        path.addQuadCurve(to: CGPoint(x: x_plus2, y: y_plus2),
                          control: CGPoint(x: x_plus1, y: y_plus1))
        offset += 2
      } else if onCurve && !onCurve_plus1 && !onCurve_plus2 {
        path.addQuadCurve(to: CGPoint(x: midValue(x_plus1, x_plus2),
                                      y: midValue(y_plus1, y_plus2)),
                          control: CGPoint(x: x_plus1, y: y_plus1))
        offset += 2
      } else if !onCurve && !onCurve_plus1  {
        path.addQuadCurve(to: CGPoint(x: midValue(x, x_plus1),
                                      y: midValue(y, y_plus1)),
                          control: CGPoint(x: x, y: y))
        offset += 1
      } else if !onCurve && onCurve_plus1 {
        path.addQuadCurve(to: CGPoint(x: x_plus1, y: y_plus1),
                          control: CGPoint(x: x, y: y))
        offset += 1
      } else {
        os_log("addContourToPath case not catered for!!")
      }
    }
  }

//  class func buildPath(with glyph: Glyph) -> CGPath {
//
//    let glyphPath = CGMutablePath()
//
//    // Iterate through all of the points in the glyph.  Each time we find a
//    // contour end point, add the point range to the path.
//    if let ttGlyph = glyph as? TTGlyph {
//      var firstIndex = 0
//      var count = 0
//      for i in 0 ..< ttGlyph.points.count {
//        count += 1
//        if ttGlyph.points[i].endOfContour {
//          addContourToPath(path: glyphPath, glyph: ttGlyph,
//                           startIndex: firstIndex, count: count)
//          firstIndex = i + 1
//          count = 0
//        }
//      }
//    } else if let t2Glyph = glyph as? T2Glyph {
//      var firstIndex = 0
//      var count = 0
//      for i in 0 ..< t2Glyph.points.count {
//        count += 1
//        if t2Glyph.points[i].endOfContour {
//          addContourToPath(path: glyphPath, glyph: t2Glyph,
//                           startIndex: firstIndex, count: count)
//          firstIndex = i + 1
//          count = 0
//        }
//      }
//    }
//    return glyphPath
//  }

  private class func midValue(_ a: Int, _ b: Int) -> Int {
    return a + (b - a) / 2
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
