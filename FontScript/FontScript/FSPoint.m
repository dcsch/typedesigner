//
//  FSPoint.m
//  FontScript
//
//  Created by David Schweinsberg on 7/6/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSPoint.h"
#import "FSContour.h"
#import "FSGlyph.h"
#import "FSLayer.h"
#import "FSFont.h"
#import "FSIdentifier.h"

@interface FSPoint ()
{
  NSString *_identifier;
}

@end

@implementation FSPoint

- (nonnull instancetype)initWithPoint:(CGPoint)cgPoint type:(FSPointType)type smooth:(BOOL)smooth {
  self = [super init];
  if (self) {
    _x = cgPoint.x;
    _y = cgPoint.y;
    _type = type;
    _smooth = smooth;
  }
  return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
  FSPoint *copy = [[FSPoint allocWithZone:zone] initWithPoint:CGPointMake(self.x, self.y)
                                                         type:self.type
                                                       smooth:self.smooth];
  copy.name = self.name;
  return copy;
}

- (void)dealloc {
  NSLog(@"FSPoint dealloc");
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

- (NSString *)identifier {
  if (_identifier == nil) {
    _identifier = [FSIdentifier RandomIdentifierWithError: nil];
  }
  return _identifier;
}

- (NSUInteger)index {
  return [self.contour.points indexOfObject:self];
}

- (CGPoint)cgPoint {
  return CGPointMake(_x, _y);
}

- (void)setCgPoint:(CGPoint)cgPoint {
  _x = cgPoint.x;
  _y = cgPoint.y;
}

- (void)transformBy:(CGAffineTransform)transform {
  CGPoint p1 = CGPointApplyAffineTransform(self.cgPoint, transform);
  _x = p1.x;
  _y = p1.y;
}

- (void)round {
  _x = llrint(_x);
  _y = llrint(_y);
}

@end
