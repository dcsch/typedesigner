//
//  GLIF2Tests.swift
//  UFOKitTests
//
//  Created by David Schweinsberg on 5/11/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import XCTest
import UFOKit

class GLIF2Tests: XCTestCase {

  var ufoReader: UFOReader!

  override func setUp() {
    super.setUp()
    if let testBundle = Bundle(identifier: "com.typista.UFOKitTests"),
      let url = testBundle.url(forResource: "test_v3", withExtension: "ufo") {
      do {
        ufoReader = try UFOReader(url: url)
      } catch {
        print("Error: \(error)")
      }
    }
  }

  override func tearDown() {
    super.tearDown()
  }

  func testTopElement() {
    let glif = """
    <notglyph name="a" format="2">
      <outline>
      </outline>
    </notglyph>
    """
  }

  func testReadGlyphException() {
    XCTAssertNoThrow(try {
      let glyphSet = try self.ufoReader.glyphSet()
      let pen = QuartzPen(glyphSet: glyphSet)
      XCTAssertThrowsError(try glyphSet.readGlyph(glyphName: ".notdef", pointPen: pen))
      XCTAssertNoThrow(try glyphSet.readGlyph(glyphName: "A", pointPen: pen))
    }())
  }
}
