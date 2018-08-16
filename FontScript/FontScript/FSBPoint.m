//
//  FSBPoint.m
//  FontScript
//
//  Created by David Schweinsberg on 8/14/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSBPoint.h"
#import "FSContour.h"

@interface FSBPoint ()

@property(weak) FSPoint *point;

@end

@implementation FSBPoint

- (nonnull instancetype)initWithPoint:(nonnull FSPoint *)point {
  self = [super init];
  if (self) {
    self.point = point;
  }
  return self;
}

- (CGPoint)anchor {
  return _point.cgPoint;
}

- (void)setAnchor:(CGPoint)anchor {
  CGPoint delta = CGPointMake(anchor.x - _point.cgPoint.x,
                              anchor.y - _point.cgPoint.y);
  [self moveBy:delta];
}

- (CGPoint)bcpIn {
  FSSegment *segment = self.segment;
  NSArray<FSPoint *> *offCurvePoints = segment.offCurvePoints;
  if (offCurvePoints.count > 0) {
    FSPoint *bcp = offCurvePoints.lastObject;
    return CGPointMake(bcp.cgPoint.x - self.point.x,
                       bcp.cgPoint.y - self.point.y);
  } else {
    return CGPointZero;
  }
}

- (void)setBcpIn:(CGPoint)bcpIn {

}

- (CGPoint)bcpOut {
  FSSegment *segment = self.nextSegment;
  NSArray<FSPoint *> *offCurvePoints = segment.offCurvePoints;
  if (offCurvePoints.count > 0) {
    FSPoint *bcp = offCurvePoints[0];
    return CGPointMake(bcp.cgPoint.x - self.point.x,
                       bcp.cgPoint.y - self.point.y);
  } else {
    return CGPointZero;
  }
}

- (void)setBcpOut:(CGPoint)bcpIn {

}

- (void)transformBy:(CGAffineTransform)transform {

}

- (void)moveBy:(CGPoint)point {
  [self.point moveBy:point];

  FSSegment *segment = self.segment;
  NSArray<FSPoint *> *offCurvePoints = segment.offCurvePoints;
  if (offCurvePoints.count > 0) {
    FSPoint *bcp = offCurvePoints.lastObject;
    [bcp moveBy:point];
  }

  segment = self.nextSegment;
  offCurvePoints = segment.offCurvePoints;
  if (offCurvePoints.count > 0) {
    FSPoint *bcp = offCurvePoints[0];
    [bcp moveBy:point];
  }
}

- (FSSegment *)segment {
  for (FSSegment *segment in self.contour.segments) {
    if (segment.onCurvePoint == self.point) {
      return segment;
    }
  }
  return nil;
}

- (FSSegment *)nextSegment {
  FSContour *contour = self.contour;
  if (!contour) {
    return nil;
  }
  NSArray<FSSegment *> *segments = contour.segments;
  FSSegment *segment = self.segment;

//  NSUInteger index = [segments indexOfObject:segment] + 1;

  NSUInteger index = [segments indexOfObjectPassingTest:^BOOL(FSSegment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSUInteger count = segment.points.count;
    if (obj.points.count != count) {
      return NO;
    }
    for (NSUInteger i = 0; i < count; ++i) {
      FSPoint *p1 = segment.points[i];
      FSPoint *p2 = obj.points[i];
      if (p1.x != p2.x || p1.y != p2.y) {
        return NO;
      }
    }
    return YES;
  }] + 1;

  if (index >= segments.count) {
    index = index % segments.count;
  }
  return segments[index];
}

@end
