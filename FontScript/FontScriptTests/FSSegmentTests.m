//
//  FSSegmentTests.m
//  FontScriptTests
//
//  Created by David Schweinsberg on 7/12/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FSSegment.h"
#import "FSPoint.h"

@interface FSSegmentTests : XCTestCase

@end

@implementation FSSegmentTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testOnAndOffCurve {
  NSArray<FSPoint *> *points =
  @[[[FSPoint alloc] initWithPoint:CGPointMake(10, 10) type:FSPointTypeOffCurve smooth:NO],
    [[FSPoint alloc] initWithPoint:CGPointMake(20, 20) type:FSPointTypeOffCurve smooth:NO],
    [[FSPoint alloc] initWithPoint:CGPointMake(10, 30) type:FSPointTypeCurve smooth:NO]];
  FSSegment *segment = [[FSSegment alloc] initWithPoints:points];
  XCTAssertEqual(segment.points.count, 3);
  XCTAssertEqual(segment.offCurvePoints.count, 2);
  XCTAssertNotNil(segment.onCurvePoint);
}

@end
