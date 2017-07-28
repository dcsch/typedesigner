//
//  TCResourceMap.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCResourceMap {
  let headerData: Data
  let nextResourceMap: Int
  let fileReferenceNumber: Int
  let attributes: Int
  var types: [TCResourceType]

  init(dataInput: TCDataInput) {
    headerData = dataInput.readData(withLength:16)
    nextResourceMap = Int(dataInput.readInt())
    fileReferenceNumber = Int(dataInput.readUnsignedShort())
    attributes = Int(dataInput.readUnsignedShort())

    _ = dataInput.readUnsignedShort()  // typeOffset
    _ = dataInput.readUnsignedShort()  // nameOffset
    let typeCount = Int(dataInput.readUnsignedShort()) + 1

    // Read types
    types = []
    for _ in 0 ..< typeCount {
      types.append(TCResourceType(dataInput: dataInput))
    }

    // Read the references
    for i in 0 ..< typeCount {
      types[i].readReferences(dataInput: dataInput)
    }

    // Read the names
    for i in 0 ..< typeCount {
      types[i].readNames(dataInput: dataInput)
    }
  }

  func resourceType(name typeName: String) -> TCResourceType? {
    for type in types {
      if type.typeAsString() == typeName {
        return type;
      }
    }
    return nil;
  }
}
