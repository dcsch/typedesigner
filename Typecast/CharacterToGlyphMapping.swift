//
//  CharacterToGlyphMapping.swift
//  Type Designer
//
//  Created by David Schweinsberg on 10/17/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class CharacterToGlyphMapping: Codable {
  let platformID: TCID.Platform
  let encodingID: Encoding
  var language: Int
  var glyphCodes: [Int: Int]
//  var glyphCodes: DictionaryLiteral<Int, Int>

  init(platformID: TCID.Platform, encodingID: Encoding, encodedMap: TCCmapFormat) {
    self.platformID = platformID
    self.encodingID = encodingID
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

  private enum CodingKeys: String, CodingKey {
    case platformID
    case encodingID
    case language
    case glyphCodes
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    platformID = try container.decode(TCID.Platform.self, forKey: .platformID)
    let encodingInt = try container.decode(Int.self, forKey: .encodingID)
    encodingID = platformID.encoding(id: encodingInt)!
    language = try container.decode(Int.self, forKey: .language)
    glyphCodes = try container.decode([Int: Int].self, forKey: .glyphCodes)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(platformID, forKey: .platformID)
    try container.encode(encodingID.rawValue, forKey: .encodingID)
    try container.encode(language, forKey: .language)
    try container.encode(glyphCodes, forKey: .glyphCodes)
  }
}
