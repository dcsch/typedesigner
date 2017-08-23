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
class TCGlyfTable: TCBaseTable {
  var descript: [TCGlyfDescript]
  let postTable: TCPostTable

  /**
   - parameters:
     - data: the raw table data
     - directoryEntry: info about this table's length and offset within the
       font file
     - maxpTable: the maxp table, specifying the glyph count
     - locaTable: the loca table, specifying the offsets to each glyph within
       the table data
     - postTable: the post table, a source of glyph names
   */
  init(data: Data,
       directoryEntry: TCDirectoryEntry,
       maxpTable: TCMaxpTable,
       locaTable: TCLocaTable,
       postTable: TCPostTable) {
    self.descript = []
    self.postTable = postTable

    super.init(directoryEntry: directoryEntry)

    // Process all the simple glyphs
    for i in 0..<maxpTable.numGlyphs {
      let len = locaTable.offset(at: i + 1) - locaTable.offset(at: i)
      if len > 0 {
        let offset = locaTable.offset(at: i)
        let glyfData = data.subdata(in: Int(offset)..<Int(offset + len))
        let dataInput = TCDataInput(data: glyfData)
        let numberOfContours = Int(dataInput.readInt16())
        if numberOfContours >= 0 {
          descript.append(TCGlyfSimpleDescript(dataInput: dataInput,
                                               parentTable: self,
                                               glyphIndex: i,
                                               numberOfContours: numberOfContours))
        } else {
          // Temporary placeholder
          descript.append(TCGlyfNullDescript(glyphIndex: i))
        }
      } else {
        descript.append(TCGlyfNullDescript(glyphIndex: i))
      }
    }

    // Now do all the composite glyphs
    for i in 0..<maxpTable.numGlyphs {
      let len = locaTable.offset(at: i + 1) - locaTable.offset(at: i)
      if len > 0 {
        let offset = locaTable.offset(at: i)
        let glyfData = data.subdata(in: Int(offset)..<Int(offset + len))
        let dataInput = TCDataInput(data: glyfData)
        let numberOfContours = Int(dataInput.readInt16())
        if numberOfContours < 0 {
          descript[i] = TCGlyfCompositeDescript(dataInput: dataInput,
                                                parentTable: self,
                                                glyphIndex: i)
        }
      }
    }
  }

  override class var tag: UInt32 {
    get {
      return TCTableTag.glyf.rawValue
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

  var countOfGlyphNames: Int {
    get {
      return Int(postTable.numGlyphs)
    }
  }

  func objectInGlyphNames(index: Int) -> String? {
    if postTable.version == 0x00020000 {
      let nameIndex = Int(postTable.glyphNameIndex[index])
      return (nameIndex > 257) ?
        postTable.psGlyphName[nameIndex - 258] :
        TCPostTable.macGlyphName[nameIndex]
    } else {
      return nil
    }
  }
}
