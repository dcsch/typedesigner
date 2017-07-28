//
//  TCFontCollection.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCFontCollection: NSObject {
  var fonts: [TCFont] = []
  var ttcHeader: TCTTCHeader?
  var suitcase: Bool

  init(data: Data, isSuitcase: Bool) {
    self.suitcase = isSuitcase
    super.init()
    load(fontData: data)
  }

  func load(fontData: Data) {
    let dataInput = TCDataInput(data: fontData)
    fonts.removeAll()

    if suitcase {
      // This is a Macintosh font suitcase resource
      let resourceHeader = TCResourceHeader(dataInput: dataInput!)

      // Seek to the map offset and read the map
      dataInput?.reset()
      dataInput?.skipByteCount(UInt(resourceHeader.mapOffset))
      let map = TCResourceMap(dataInput: dataInput!)

      // Get the 'sfnt' resources
      let resourceType = map.resourceType(name: "sfnt")

      // This could be a font suitcase, but with only FONT or NFNT resources
      if resourceType == nil {
        return
      }

      // Load the font data
      for resourceReference in (resourceType?.references)! {
        let font = TCFont()
        fonts.append(font)
        let offset = UInt(resourceHeader.dataOffset + resourceReference.dataOffset + 4)
        font.read(from: dataInput, directoryOffset:offset, tablesOrigin:offset)
      }
    } else if TCTTCHeader.isTTCDataInput(dataInput) {

      // This is a TrueType font collection
      dataInput?.reset()
      ttcHeader = TCTTCHeader(dataInput: dataInput)
      for i in 0 ..< Int((ttcHeader?.directoryCount)!) {
        let font = TCFont()
        fonts.append(font)
        let offset = UInt(ttcHeader?.tableDirectory[i] as! Int)
        font.read(from: dataInput, directoryOffset: offset, tablesOrigin: 0)
      }
    } else {

      // This is a standalone font file
      let font = TCFont()
      font.read(from: dataInput, directoryOffset: 0, tablesOrigin: 0)
      fonts.append(font)
    }
  }
}
