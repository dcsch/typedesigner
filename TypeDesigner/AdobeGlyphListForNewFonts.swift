//
//  AdobeGlyphListForNewFonts.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/7/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log

class AdobeGlyphListForNewFonts {
  var entries = [(Int, String, String)]()

  init() {
    if let url = Bundle.main.url(forResource: "aglfn", withExtension: "txt") {
      do {
        let contents = try String(contentsOf: url, encoding: .utf8)
        let lines = contents.components(separatedBy: .newlines)
        let separator = CharacterSet.init(charactersIn: ";")
        for line in lines {
          if line.starts(with: "#") || line.isEmpty {
            continue
          }
          let elements = line.components(separatedBy: separator)
          if let unicodeValue = Int(elements[0], radix: 16) {
            let glyphName = elements[1]
            let characterName = elements[2]
            entries.append((unicodeValue, glyphName, characterName))
          }
        }
      } catch {
        os_log("Error loading aglfn.txt")
      }
    }
  }

}
