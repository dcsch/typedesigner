//
//  FSSegment.m
//  FontScript
//
//  Created by David Schweinsberg on 7/9/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSSegment.h"
#import "FSPoint.h"
#import "FSContour.h"

@interface FSSegment ()
{
}

@end

@implementation FSSegment

- (nonnull instancetype)initWithPoints:(nonnull NSArray<FSPoint *> *)points {
  self = [super init];
  if (self) {
    _points = points;
  }
  return self;
}

- (FSGlyph *)glyph {
  return self.contour.glyph;
}

- (FSLayer *)layer {
  return self.contour.layer;
}

- (FSFont *)font {
  return self.contour.font;
}

- (FSSegmentType)type {
  FSPoint *lastPoint = _points.lastObject;
  switch (lastPoint.type) {
    case FSPointTypeMove:
      return FSSegmentTypeMove;
    case FSPointTypeLine:
      return FSSegmentTypeLine;
    case FSPointTypeCurve:
      return FSSegmentTypeCurve;
    case FSPointTypeQCurve:
      return FSSegmentTypeQCurve;
    case FSPointTypeOffCurve:
      // Actually invalid. What to do? An "invalid" type?
      // Ideally we'd disallow this in init.
      return FSSegmentTypeMove;
  }
}

- (nullable FSPoint *)onCurvePoint {
  return _points.lastObject;
}

- (nonnull NSArray<FSPoint *> *)offCurvePoints {
  return [_points subarrayWithRange:NSMakeRange(0, _points.count - 1)];
}

@end
