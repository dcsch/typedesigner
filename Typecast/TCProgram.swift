//
//  TCProgram.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/3/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCProgram: NSObject {
  var instructions = [UInt8]()

  func readInstructions(dataInput: TCDataInput, count: Int) {
    instructions = dataInput.read(length: count)
  }
}
