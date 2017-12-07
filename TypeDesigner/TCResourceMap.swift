//
//  TCResourceMap.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCResourceMap {
  let headerData: [UInt8]
  let nextResourceMap: UInt32
  let fileReferenceNumber: UInt16
  let attributes: UInt16
  var types: [TCResourceType]

  init(dataInput: TCDataInput) {
    headerData = dataInput.read(length: 16)
    nextResourceMap = dataInput.readUInt32()
    fileReferenceNumber = dataInput.readUInt16()
    attributes = dataInput.readUInt16()

    _ = dataInput.readUInt16()  // typeOffset
    _ = dataInput.readUInt16()  // nameOffset
    let typeCount = Int(dataInput.readUInt16()) + 1

    // Read types
    types = []
    for _ in 0..<typeCount {
      types.append(TCResourceType(dataInput: dataInput))
    }

    // Read the references
    for i in 0..<typeCount {
      types[i].readReferences(dataInput: dataInput)
    }

    // Read the names
    for i in 0..<typeCount {
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
