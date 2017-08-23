//
//  TCGlyfCompositeDescript.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/21/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

/**
 Glyph description for composite glyphs.  Composite glyphs are made up of one
 or more simple glyphs, usually with some sort of transformation applied to
 each.
 */
class TCGlyfCompositeDescript: TCGlyfBaseDescript, TCGlyphDescription {

  class Component {

    static let ARG_1_AND_2_ARE_WORDS = 0x0001
    static let ARGS_ARE_XY_VALUES = 0x0002
    static let ROUND_XY_TO_GRID = 0x0004
    static let WE_HAVE_A_SCALE = 0x0008
    static let MORE_COMPONENTS = 0x0020
    static let WE_HAVE_AN_X_AND_Y_SCALE = 0x0040
    static let WE_HAVE_A_TWO_BY_TWO = 0x0080
    static let WE_HAVE_INSTRUCTIONS = 0x0100
    static let USE_MY_METRICS = 0x0200

    let firstIndex: Int
    let firstContour: Int
    let argument1: Int
    let argument2: Int
    let flags: Int
    let glyphIndex: Int
    let xscale: Double
    let yscale: Double
    let scale01: Double
    let scale10: Double
    let xtranslate: Int
    let ytranslate: Int
    let point1: Int
    let point2: Int

    init(firstIndex: Int, firstContour: Int, dataInput: TCDataInput) {
      self.firstIndex = firstIndex
      self.firstContour = firstContour
      self.flags = Int(dataInput.readUInt16())
      self.glyphIndex = Int(dataInput.readUInt16())

      // Get the arguments as just their raw values
      if flags & Component.ARG_1_AND_2_ARE_WORDS != 0 {
        argument1 = Int(dataInput.readInt16())
        argument2 = Int(dataInput.readInt16())
      } else {
        argument1 = Int(dataInput.readInt8())
        argument2 = Int(dataInput.readInt8())
      }

      // Assign the arguments according to the flags
      if flags & Component.ARGS_ARE_XY_VALUES != 0 {
        xtranslate = argument1
        ytranslate = argument2
        point1 = 0
        point2 = 0
      } else {
        point1 = argument1
        point2 = argument2
        xtranslate = 0
        ytranslate = 0
      }

      // Get the scale values (if any)
      if flags & Component.WE_HAVE_A_SCALE != 0 {
        let i = Double(dataInput.readInt16())
        xscale = i / Double(0x4000)
        yscale = xscale
        scale01 = 0.0
        scale10 = 0.0
      } else if flags & Component.WE_HAVE_AN_X_AND_Y_SCALE != 0 {
        let x = Double(dataInput.readInt16())
        xscale = x / Double(0x4000)
        let y = Double(dataInput.readInt16())
        yscale = y / Double(0x4000)
        scale01 = 0.0
        scale10 = 0.0
      } else if flags & Component.WE_HAVE_A_TWO_BY_TWO != 0 {
        let x = Double(dataInput.readInt16())
        xscale = x / Double(0x4000)
        let s01 = Double(dataInput.readInt16())
        scale01 = s01 / Double(0x4000)
        let s10 = Double(dataInput.readInt16())
        scale10 = s10 / Double(0x4000)
        let y = Double(dataInput.readInt16())
        yscale = y / Double(0x4000)
      } else {
        xscale = 1.0
        yscale = 1.0
        scale01 = 0.0
        scale10 = 0.0
      }
    }

    /**
     Transforms an x-coordinate of a point for this component.
     - returns: The transformed x-coordinate
     - parameters:
       - x: The x-coordinate of the point to transform
       - y: The y-coordinate of the point to transform
     */
    func scaleX(x: Int, y: Int) -> Int {
      return Int(Double(x) * xscale + Double(y) * scale10)
    }

    /**
     Transforms a y-coordinate of a point for this component.
     - returns: The transformed y-coordinate
     - parameters:
     - x: The x-coordinate of the point to transform
     - y: The y-coordinate of the point to transform
     */
    func scaleY(x: Int, y: Int) -> Int {
      return Int(Double(x) * scale01 + Double(y) * yscale)
    }
  }

  var components = [Component]()

  init(dataInput: TCDataInput, parentTable: TCGlyfTable, glyphIndex: Int) {

    super.init(dataInput: dataInput, parentTable: parentTable,
               glyphIndex: glyphIndex, numberOfContours: -1)

    // Get all of the composite components
    var comp: Component
    var firstIndex = 0
    var firstContour = 0
    repeat {
      comp = Component(firstIndex: firstIndex, firstContour: firstContour, dataInput: dataInput)
      components.append(comp)
      if let desc = parentTable.descript[comp.glyphIndex] as? TCGlyphDescription {
        firstIndex += desc.pointCount
        firstContour += desc.contourCount
      }
    } while comp.flags & Component.MORE_COMPONENTS != 0

    // Are there hinting intructions to read?
    if comp.flags & Component.WE_HAVE_INSTRUCTIONS != 0 {
      let instructionCount = Int(dataInput.readInt16())
      readInstructions(dataInput: dataInput, count: instructionCount)
    }
  }

  func compositeComp(at index: Int) -> Component? {
    for comp in components {
      if let gd = parentTable.descript[comp.glyphIndex] as? TCGlyphDescription {
        if comp.firstIndex <= index && index < comp.firstIndex + gd.pointCount {
          return comp
        }
      }
    }
    return nil
  }

  func compositeCompEndPt(at index: Int) -> Component? {
    for comp in components {
      if let gd = parentTable.descript[comp.glyphIndex] as? TCGlyphDescription {
        if comp.firstContour <= index && index < comp.firstContour + gd.contourCount {
          return comp
        }
      }
    }
    return nil
  }

  func endPtOfContours(at index: Int) -> Int {
    if let comp = compositeCompEndPt(at: index),
      let gd = parentTable.descript[comp.glyphIndex] as? TCGlyphDescription {
      return gd.endPtOfContours(at: index - comp.firstContour) + comp.firstIndex
    }
    return 0
  }

  func flags(index: Int) -> UInt8 {
    if let comp = compositeComp(at: index),
      let gd = parentTable.descript[comp.glyphIndex] as? TCGlyphDescription {
      return gd.flags(index: index - comp.firstIndex)
    }
    return 0
  }

  func xCoordinate(at index: Int) -> Int {
    if let comp = compositeComp(at: index),
      let gd = parentTable.descript[comp.glyphIndex] as? TCGlyphDescription {
      let n = index - comp.firstIndex
      let x = gd.xCoordinate(at: n)
      let y = gd.yCoordinate(at: n)
      var x1 = comp.scaleX(x: x, y: y)
      x1 += comp.xtranslate
      return x1
    }
    return 0
  }

  func yCoordinate(at index: Int) -> Int {
    if let comp = compositeComp(at: index),
      let gd = parentTable.descript[comp.glyphIndex] as? TCGlyphDescription {
      let n = index - comp.firstIndex
      let x = gd.xCoordinate(at: n)
      let y = gd.yCoordinate(at: n)
      var y1 = comp.scaleY(x: x, y: y)
      y1 += comp.ytranslate
      return y1
    }
    return 0
  }

  var xMaximum: Int {
    get {
      return xMax
    }
  }

  var xMinimum: Int {
    get {
      return xMin
    }
  }

  var yMaximum: Int {
    get {
      return yMax
    }
  }

  var yMinimum: Int {
    get {
      return yMin
    }
  }

  var isComposite: Bool {
    get {
      return true
    }
  }

  var pointCount: Int {
    get {
      if let comp = components.last,
        let gd = parentTable.descript[comp.glyphIndex] as? TCGlyphDescription {
        return comp.firstIndex + gd.pointCount
      } else {
        return 0
      }
    }
  }

  var contourCount: Int {
    get {
      if let comp = components.last,
        let gd = parentTable.descript[comp.glyphIndex] as? TCGlyphDescription {
        return comp.firstContour + gd.contourCount
      } else {
        return 0
      }
    }
  }
}
