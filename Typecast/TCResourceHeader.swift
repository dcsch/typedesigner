//
//  TCResourceHeader.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCResourceHeader {
  let dataOffset: Int
  let mapOffset: Int
  let dataLength: Int
  let mapLength: Int

  init(dataInput: TCDataInput) {
    dataOffset = Int(dataInput.readInt())
    mapOffset = Int(dataInput.readInt())
    dataLength = Int(dataInput.readInt())
    mapLength = Int(dataInput.readInt())
  }
}
