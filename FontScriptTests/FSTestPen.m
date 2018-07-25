//
//  FSTestPen.m
//  FontScriptTests
//
//  Created by David Schweinsberg on 7/20/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSTestPen.h"

@interface FSTestPen ()
{
  NSMutableArray<NSString *> *_records;
}

@end

@implementation FSTestPen

- (nonnull instancetype)init {
  self = [super init];
  if (self) {
    _records = [NSMutableArray array];
  }
  return self;
}

- (void)reset {
  [_records removeAllObjects];
}

- (void)moveToPoint:(CGPoint)point {
  [_records addObject:[NSString stringWithFormat:@"moveTo (%g, %g)", point.x, point.y]];
}

- (void)lineToPoint:(CGPoint)point {
  [_records addObject:[NSString stringWithFormat:@"lineTo (%g, %g)", point.x, point.y]];
}

- (void)curveToPoints:(NSArray<NSValue *> *)points {
  NSMutableString *str = [NSMutableString stringWithString:@"curveTo"];
  for (NSValue *point in points) {
    [str appendFormat:@" (%g, %g)", [point pointValue].x, [point pointValue].y];
  }
  [_records addObject:str];
}

- (void)qCurveToPoints:(NSArray<NSValue *> *)points {
  NSMutableString *str = [NSMutableString stringWithString:@"qCurveTo"];
  for (NSValue *point in points) {
    [str appendFormat:@" (%g, %g)", [point pointValue].x, [point pointValue].y];
  }
  [_records addObject:str];
}

- (void)closePath {
  [_records addObject:@"closePath"];
}

- (void)endPath {
  [_records addObject:@"endPath"];
}

- (BOOL)addComponentWithName:(NSString *)glyphName
              transformation:(CGAffineTransform)transformation
                       error:(NSError **)error {
  [_records addObject:[NSString stringWithFormat:@"addComponent %@ (%g, %g, %g, %g, %g, %g)",
                       glyphName,
                       transformation.a,
                       transformation.b,
                       transformation.c,
                       transformation.d,
                       transformation.tx,
                       transformation.ty]];
  return NO;
}

@end
