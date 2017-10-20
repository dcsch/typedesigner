//
//  TCCvtTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/18/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

/**
 The Control Value Table.
 */
class TCCvtTable: TCBaseTable, Codable {
  var values = [Int]()

  init(data: Data) {
    let dataInput = TCDataInput(data: data)
    let len = data.count / 2
    values.reserveCapacity(len)
    for _ in 0..<len {
      values.append(Int(dataInput.readInt16()))
    }
    super.init()
  }

  override class var tag: UInt32 {
    get {
      return TCTableTag.cvt.rawValue
    }
  }

  override var description: String {
    get {
      var str = "'cvt ' Table - Control Value Table\n----------------------------------\n"
      str.append("Size = \(2 * values.count) bytes, \(values.count) entries\n")
      str.append("        Values\n        ------\n")
      for (i, value) in values.enumerated() {
        str.append("        \(i): \(value)\n")
      }
      return str
    }
  }
}
