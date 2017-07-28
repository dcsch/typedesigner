//
//  TCResourceType.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCResourceType {
  let type: Int
  let count: Int
  let offset: Int
  var references: [TCResourceReference] = []

  init(dataInput: TCDataInput) {
    type = Int(dataInput.readInt())
    count = Int(dataInput.readUnsignedShort()) + 1;
    offset = Int(dataInput.readUnsignedShort())
  }

  func readReferences(dataInput: TCDataInput) {
    references = []
    for _ in 0 ..< count {
      references.append(TCResourceReference(dataInput: dataInput))
    }
  }

  func readNames(dataInput: TCDataInput) {
    for i in 0 ..< count {
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
