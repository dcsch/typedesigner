//
//  FSPointTests.m
//  FontScriptTests
//
//  Created by David Schweinsberg on 7/9/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FSPoint.h"

@interface FSPointTests : XCTestCase

@end

@implementation FSPointTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testRounding {
  FSPoint *point = [[FSPoint alloc] initWithPoint:CGPointMake(0.0, 0.0)
                                             type:FSPointTypeMove
                                           smooth:FALSE];
  point.x = 0.1;
  [point round];
  XCTAssertEqual(point.x, 0.0);
  point.x = 0.9;
  [point round];
  XCTAssertEqual(point.x, 1.0);
  point.x = 0.5;
  [point round];
  XCTAssertEqual(point.x, 0.0);
  point.x = 0.51;
  [point round];
  XCTAssertEqual(point.x, 1.0);
  point.x = 1.49;
  [point round];
  XCTAssertEqual(point.x, 1.0);
  point.x = 1.5;
  [point round];
  XCTAssertEqual(point.x, 2.0);
}

@end
