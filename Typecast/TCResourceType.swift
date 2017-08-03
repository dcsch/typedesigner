//
//  TCResourceType.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCResourceType {
  let type: UInt32
  let count: UInt16
  let offset: UInt16
  var references: [TCResourceReference] = []

  init(dataInput: TCDataInput) {
    type = dataInput.readUInt32()
    count = dataInput.readUInt16() + 1
    offset = dataInput.readUInt16()
  }

  func readReferences(dataInput: TCDataInput) {
    references = []
    for _ in 0 ..< count {
      references.append(TCResourceReference(dataInput: dataInput))
    }
  }

  func readNames(dataInput: TCDataInput) {
    for i in 0 ..< Int(count) {
      references[i].readName(dataInput: dataInput)
    }
  }

  func typeAsString() -> String {
    return String(format: "%c%c%c%c",
                  CChar((type >> 24) & 0xff),
                  CChar((type >> 16) & 0xff),
                  CChar((type >> 8) & 0xff),
                  CChar(type & 0xff))
  }
}
