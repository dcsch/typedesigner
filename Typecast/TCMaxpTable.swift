//
//  TCMaxpTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/5/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCMaxpTable: TCTable, Codable {
  let versionNumber: UInt32
  let numGlyphs: Int
  let maxPoints: UInt16
  let maxContours: UInt16
  let maxCompositePoints: UInt16
  let maxCompositeContours: UInt16
  let maxZones: UInt16
  let maxTwilightPoints: UInt16
  let maxStorage: UInt16
  let maxFunctionDefs: UInt16
  let maxInstructionDefs: UInt16
  let maxStackElements: UInt16
  let maxSizeOfInstructions: UInt16
  let maxComponentElements: UInt16
  let maxComponentDepth: UInt16

  override init() {
    versionNumber = 0
    numGlyphs = 0
    maxPoints = 0
    maxContours = 0
    maxCompositePoints = 0
    maxCompositeContours = 0
    maxZones = 0
    maxTwilightPoints = 0
    maxStorage = 0
    maxFunctionDefs = 0
    maxInstructionDefs = 0
    maxStackElements = 0
    maxSizeOfInstructions = 0
    maxComponentElements = 0
    maxComponentDepth = 0
    super.init()
  }

  init(data: Data) {
    let dataInput = TCDataInput(data: data)
    versionNumber = dataInput.readUInt32()

    // CFF fonts use version 0.5, TrueType fonts use version 1.0
    if versionNumber == 0x00005000 {
      numGlyphs = Int(dataInput.readUInt16())
      maxPoints = 0
      maxContours = 0
      maxCompositePoints = 0
      maxCompositeContours = 0
      maxZones = 0
      maxTwilightPoints = 0
      maxStorage = 0
      maxFunctionDefs = 0
      maxInstructionDefs = 0
      maxStackElements = 0
      maxSizeOfInstructions = 0
      maxComponentElements = 0
      maxComponentDepth = 0
    } else if versionNumber == 0x00010000 {
      numGlyphs = Int(dataInput.readUInt16())
      maxPoints = dataInput.readUInt16()
      maxContours = dataInput.readUInt16()
      maxCompositePoints = dataInput.readUInt16()
      maxCompositeContours = dataInput.readUInt16()
      maxZones = dataInput.readUInt16()
      maxTwilightPoints = dataInput.readUInt16()
      maxStorage = dataInput.readUInt16()
      maxFunctionDefs = dataInput.readUInt16()
      maxInstructionDefs = dataInput.readUInt16()
      maxStackElements = dataInput.readUInt16()
      maxSizeOfInstructions = dataInput.readUInt16()
      maxComponentElements = dataInput.readUInt16()
      maxComponentDepth = dataInput.readUInt16()
    } else {
      numGlyphs = 0
      maxPoints = 0
      maxContours = 0
      maxCompositePoints = 0
      maxCompositeContours = 0
      maxZones = 0
      maxTwilightPoints = 0
      maxStorage = 0
      maxFunctionDefs = 0
      maxInstructionDefs = 0
      maxStackElements = 0
      maxSizeOfInstructions = 0
      maxComponentElements = 0
      maxComponentDepth = 0
    }
    super.init()
  }

  override class var tag: TCTable.Tag {
    get {
      return .maxp
    }
  }

  override var description: String {
    get {
      var str = String(format:
        "'maxp' Table - Maximum Profile\n------------------------------" +
        "\n        'maxp' version:         %x" +
        "\n        numGlyphs:              %d",
        versionNumber,
        numGlyphs)

      if versionNumber == 0x00010000 {
        str.append(String(format:
          "\n        maxPoints:              %d" +
          "\n        maxContours:            %d" +
          "\n        maxCompositePoints:     %d" +
          "\n        maxCompositeContours:   %d" +
          "\n        maxZones:               %d" +
          "\n        maxTwilightPoints:      %d" +
          "\n        maxStorage:             %d" +
          "\n        maxFunctionDefs:        %d" +
          "\n        maxInstructionDefs:     %d" +
          "\n        maxStackElements:       %d" +
          "\n        maxSizeOfInstructions:  %d" +
          "\n        maxComponentElements:   %d" +
          "\n        maxComponentDepth:      %d",
          maxPoints,
          maxContours,
          maxCompositePoints,
          maxCompositeContours,
          maxZones,
          maxTwilightPoints,
          maxStorage,
          maxFunctionDefs,
          maxInstructionDefs,
          maxStackElements,
          maxSizeOfInstructions,
          maxComponentElements,
          maxComponentDepth))
      } else {
        str.append("\n")
      }
      return str;
    }
  }
}
