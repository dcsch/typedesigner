//
//  GlyfSimpleDescript.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/3/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class GlyfSimpleDescript: GlyfDescript, Codable {

  struct Flags: OptionSet, Codable {
    var rawValue: UInt8

    static let onCurvePoint = Flags(rawValue: 1 << 0)
    static let xShortVector = Flags(rawValue: 1 << 1)
    static let yShortVector = Flags(rawValue: 1 << 2)
    static let repeatFlag = Flags(rawValue: 1 << 3)
    static let xDual = Flags(rawValue: 1 << 4)
    static let yDual = Flags(rawValue: 1 << 5)
  }

  var xMin: Int
  var yMin: Int
  var xMax: Int
  var yMax: Int
  var endPtsOfContours: [Int]
  var flags: [Flags]
  var xCoordinates: [Int]
  var yCoordinates: [Int]
  var instructions = [UInt8]()

  init(dataInput: TCDataInput,
       glyphIndex: Int,
       numberOfContours: Int) {
    self.xMin = Int(dataInput.readInt16())
    self.yMin = Int(dataInput.readInt16())
    self.xMax = Int(dataInput.readInt16())
    self.yMax = Int(dataInput.readInt16())
    endPtsOfContours = []
    flags = []
    xCoordinates = []
    yCoordinates = []

    // Simple glyph description
    for _ in 0..<numberOfContours {
      endPtsOfContours.append(Int(dataInput.readInt16()))
    }

    // The last end point index reveals the total number of points
    let pointCount = Int(endPtsOfContours[numberOfContours - 1]) + 1

    let instructionCount = Int(dataInput.readInt16())
    instructions = dataInput.read(length: instructionCount)
    super.init()
    readFlags(dataInput: dataInput, pointCount: pointCount)
    readCoords(dataInput: dataInput)
  }
  
  // The flags are run-length encoded
  func readFlags(dataInput: TCDataInput, pointCount: Int) {
    flags.removeAll()
    var index = 0
    while index < pointCount {
      let flagByte = Flags(rawValue: dataInput.readUInt8())
      flags.append(flagByte)
      if flagByte.contains(.repeatFlag) {
        let repeats = Int(dataInput.readUInt8())
        for _ in 0..<repeats {
          flags.append(flagByte)
        }
        index += repeats
      }
      index += 1
    }
  }

  // The table is stored as relative values, but we'll store them as absolutes
  func readCoords(dataInput: TCDataInput) {
    var xCoordinates = [Int]()
    var yCoordinates = [Int]()

    var x = 0
    var y = 0
    for flags in self.flags {
      if flags.contains(.xDual) {
        if flags.contains(.xShortVector) {
          x += Int(dataInput.readUInt8())
        }
      } else {
        if flags.contains(.xShortVector) {
          x += -Int(dataInput.readUInt8())
        } else {
          x += Int(dataInput.readInt16())
        }
      }
      xCoordinates.append(x)
    }

    for flags in self.flags {
      if flags.contains(.yDual) {
        if flags.contains(.yShortVector) {
          y += Int(dataInput.readUInt8())
        }
      } else {
        if flags.contains(.yShortVector) {
          y += -Int(dataInput.readUInt8())
        } else {
          y += Int(dataInput.readInt16())
        }
      }
      yCoordinates.append(y)
    }

    self.xCoordinates = xCoordinates
    self.yCoordinates = yCoordinates
  }

  override var description: String {
    get {
      var str = """
                numberOfContours: \(endPtsOfContours.count)
                xMin:             \(xMin)
                yMin:             \(yMin)
                xMax:             \(xMax)
                yMax:             \(yMax)

              EndPoints
              ---------
      """

      for (i, pt) in endPtsOfContours.enumerated() {
        str += "\n          \(i): \(pt)"
      }
      str += "\n\n          Length of Instructions: \(instructions.count)\n"
      str += Disassembler.disassemble(instructions: instructions, leadingSpaceCount: 8)

      str += """

              Flags
              -----

      """
      for (i, flags) in self.flags.enumerated() {
        str += String(format:"          %d: %@%@%@%@%@%@\n",
                      i,
                      flags.contains(.yDual) ? "YDual " : "      ",
                      flags.contains(.xDual) ? "XDual " : "      ",
                      flags.contains(.repeatFlag) ? "Repeat " : "       ",
                      flags.contains(.yShortVector) ? "Y-Short " : "        ",
                      flags.contains(.xShortVector) ? "X-Short " : "        ",
                      flags.contains(.onCurvePoint) ? "On" : "  ")
      }

      str += """

              Coordinates
              -----------

      """
      var prevX = 0
      var prevY = 0
      for (i, (x, y)) in zip(xCoordinates, yCoordinates).enumerated() {
        str += "          \(i): Rel (\(x - prevX), \(y - prevY))  ->  Abs (\(x), \(y))\n"
        prevX = x
        prevY = y
      }
      return str;
    }
  }

  private enum CodingKeys: String, CodingKey {
    case xMaximum
    case xMinimum
    case yMaximum
    case yMinimum
    case endPtsOfContours
    case flags
    case xCoordinates
    case yCoordinates
    case count
    case instructions
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    xMax = try container.decode(Int.self, forKey: .xMaximum)
    xMin = try container.decode(Int.self, forKey: .xMinimum)
    yMax = try container.decode(Int.self, forKey: .yMaximum)
    yMin = try container.decode(Int.self, forKey: .yMinimum)
    endPtsOfContours = try container.decode([Int].self, forKey: .endPtsOfContours)
    flags = try container.decode([Flags].self, forKey: .flags)
    xCoordinates = try container.decode([Int].self, forKey: .xCoordinates)
    yCoordinates = try container.decode([Int].self, forKey: .yCoordinates)
    instructions = try container.decode([UInt8].self, forKey: .instructions)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(xMax, forKey: .xMaximum)
    try container.encode(xMin, forKey: .xMinimum)
    try container.encode(yMax, forKey: .yMaximum)
    try container.encode(yMin, forKey: .yMinimum)
    try container.encode(endPtsOfContours, forKey: .endPtsOfContours)
    try container.encode(flags, forKey: .flags)
    try container.encode(xCoordinates, forKey: .xCoordinates)
    try container.encode(yCoordinates, forKey: .yCoordinates)
    try container.encode(instructions, forKey: .instructions)
  }
}
