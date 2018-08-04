//
//  OpenTypeConverter.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/1/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Foundation
import FontScript
import CFF

class OpenTypeConverter : FontConverter {
  var fontCollection: OpenTypeFontCollection

  init(openTypeData: Data, isSuitcase: Bool) throws {
    fontCollection = try OpenTypeFontCollection(data: openTypeData, isSuitcase: isSuitcase)
  }

  var fontNames: [String] {
    get {
      var names = [String]()
      for font in fontCollection.fonts {
        names.append(font.nameTable.record(nameID: .fullFontName)!.record)
      }
      return names
    }
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

      // TrueType outlines
      for (i, descript) in ttFont.glyfTable.descript.enumerated() {

        let name = otFont.postTable.name(at: i) ?? "glyph\(i)"
        ufoFont.libProps.glyphOrder.append(name)

        if descript is GlyfNullDescript {
          layer.glyphs[name] = UFOGlyph(name: name, layer: layer)
        } else if let simpleDescript = descript as? GlyfSimpleDescript {
          let glyph = OpenTypeConverter.convert(glyph: simpleDescript, name: name, layer: layer)
          bounds = bounds.union(glyph.bounds)
          layer.glyphs[name] = glyph
        } else if let compositeDescript = descript as? GlyfCompositeDescript {
          let glyph = OpenTypeConverter.convert(glyph: compositeDescript, otFont: otFont, name: name, layer: layer)
          bounds = bounds.union(glyph.bounds)
          layer.glyphs[name] = glyph
        }
      }
    } else if let t2Font = otFont as? T2Font {

      // Type 2 / CFF outlines
      for i in 0..<t2Font.cffTable.fonts[0].charstrings.count {
        let name = otFont.postTable.name(at: i) ?? "glyph\(i)"
        if let t2Glyph = t2Font.glyph(at: i) {
          ufoFont.libProps.glyphOrder.append(name)
          let glyph = OpenTypeConverter.convert(glyph: t2Glyph, name: name, layer: layer)
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

  class func convert(glyph: T2Glyph, name: String, layer: Layer?) -> UFOGlyph {
    let ufoGlyph = UFOGlyph(name: name, layer: layer)
    var cffPoints = [CFFPoint]()
    for point in glyph.points {
      cffPoints.append(point)
      if point.endOfContour {
        let contour = contourFromPoints(points: cffPoints)
        ufoGlyph.appendContour(contour, offset: CGPoint.zero)
        cffPoints.removeAll()
      }
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

  private class func contourFromPoints(points: [CFFPoint]) -> Contour {
    let contour = Contour(glyph: nil)
    var previousOnCurve = points.last?.onCurve ?? true
    for point in points {
      var pointType: PointType
      var smooth: Bool
      if previousOnCurve && point.onCurve {
        pointType = .line
        smooth = false
      } else if !previousOnCurve && point.onCurve {
        pointType = .curve
        smooth = true
      } else {
        pointType = .offCurve
        smooth = false
      }
      previousOnCurve = point.onCurve
      contour.appendPoint(CGPoint(x: point.x, y: point.y), type: pointType, smooth: smooth)
    }
    return contour
  }

}
