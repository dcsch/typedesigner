//
//  OpenTypeFontCollection.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class OpenTypeFontCollection {
  var fonts: [OpenTypeFont]
  var ttcHeader: TTCHeader?
  var suitcase: Bool

  init(data: Data, isSuitcase: Bool) throws {
    fonts = []
    self.suitcase = isSuitcase

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
        let font = try TTFont(data: resData, tablesOrigin: 0)
        fonts.append(font)
      }
    } else if TTCHeader.isTTC(data: data) {

      // This is a TrueType font collection
      let header = TTCHeader(data: data)
      for offset in header.tableDirectory {
        let fontData = data.subdata(in: offset..<data.count)
        let font = try TTFont(data: fontData, tablesOrigin: offset)
        fonts.append(font)
      }
      ttcHeader = header
    } else {

      // This is a standalone font file
      let font = try TTFont(data: data, tablesOrigin: 0)
      fonts.append(font)
    }
  }
}
