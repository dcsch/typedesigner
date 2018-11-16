//
//  AdobeMigration.swift
//  UFOSample
//
//  Created by David Schweinsberg on 11/15/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Foundation

class AdobeMigration {

  static func migrate(data: Data) -> Data {
    if let str = String(data: data, encoding: .utf8),
      let range = str.range(of: "<key>com.adobe.type.autohint</key><data>"),
      let r2 = str.range(of: "</data>", range: range.lowerBound..<str.endIndex) {
      let s2 = str[range.upperBound..<r2.lowerBound]
      if let d2 = s2.data(using: .utf8) {

        // Reconstruct the data
        let reconstructedStr = str[str.startIndex..<range.upperBound] +
          d2.base64EncodedString() + str[r2.lowerBound..<str.endIndex]
        return reconstructedStr.data(using: .utf8) ?? data
      }
    }
    return data
  }

}
