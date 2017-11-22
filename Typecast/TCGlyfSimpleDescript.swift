//
//  TCGlyfSimpleDescript.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/3/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCGlyfSimpleDescript: TCGlyfDescript {

  struct Flags: OptionSet {
    var rawValue: UInt8

    static let onCurvePoint = Flags(rawValue: 1 << 0)
    static let xShortVector = Flags(rawValue: 1 << 1)
    static let yShortVector = Flags(rawValue: 1 << 2)
    static let repeatFlag = Flags(rawValue: 1 << 3)
    static let xDual = Flags(rawValue: 1 << 4)
    static let yDual = Flags(rawValue: 1 << 5)
  }

  let numberOfContours: Int
  var xMin: Int
  var yMin: Int
  var xMax: Int
  var yMax: Int
  var endPtsOfContours: [Int]
  var flags: [Flags]
  var xCoordinates: [Int]
  var yCoordinates: [Int]
  var count: Int
  var instructions = [UInt8]()

  init(dataInput: TCDataInput,
       glyphIndex: Int,
       numberOfContours: Int) {
    self.numberOfContours = numberOfContours
    self.xMin = Int(dataInput.readInt16())
    self.yMin = Int(dataInput.readInt16())
    self.xMax = Int(dataInput.readInt16())
    self.yMax = Int(dataInput.readInt16())
    endPtsOfContours = []
    flags = []
    xCoordinates = []
    yCoordinates = []
    count = 0

    // Simple glyph description
    for _ in 0..<numberOfContours {
      endPtsOfContours.append(Int(dataInput.readInt16()))
    }

    // The last end point index reveals the total number of points
    count = Int(endPtsOfContours[numberOfContours - 1]) + 1

    let instructionCount = Int(dataInput.readInt16())
    instructions = dataInput.read(length: instructionCount)
    super.init(glyphIndex: glyphIndex)
    readFlags(dataInput: dataInput, count: count)
    readCoords(dataInput: dataInput, count: count)
  }
  
  // The flags are run-length encoded
  func readFlags(dataInput: TCDataInput, count: Int) {
    flags.removeAll()
    var index = 0
    while index < count {
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
  func readCoords(dataInput: TCDataInput, count: Int) {
    var xCoordinates = [Int]()
    var yCoordinates = [Int]()

    var x = 0
    var y = 0
    for i in 0..<count {
      if self.flags[i].contains(.xDual) {
        if self.flags[i].contains(.xShortVector) {
          x += Int(dataInput.readUInt8())
        }
      } else {
        if self.flags[i].contains(.xShortVector) {
          x += -Int(dataInput.readUInt8())
        } else {
          x += Int(dataInput.readInt16())
        }
      }
      xCoordinates.append(x)
    }

    for i in 0..<count {
      if self.flags[i].contains(.yDual) {
        if self.flags[i].contains(.yShortVector) {
          y += Int(dataInput.readUInt8())
        }
      } else {
        if self.flags[i].contains(.yShortVector) {
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

  var description: String {
    get {
      var str = "          numberOfContours: \(numberOfContours)\n" +
        "          xMin:             \(xMin)\n" +
        "          yMin:             \(yMin)\n" +
        "          xMax:             \(xMax)\n" +
        "          yMax:             \(yMax)\n"

      str.append("\n        EndPoints\n        ---------")
      for i in 0..<endPtsOfContours.count {
        str.append(String(format: "\n          %d: %d", i, endPtsOfContours[i]))
      }
      str.append(String(format: "\n\n          Length of Instructions: %ld\n", instructions.count))
//      str.append(TCDisassembler.disassemble(instructions:instructions, leadingSpaceCount: 8))

      str.append("\n        Flags\n        -----")
      for i in 0..<flags.count {
        let flags = self.flags[i]
        str.append(String(format:"\n          %d: %s%s%s%s%s%s",
                          i,
                          flags.contains(.yDual) ? "YDual " : "      ",
                          flags.contains(.xDual) ? "XDual " : "      ",
                          flags.contains(.repeatFlag) ? "Repeat " : "       ",
                          flags.contains(.yShortVector) ? "Y-Short " : "        ",
                          flags.contains(.xShortVector) ? "X-Short " : "        ",
                          flags.contains(.onCurvePoint) ? "On" : "  "))
      }

      str.append("\n\n        Coordinates\n        -----------")
      var oldX = 0
      var oldY = 0
      for i in 0..<xCoordinates.count {
        str.append(String(format:"\n          %d: Rel (%d, %d)  ->  Abs (%d, %d)",
                          i,
                          xCoordinates[i] - oldX,
                          yCoordinates[i] - oldY,
                          xCoordinates[i],
                          yCoordinates[i]))
        oldX = xCoordinates[i]
        oldY = yCoordinates[i]
      }
      return str;
    }
  }

  private enum CodingKeys: String, CodingKey {
    case numberOfContours
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
    numberOfContours = try container.decode(Int.self, forKey: .numberOfContours)
    xMax = try container.decode(Int.self, forKey: .xMaximum)
    xMin = try container.decode(Int.self, forKey: .xMinimum)
    yMax = try container.decode(Int.self, forKey: .yMaximum)
    yMin = try container.decode(Int.self, forKey: .yMinimum)
    endPtsOfContours = try container.decode([Int].self, forKey: .endPtsOfContours)
    flags = try container.decode([Flags].self, forKey: .flags)
    xCoordinates = try container.decode([Int].self, forKey: .xCoordinates)
    yCoordinates = try container.decode([Int].self, forKey: .yCoordinates)
    count = try container.decode(Int.self, forKey: .count)
    instructions = try container.decode([UInt8].self, forKey: .instructions)
    let superDecoder = try container.superDecoder()
    try super.init(from: superDecoder)
  }

  override func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(numberOfContours, forKey: .numberOfContours)
    try container.encode(xMax, forKey: .xMaximum)
    try container.encode(xMin, forKey: .xMinimum)
    try container.encode(yMax, forKey: .yMaximum)
    try container.encode(yMin, forKey: .yMinimum)
    try container.encode(endPtsOfContours, forKey: .endPtsOfContours)
    try container.encode(flags, forKey: .flags)
    try container.encode(xCoordinates, forKey: .xCoordinates)
    try container.encode(yCoordinates, forKey: .yCoordinates)
    try container.encode(count, forKey: .count)
    try container.encode(instructions, forKey: .instructions)
    let superEncoder = container.superEncoder()
    try super.encode(to: superEncoder)
  }
}
