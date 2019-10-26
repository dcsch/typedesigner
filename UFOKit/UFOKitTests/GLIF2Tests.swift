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
//    let glif = """
//    <notglyph name="a" format="2">
//      <outline>
//      </outline>
//    </notglyph>
//    """
  }

  func testReadGlyphException() {
    XCTAssertNoThrow(try {
      let glyphSet = try self.ufoReader.glyphSet()
      let pen = QuartzPen(glyphSet: glyphSet)
      XCTAssertThrowsError(try glyphSet.readGlyph(glyphName: ".notdef", pointPen: pen))
      XCTAssertNoThrow(try glyphSet.readGlyph(glyphName: "A", pointPen: pen))
    }())
  }

  func testFSGlyph() {

    class TestGlyph: UFOKit.FSGlyph {
      var width: CGFloat = 0
      var height: CGFloat = 0
      var unicodes: [NSNumber] = []
      var note: String = ""
      var lib: Data = Data()
      var image: [String : Any] = [:]
      var guidelines: [[String : Any]] = []
      var anchors: [[String : Any]] = []
    }

    class Lib: Codable {
      var brightness: Int?
      var contrast: Int?
      var saturation: Int?
      var sharpness: Double?

      enum CodingKeys: String, CodingKey {
        case brightness = "com.typemytype.robofont.Image.Brightness"
        case contrast = "com.typemytype.robofont.Image.Contrast"
        case saturation = "com.typemytype.robofont.Image.Saturation"
        case sharpness = "com.typemytype.robofont.Image.Sharpness"
      }
    }

    let testGlyph = TestGlyph()

    XCTAssertNoThrow(try {
      let glyphSet = try self.ufoReader.glyphSet()
      var fsGlyph = testGlyph as UFOKit.FSGlyph
      try glyphSet.readGlyph(glyphName: "A", glyph: &fsGlyph)
    }())

    XCTAssertEqual(testGlyph.width, 500)
    XCTAssertEqual(testGlyph.unicodes.count, 1)
    XCTAssert(testGlyph.unicodes.contains(NSNumber(value: 0x41)))

    let decoder = PropertyListDecoder()
    let libProps = try? decoder.decode(Lib.self, from: testGlyph.lib)

    XCTAssertNotNil(libProps)
    XCTAssertEqual(libProps?.brightness, 0)
    XCTAssertEqual(libProps?.contrast, 1)
    XCTAssertEqual(libProps?.saturation, 1)
    XCTAssertEqual(libProps?.sharpness, 0.4)
  }

}
