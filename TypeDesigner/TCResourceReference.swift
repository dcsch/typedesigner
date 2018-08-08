//
//  TCResourceReference.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCResourceReference {
  let resourceID: UInt16
  let nameOffset: Int16
  let attributes: UInt8
  let dataOffset: UInt32
  let handle: UInt32
  var name: String?

  init(dataInput: TCDataInput) {
    resourceID = dataInput.readUInt16()
    nameOffset = dataInput.readInt16()
    attributes = dataInput.readUInt8()
    dataOffset = UInt32(dataInput.readUInt8()) << 16 | UInt32(dataInput.readUInt16())
    handle = dataInput.readUInt32()
  }

  func readName(dataInput: TCDataInput) {
    if nameOffset > -1 {
      let len = Data.Index(dataInput.readUInt8())
      let bytes = dataInput.read(length: len)
      name = String(bytes: bytes, encoding: String.Encoding.ascii)!
    }
  }

}
