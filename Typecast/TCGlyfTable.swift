//
//  TCGlyfTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/3/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCGlyfTable: TCTable {
  var descript: [TCGlyfDescript]
  let postTable: TCPostTable

  init(data: Data,
       directoryEntry: TCDirectoryEntry,
       maxpTable: TCMaxpTable,
       locaTable: TCLocaTable,
       postTable: TCPostTable) {
    self.descript = []
    self.postTable = postTable

    super.init()
    self.directoryEntry = directoryEntry.copy() as! TCDirectoryEntry

    // Process all the simple glyphs
    for i in 0..<Int(maxpTable.numGlyphs) {
      let len = locaTable.offset(at: UInt(i + 1)) - locaTable.offset(at: UInt(i))
      if len > 0 {
        let offset = locaTable.offset(at: UInt(i))
        let glyfData = data.subdata(in: Int(offset)..<Int(offset + len))
        let dataInput = TCDataInput(data: glyfData)
        let numberOfContours = Int(dataInput.readInt16())
        if numberOfContours >= 0 {
          descript.append(TCGlyfSimpleDescript(dataInput: dataInput,
                                                parentTable: self,
                                                glyphIndex: i,
                                                numberOfContours: numberOfContours))
        }
      } else {
        descript.append(TCGlyfNullDescript(glyphIndex: i))
      }
    }

//        // Now do all the composite glyphs
//        for (int i = 0; i < maxp.getNumGlyphs(); i++) {
//            int len = loca.getOffset(i + 1) - loca.getOffset(i);
//            if (len > 0) {
//                bais.reset();
//                bais.skip(loca.getOffset(i));
//                DataInputStream dis = new DataInputStream(bais);
//                short numberOfContours = dis.readShort();
//                if (numberOfContours < 0) {
//                    _descript[i] = new GlyfCompositeDescript(this, i, dis);
//                }
//            }
//        }
  }

  override var type: UInt32 {
    get {
      return TCTableType.glyf.rawValue
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

  override func value(forUndefinedKey key: String) -> Any? {
    return super.value(forUndefinedKey: key)
  }
}
