//
//  KernTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 12/7/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

/**
 Values that control the inter-character spacing for the glyphs in a font.
 */
class KernTable: Table, Codable {

  struct Coverage: OptionSet, Codable {
    var rawValue: UInt8

    static let horizontal = Coverage(rawValue: 1 << 0)
    static let minimum = Coverage(rawValue: 1 << 1)
    static let crossStream = Coverage(rawValue: 1 << 2)
    static let override = Coverage(rawValue: 1 << 3)
  }

  struct KerningPair: Codable {
    let left: Int
    let right: Int
    let value: Int
  }

  struct Subtable: Codable {
    let coverage: Coverage
    var kerningPairs: [KerningPair]
  }

  var subtables: [Subtable]

  init(data: Data) {
    let dataInput = TCDataInput(data: data)
    _ = Int(dataInput.readUInt16()) // version
    let nTables = Int(dataInput.readUInt16())
    subtables = []
    for _ in 0..<nTables {
      _ = dataInput.readUInt16() // version
      _ = dataInput.readUInt16() // length
      let format = dataInput.readUInt8()
      let coverage = Coverage(rawValue: dataInput.readUInt8())
      if format == 0 {
        var kerningPairs = [KerningPair]()
        let nPairs = dataInput.readUInt16()
        _ = dataInput.readUInt16() // searchRange
        _ = dataInput.readUInt16() // entrySelector
        _ = dataInput.readUInt16() // rangeShift
        for _ in 0..<nPairs {
          let left = Int(dataInput.readUInt16())
          let right = Int(dataInput.readUInt16())
          let value = Int(dataInput.readInt16())
          kerningPairs.append(KerningPair(left: left, right: right, value: value))
        }
        subtables.append(Subtable(coverage: coverage, kerningPairs: kerningPairs))
      } else if format == 2 {
        assertionFailure("kern format 2 not implemented")
      }
    }
  }
}
