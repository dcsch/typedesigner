//
//  Table.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/13/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log

enum TableError: Error {
  case unrecognizedTableType(tag: UInt32)
  case unimplementedTableType(tag: UInt32)
  case missingTable(tag: UInt32)
  case badOffset(message: String)
}

/**
 The superclass for all OpenType tables.
 */
class Table: CustomStringConvertible {

  enum Tag: UInt32, CustomStringConvertible {

    // Baseline data [OpenType]
    case BASE = 0x42415345

    // PostScript font program (compact font format) [PostScript]
    case CFF = 0x43464620

    // Digital signature
    case DSIG = 0x44534947

    // Embedded bitmap data
    case EBDT = 0x45424454

    // Embedded bitmap location data
    case EBLC = 0x45424c43

    // Embedded bitmap scaling data
    case EBSC = 0x45425343

    // Glyph definition data [OpenType]
    case GDEF = 0x47444546

    // Glyph positioning data [OpenType]
    case GPOS = 0x47504f53

    // Glyph substitution data [OpenType]
    case GSUB = 0x47535542

    // Justification data [OpenType]
    case JSTF = 0x4a535446

    // Linear threshold table
    case LTSH = 0x4c545348

    // Multiple master font metrics [PostScript]
    case MMFX = 0x4d4d4658

    // Multiple master supplementary data [PostScript]
    case MMSD = 0x4d4d5344

    // OS/2 and Windows specific metrics [r]
    case OS_2 = 0x4f532f32

    // PCL5
    case PCLT = 0x50434c54

    // Vertical Device Metrics table
    case VDMX = 0x56444d58

    // character to glyph mapping [r]
    case cmap = 0x636d6170

    // Control Value Table
    case cvt = 0x63767420

    // font program
    case fpgm = 0x6670676d

    // Apple's font variations table [PostScript]
    case fvar = 0x66766172

    // grid-fitting and scan conversion procedure (grayscale)
    case gasp = 0x67617370

    // glyph data [r]
    case glyf = 0x676c7966

    // horizontal device metrics
    case hdmx = 0x68646d78

    // font header [r]
    case head = 0x68656164

    // horizontal header [r]
    case hhea = 0x68686561

    // horizontal metrics [r]
    case hmtx = 0x686d7478

    // kerning
    case kern = 0x6b65726e

    // index to location [r]
    case loca = 0x6c6f6361

    // maximum profile [r]
    case maxp = 0x6d617870

    // naming table [r]
    case name = 0x6e616d65

    // CVT Program
    case prep = 0x70726570

    // PostScript information [r]
    case post = 0x706f7374

    // Vertical Metrics header
    case vhea = 0x76686561

    // Vertical Metrics
    case vmtx = 0x766d7478

    var description: String {
      get {
        return String(format: "%c%c%c%c",
                      CChar(truncatingIfNeeded:rawValue >> 24),
                      CChar(truncatingIfNeeded:rawValue >> 16),
                      CChar(truncatingIfNeeded:rawValue >> 8),
                      CChar(truncatingIfNeeded:rawValue))
      }
    }
  }

  var description: String {
    get {
      return "TCTable"
    }
  }
}
