//
//  DataInput.swift
//  IOUtils
//
//  Created by David Schweinsberg on 8/23/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log

public class DataInput {
  let data: NSData
  let bytes: UnsafeRawPointer
  var offset: Int

  public init(data: Data) {
    self.data = data as NSData
    bytes = self.data.bytes
    offset = 0
  }

}
