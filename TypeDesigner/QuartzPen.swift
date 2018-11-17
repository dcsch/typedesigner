//
//  QuartzPen.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/26/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Foundation
import FontScript
import os.log

class QuartzPen : Pen {
  let path = CGMutablePath()
  let layer: Layer?

  init(layer: Layer?) {
    self.layer = layer
  }

  func move(to point: CGPoint) {
    path.move(to: point)
  }

  func line(to point: CGPoint) {
    path.addLine(to: point)
  }

  func curve(to points: [NSValue]) {
    if points.count == 3 {
      let c1 = points[0].pointValue
      let c2 = points[1].pointValue
      let pt = points[2].pointValue
      path.addCurve(to: pt, control1: c1, control2: c2)
    } else if points.count == 2 {
      let c = points[0].pointValue
      let pt = points[1].pointValue
      path.addQuadCurve(to: pt, control: c)
//      os_log("NOTE addQuadCurve: to: %f, %f, control: %f, %f", pt.x, pt.y, c.x, c.y)
    }
  }

  func qCurve(to points: [NSValue]) {
    for (n, point) in points.enumerated() {
      if n < points.count - 2 {
        let c = point.pointValue
        let pt = QuartzPen.midPoint(point.pointValue, points[n + 1].pointValue)
        path.addQuadCurve(to: pt, control: c)
      } else {
        let c = point.pointValue
        let pt = points[n + 1].pointValue
        path.addQuadCurve(to: pt, control: c)
        break
      }
    }
  }

  func closePath() {
    path.closeSubpath()
  }

  func endPath() {
    path.closeSubpath()
  }

  func addComponent(name: String, transformation: CGAffineTransform) throws {
    if let layer = self.layer {
      let componentPen = QuartzPen(layer: layer)
      let glyph = layer.glyphs[name] as! FontScript.Glyph
      glyph.draw(with: componentPen)
      path.addPath(componentPen.path, transform: transformation)
    }
  }

  private class func midPoint(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
    return CGPoint(x: a.x + (b.x - a.x) / 2.0,
                   y: a.y + (b.y - a.y) / 2.0)
  }

}
