//
//  TCGlyfBaseDescript.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/4/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCGlyfBaseDescript: TCProgram, TCGlyfDescript {

  let parentTable: TCGlyfTable
  @objc let glyphIndex: Int
  let numberOfContours: Int
  let xMin: Int
  let yMin: Int
  let xMax: Int
  let yMax: Int

  init(dataInput: TCDataInput,
       parentTable: TCGlyfTable,
       glyphIndex: Int,
       numberOfContours: Int) {
    self.parentTable = parentTable
    self.glyphIndex = glyphIndex
    self.numberOfContours = numberOfContours
    self.xMin = Int(dataInput.readInt16())
    self.yMin = Int(dataInput.readInt16())
    self.xMax = Int(dataInput.readInt16())
    self.yMax = Int(dataInput.readInt16())
  }

  var name: String {
    get {
      if let name = parentTable.objectInGlyphNames(index: glyphIndex) {
        return name
      } else {
        return ""
      }
    }
  }

  override var description: String {
    get {
      return "          numberOfContours: \(numberOfContours)\n" +
             "          xMin:             \(xMin)\n" +
             "          yMin:             \(yMin)\n" +
             "          xMax:             \(xMax)\n" +
             "          yMax:             \(yMax)\n"
    }
  }
}
