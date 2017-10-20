//
//  T2Glyph.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/11/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log
import CFF

/**
 An individual Type 2 Charstring glyph within a font.
 */
class T2Glyph: Glyph {
  let glyphIndex: Int
  var leftSideBearing: Int
  var advanceWidth: Int
  var points: [CFFPoint]
  var hstems: [Int]
  var vstems: [Int]

  /**
   Construct a Glyph from a PostScript outline described by a Charstring.
   - parameters
     - charstring: The Charstring describing the glyph.
     - leftSideBearing: The Left Side Bearing.
     - advanceWidth: The advance width.
   */
  init?(glyphIndex: Int,
        charstring: CFFCharstring,
        localSubrIndex: CFFIndex,
        globalSubrIndex: CFFIndex,
        leftSideBearing: Int,
        advanceWidth: Int) {
    self.glyphIndex = glyphIndex
    self.leftSideBearing = leftSideBearing
    self.advanceWidth = advanceWidth
    if let cst2 = charstring as? CFFCharstringType2 {
      let t2i = CFFType2Interpreter(localSubrIndex: localSubrIndex,
                                    globalSubrIndex: globalSubrIndex)
      do {
        points = try t2i.execute(cs: cst2)
        hstems = t2i.hstems
        vstems = t2i.vstems
      } catch {
        os_log("Failed to interpret charstring")
        return nil
      }
    } else {
      return nil
    }
  }

//  var bounds: CGRect {
//    var r: CGRect
//    for p in points) {
//      if (r == null) {
//        r = new Rectangle(p.x, p.y, 0, 0);
//      }
//      r.add(new java.awt.Point(p.x, p.y));
//    }
//    return r != null ? r : new Rectangle(0, 0, 0, 0);
//  }
}
