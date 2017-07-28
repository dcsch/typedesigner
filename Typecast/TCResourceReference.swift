//
//  TCResourceReference.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCResourceReference {
  let resourceID: Int
  let nameOffset: Int
  let attributes: Int
  let dataOffset: Int
  let handle: Int
  var name: String?

  init(dataInput: TCDataInput) {
    resourceID = Int(dataInput.readUnsignedShort())
    nameOffset = Int(dataInput.readShort())
    attributes = Int(dataInput.readUnsignedByte())
    dataOffset = Int(dataInput.readUnsignedByte()) << 16 | Int(dataInput.readUnsignedShort())
    handle = Int(dataInput.readInt())
  }

  func readName(dataInput: TCDataInput) {
    if nameOffset > -1 {
      let len = UInt(dataInput.readUnsignedByte())
      let data = dataInput.readData(withLength: len)
      name = String(data: data!, encoding: String.Encoding.ascii)!
    }
  }
}
