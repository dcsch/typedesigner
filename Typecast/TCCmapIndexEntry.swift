//
//  TCCmapIndexEntry.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCCmapIndexEntry: NSObject, Comparable {
  let platformID: Int
  let encodingID: Int
  let offset: Int
  var format: TCCmapFormat?

  var platformDescription: String {
    get {
      return TCID.platformName(platformID: platformID)
    }
  }

  var encodingDescription: String {
    get {
      return TCID.encodingName(platformID: platformID, encodingID: encodingID)
    }
  }

  init(dataInput: TCDataInput) {
    platformID = Int(dataInput.readUInt16())
    encodingID = Int(dataInput.readUInt16())
    offset = Int(dataInput.readUInt32())
  }

  override var description: String {
    get {
      return String(format: "platform id: %d (%@), encoding id: %d (%@), offset: %d",
                    platformID,
                    TCID.platformName(platformID: platformID),
                    encodingID,
                    TCID.encodingName(platformID: platformID, encodingID: encodingID),
                    offset)
    }
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
