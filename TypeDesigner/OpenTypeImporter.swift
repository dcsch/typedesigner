//
//  OpenTypeImporter.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/1/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Foundation
import FontScript

class OpenTypeImporter {
  var fontCollection: OpenTypeFontCollection

  init(openTypeData: Data, isSuitcase: Bool) throws {
    fontCollection = try OpenTypeFontCollection(data: openTypeData, isSuitcase: isSuitcase)
  }

  var fontCount: Int {
    get {
      return fontCollection.fonts.count
    }
  }

  func convert(index: Int) throws -> UFOFont {
    let otFont = fontCollection.fonts[index]
    let ufoFont = UFOFont()

    let layer = ufoFont.newLayer(name: "default", color: CGColor.black)
    var bounds = CGRect.zero

    if let ttFont = otFont as? TTFont {

      // Convert all the glyph names
      var i = 0

      for descript in ttFont.glyfTable.descript {

        let name = otFont.postTable.name(at: i) ?? "glyph\(i)"
        i = i + 1

        ufoFont.libProps.glyphOrder.append(name)

        if descript is GlyfNullDescript {
          layer.glyphs[name] = UFOGlyph(name: name, layer: layer)
        } else if let simpleDescript = descript as? GlyfSimpleDescript {
          let glyph = OpenTypeImporter.convert(glyph: simpleDescript, name: name, layer: layer)
          bounds = bounds.union(glyph.bounds)
          layer.glyphs[name] = glyph
        } else if let compositeDescript = descript as? GlyfCompositeDescript {
          let glyph = OpenTypeImporter.convert(glyph: compositeDescript, otFont: otFont, name: name, layer: layer)
          bounds = bounds.union(glyph.bounds)
          layer.glyphs[name] = glyph
        }
      }
    }
    ufoFont.bounds = bounds;

    return ufoFont
  }

  class func convert(glyph: GlyfSimpleDescript, name: String, layer: Layer?) -> UFOGlyph {
    let ufoGlyph = UFOGlyph(name: name, layer: layer)
    var beginPt = 0
    for endPt in glyph.endPtsOfContours {
      let contour = contourFromPoints(glyph: glyph, beginPt: beginPt, endPt: endPt)
      ufoGlyph.appendContour(contour, offset: CGPoint.zero)
      beginPt = endPt + 1
    }
    return ufoGlyph
  }

  class func convert(glyph: GlyfCompositeDescript, otFont: OpenTypeFont, name: String, layer: Layer?) -> UFOGlyph {
    let ufoGlyph = UFOGlyph(name: name, layer: layer)
    for component in glyph.components {
      let componentName = otFont.postTable.name(at: component.glyphIndex) ?? "glyph\(component.glyphIndex)"
      let tranform = CGAffineTransform(a: CGFloat(component.xscale), b: CGFloat(component.scale01),
                                       c: CGFloat(component.scale10), d: CGFloat(component.yscale),
                                       tx: CGFloat(component.xtranslate), ty: CGFloat(component.ytranslate))
      let ufoComponent = Component(baseGlyphName: componentName)
      ufoComponent.transformation = tranform
      ufoGlyph.appendComponent(ufoComponent)
    }
    return ufoGlyph
  }

  private class func contourFromPoints(glyph: GlyfSimpleDescript,
                                       beginPt: Int, endPt: Int) -> Contour {
    // Extract the points of the contour
    var rawContour = [(CGPoint, Bool)]()
    let count = endPt - beginPt + 1
    for offset in 0..<count {
      let x = glyph.xCoordinates[beginPt + offset]
      let y = glyph.yCoordinates[beginPt + offset]
      let onCurve = glyph.flags[beginPt + offset].contains(.onCurvePoint)
      rawContour.append((CGPoint(x: x, y: y), onCurve))
    }

    // Build the contour
    let contour = Contour(glyph: nil)
    var previousOnCurve = rawContour.last?.1 ?? true
    for (cgPoint, onCurve) in rawContour {
      var pointType: PointType
      var smooth: Bool
      if previousOnCurve && onCurve {
        pointType = .line
        smooth = false
      } else if !previousOnCurve && onCurve {
        pointType = .qCurve
        smooth = true
      } else {
        pointType = .offCurve
        smooth = false
      }
      previousOnCurve = onCurve
      contour.appendPoint(cgPoint, type: pointType, smooth: smooth)
    }
    return contour
  }

}
