//
//  TCCmapIndexEntry.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCCmapIndexEntry: Comparable, CustomStringConvertible {
  let platformID: TCID.Platform
  let encodingID: Encoding
  let offset: Int
  var format: TCCmapFormat?

  var platformDescription: String {
    get {
      return String(describing: platformID)
    }
  }

  var encodingDescription: String {
    get {
      return String(describing: encodingID)
    }
  }

  init(dataInput: TCDataInput) {
    platformID = TCID.Platform(rawValue: Int(dataInput.readUInt16())) ?? .unknown
    let encodingIDRawValue = Int(dataInput.readUInt16())
    encodingID = platformID.encoding(id: encodingIDRawValue) ?? TCID.CustomEncoding.unknown
    offset = Int(dataInput.readUInt32())
  }

  var description: String {
    get {
      return String(format: "platform id: %d (%@), encoding id: %d (%@), offset: %d",
                    platformID.rawValue,
                    platformDescription,
                    encodingID.rawValue,
                    encodingDescription,
                    offset)
    }
  }

  static func ==(lhs: TCCmapIndexEntry, rhs: TCCmapIndexEntry) -> Bool {
    return lhs.offset == rhs.offset
  }

  static func <(lhs: TCCmapIndexEntry, rhs: TCCmapIndexEntry) -> Bool {
    return lhs.offset < rhs.offset
  }

  static func <=(lhs: TCCmapIndexEntry, rhs: TCCmapIndexEntry) -> Bool {
    return lhs.offset <= rhs.offset
  }

  static func >(lhs: TCCmapIndexEntry, rhs: TCCmapIndexEntry) -> Bool {
    return lhs.offset > rhs.offset
  }

  static func >=(lhs: TCCmapIndexEntry, rhs: TCCmapIndexEntry) -> Bool {
    return lhs.offset >= rhs.offset
  }
}
