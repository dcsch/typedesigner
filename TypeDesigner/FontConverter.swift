//
//  FontConverter.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/3/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Foundation

protocol FontConverter {
  var fontNames: [String] { get }
  func convert(index: Int) throws -> UFOFont
}
