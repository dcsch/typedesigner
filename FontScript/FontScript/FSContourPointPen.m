//
//  FSContourPointPen.m
//  FontScript
//
//  Created by David Schweinsberg on 7/25/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSContourPointPen.h"
#import "FSGlyph.h"
#import "FSContour.h"
#import "FSComponent.h"

@interface FSContourPointPen ()
{
  FSGlyph *_glyph;
  FSContour *_contour;
}

@end

@implementation FSContourPointPen

- (nonnull instancetype)initWithGlyph:(nonnull FSGlyph *)glyph {
  self = [super init];
  if (self) {
    _glyph = glyph;
  }
  return self;
}

- (void)beginPath {
  _contour = [[FSContour alloc] initWithGlyph:nil];
}

- (void)beginPathWithIdentifier:(nonnull NSString *)identifier {
  _contour = [[FSContour alloc] initWithGlyph:nil];
}

- (void)endPath {
  [_glyph appendContour:_contour offset:CGPointZero];
  _contour = nil;
}

- (void)addPoint:(nonnull FSPoint *)point {
  [_contour appendPoint:point.cgPoint type:point.type smooth:point.smooth];
}

- (void)addPoints:(nonnull NSArray<FSPoint *> *)points {
  for (FSPoint *point in points) {
    [self addPoint:point];
  }
}

- (void)addCGPoint:(CGPoint)point type:(FSPointType)type smooth:(BOOL)smooth {
  [_contour appendPoint:point type:type smooth:smooth];
}

- (void)addCGPoint:(CGPoint)point type:(FSPointType)type smooth:(BOOL)smooth name:(nullable NSString *)name identifier:(nullable NSString *)identifier {
  [_contour appendPoint:point type:type smooth:smooth];
}

- (BOOL)addComponentWithBaseGlyphName:(nonnull NSString *)baseGlyphName transformation:(CGAffineTransform)transformation identifier:(nullable NSString *)identifier error:(NSError *__autoreleasing *)error {
  FSComponent *component = [[FSComponent alloc] initWithBaseGlyphName:baseGlyphName];
  component.transformation = transformation;
//  component.identifier = identifier;
  [_glyph appendComponent:component];
  return YES;
}

@end
