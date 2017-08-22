//
//  TCGlyphImageFactory.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/7/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

/**
 A factory for generating bitmaps from glyph outlines.
 */
class TCGlyphImageFactory {

  /**
   Build a [CGImage](https://developer.apple.com/documentation/coregraphics/cgimage)
   from a TCGlyph.
   - returns: A CGImage of the glyph
   - parameters:
     - glyph: The glyph to render to an image
     - transform: The transformation to apply to the glyph before rendering
     - size: The size of the image to render into
   */
  class func buildImage(glyph: TCGlyph, transform: CGAffineTransform, size: CGSize) -> CGImage? {
    let path = TCGlyphPathFactory.buildPath(with: glyph)
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
}
