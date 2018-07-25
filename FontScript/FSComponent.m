//
//  FSComponent.m
//  FontScript
//
//  Created by David Schweinsberg on 7/19/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSComponent.h"
#import "FSGlyph.h"
#import "FSPen.h"
#import "FSIdentifier.h"
#import "FSPointToSegmentPen.h"

@interface FSComponent ()
{
  NSString *_identifier;
}

@end

@implementation FSComponent

- (instancetype)initWithBaseGlyphName:(NSString *)baseGlyphName {
  self = [super init];
  if (self) {
    _baseGlyphName = baseGlyphName;
    _transformation = CGAffineTransformIdentity;
  }
  return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
  FSComponent *copy = [[FSComponent allocWithZone:zone] initWithBaseGlyphName:_baseGlyphName];
  copy->_transformation = _transformation;
  return copy;
}

- (void)dealloc {
  NSLog(@"Component dealloc");
}

- (FSLayer *)layer {
  return self.glyph.layer;
}

- (FSFont *)font {
  return self.glyph.font;
}

- (NSString *)identifier {
  if (_identifier == nil) {
    _identifier = [FSIdentifier RandomIdentifierWithError:nil];
  }
  return _identifier;
}

- (NSUInteger)index {
  return [self.glyph.components indexOfObject:self];
}

- (void)setIndex:(NSUInteger)index {
  [self.glyph reorderComponent:self toIndex:index error:nil];
}

- (BOOL)setIndex:(NSUInteger)index error:(NSError **)error {
  return [self.glyph reorderComponent:self toIndex:index error:error];
}

- (CGPoint)offset {
  return CGPointMake(_transformation.tx, _transformation.ty);
}

- (void)setOffset:(CGPoint)offset {
  _transformation.tx = offset.x;
  _transformation.ty = offset.y;
}

- (CGPoint)scale {
  return CGPointMake(_transformation.a, _transformation.d);
}

- (void)setScale:(CGPoint)scale {
  _transformation.a = scale.x;
  _transformation.d = scale.y;
}

- (void)drawWithPen:(NSObject<FSPen> *)pen {
  FSPointToSegmentPen *pointToSegmentPen = [[FSPointToSegmentPen alloc] initWithPen:pen];
  [self drawWithPointPen:pointToSegmentPen];
}

- (void)drawWithPointPen:(NSObject<FSPointPen> *)pointPen {
  [pointPen beginPath];
  NSError *error;
  [pointPen addComponentWithBaseGlyphName:_baseGlyphName
                           transformation:_transformation
                               identifier:_identifier
                                    error:&error];
  [pointPen endPath];
}

- (BOOL)decomposeWithError:(NSError **)error {
  return [self.glyph decomposeComponent:self error:error];
}

@end
