//
//  GaspTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 12/7/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

/**
 Grid-fitting And Scan-conversion Procedure Table.
 */
class GaspTable: Table, Codable {

  struct GaspRange: Codable {
    let rangeMaxPPEM: Int
    let rangeGaspBehavior: Int
  }

  var gaspRanges: [GaspRange]

  init(data: Data) {
    let dataInput = TCDataInput(data: data)
    _ = Int(dataInput.readUInt16()) // Version
    let numRanges = Int(dataInput.readUInt16())
    gaspRanges = []
    for _ in 0..<numRanges {
      let rangeMaxPPEM = Int(dataInput.readUInt16())
      let rangeGaspBehavior = Int(dataInput.readUInt16())
      gaspRanges.append(GaspRange(rangeMaxPPEM: rangeMaxPPEM,
                                  rangeGaspBehavior: rangeGaspBehavior))
    }
  }
}
