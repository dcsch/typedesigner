//
//  TCGlyfSimpleDescript.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/3/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

enum TCGlyphFlag: UInt8 {
  case onCurvePoint = 0x01
  case xShortVector = 0x02
  case yShortVector = 0x04
  case repeatFlag = 0x08
  case xDual = 0x10
  case yDual = 0x20
}

class TCGlyfSimpleDescript: TCGlyfDescript {
  let numberOfContours: Int
  var xMin: Int
  var yMin: Int
  var xMax: Int
  var yMax: Int
  var endPtsOfContours: [Int]
  var flags: [UInt8]
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
      let flagByte = dataInput.readUInt8()
      flags.append(flagByte)
      if Int(flagByte & TCGlyphFlag.repeatFlag.rawValue) != 0 {
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
      if (self.flags[i] & TCGlyphFlag.xDual.rawValue) != 0 {
        if (self.flags[i] & TCGlyphFlag.xShortVector.rawValue) != 0 {
          x += Int(dataInput.readUInt8())
        }
      } else {
        if (self.flags[i] & TCGlyphFlag.xShortVector.rawValue) != 0 {
          x += -Int(dataInput.readUInt8())
        } else {
          x += Int(dataInput.readInt16())
        }
      }
      xCoordinates.append(x)
    }

    for i in 0..<count {
      if (self.flags[i] & TCGlyphFlag.yDual.rawValue) != 0 {
        if (self.flags[i] & TCGlyphFlag.yShortVector.rawValue) != 0 {
          y += Int(dataInput.readUInt8())
        }
      } else {
        if (self.flags[i] & TCGlyphFlag.yShortVector.rawValue) != 0 {
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
                          ((flags & 0x20) != 0) ? "YDual " : "      ",
                          ((flags & 0x10) != 0) ? "XDual " : "      ",
                          ((flags & 0x08) != 0) ? "Repeat " : "       ",
                          ((flags & 0x04) != 0) ? "Y-Short " : "        ",
                          ((flags & 0x02) != 0) ? "X-Short " : "        ",
                          ((flags & 0x01) != 0) ? "On" : "  "))
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

  func endPtOfContours(at index: Int) -> Int {
    return endPtsOfContours[index]
  }

  func flags(index: Int) -> UInt8 {
    return flags[index]
  }

  func xCoordinate(at index: Int) -> Int {
    return xCoordinates[index]
  }

  func yCoordinate(at index: Int) -> Int {
    return yCoordinates[index]
  }

  override var isComposite: Bool {
    get {
      return false
    }
  }

  var pointCount: Int {
    get {
      return count
    }
  }

  var contourCount: Int {
    get {
      return numberOfContours
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
    flags = try container.decode([UInt8].self, forKey: .flags)
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
