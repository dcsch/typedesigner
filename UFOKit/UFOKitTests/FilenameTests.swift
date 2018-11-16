//
//  FilenameTests.swift
//  UFOKitTests
//
//  Created by David Schweinsberg on 5/11/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import XCTest
import UFOKit

class FilenameTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    super.tearDown()
  }

  func testPeriodPrefix() {
    XCTAssertEqual(Filenames.filename(glyphName: ".notdef"), "_notdef")
  }

  func testIllegalCharacters() {
    XCTAssertEqual(Filenames.filename(glyphName: "a\\b"), "a_b")
    XCTAssertEqual(Filenames.filename(glyphName: "a\0b"), "a_b")
    XCTAssertEqual(Filenames.filename(glyphName: "a\"b"), "a_b")
    XCTAssertEqual(Filenames.filename(glyphName: "a*b"), "a_b")
    XCTAssertEqual(Filenames.filename(glyphName: "a b"), "a_b")
    XCTAssertEqual(Filenames.filename(glyphName: "a\tb"), "a_b")
    XCTAssertEqual(Filenames.filename(glyphName: "a\nb"), "a_b")
  }

  func testNameFiltering() {
    XCTAssertEqual(Filenames.filename(glyphName: "a"), "a")
    XCTAssertEqual(Filenames.filename(glyphName: "A"), "A_")
    XCTAssertEqual(Filenames.filename(glyphName: "AE"), "A_E_")
    XCTAssertEqual(Filenames.filename(glyphName: "Ae"), "A_e")
    XCTAssertEqual(Filenames.filename(glyphName: "ae"), "ae")
    XCTAssertEqual(Filenames.filename(glyphName: "aE"), "aE_")
    XCTAssertEqual(Filenames.filename(glyphName: "a.alt"), "a.alt")
    XCTAssertEqual(Filenames.filename(glyphName: "A.alt"), "A_.alt")
    XCTAssertEqual(Filenames.filename(glyphName: "A.Alt"), "A_.A_lt")
    XCTAssertEqual(Filenames.filename(glyphName: "A.aLt"), "A_.aL_t")
    XCTAssertEqual(Filenames.filename(glyphName: "A.alT"), "A_.alT_")
    XCTAssertEqual(Filenames.filename(glyphName: "T_H"), "T__H_")
    XCTAssertEqual(Filenames.filename(glyphName: "T_h"), "T__h")
    XCTAssertEqual(Filenames.filename(glyphName: "t_h"), "t_h")
    XCTAssertEqual(Filenames.filename(glyphName: "F_F_I"), "F__F__I_")
    XCTAssertEqual(Filenames.filename(glyphName: "f_f_i"), "f_f_i")
    XCTAssertEqual(Filenames.filename(glyphName: "Aacute_V.swash"), "A_acute_V_.swash")
    XCTAssertEqual(Filenames.filename(glyphName: ".notdef"), "_notdef")
    XCTAssertEqual(Filenames.filename(glyphName: "con"), "_con")
    XCTAssertEqual(Filenames.filename(glyphName: "CON"), "C_O_N_")
    XCTAssertEqual(Filenames.filename(glyphName: "con.alt"), "_con.alt")
    XCTAssertEqual(Filenames.filename(glyphName: "alt.con"), "alt._con")
  }

  func testMaxNameLength() {
    let verylongname = String(repeating: "x", count: 260)
    let slightlyshortername = Filenames.filename(glyphName: verylongname)
    XCTAssertEqual(slightlyshortername.count, 255)
    let slightlyshortername2 = Filenames.filename(glyphName: verylongname, suffix: ".glif")
    XCTAssertEqual(slightlyshortername2.count, 255)
  }

}
