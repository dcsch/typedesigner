//
//  GlyphImageFactory.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/7/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

/**
 A factory for generating bitmaps from glyph outlines.
 */
class GlyphImageFactory {

  /**
   Build a [CGImage](https://developer.apple.com/documentation/coregraphics/cgimage)
   from a TrueType simple glyph description.
   - returns: A CGImage of the glyph
   - parameters:
     - glyph: The glyph description to render to an image
     - transform: The transformation to apply to the glyph before rendering
     - size: The size of the image to render into
   */
  class func buildImage(glyph: TCGlyfSimpleDescript, transform: CGAffineTransform, size: CGSize) -> CGImage? {
    let path = GlyphPathFactory.buildPath(with: glyph)
    let colorspace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue)
    if let context = CGContext(data: nil,
                               width: Int(size.width),
                               height: Int(size.height),
                               bitsPerComponent: 8,
                               bytesPerRow: 0,
                               space: colorspace,
                               bitmapInfo: bitmapInfo.rawValue) {
      // Fill the background
      context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
      context.fill(CGRect(x: 0.0, y: 0.0,
                          width: size.width, height: size.height))

      // Transform and render the glyph
      context.concatenate(transform)
      context.addPath(path)
      context.setFillColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
      context.fillPath()
      return context.makeImage()
    }
    return nil
  }

  /**
   Build a [CGImage](https://developer.apple.com/documentation/coregraphics/cgimage)
   from a TrueType composite glyph description.
   - returns: A CGImage of the glyph
   - parameters:
   - glyph: The glyph description to render to an image
   - transform: The transformation to apply to the glyph before rendering
   - size: The size of the image to render into
   */
  class func buildImage(glyph: TCGlyfCompositeDescript, font: TTFont,
                        transform: CGAffineTransform, size: CGSize) -> CGImage? {
    let colorspace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue)
    if let context = CGContext(data: nil,
                               width: Int(size.width),
                               height: Int(size.height),
                               bitsPerComponent: 8,
                               bytesPerRow: 0,
                               space: colorspace,
                               bitmapInfo: bitmapInfo.rawValue) {
      // Fill the background
      context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
      context.fill(CGRect(x: 0.0, y: 0.0,
                          width: size.width, height: size.height))

      // Transform and render the glyph
      context.concatenate(transform)

      for component in glyph.components {
        let componentGlyphIndex = component.glyphIndex
        if let componentDescript = font.glyfTable.descript[componentGlyphIndex] as? TCGlyfSimpleDescript {
          let transform = CGAffineTransform(a: CGFloat(component.xscale), b: CGFloat(component.scale01),
                                            c: CGFloat(component.scale10), d: CGFloat(component.yscale),
                                            tx: CGFloat(component.xtranslate), ty: CGFloat(component.ytranslate))
          context.saveGState()
          context.concatenate(transform)
          context.addPath(GlyphPathFactory.buildPath(with: componentDescript))
          context.setFillColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
          context.fillPath()
          context.restoreGState()
        }
      }
      return context.makeImage()
    }
    return nil
  }
}
