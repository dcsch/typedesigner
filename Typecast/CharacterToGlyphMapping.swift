//
//  CharacterToGlyphMapping.swift
//  Type Designer
//
//  Created by David Schweinsberg on 10/17/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class CharacterToGlyphMapping: Codable {
  var language: Int
  var glyphCodes: [Int: Int]
//  var glyphCodes: DictionaryLiteral<Int, Int>

  init(encodedMap: TCCmapFormat) {
    language = encodedMap.language
    let ranges = encodedMap.ranges
    glyphCodes = [:]
    for range in ranges {
      for i in range {
        glyphCodes[i] = encodedMap.glyphCode(characterCode: i)
//        glyphCodes.append(i, encodedMap.glyphCode(characterCode: i))
      }
    }
  }
}
