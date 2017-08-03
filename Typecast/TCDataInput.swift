//
//  TCDataInput.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/31/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log

class TCDataInput: NSObject {
  let inputStream: InputStream

  init(data: Data) {
    inputStream = InputStream(data: data)
    inputStream.open()
  }

  func read(length: Int) -> [UInt8] {
    var buf = Array<UInt8>(repeating: 0, count: length)
    let read = inputStream.read(&buf, maxLength: length)
    if read != length {
      os_log("Stream error: %s", inputStream.streamError.debugDescription)
    }
    return buf;
  }

  func readInt32() -> Int32 {
    var buf: [UInt8] = [0, 0, 0, 0]
    inputStream.read(&buf, maxLength: buf.capacity)
    let value = Int32(buf[0]) << 24 | Int32(buf[1]) << 16 | Int32(buf[2]) << 8 | Int32(buf[3])
    return value
  }

  func readInt16() -> Int16 {
    var buf: [UInt8] = [0, 0]
    inputStream.read(&buf, maxLength: buf.capacity)
    let value = Int16(buf[0]) << 8 | Int16(buf[1])
    return value
  }

  func readInt8() -> Int8 {
    var value: UInt8 = 0
    inputStream.read(&value, maxLength: 1)
    return Int8(bitPattern: value)
  }

  func readUInt64() -> UInt64 {
    var buf: [UInt8] = [0, 0, 0, 0, 0, 0, 0, 0]
    inputStream.read(&buf, maxLength: buf.capacity)
    let value = UInt64(buf[0]) << 56 | UInt64(buf[1]) << 48 | UInt64(buf[2]) << 40 | UInt64(buf[3]) << 32 |
      UInt64(buf[4]) << 24 | UInt64(buf[5]) << 16 | UInt64(buf[6]) << 8 | UInt64(buf[7])
    return value
  }

  func readUInt32() -> UInt32 {
    var buf: [UInt8] = [0, 0, 0, 0]
    let ret = inputStream.read(&buf, maxLength: buf.capacity)
    if ret == -1 {
      os_log("Stream error: %s", inputStream.streamError.debugDescription)
    }
    let value = UInt32(buf[0]) << 24 | UInt32(buf[1]) << 16 | UInt32(buf[2]) << 8 | UInt32(buf[3])
    return value
  }

  func readUInt16() -> UInt16 {
    var buf: [UInt8] = [0, 0]
    inputStream.read(&buf, maxLength: buf.capacity)
    let value = UInt16(buf[0]) << 8 | UInt16(buf[1])
    return value
  }

  func readUInt8() -> UInt8 {
    var value: UInt8 = 0
    inputStream.read(&value, maxLength: 1)
    return value
  }
}
