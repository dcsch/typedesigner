//
//  TCCmapFormat.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

protocol CmapFormat {

  var format: Int { get }

  var length: Int { get }

  var language: Int { get }

  var ranges: [CountableClosedRange<Int>] { get }

  func glyphCode(characterCode: Int) -> Int
}

class CmapFormatFactory {

  class func cmapFormat(type formatType: Int, dataInput: TCDataInput) -> CmapFormat {
    switch formatType {
    case 0:
      return CmapFormat0(dataInput: dataInput)
    case 2:
      return CmapFormat2(dataInput: dataInput)
    case 4:
      return CmapFormat4(dataInput: dataInput)
    case 6:
      return CmapFormat6(dataInput: dataInput)
    case 12:
      return CmapFormat12(dataInput: dataInput)
    default:
      return CmapFormatUnknown(type: formatType, dataInput: dataInput)
    }
  }

}
