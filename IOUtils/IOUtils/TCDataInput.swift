//
//  TCDataInput.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/31/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log

public class TCDataInput: NSObject {
  let inputStream: InputStream

  public init(data: Data) {
    inputStream = InputStream(data: data)
    inputStream.open()
  }

  public func read(length: Int) -> [UInt8] {
    if length < 0 {
      os_log("Error: read length less than zero: %d", length)
      return []
    }
    var buf = Array<UInt8>(repeating: 0, count: length)
    let read = inputStream.read(&buf, maxLength: length)
    if read != length {
      os_log("Stream error: %s", inputStream.streamError.debugDescription)
    }
    return buf;
  }

  public func readInt32() -> Int32 {
    var buf: [UInt8] = [0, 0, 0, 0]
    inputStream.read(&buf, maxLength: buf.capacity)
    let v0 = Int32(buf[0]) << 24
    let v1 = Int32(buf[1]) << 16
    let v2 = Int32(buf[2]) << 8
    let v3 = Int32(buf[3])
    let value = v0 | v1 | v2 | v3
    return value
  }

  public func readInt16() -> Int16 {
    var buf: [UInt8] = [0, 0]
    inputStream.read(&buf, maxLength: buf.capacity)
    let value = Int16(buf[0]) << 8 | Int16(buf[1])
    return value
  }

  public func readInt8() -> Int8 {
    var value: UInt8 = 0
    inputStream.read(&value, maxLength: 1)
    return Int8(bitPattern: value)
  }

  public func readUInt64() -> UInt64 {
    var buf: [UInt8] = [0, 0, 0, 0, 0, 0, 0, 0]
    inputStream.read(&buf, maxLength: buf.capacity)
    let v0 = UInt64(buf[0]) << 56
    let v1 = UInt64(buf[1]) << 48
    let v2 = UInt64(buf[2]) << 40
    let v3 = UInt64(buf[3]) << 32
    let v4 = UInt64(buf[4]) << 24
    let v5 = UInt64(buf[5]) << 16
    let v6 = UInt64(buf[6]) << 8
    let v7 = UInt64(buf[7])
    let value = v0 | v1 | v2 | v3 | v4 | v5 | v6 | v7
    return value
  }

  public func readUInt32() -> UInt32 {
    var buf: [UInt8] = [0, 0, 0, 0]
    let ret = inputStream.read(&buf, maxLength: buf.capacity)
    if ret == -1 {
      os_log("Stream error: %s", inputStream.streamError.debugDescription)
    }
    let v0 = UInt32(buf[0]) << 24
    let v1 = UInt32(buf[1]) << 16
    let v2 = UInt32(buf[2]) << 8
    let v3 = UInt32(buf[3])
    let value = v0 | v1 | v2 | v3
    return value
  }

  public func readUInt16() -> UInt16 {
    var buf: [UInt8] = [0, 0]
    inputStream.read(&buf, maxLength: buf.capacity)
    let value = UInt16(buf[0]) << 8 | UInt16(buf[1])
    return value
  }

  public func readUInt8() -> UInt8 {
    var value: UInt8 = 0
    inputStream.read(&value, maxLength: 1)
    return value
  }
}
