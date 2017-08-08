//
//  TCCharacterMapWindowController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/7/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa

class TCCharacterMapping {
  weak var font: TCFont?
  var characterCode: Int
  var glyphCode: Int

  var characterCodeString: String {
    get {
      return String(format: "%04lX", characterCode)
    }
  }

  var glyphImage: NSImage? {
    get {
      return nil
    }
  }

  var glyph: TCGlyph? {
    get {
      //      let glyphDescription = font?.glyfTable?.descript[glyphCode]
      //      let glyph = TCGlyph(glyphDescription: glyphDescription,
      //                          leftSideBearing: font.hmtxTable.leftSideBearing(index: glyphDescription.glyphIndex),
      //                          advanceWidth: font.hmtxTable.advanceWidth(index: glyphDescription.glyphIndex))
      //      return glyph;
      return nil
    }
  }

  init(font: TCFont, characterCode: Int, glyphCode: Int) {
    self.font = font
    self.characterCode = characterCode
    self.glyphCode = glyphCode
  }
}

class TCCharacterMapWindowController: NSWindowController {
  weak var cmapIndexEntry: TCCmapIndexEntry?
  var characterMappings = [TCCharacterMapping]()

  override func windowDidLoad() {
    super.windowDidLoad()

    if let fontCollection = (document as! TCDocument).fontCollection {

      // TODO: Don't just select the first font
      let font = fontCollection.fonts[0]

      characterMappings.removeAll()
      if let format = cmapIndexEntry?.format {
        for range in format.ranges {
          for i in range {
            let mapping = TCCharacterMapping(font: font,
                                             characterCode: i,
                                             glyphCode: format.glyphCode(characterCode: i))
            characterMappings.append(mapping)
          }
        }
      }
    }
  }

//  func insertObject(_ mapping: TCCharacterMapping, inCharacterMappingsAtIndex index: Int) {
//    characterMappings.insert(mapping, at: index)
//  }
//
//  - (void)removeObjectFromCharacterMappingsAtIndex:(NSUInteger)index
//  {
//  [_characterMappings removeObjectAtIndex:index];
//  }

  func setCharacterMappings(_ characterMappings: [TCCharacterMapping]) {
    self.characterMappings = characterMappings
  }

  func CharacterMappings() -> [TCCharacterMapping] {
    return characterMappings
  }
}
