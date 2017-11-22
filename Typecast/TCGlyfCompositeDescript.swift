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

    struct Flags: OptionSet {
      let rawValue: UInt16

      static let arg1And2AreWords = Flags(rawValue: 1 << 0)
      static let argsAreXYValues = Flags(rawValue: 1 << 1)
      static let roundXYToGrid = Flags(rawValue: 1 << 2)
      static let weHaveAScale = Flags(rawValue: 1 << 3)
      static let moreComponents = Flags(rawValue: 1 << 5)
      static let weHaveAnXAndYScale = Flags(rawValue: 1 << 6)
      static let weHaveATwoByTwo = Flags(rawValue: 1 << 7)
      static let weHaveInstructions = Flags(rawValue: 1 << 8)
      static let useMyMetrics = Flags(rawValue: 1 << 9)
    }

    let glyphIndex: Int
    let xscale: Double
    let yscale: Double
    let scale01: Double
    let scale10: Double
    let xtranslate: Int
    let ytranslate: Int
    let point1: Int
    let point2: Int

    init(dataInput: TCDataInput, flags: Flags) {
      self.glyphIndex = Int(dataInput.readUInt16())

      // Get the arguments as just their raw values
      var argument1: Int
      var argument2: Int
      if flags.contains(.arg1And2AreWords) {
        argument1 = Int(dataInput.readInt16())
        argument2 = Int(dataInput.readInt16())
      } else {
        argument1 = Int(dataInput.readInt8())
        argument2 = Int(dataInput.readInt8())
      }

      // Assign the arguments according to the flags
      if flags.contains(.argsAreXYValues) {
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
      if flags.contains(.weHaveAScale) {
        let i = Double(dataInput.readInt16())
        xscale = i / Double(0x4000)
        yscale = xscale
        scale01 = 0.0
        scale10 = 0.0
      } else if flags.contains(.weHaveAnXAndYScale) {
        let x = Double(dataInput.readInt16())
        xscale = x / Double(0x4000)
        let y = Double(dataInput.readInt16())
        yscale = y / Double(0x4000)
        scale01 = 0.0
        scale10 = 0.0
      } else if flags.contains(.weHaveATwoByTwo) {
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
    var flags: Component.Flags
    repeat {
      flags = Component.Flags(rawValue: dataInput.readUInt16())
      comp = Component(dataInput: dataInput, flags: flags)
      components.append(comp)
    } while flags.contains(.moreComponents)

    // Are there hinting intructions to read?
    if flags.contains(.weHaveInstructions) {
      let instructionCount = Int(dataInput.readInt16())
      instructions = dataInput.read(length: instructionCount)
    }
    super.init(glyphIndex: glyphIndex)
  }
  
  var description: String {
    get {
      let str = "          xMin:             \(xMin)\n" +
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
