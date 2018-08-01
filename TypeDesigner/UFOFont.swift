//
//  UFOFont.swift
//  Type Designer
//
//  Created by David Schweinsberg on 5/25/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Cocoa
import FontScript
import UFOKit

class UFOFont : FontScript.Font {
  var ufoInfo: UFOKit.FontInfo
  var libProps: RoboFontLib
  var bounds: CGRect

  var unitsPerEm: Int {
    get {
      return Int(ufoInfo.unitsPerEm ?? 2048)
    }
    set {
      ufoInfo.unitsPerEm = Double(newValue)
    }
  }

  override init() {
    ufoInfo = UFOKit.FontInfo()
    libProps = RoboFontLib()
    bounds = CGRect.zero
    super.init()
  }

  init(reader: UFOReader) throws {

    ufoInfo = try reader.readInfo()
    let libData = try reader.readLib()
    let decoder = PropertyListDecoder()
    libProps = try decoder.decode(RoboFontLib.self, from: libData)
    bounds = CGRect.zero

    super.init()

    if let names = libProps.glyphOrder {
      let layer = newLayer(name: "default", color: CGColor.black)
      let glyphSet = try reader.glyphSet()
      for name in names {
        let glyph = layer.newGlyph(name: name, clear: false) as! UFOGlyph
        try glyphSet.readGlyph(glyphName: name, pointPen: glyph.ufoPointPen)
        bounds = bounds.union(glyph.bounds)
      }
    }
  }

  override func layer(name: String, color: CGColor) -> Layer {
    return UFOLayer(name: name, color: color)
  }

}
