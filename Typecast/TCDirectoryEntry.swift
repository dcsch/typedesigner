//
//  TCDirectoryEntry.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/31/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

struct TCDirectoryEntry: CustomStringConvertible {
  let tag: UInt32
  let checksum: UInt32
  let offset: Int
  let length: Int
  var tagAsString: String {
    get {
      return String(format: "%c%c%c%c",
                    CChar(truncatingIfNeeded: tag >> 24),
                    CChar(truncatingIfNeeded: tag >> 16),
                    CChar(truncatingIfNeeded: tag >> 8),
                    CChar(truncatingIfNeeded: tag))
    }
  }

  init(dataInput: TCDataInput) {
    tag = dataInput.readUInt32()
    checksum = dataInput.readUInt32()
    offset = Int(dataInput.readUInt32())
    length = Int(dataInput.readUInt32())
  }

  init(tag: UInt32, checksum: UInt32, offset: Int, length: Int) {
    self.tag = tag
    self.checksum = checksum
    self.offset = offset
    self.length = length
  }

  var description: String {
    get {
      return String(format:"'%@' - chksm = 0x%x, off = 0x%x, len = %d",
                    tagAsString,
                    checksum,
                    offset,
                    length)
    }
  }
}
