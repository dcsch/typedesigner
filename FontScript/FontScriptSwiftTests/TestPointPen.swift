//
//  TestPointPen.swift
//  FontScriptSwiftTests
//
//  Created by David Schweinsberg on 7/15/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Foundation
import FontScript

class TestPointPen : NSObject, PointPen
{
  func addCGPoint(_ point: CGPoint, type: Point.Type, smooth: Bool) {
  }

  var records = Array<String>()

  func beginPath() {
    records.append("beginPath")
  }

  func beginPath(identifier: String) {
    records.append("beginPath \"\(identifier)\"")
  }

  func endPath() {
    records.append("endPath")
  }

  func addPoint(_ point: Point) {
    records.append("add (\(point.x), \(point.y))")
  }

  func addPoints(_ points: [Point]) {
    var str = "curveTo"
    for point in points {
      str += " (\(point.x), \(point.y))"
    }
    records.append(str)
  }

//  func addCGPoint(_ point: CGPoint, type: Point.Type, smooth: Bool) {
//  }
//
//  func addCGPoint(_ point: CGPoint, type: Point.Type, smooth: Bool, name: String?, identifier: String?) {
//  }

  func addComponent(withBaseGlyphName baseGlyphName: String,
                    transformation: CGAffineTransform,
                    identifier: String?) throws {
  }

}
