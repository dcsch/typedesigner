//
//  TCResourceHeader.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCResourceHeader {
  let dataOffset: UInt32
  let mapOffset: UInt32
  let dataLength: UInt32
  let mapLength: UInt32

  init(dataInput: TCDataInput) {
    dataOffset = dataInput.readUInt32()
    mapOffset = dataInput.readUInt32()
    dataLength = dataInput.readUInt32()
    mapLength = dataInput.readUInt32()
  }
}
