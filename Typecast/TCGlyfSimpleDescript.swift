//
//  TCGlyfSimpleDescript.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/3/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCGlyfSimpleDescript: TCGlyfBaseDescript, TCGlyphDescription {
  var endPtsOfContours: [Int]
  var flags: [UInt8]
  var xCoordinates: [Int]
  var yCoordinates: [Int]
  var count: Int

  override init(dataInput: TCDataInput,
                parentTable: TCGlyfTable,
                glyphIndex: Int,
                numberOfContours: Int) {
    endPtsOfContours = []
    flags = []
    xCoordinates = []
    yCoordinates = []
    count = 0
    super.init(dataInput: dataInput,
               parentTable: parentTable,
               glyphIndex: glyphIndex,
               numberOfContours: numberOfContours)

    // Simple glyph description
    for _ in 0..<numberOfContours {
      endPtsOfContours.append(Int(dataInput.readInt16()))
    }

    // The last end point index reveals the total number of points
    count = Int(endPtsOfContours[numberOfContours - 1]) + 1

    let instructionCount = Int(dataInput.readInt16())
    readInstructions(dataInput: dataInput, count: instructionCount)
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

  override var description: String {
    get {
      var str = super.description

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

  func endPtOfContours(index: Int) -> Int {
    return endPtsOfContours[index]
  }

  func flags(index: Int) -> UInt8 {
    return flags[index]
  }

  func xCoordinate(index: Int) -> Int {
    return xCoordinates[index]
  }

  func yCoordinate(index: Int) -> Int {
    return yCoordinates[index]
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
}
