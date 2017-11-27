//
//  TCDsigTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/18/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

/**
 Digital Signature Table.
 */
class TCDsigTable: TCTable, Codable {

  class SignatureRecord: Codable {
    let format: Int
    let length: Int
    let offset: Int

    init(dataInput: TCDataInput) {
      format = Int(dataInput.readInt32())
      length = Int(dataInput.readInt32())
      offset = Int(dataInput.readInt32())
    }
  }

  class SignatureBlockFormat1: CustomStringConvertible, Codable {
    let signatureLen: Int
    var signature: [UInt8]

    init(dataInput: TCDataInput) {
      _ = dataInput.readUInt16()
      _ = dataInput.readUInt16()
      signatureLen = Int(dataInput.readInt32())
      signature = dataInput.read(length: signatureLen)
    }

    var description: String {
      get {
        if let str = String(bytes: signature, encoding: .ascii) {
          return str
        } else {
          return String(describing: self)
        }
      }
    }
  }

  let version: Int
  let numSignatures: Int
  let flags: Int
  var signatureRecords = [SignatureRecord]()
  var signatureBlocks = [SignatureBlockFormat1]()

  init(data: Data) {
    let dataInput = TCDataInput(data: data)
    version = Int(dataInput.readInt32())
    numSignatures = Int(dataInput.readUInt16())
    flags = Int(dataInput.readUInt16())
    signatureRecords.reserveCapacity(numSignatures)
    signatureBlocks.reserveCapacity(numSignatures)
    for _ in 0..<numSignatures {
      signatureRecords.append(SignatureRecord(dataInput: dataInput))
    }
    for _ in 0..<numSignatures {
      signatureBlocks.append(SignatureBlockFormat1(dataInput: dataInput))
    }
    super.init()
  }

  override class var tag: TCTable.Tag {
    get {
      return .DSIG
    }
  }

  override var description: String {
    get {
      var str = "DSIG\n"
      for signatureBlock in signatureBlocks {
        str.append("\(signatureBlock)\n")
      }
      return str
    }
  }
}
