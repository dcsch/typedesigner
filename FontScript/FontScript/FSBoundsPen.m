//
//  FSBoundsPen.m
//  FontScript
//
//  Created by David Schweinsberg on 6/8/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSBoundsPen.h"
#if TARGET_OS_OSX
#import "NSValue+CGPoint.h"
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

static void calcCubicParameters(CGPoint pt1, CGPoint pt2, CGPoint pt3, CGPoint pt4,
                                CGPoint *a, CGPoint *b, CGPoint *c, CGPoint *d) {
  double dx = pt1.x;
  double dy = pt1.y;
  double cx = (pt2.x - dx) * 3.0;
  double cy = (pt2.y - dy) * 3.0;
  double bx = (pt3.x - pt2.x) * 3.0 - cx;
  double by = (pt3.y - pt2.y) * 3.0 - cy;
  double ax = pt4.x - dx - cx - bx;
  double ay = pt4.y - dy - cy - by;
  *a = CGPointMake(ax, ay);
  *b = CGPointMake(bx, by);
  *c = CGPointMake(cx, cy);
  *d = CGPointMake(dx, dy);
}

static int solveQuadratic(double a, double b, double c, double *roots) {
  const double epsilon = 1e-10;
  if (fabs(a) < epsilon) {
    if (fabs(b) < epsilon) {
      return 0;
    } else {
      roots[0] = -c / b;
      return 1;
    }
  } else {
    double dd = b * b - 4.0 * a * c;
    if (dd >= 0.0) {
      double rdd = sqrt(dd);
      roots[0] = (-b + rdd) / 2.0 / a;
      roots[1] = (-b - rdd) / 2.0 / a;
      return 2;
    } else {
      return 0;
    }
  }
}

static int filterValues(int count, double *values, double *filteredValues) {
  int filteredCount = 0;
  for (int i = 0; i < count; ++i) {
    if (0.0 <= values[i] && values[i] < 1.0) {
      filteredValues[filteredCount] = values[i];
      ++filteredCount;
    }
  }
  return filteredCount;
}

static void calcCubicPoints(CGPoint pt1,
                            CGPoint pt2,
                            CGPoint pt3,
                            CGPoint pt4,
                            void (^point)(CGPoint pt)) {
  CGPoint a, b, c, d;
  calcCubicParameters(pt1, pt2, pt3, pt4, &a, &b, &c, &d);

  // Calculate first derivative
  double ax3 = a.x * 3.0;
  double ay3 = a.y * 3.0;
  double bx2 = b.x * 2.0;
  double by2 = b.y * 2.0;

  double roots[4];
  double xRoots[2];
  int n = solveQuadratic(ax3, bx2, c.x, xRoots);
  int nRoots = filterValues(n, xRoots, roots);

  double yRoots[2];
  n = solveQuadratic(ay3, by2, c.y, yRoots);
  nRoots += filterValues(n, yRoots, roots + nRoots);

  point(pt1);
  point(pt4);
  for (int i = 0; i < nRoots; ++i) {
    const double t = roots[i];
    point(CGPointMake(a.x * t * t * t + b.x * t * t + c.x * t + d.x,
                      a.y * t * t * t + b.y * t * t + c.y * t + d.y));
  }
}

@interface FSBoundsPen ()

@property CGPoint currentPoint;

@end

@implementation FSBoundsPen

- (nonnull instancetype)init {
  self = [super init];
  if (self) {
    _bounds = CGRectNull;
  }
  return self;
}

- (void)addPoint:(CGPoint)point {
  if (CGRectEqualToRect(self.bounds, CGRectNull)) {
    self.bounds = CGRectMake(point.x, point.y, 0, 0);
  } else if (!CGRectContainsPoint(self.bounds, point)) {
    self.bounds = CGRectUnion(self.bounds, CGRectMake(point.x, point.y, 0, 0));
  }
  _currentPoint = point;
}

- (void)moveToPoint:(CGPoint)point {
  [self addPoint:point];
}

- (void)lineToPoint:(CGPoint)point {
  [self addPoint:point];
}

- (void)curveToPoint:(CGPoint)point control1:(CGPoint)control1 control2:(CGPoint)control2 {
  calcCubicPoints(_currentPoint, control1, control2, point, ^(CGPoint pt) {
    [self addPoint:pt];
  });
}

- (void)qCurveToPoint:(CGPoint)point control:(CGPoint)control {

}

- (void)curveToPoints:(NSArray<NSValue *> *)points {
  if (points.count == 3) {
    [self curveToPoint:points[2].CGPointValue
              control1:points[0].CGPointValue
              control2:points[1].CGPointValue];
  } else if (points.count == 2) {
    [self qCurveToPoint:points[1].CGPointValue
                control:points[0].CGPointValue];
  } else if (points.count == 1) {
    [self lineToPoint:points[0].CGPointValue];
  }
}

- (void)qCurveToPoints:(NSArray<NSValue *> *)points {
}

- (void)closePath {
}

- (void)endPath {
}

- (BOOL)addComponentWithName:(NSString *)glyphName
              transformation:(CGAffineTransform)transformation
                       error:(NSError **)error {
  return YES;
}

@end
