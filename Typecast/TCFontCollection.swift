//
//  TCFontCollection.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCFontCollection: NSObject {
  var fonts: [TCFont]
  var ttcHeader: TCTTCHeader?
  var suitcase: Bool

  init(data: Data, isSuitcase: Bool) {
    fonts = []
    self.suitcase = isSuitcase
    super.init()

    if suitcase {
      // This is a Macintosh font suitcase resource
      let dataInput = TCDataInput(data: data)
      let resourceHeader = TCResourceHeader(dataInput: dataInput)

      // Seek to the map offset and read the map
      let mapData = data.subdata(in: Int(resourceHeader.mapOffset)..<data.count)
      let mapDataInput = TCDataInput(data: mapData)
      let map = TCResourceMap(dataInput: mapDataInput)

      // Get the 'sfnt' resources
      let resourceType = map.resourceType(name: "sfnt")

      // This could be a font suitcase, but with only FONT or NFNT resources
      if resourceType == nil {
        return
      }

      // Load the font data
      for resourceReference in (resourceType?.references)! {
        let offset = resourceHeader.dataOffset + UInt32(resourceReference.dataOffset + 4)
        let resData = data.subdata(in: Int(offset)..<data.count)
        if let font = TCFont(data: resData, tablesOrigin: 0) {
          fonts.append(font)
        }
      }
    } else if TCTTCHeader.isTTC(data: data) {

      // This is a TrueType font collection
      ttcHeader = TCTTCHeader(data: data)
      for i in 0 ..< Int((ttcHeader?.directoryCount)!) {
        let offset = ttcHeader?.tableDirectory[i]
//        font.read(dataInput: dataInput, directoryOffset: Int(offset), tablesOrigin: 0)
        let fontData = data.subdata(in: Int(offset!)..<data.count)
        if let font = TCFont(data: fontData, tablesOrigin: UInt(offset!)) {
          fonts.append(font)
        }
      }
    } else {

      // This is a standalone font file
      if let font = TCFont(data: data, tablesOrigin: 0) {
        fonts.append(font)
      }
    }
  }
}
