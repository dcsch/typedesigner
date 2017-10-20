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
class TCGlyfCompositeDescript: TCGlyfDescript {

  class Component: Codable {

    static let ARG_1_AND_2_ARE_WORDS = 0x0001
    static let ARGS_ARE_XY_VALUES = 0x0002
    static let ROUND_XY_TO_GRID = 0x0004
    static let WE_HAVE_A_SCALE = 0x0008
    static let MORE_COMPONENTS = 0x0020
    static let WE_HAVE_AN_X_AND_Y_SCALE = 0x0040
    static let WE_HAVE_A_TWO_BY_TWO = 0x0080
    static let WE_HAVE_INSTRUCTIONS = 0x0100
    static let USE_MY_METRICS = 0x0200

//    let firstIndex: Int
//    let firstContour: Int
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

    init(dataInput: TCDataInput) {
//      self.firstIndex = firstIndex
//      self.firstContour = firstContour
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

  var numberOfContours: Int {
    get {
      return -1
    }
  }
  let xMin: Int
  let yMin: Int
  let xMax: Int
  let yMax: Int
  var components = [Component]()
  var instructions = [UInt8]()

  init(dataInput: TCDataInput, glyphIndex: Int) {
    self.xMin = Int(dataInput.readInt16())
    self.yMin = Int(dataInput.readInt16())
    self.xMax = Int(dataInput.readInt16())
    self.yMax = Int(dataInput.readInt16())

    // Get all of the composite components
    var comp: Component
//    var firstIndex = 0
//    var firstContour = 0
    repeat {
      comp = Component(dataInput: dataInput)
      components.append(comp)
//      let desc = parentTable.descript[comp.glyphIndex]
//      firstIndex += desc.pointCount
//      firstContour += desc.contourCount
    } while comp.flags & Component.MORE_COMPONENTS != 0

    // Are there hinting intructions to read?
    if comp.flags & Component.WE_HAVE_INSTRUCTIONS != 0 {
      let instructionCount = Int(dataInput.readInt16())
      instructions = dataInput.read(length: instructionCount)
    }
    super.init(glyphIndex: glyphIndex)
  }
  
  required init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
  }
  
//  func compositeComp(at index: Int) -> Component? {
//    for comp in components {
//      let gd = parentTable.descript[comp.glyphIndex]
//      if comp.firstIndex <= index && index < comp.firstIndex + gd.pointCount {
//        return comp
//      }
//    }
//    return nil
//  }
//
//  func compositeCompEndPt(at index: Int) -> Component? {
//    for comp in components {
//      let gd = parentTable.descript[comp.glyphIndex]
//      if comp.firstContour <= index && index < comp.firstContour + gd.contourCount {
//        return comp
//      }
//    }
//    return nil
//  }

  var description: String {
    get {
      let str = "          numberOfContours: \(numberOfContours)\n" +
        "          xMin:             \(xMin)\n" +
        "          yMin:             \(yMin)\n" +
        "          xMax:             \(xMax)\n" +
        "          yMax:             \(yMax)\n"
      return str;
    }
  }

//  func endPtOfContours(at index: Int) -> Int {
//    if let comp = compositeCompEndPt(at: index) {
//      let gd = parentTable.descript[comp.glyphIndex]
//      return gd.endPtOfContours(at: index - comp.firstContour) + comp.firstIndex
//    }
//    return 0
//  }
//
//  func flags(index: Int) -> UInt8 {
//    if let comp = compositeComp(at: index) {
//      let gd = parentTable.descript[comp.glyphIndex]
//      return gd.flags(index: index - comp.firstIndex)
//    }
//    return 0
//  }
//
//  func xCoordinate(at index: Int) -> Int {
//    if let comp = compositeComp(at: index) {
//      let gd = parentTable.descript[comp.glyphIndex]
//      let n = index - comp.firstIndex
//      let x = gd.xCoordinate(at: n)
//      let y = gd.yCoordinate(at: n)
//      var x1 = comp.scaleX(x: x, y: y)
//      x1 += comp.xtranslate
//      return x1
//    }
//    return 0
//  }
//
//  func yCoordinate(at index: Int) -> Int {
//    if let comp = compositeComp(at: index) {
//      let gd = parentTable.descript[comp.glyphIndex]
//      let n = index - comp.firstIndex
//      let x = gd.xCoordinate(at: n)
//      let y = gd.yCoordinate(at: n)
//      var y1 = comp.scaleY(x: x, y: y)
//      y1 += comp.ytranslate
//      return y1
//    }
//    return 0
//  }

  override var xMaximum: Int {
    get {
      return xMax
    }
  }

  override var xMinimum: Int {
    get {
      return xMin
    }
  }

  override var yMaximum: Int {
    get {
      return yMax
    }
  }

  override var yMinimum: Int {
    get {
      return yMin
    }
  }

  override var isComposite: Bool {
    get {
      return true
    }
  }

//  var pointCount: Int {
//    get {
//      if let comp = components.last {
//        let gd = parentTable.descript[comp.glyphIndex]
//        return comp.firstIndex + gd.pointCount
//      } else {
//        return 0
//      }
//    }
//  }
//
//  var contourCount: Int {
//    get {
//      if let comp = components.last {
//        let gd = parentTable.descript[comp.glyphIndex]
//        return comp.firstContour + gd.contourCount
//      } else {
//        return 0
//      }
//    }
//  }

  enum ExtraCodingKeys: String, CodingKey {
    case glyphIndex
    case xMaximum
    case xMinimum
    case yMaximum
    case yMinimum
  }

  override func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: ExtraCodingKeys.self)
    try container.encode(glyphIndex, forKey: .glyphIndex)
    try container.encode(xMaximum, forKey: .xMaximum)
    try container.encode(xMinimum, forKey: .xMinimum)
    try container.encode(yMaximum, forKey: .yMaximum)
    try container.encode(yMinimum, forKey: .yMinimum)
  }
}

