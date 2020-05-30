//
//  CFFCharset.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/10/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

protocol CFFCharset {
  var format: Int { get }
  func sid(gid: Int) -> Int
}

class CFFCharsetFormat0: CFFCharset {
  let glyphs: [Int]

  init(dataInput: TCDataInput, glyphCount: Int) {
    var glyphs = [Int]()
    for _ in 0..<glyphCount - 1 {  // minus 1 because .notdef is omitted
      glyphs.append(Int(dataInput.readUInt16()))
    }
    self.glyphs = glyphs
  }

  var format: Int {
    get {
      return 0
    }
  }

  func sid(gid: Int) -> Int {
    if gid == 0 {
      return 0
    }
    return glyphs[gid - 1]
  }

}

class CFFCharsetFormat1: CFFCharset {
  let charsetRanges: [CountableClosedRange<Int>]

  init(dataInput: TCDataInput, glyphCount: Int) {
    var charsetRanges = [CountableClosedRange<Int>]()

    var glyphsCovered = glyphCount - 1  // minus 1 because .notdef is omitted
    while glyphsCovered > 0 {
      let first = Int(dataInput.readUInt16())
      let left = Int(dataInput.readUInt8())
      let range = first...first + left
      charsetRanges.append(range)
      glyphsCovered -= left + 1
    }
    self.charsetRanges = charsetRanges
  }

  var format: Int {
    get {
      return 1
    }
  }

  func sid(gid: Int) -> Int {
    if gid == 0 {
      return 0
    }

    // Count through the ranges to find the one of interest
    var count = 0
    for range in charsetRanges {
      if gid <= range.count + count {
        let sid = gid - count + range.lowerBound - 1
        return sid
      }
      count += range.count
    }
    return 0
  }

}

class CFFCharsetFormat2: CFFCharset {
  let charsetRanges: [CountableClosedRange<Int>]

  init(dataInput: TCDataInput, glyphCount: Int) {
    var charsetRanges = [CountableClosedRange<Int>]()

    var glyphsCovered = glyphCount - 1  // minus 1 because .notdef is omitted
    while glyphsCovered > 0 {
      let first = Int(dataInput.readUInt16())
      let left = Int(dataInput.readUInt16())
      let range = first...first + left
      charsetRanges.append(range)
      glyphsCovered -= left + 1
    }
    self.charsetRanges = charsetRanges
  }

  var format: Int {
    get {
      return 2
    }
  }

  func sid(gid: Int) -> Int {
    if gid == 0 {
      return 0
    }

    // Count through the ranges to find the one of interest
    var count = 0
    for range in charsetRanges {
      if gid <= range.count + count {
        let sid = gid - count + range.lowerBound - 1
        return sid
      }
      count += range.count
    }
    return 0
  }

}
