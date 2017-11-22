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

    static let ARG_1_AND_2_ARE_WORDS: UInt16 = 0x0001
    static let ARGS_ARE_XY_VALUES: UInt16 = 0x0002
    static let ROUND_XY_TO_GRID: UInt16 = 0x0004
    static let WE_HAVE_A_SCALE: UInt16 = 0x0008
    static let MORE_COMPONENTS: UInt16 = 0x0020
    static let WE_HAVE_AN_X_AND_Y_SCALE: UInt16 = 0x0040
    static let WE_HAVE_A_TWO_BY_TWO: UInt16 = 0x0080
    static let WE_HAVE_INSTRUCTIONS: UInt16 = 0x0100
    static let USE_MY_METRICS: UInt16 = 0x0200

    let glyphIndex: Int
    let xscale: Double
    let yscale: Double
    let scale01: Double
    let scale10: Double
    let xtranslate: Int
    let ytranslate: Int
    let point1: Int
    let point2: Int

    init(dataInput: TCDataInput, flags: UInt16) {
      self.glyphIndex = Int(dataInput.readUInt16())

      // Get the arguments as just their raw values
      var argument1: Int
      var argument2: Int
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
    var flags: UInt16 = 0
    repeat {
      flags = dataInput.readUInt16()
      comp = Component(dataInput: dataInput, flags: flags)
      components.append(comp)
    } while flags & Component.MORE_COMPONENTS != 0

    // Are there hinting intructions to read?
    if flags & Component.WE_HAVE_INSTRUCTIONS != 0 {
      let instructionCount = Int(dataInput.readInt16())
      instructions = dataInput.read(length: instructionCount)
    }
    super.init(glyphIndex: glyphIndex)
  }
  
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

  private enum CodingKeys: String, CodingKey {
    case xMaximum
    case xMinimum
    case yMaximum
    case yMinimum
    case components
    case instructions
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    xMax = try container.decode(Int.self, forKey: .xMaximum)
    xMin = try container.decode(Int.self, forKey: .xMinimum)
    yMax = try container.decode(Int.self, forKey: .yMaximum)
    yMin = try container.decode(Int.self, forKey: .yMinimum)
    components = try container.decode([Component].self, forKey: .components)
    instructions = try container.decode([UInt8].self, forKey: .instructions)
    let superDecoder = try container.superDecoder()
    try super.init(from: superDecoder)
  }

  override func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(xMax, forKey: .xMaximum)
    try container.encode(xMin, forKey: .xMinimum)
    try container.encode(yMax, forKey: .yMaximum)
    try container.encode(yMin, forKey: .yMinimum)
    try container.encode(components, forKey: .components)
    try container.encode(instructions, forKey: .instructions)
    let superEncoder = container.superEncoder()
    try super.encode(to: superEncoder)
  }
}
