//
//  TCGlyfTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/3/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

/**
 Information describing the glyphs in TrueType outline format.
 */
class TCGlyfTable: TCTable, Codable {
  var descript: [TCGlyfDescript]

  /**
   - parameters:
     - data: the raw table data
     - maxpTable: the maxp table, specifying the glyph count
     - locaTable: the loca table, specifying the offsets to each glyph within
       the table data
     - postTable: the post table, a source of glyph names
   */
  init(data: Data,
       maxpTable: TCMaxpTable,
       locaTable: TCLocaTable) {
    self.descript = []

    super.init()

    // Process each individual glyph
    for i in 0..<maxpTable.numGlyphs {
      let len = locaTable.offsets[i + 1] - locaTable.offsets[i]
      if len > 0 {
        let offset = locaTable.offsets[i]
        let glyfData = data.subdata(in: offset..<offset + len)
        let dataInput = TCDataInput(data: glyfData)
        let numberOfContours = Int(dataInput.readInt16())
        if numberOfContours >= 0 {
          descript.append(TCGlyfSimpleDescript(dataInput: dataInput,
                                               glyphIndex: i,
                                               numberOfContours: numberOfContours))
        } else {
          descript.append(TCGlyfCompositeDescript(dataInput: dataInput, glyphIndex: i))
        }
      } else {
        descript.append(TCGlyfNullDescript())
      }
    }
  }

  override class var tag: TCTable.Tag {
    get {
      return .glyf
    }
  }

  func description(at index: Int) -> TCGlyfDescript {
    if index < descript.count {
      return descript[index]
    } else {
      // Return the missingGlyph
      return descript[0]
    }
  }

//  var countOfGlyphNames: Int {
//    get {
//      return Int(postTable.numGlyphs)
//    }
//  }
//
//  func objectInGlyphNames(at index: Int) -> String {
//    if postTable.version == 0x00020000 {
//      let nameIndex = Int(postTable.glyphNameIndex[index])
//      return (nameIndex > 257) ?
//        postTable.psGlyphName[nameIndex - 258] :
//        TCPostTable.macGlyphName[nameIndex]
//    } else {
//      return ""
//    }
//  }

  private enum CodingKeys: String, CodingKey {
    case descript
  }

  enum DescriptTypeKey: CodingKey {
    case type
    case value
  }

  enum DescriptTypes: String, Codable {
    case null
    case simple
    case composite
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    var nestedArrayContainer = try container.nestedUnkeyedContainer(forKey: CodingKeys.descript)
    var descripts = [TCGlyfDescript]()
    while(!nestedArrayContainer.isAtEnd) {
      let nestedDescriptContainer = try nestedArrayContainer.nestedContainer(keyedBy: DescriptTypeKey.self)
      let type = try nestedDescriptContainer.decode(DescriptTypes.self, forKey: DescriptTypeKey.type)
      switch type {
      case .null:
        descripts.append(try nestedDescriptContainer.decode(TCGlyfNullDescript.self,
                                                            forKey: DescriptTypeKey.value))
      case .simple:
        descripts.append(try nestedDescriptContainer.decode(TCGlyfSimpleDescript.self,
                                                            forKey: DescriptTypeKey.value))
      case .composite:
        descripts.append(try nestedDescriptContainer.decode(TCGlyfCompositeDescript.self,
                                                            forKey: DescriptTypeKey.value))
      }
    }
    self.descript = descripts
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    var nestedArrayContainer = container.nestedUnkeyedContainer(forKey: CodingKeys.descript)
    for d in descript {
      var nestedDescriptContainer = nestedArrayContainer.nestedContainer(keyedBy: DescriptTypeKey.self)
      if let nd = d as? TCGlyfNullDescript {
        try nestedDescriptContainer.encode(DescriptTypes.null, forKey: DescriptTypeKey.type)
        try nestedDescriptContainer.encode(nd, forKey: DescriptTypeKey.value)
      } else if let sd = d as? TCGlyfSimpleDescript {
        try nestedDescriptContainer.encode(DescriptTypes.simple, forKey: DescriptTypeKey.type)
        try nestedDescriptContainer.encode(sd, forKey: DescriptTypeKey.value)
      } else if let cd = d as? TCGlyfCompositeDescript {
        try nestedDescriptContainer.encode(DescriptTypes.composite, forKey: DescriptTypeKey.type)
        try nestedDescriptContainer.encode(cd, forKey: DescriptTypeKey.value)
      }
    }
  }
}
