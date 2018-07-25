//
//  FSContourTests.m
//  FontScriptTests
//
//  Created by David Schweinsberg on 7/5/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FSGlyph.h"
#import "FSContour.h"

@interface FSContourTests : XCTestCase

@end

@implementation FSContourTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIdentifier {
  FSContour *contour = [[FSContour alloc] initWithGlyph:nil];
  NSString *identifier = contour.identifier;
  XCTAssertNotNil(identifier);
  XCTAssertEqualObjects(identifier, contour.identifier);
}

- (void)testIndex {
  FSGlyph *glyph = [[FSGlyph alloc] initWithName:@"A" layer:nil];
  [glyph appendContour:[[FSContour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);
  [glyph appendContour:[[FSContour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 2);

  XCTAssertEqual(glyph.contours[0].index, 0);
  XCTAssertEqual(glyph.contours[1].index, 1);
}

- (void)testSetIndex {
  FSGlyph *glyph = [[FSGlyph alloc] initWithName:@"A" layer:nil];
  [glyph appendContour:[[FSContour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);
  [glyph appendContour:[[FSContour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 2);

  XCTAssertEqual(glyph.contours[0].index, 0);
  XCTAssertEqual(glyph.contours[1].index, 1);

  FSContour *contour0 = glyph.contours[0];
  FSContour *contour1 = glyph.contours[1];
  glyph.contours[0].index = 1;

  XCTAssertEqualObjects(contour0, glyph.contours[1]);
  XCTAssertEqualObjects(contour1, glyph.contours[0]);
  XCTAssertEqual(glyph.contours[0].index, 0);
  XCTAssertEqual(glyph.contours[1].index, 1);
}

- (void)testSegmentsNone {
  FSContour *contour = [[FSContour alloc] initWithGlyph:nil];
  NSArray<FSSegment *> *segments = contour.segments;
  XCTAssertEqual(segments.count, 0);
}

- (void)testSegmentsMove {
  FSContour *contour = [[FSContour alloc] initWithGlyph:nil];

  [contour appendPoint:CGPointMake(100, 100) type:FSPointTypeMove smooth:NO];

  NSArray<FSSegment *> *segments = contour.segments;
  XCTAssertEqual(segments.count, 1);
  XCTAssertEqual(segments[0].type, FSSegmentTypeMove);
  XCTAssertEqual(segments[0].points.count, 1);
  XCTAssertEqual(segments[0].points[0].x, 100);
  XCTAssertEqual(segments[0].points[0].y, 100);
}

- (void)testSegmentsBox {
  FSContour *contour = [[FSContour alloc] initWithGlyph:nil];

  [contour appendPoint:CGPointMake(100, 100) type:FSPointTypeLine smooth:NO];
  [contour appendPoint:CGPointMake(100, -100) type:FSPointTypeLine smooth:NO];
  [contour appendPoint:CGPointMake(-100, -100) type:FSPointTypeLine smooth:NO];
  [contour appendPoint:CGPointMake(-100, 100) type:FSPointTypeLine smooth:NO];

  NSArray<FSSegment *> *segments = contour.segments;
  XCTAssertEqual(segments.count, 4);
  for (FSSegment *segment in segments) {
    XCTAssertEqual(segment.type, FSSegmentTypeLine);
    XCTAssertEqual(segment.points.count, 1);
  }
  // Points array will be rotated so that the first is now the last
  XCTAssertEqual(segments[3].points[0].x, 100);
  XCTAssertEqual(segments[3].points[0].y, 100);
  XCTAssertEqual(segments[0].points[0].x, 100);
  XCTAssertEqual(segments[0].points[0].y, -100);
  XCTAssertEqual(segments[1].points[0].x, -100);
  XCTAssertEqual(segments[1].points[0].y, -100);
  XCTAssertEqual(segments[2].points[0].x, -100);
  XCTAssertEqual(segments[2].points[0].y, 100);
}

- (void)testSegmentsOpenAngledLine {
  FSContour *contour = [[FSContour alloc] initWithGlyph:nil];

  [contour appendPoint:CGPointMake(0, 100) type:FSPointTypeMove smooth:NO];
  [contour appendPoint:CGPointMake(0, 0) type:FSPointTypeLine smooth:NO];
  [contour appendPoint:CGPointMake(100, 0) type:FSPointTypeLine smooth:NO];

  NSArray<FSSegment *> *segments = contour.segments;
  XCTAssertEqual(segments.count, 3);
  XCTAssertEqual(segments[0].type, FSSegmentTypeMove);
  XCTAssertEqual(segments[1].type, FSSegmentTypeLine);
  XCTAssertEqual(segments[2].type, FSSegmentTypeLine);

  XCTAssertEqual(segments[0].points.count, 1);
  XCTAssertEqual(segments[0].points[0].x, 0);
  XCTAssertEqual(segments[0].points[0].y, 100);

  XCTAssertEqual(segments[1].points.count, 1);
  XCTAssertEqual(segments[1].points[0].x, 0);
  XCTAssertEqual(segments[1].points[0].y, 0);

  XCTAssertEqual(segments[2].points.count, 1);
  XCTAssertEqual(segments[2].points[0].x, 100);
  XCTAssertEqual(segments[2].points[0].y, 0);
}

- (void)testSegmenstDee {
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

  NSArray<FSSegment *> *segments = contour.segments;
  XCTAssertEqual(segments.count, 5);
  XCTAssertEqual(segments[0].type, FSSegmentTypeLine);
  XCTAssertEqual(segments[1].type, FSSegmentTypeCurve);
  XCTAssertEqual(segments[2].type, FSSegmentTypeCurve);
  XCTAssertEqual(segments[3].type, FSSegmentTypeLine);
  XCTAssertEqual(segments[4].type, FSSegmentTypeLine);
}

@end
