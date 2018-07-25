//
//  FontScriptSwiftTests.swift
//  FontScriptSwiftTests
//
//  Created by David Schweinsberg on 7/6/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import XCTest
import FontScript

class FontScriptSwiftTests: XCTestCase {
    
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testGlyphAppendContour() {
    let glyph = FontScript.Glyph(name: "A", layer: nil)
    XCTAssertEqual(glyph.contours.count, 0)
    let contour = FontScript.Contour(glyph: nil)
    glyph.appendContour(contour, offset: CGPoint.zero)
    XCTAssertEqual(glyph.contours.count, 1)
  }

  func testPoint() {
    let point = FontScript.Point(point: CGPoint(x: 100, y: 100), type: .move, smooth: false)
    XCTAssertEqual(point.x, 100)
    XCTAssertEqual(point.y, 100)
    XCTAssertEqual(point.type, .move)
    point.x = 110
    point.y = 120
    point.type = .curve
    XCTAssertEqual(point.x, 110)
    XCTAssertEqual(point.y, 120)
    XCTAssertEqual(point.type, .curve)
  }

  func testRandomIdentifier() {
    for _ in 0..<1000 {
      XCTAssertNoThrow(try Identifier.randomIdentifier())
    }
  }
}
