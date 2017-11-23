//
//  TCGlyfDescript.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/3/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCGlyfDescript: CustomStringConvertible, Codable {
  var glyphIndex: Int

  init(glyphIndex: Int) {
    self.glyphIndex = glyphIndex
  }

  var description: String {
    get {
      return "TCGlyfDescript"
    }
  }

  private enum CodingKeys: String, CodingKey {
    case glyphIndex
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    glyphIndex = try container.decode(Int.self, forKey: .glyphIndex)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(glyphIndex, forKey: .glyphIndex)
  }
}
