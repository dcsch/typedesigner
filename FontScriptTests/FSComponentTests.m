//
//  FSComponentTests.m
//  FontScriptTests
//
//  Created by David Schweinsberg on 7/20/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FSLayer.h"
#import "FSGlyph.h"
#import "FSComponent.h"
#import "FSContour.h"
#import "FSTestPen.h"

@interface FSComponentTests : XCTestCase

@end

@implementation FSComponentTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSmallBox {
  FSLayer *layer = [[FSLayer alloc] initWithName:@"base" color:nil];
  FSGlyph *glyph = [layer newGlyphWithName:@"box" clear:NO];
  FSContour *contour = [[FSContour alloc] initWithGlyph:glyph];
  [contour appendPoint:CGPointMake(100, 100) type:FSPointTypeLine smooth:NO];
  [contour appendPoint:CGPointMake(100, -100) type:FSPointTypeLine smooth:NO];
  [contour appendPoint:CGPointMake(-100, -100) type:FSPointTypeLine smooth:NO];
  [contour appendPoint:CGPointMake(-100, 100) type:FSPointTypeLine smooth:NO];
  [glyph appendContour:contour offset:CGPointZero];

  FSGlyph *compositeGlyph = [layer newGlyphWithName:@"smallbox" clear:NO];
  FSComponent *component = [[FSComponent alloc] initWithBaseGlyphName:@"box"];
  component.scale = CGPointMake(0.5, 0.5);
  [compositeGlyph appendComponent:component];

  FSTestPen *testPen = [[FSTestPen alloc] init];
  [compositeGlyph drawWithPen:testPen];

  XCTAssertEqual(testPen.records.count, 1);
  XCTAssertEqualObjects(testPen.records[0], @"addComponent box (0.5, 0, 0, 0.5, 0, 0)");

  NSError *error;
  XCTAssertTrue([compositeGlyph decomposeWithError:&error]);
  [testPen reset];
  [compositeGlyph drawWithPen:testPen];

  XCTAssertEqual(testPen.records.count, 5);
  XCTAssertEqualObjects(testPen.records[0], @"moveTo (50, 50)");
  XCTAssertEqualObjects(testPen.records[1], @"lineTo (50, -50)");
  XCTAssertEqualObjects(testPen.records[2], @"lineTo (-50, -50)");
  XCTAssertEqualObjects(testPen.records[3], @"lineTo (-50, 50)");
  XCTAssertEqualObjects(testPen.records[4], @"closePath");
}

@end
