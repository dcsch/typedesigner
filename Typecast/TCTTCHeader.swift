//
//  TCTTCHeader.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/2/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCTTCHeader {
  let ttcTag: Int32
  let version: Int32
  let directoryCount: Int32
  var tableDirectory: [Int32]
  let dsigTag: Int32
  let dsigLength: Int32
  let dsigOffset: Int32

  class func isTTC(data: Data) -> Bool {
    let dataInput = TCDataInput(data: data)
    let ttcf: Int32 = 0x74746366
    let ttcTag = dataInput.readInt32()
    return ttcTag == ttcf
  }

  init(data: Data) {
    let dataInput = TCDataInput(data: data)
    ttcTag = dataInput.readInt32()
    version = dataInput.readInt32()
    directoryCount = dataInput.readInt32()
    tableDirectory = []
    for _ in 0..<directoryCount {
      tableDirectory.append(dataInput.readInt32())
    }
    if version == 0x00020000 {
      dsigTag = dataInput.readInt32()
      dsigLength = dataInput.readInt32()
      dsigOffset = dataInput.readInt32()
    } else {
      dsigTag = 0
      dsigLength = 0
      dsigOffset = 0
    }
  }
}
