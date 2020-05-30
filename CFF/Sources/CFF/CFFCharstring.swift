//
//  CFFCharstring.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/9/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

/**
 CFF Charstring
 */
public protocol CFFCharstring {
  var index: Int { get }
  var name: String { get }
}
