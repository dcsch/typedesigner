//
//  FSGlyphTests.m
//  FontScriptTests
//
//  Created by David Schweinsberg on 6/14/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FontScript.h"

@interface FSGlyphTests : XCTestCase
{
  NSBundle *testBundle;
}

@end

@implementation FSGlyphTests

- (void)setUp {
  [super setUp];
  testBundle = [NSBundle bundleWithIdentifier:@"com.typista.FontScriptTests"];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testCopy {
  FSGlyph *glyph1 = [[FSGlyph alloc] initWithName:@"A" layer:nil];
  glyph1.unicodes = @[@20U, @30U, @40U];
  glyph1.unicode = @10U;

  FSContour *contour = [[FSContour alloc] initWithGlyph:nil];
  [glyph1 appendContour:contour offset:CGPointZero];

  FSGlyph *glyph2 = [glyph1 copy];
  XCTAssertNotEqualObjects(glyph1, glyph2);
  XCTAssertEqualObjects(glyph1.name, glyph2.name);
  XCTAssertEqualObjects(glyph1.unicodes, glyph2.unicodes);
  XCTAssertEqualObjects(glyph1.contours, glyph2.contours);
  XCTAssertEqual(glyph1.width, glyph2.width);
  XCTAssertEqual(glyph1.leftMargin, glyph2.leftMargin);
  XCTAssertEqual(glyph1.rightMargin, glyph2.rightMargin);
  XCTAssertEqual(glyph1.height, glyph2.height);
  XCTAssertEqual(glyph1.bottomMargin, glyph2.bottomMargin);
  XCTAssertEqual(glyph1.topMargin, glyph2.topMargin);

  glyph1.name = @"B";
  XCTAssertNotEqualObjects(glyph1.name, glyph2.name);

  glyph2.unicode = @5U;
  XCTAssertNotEqualObjects(glyph1.unicodes, glyph2.unicodes);
}

- (void)testAppendContour {
  FSGlyph *glyph = [[FSGlyph alloc] initWithName:@"A" layer:nil];
  XCTAssertEqual([glyph.contours count], 0);
  FSContour *contour = [[FSContour alloc] initWithGlyph:nil];
  [glyph appendContour:contour offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);
//  XCTAssertEqualObjects(glyph.contours[0], contour);
}

- (void)testRemoveContour {
  FSGlyph *glyph = [[FSGlyph alloc] initWithName:@"A" layer:nil];
  XCTAssertEqual([glyph.contours count], 0);
  FSContour *contour = [[FSContour alloc] initWithGlyph:nil];
  [glyph appendContour:contour offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);

  contour = glyph.contours[0];
  NSError *error = nil;
  XCTAssertTrue([glyph removeContour:contour error:&error]);
  XCTAssertNil(error);
  XCTAssertEqual([glyph.contours count], 0);
}

- (void)testRemoveContourAtIndex {
  FSGlyph *glyph = [[FSGlyph alloc] initWithName:@"A" layer:nil];
  XCTAssertEqual([glyph.contours count], 0);
  FSContour *contour = [[FSContour alloc] initWithGlyph:nil];
  [glyph appendContour:contour offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);

  NSError *error = nil;
  XCTAssertTrue([glyph removeContourAtIndex:0 error:&error]);
  XCTAssertNil(error);
  XCTAssertEqual([glyph.contours count], 0);
}

- (void)testRemoveContourFail {
  FSGlyph *glyph = [[FSGlyph alloc] initWithName:@"A" layer:nil];
  XCTAssertEqual([glyph.contours count], 0);
  FSContour *contour = [[FSContour alloc] initWithGlyph:nil];
  [glyph appendContour:contour offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);

  // Try to remove with the same contour, which is not equal (since the array
  // has a copy and equivilance is based on object address - is this how we
  // really want things?)
  NSError *error = nil;
  XCTAssertFalse([glyph removeContour:contour error:&error]);
  XCTAssertNotNil(error);
  XCTAssertTrue([error.domain isEqualToString:FontScriptErrorDomain]);
  XCTAssertEqual(error.code, FontScriptErrorContourNotLocated);
  XCTAssertEqual([glyph.contours count], 1);
}

- (void)testRemoveContourAtIndexFail {
  FSGlyph *glyph = [[FSGlyph alloc] initWithName:@"A" layer:nil];
  NSError *error = nil;
  XCTAssertFalse([glyph removeContourAtIndex:0 error:&error]);
  XCTAssertNotNil(error);
  XCTAssertTrue([error.domain isEqualToString:FontScriptErrorDomain]);
  XCTAssertEqual(error.code, FontScriptErrorContourNotLocated);
  XCTAssertEqual([glyph.contours count], 0);
}

- (void)testReorderContour {
  FSGlyph *glyph = [[FSGlyph alloc] initWithName:@"A" layer:nil];
  [glyph appendContour:[[FSContour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);
  [glyph appendContour:[[FSContour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 2);

  FSContour *contour0 = glyph.contours[0];
  NSError *error = nil;
  XCTAssertTrue([glyph reorderContour:contour0 toIndex:1 error:&error]);
  XCTAssertNil(error);
  XCTAssertEqualObjects(contour0, glyph.contours[1]);
}

- (void)testReorderContourOutOfRange {
  FSGlyph *glyph = [[FSGlyph alloc] initWithName:@"A" layer:nil];
  [glyph appendContour:[[FSContour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);
  [glyph appendContour:[[FSContour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 2);

  FSContour *contour0 = glyph.contours[0];
  NSError *error = nil;
  XCTAssertFalse([glyph reorderContour:contour0 toIndex:2 error:&error]);
  XCTAssertNotNil(error);
  XCTAssertTrue([error.domain isEqualToString:FontScriptErrorDomain]);
  XCTAssertEqual(error.code, FontScriptErrorIndexOutOfRange);
  XCTAssertEqualObjects(contour0, glyph.contours[0]);
}

- (void)testGlyphBounds {
  FSScript *script = [[FSScript alloc] initWithPath:testBundle.resourceURL.path];
  FSFont *font = [script newFontWithFamilyName:@"Test Family"
                                     styleName:@"Test Style"
                                 showInterface:NO];
  FSLayer *layer = [font newLayerWithName:@"Test Layer" color:nil];
  FSGlyph *glyph = [layer newGlyphWithName:@"A" clear:NO];

  FSContour *contour = [[FSContour alloc] initWithGlyph:nil];
  [contour appendPoint:CGPointMake(100, 100) type:FSPointTypeMove smooth:NO];
  [contour appendPoint:CGPointMake(100, -100) type:FSPointTypeLine smooth:NO];
  [contour appendPoint:CGPointMake(-100, -100) type:FSPointTypeLine smooth:NO];
  [contour appendPoint:CGPointMake(-100, 100) type:FSPointTypeLine smooth:NO];
  [glyph appendContour:contour offset:CGPointZero];

  CGRect bounds = glyph.bounds;
  XCTAssertEqual(CGRectGetMinX(bounds), -100);
  XCTAssertEqual(CGRectGetMinY(bounds), -100);
  XCTAssertEqual(CGRectGetMaxX(bounds), 100);
  XCTAssertEqual(CGRectGetMaxY(bounds), 100);
}

- (void)testGlyphCurveBounds {
  FSScript *script = [[FSScript alloc] initWithPath:testBundle.resourceURL.path];
  FSFont *font = [script newFontWithFamilyName:@"Test Family"
                                     styleName:@"Test Style"
                                 showInterface:NO];
  FSLayer *layer = [font newLayerWithName:@"Test Layer" color:nil];
  FSGlyph *glyph = [layer newGlyphWithName:@"D" clear:NO];

  FSContour *contour = [[FSContour alloc] initWithGlyph:nil];
  [contour appendPoint:CGPointMake(-100, 100) type:FSPointTypeLine smooth:NO];
  [contour appendPoint:CGPointMake(0, 100) type:FSPointTypeLine smooth:NO];
  [contour appendPoint:CGPointMake(50, 100) type:FSPointTypeOffCurve smooth:NO];
  [contour appendPoint:CGPointMake(100, 50) type:FSPointTypeOffCurve smooth:NO];
  [contour appendPoint:CGPointMake(100, 0) type:FSPointTypeCurve smooth:NO];
  [contour appendPoint:CGPointMake(100, -50) type:FSPointTypeOffCurve smooth:NO];
  [contour appendPoint:CGPointMake(50, -100) type:FSPointTypeOffCurve smooth:NO];
  [contour appendPoint:CGPointMake(0, -100) type:FSPointTypeCurve smooth:NO];
  [contour appendPoint:CGPointMake(-100, -100) type:FSPointTypeLine smooth:NO];
  [glyph appendContour:contour offset:CGPointZero];

  CGRect bounds = glyph.bounds;
  XCTAssertEqual(CGRectGetMinX(bounds), -100);
  XCTAssertEqual(CGRectGetMinY(bounds), -100);
  XCTAssertEqual(CGRectGetMaxX(bounds), 100);
  XCTAssertEqual(CGRectGetMaxY(bounds), 100);
}

@end
