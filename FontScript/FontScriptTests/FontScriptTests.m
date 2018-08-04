//
//  FontScriptTests.m
//  FontScriptTests
//
//  Created by David Schweinsberg on 5/25/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FontScript.h"

@interface FontScriptTests : XCTestCase
{
  NSBundle *testBundle;
}
@end

@implementation FontScriptTests

- (void)setUp {
  [super setUp];
  testBundle = [NSBundle bundleWithIdentifier:@"com.typista.FontScriptTests"];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testExample {
  NSString *bundlePath = testBundle.resourceURL.path;
  FSScript *script = [[FSScript alloc] initWithPath:bundlePath];
  [script runModule:@"multiply" function:@"multiply" arguments:@[@3, @2]];
}

- (void)testBasics {
  FSScript *script = [[FSScript alloc] initWithPath:testBundle.resourceURL.path];
  [script importModule:@"basics"];
}

- (void)testNewFont {
  FSScript *script = [[FSScript alloc] initWithPath:testBundle.resourceURL.path];
  [script importModule:@"new_font"];

//  NSArray *fonts = script.fonts;
//  XCTAssertEqual(fonts.count, 1);
}

- (void)testAccessFontsAlreadyLoaded {
  FSScript *script = [[FSScript alloc] initWithPath:testBundle.resourceURL.path];

  [script newFontWithFamilyName:@"Test Family" styleName:@"Test Style" showInterface:NO];

  [script importModule:@"list_fonts"];
}

- (void)testNewGlyph {
  FSScript *script = [[FSScript alloc] initWithPath:testBundle.resourceURL.path];
  [script importModule:@"new_glyph"];

  NSArray<FSFont *> *fonts = script.fonts;
  XCTAssertEqual(fonts.count, 1);

  NSArray<FSLayer *> *layers = fonts[0].layers;
  XCTAssertEqual(layers.count, 1);

  NSDictionary<NSString *, FSGlyph *> *glyphs = layers[0].glyphs;
  XCTAssertEqual(glyphs.count, 1);
}

- (void)testGlyphNameChange {
  FSScript *script = [[FSScript alloc] initWithPath:testBundle.resourceURL.path];
  [script importModule:@"new_glyph"];
  NSDictionary<NSString *, FSGlyph *> *glyphs = script.fonts[0].layers[0].glyphs;
  FSGlyph *glyph = glyphs[@"A"];
  XCTAssertNotNil(glyph);
  XCTAssertTrue([glyph.name isEqualToString:@"A"]);

  NSError *error = nil;
  [glyph setName:@"B" error:&error];
  XCTAssertNil(error);

  FSGlyph *glyphB = glyphs[@"B"];
  XCTAssertEqual(glyph, glyphB);

  [script.fonts[0].layers[0] newGlyphWithName:@"C" clear:NO];
  [glyph setName:@"C" error:&error];
  XCTAssertNotNil(error);
  XCTAssertTrue([error.domain isEqualToString:FontScriptErrorDomain]);
  XCTAssertEqual(error.code, FontScriptErrorGlyphNameInUse);
}

- (void)testScriptedGlyphNameChange {
  FSScript *script = [[FSScript alloc] initWithPath:testBundle.resourceURL.path];
  [script importModule:@"rename_glyph"];
}

- (void)testRandomIdentifier {
  NSError *error = nil;
  for (NSUInteger i = 0; i < 1000; ++i) {
    NSString *identifier = [FSIdentifier RandomIdentifierWithError:&error];
    XCTAssertNotNil(identifier);
    XCTAssertNil(error);
  }
}

@end
