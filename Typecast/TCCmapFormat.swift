//
//  TCCmapFormat.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

protocol TCCmapFormat {

  var format: Int { get }

  var length: Int { get }

  var language: Int { get }

  var ranges: [CountableClosedRange<Int>] { get }

  func glyphCode(characterCode: Int) -> Int
}

class TCCmapFormatFactory {
  class func cmapFormat(type formatType: Int, dataInput: TCDataInput) -> TCCmapFormat {
    switch formatType {
    case 0:
      return TCCmapFormat0(dataInput: dataInput)
    case 2:
      return TCCmapFormat2(dataInput: dataInput)
    case 4:
      return TCCmapFormat4(dataInput: dataInput)
    case 6:
      return TCCmapFormat6(dataInput: dataInput)
    case 12:
      return TCCmapFormat12(dataInput: dataInput)
    default:
      return TCCmapFormatUnknown(type: formatType, dataInput: dataInput)
    }
  }
}
