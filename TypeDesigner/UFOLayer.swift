//
//  UFOLayer.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/25/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Foundation
import FontScript

class UFOLayer : FontScript.Layer {

  override func newGlyph(name: String) -> FontScript.Glyph {
    return UFOGlyph(name: name, layer: self)
  }

}
