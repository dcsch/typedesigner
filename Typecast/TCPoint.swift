//
//  TCPoint.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/26/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class TCPoint: NSObject {
  var x: Int
  var y: Int
  var onCurve: Bool
  var endOfContour: Bool
  var touched: Bool

  init(x: Int, y: Int, onCurve: Bool, endOfContour: Bool, touched: Bool) {
    self.x = x
    self.y = y
    self.onCurve = onCurve
    self.endOfContour = endOfContour
    self.touched = touched
  }
}
