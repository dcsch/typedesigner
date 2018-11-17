//
//  UFOGlyph.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/25/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Foundation
import FontScript
import UFOKit

// Awkward adapter that we're going to have to do away with
class UFOToFSPointPen : UFOKit.PointPen {
  let fsPointPen: FontScript.PointPen

  init(fsPointPen: FontScript.PointPen) {
    self.fsPointPen = fsPointPen
  }

  func beginPath(identifier: String?) {
    if let identifier = identifier {
      fsPointPen.beginPath(identifier: identifier)
    } else {
      fsPointPen.beginPath()
    }
  }

  func endPath() {
    fsPointPen.endPath()
  }

  func addPoint(_ pt: CGPoint, segmentType: UFOKit.SegmentType, smooth: Bool, name: String?, identifier: String?) {
    var pointType: PointType
    switch segmentType {
    case .move:
      pointType = .move
    case .line:
      pointType = .line
    case .curve:
      pointType = .curve
    case .qCurve:
      pointType = .qCurve
    case .offCurve:
      pointType = .offCurve
    }
    fsPointPen.addCGPoint(pt, type: pointType, smooth: smooth, name: name, identifier: identifier)
  }

  func addComponent(baseGlyphName: String, transformation: CGAffineTransform, identifier: String?) throws {
    try fsPointPen.addComponent(withBaseGlyphName: baseGlyphName,
                                transformation: transformation,
                                identifier: identifier)
  }

}

class UFOGlyph : FontScript.Glyph, UFOKit.FSGlyph {

  // TODO: Temporary placeholders
  var note: String = ""
  var lib: Data = Data()
  var image: [String : Any] = [:]
  var guidelines: [[String : Any]] = []
  var anchors: [[String : Any]] = []

  var ufoPointPen: UFOKit.PointPen {
    get {
      return UFOToFSPointPen(fsPointPen: self.pointPen)
    }
  }

}
