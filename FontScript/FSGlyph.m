//
//  FSGlyph.m
//  FontScript
//
//  Created by David Schweinsberg on 5/28/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSGlyph.h"
#import "FSLayer.h"
#import "FSContour.h"
#import "FSComponent.h"
#import "FSBoundsPen.h"
#import "FontScriptFunctions.h"

@interface FSGlyph ()
{
  NSString *_name;
  NSArray<NSNumber *> *_unicodes;
  NSMutableArray<FSContour *> *_contours;
  NSMutableArray<FSComponent *> *_components;
}

@end

@implementation FSGlyph

- (nonnull instancetype)initWithName:(nonnull NSString *)name layer:(nullable FSLayer *)layer {
  self = [super init];
  if (self) {
    _name = name;
    self.layer = layer;
    self.unicodes = [NSArray array];
    _contours = [NSMutableArray array];
    _components = [NSMutableArray array];
  }
  return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
  FSGlyph *glyph = [[FSGlyph allocWithZone:zone] initWithName:self.name layer:nil];
  glyph.unicodes = [self.unicodes copyWithZone:zone];
  glyph->_contours = [self.contours copyWithZone:zone];
  glyph->_components = [self.contours copyWithZone:zone];
  return glyph;
}

- (void)dealloc {
  NSLog(@"Glyph dealloc");

//  if (self.pyObject) {
//    self.pyObject->glyph = nil;
//    self.pyObject = NULL;
//  }
}

- (nonnull NSString *)name {
  return _name;
}

- (void)setName:(nonnull NSString *)name {
  [self setName:name error:nil];
}

- (BOOL)setName:(nonnull NSString *)name error:(NSError **)error {
  if ([_name isEqualToString:name]) {
    return YES;
  }

  if (_layer) {

    // Check that the name doesn't already exist
    if ([_layer.glyphs.allKeys containsObject:name]) {
      if (error) {
        NSString *desc = [NSString stringWithFormat:
                          FSLocalizedString(@"A glyph with the name '%@' already exists"),
                          name];
        NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
        *error = [NSError errorWithDomain:FontScriptErrorDomain
                                     code:FontScriptErrorGlyphNameInUse
                                 userInfo:dict];
      }
      return NO;
    }

    // Relocate the glyph in the dictionary
    [_layer.glyphs removeObjectForKey:_name];
    _layer.glyphs[name] = self;
  }
  _name = name;
  return YES;
}

- (nullable NSNumber *)unicode {
  if (self.unicodes.count > 0) {
    return self.unicodes[0];
  } else {
    return nil;
  }
}

- (void)setUnicode:(nullable NSNumber *)unicode {
  NSMutableArray *copy = [self.unicodes mutableCopy];
  if ([self.unicodes containsObject:unicode]) {
    [copy removeObject:unicode];
  }
  [copy insertObject:unicode atIndex:0];
  self.unicodes = copy;
}

- (CGFloat)leftMargin {
  return CGRectGetMinX(self.bounds);
}

- (void)setLeftMargin:(CGFloat)leftMargin {
  CGFloat delta = leftMargin - self.leftMargin;
  [self moveBy:CGPointMake(delta, 0)];
  self.width += delta;
}

- (CGFloat)rightMargin {
  return self.width - CGRectGetMaxX(self.bounds);
}

- (void)setRightMargin:(CGFloat)rightMargin {
  self.width = CGRectGetMaxX(self.bounds) + rightMargin;
}

- (CGRect)bounds {
  FSBoundsPen *pen = [[FSBoundsPen alloc] init];
  [self drawWithPen:pen];
  return pen.bounds;
}

- (nonnull FSContour *)appendContour:(nonnull FSContour *)contour offset:(CGPoint)offset {
  FSContour *copy = [contour copy];
  if (!CGPointEqualToPoint(offset, CGPointZero)) {
    [copy moveBy:offset];
  }
  [_contours addObject:copy];
  copy.glyph = self;
  return copy;
}

- (BOOL)removeContour:(nonnull FSContour *)contour error:(NSError **)error {
  NSUInteger index = [_contours indexOfObject:contour];
  if (index == NSNotFound) {
    if (error) {
      NSString *desc = [NSString stringWithFormat:
                        FSLocalizedString(@"Contour not located in Glyph"),
                        index];
      NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
      *error = [NSError errorWithDomain:FontScriptErrorDomain
                                   code:FontScriptErrorContourNotLocated
                               userInfo:dict];
    }
    return NO;
  }
  [self removeContourAtIndex:index error:error];
  return YES;
}

- (BOOL)removeContourAtIndex:(NSUInteger)index error:(NSError **)error {
  if (index < _contours.count) {
    FSContour *contour = [_contours objectAtIndex:index];
    contour.glyph = nil;
    [_contours removeObjectAtIndex:index];
  } else {
    if (error) {
      NSString *desc = [NSString stringWithFormat:
                        FSLocalizedString(@"No contour located at index %u"),
                        index];
      NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
      *error = [NSError errorWithDomain:FontScriptErrorDomain
                                   code:FontScriptErrorContourNotLocated
                               userInfo:dict];
    }
    return NO;
  }
  return YES;
}

- (void)clearContours {
  for (FSContour *contour in _contours) {
    contour.glyph = nil;
  }
  [_contours removeAllObjects];
}

- (BOOL)reorderContour:(nonnull FSContour *)contour toIndex:(NSUInteger)index error:(NSError **)error {
  if (index >= _contours.count) {
    if (error) {
      NSString *desc = [NSString stringWithFormat:
                        FSLocalizedString(@"Index %u is out-of-range"),
                        index];
      NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
      *error = [NSError errorWithDomain:FontScriptErrorDomain
                                   code:FontScriptErrorIndexOutOfRange
                               userInfo:dict];
    }
    return NO;
  }
  [self removeContour:contour error:error];
  if (error && *error) {
    return NO;
  }
  [_contours insertObject:contour atIndex:index];
  contour.glyph = self;
  return YES;
}

- (FSComponent *)appendComponentWithGlyphName:(nonnull NSString *)glyphName
                                       offset:(CGPoint)offset
                                        scale:(CGPoint)scale {
  FSComponent *component = [[FSComponent alloc] initWithBaseGlyphName:glyphName];
  component.offset = offset;
  component.scale = scale;
  [_components addObject:component];
  component.glyph = self;
  return component;
}

- (FSComponent *)appendComponent:(nonnull FSComponent *)component {
  FSComponent *copy = [component copy];
  [_components addObject:copy];
  copy.glyph = self;
  return copy;
}

- (BOOL)removeComponent:(nonnull FSComponent *)component error:(NSError **)error {
  NSUInteger index = [_components indexOfObject:component];
  if (index == NSNotFound) {
    if (error) {
      NSString *desc = [NSString stringWithFormat:
                        FSLocalizedString(@"Component not located in Glyph"),
                        index];
      NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
      *error = [NSError errorWithDomain:FontScriptErrorDomain
                                   code:FontScriptErrorContourNotLocated
                               userInfo:dict];
    }
    return NO;
  }
  [self removeComponentAtIndex:index error:error];
  return YES;
}

- (BOOL)removeComponentAtIndex:(NSUInteger)index error:(NSError **)error {
  if (index < _components.count) {
    FSComponent *component = [_components objectAtIndex:index];
    component.glyph = nil;
    [_components removeObjectAtIndex:index];
  } else {
    if (error) {
      NSString *desc = [NSString stringWithFormat:
                        FSLocalizedString(@"No component located at index %u"),
                        index];
      NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
      *error = [NSError errorWithDomain:FontScriptErrorDomain
                                   code:FontScriptErrorContourNotLocated
                               userInfo:dict];
    }
    return NO;
  }
  return YES;
}

- (void)clearComponents {
  for (FSComponent *component in _components) {
    component.glyph = nil;
  }
  [_components removeAllObjects];
}

- (BOOL)reorderComponent:(nonnull FSComponent *)component toIndex:(NSUInteger)index error:(NSError **)error {
  if (index >= _components.count) {
    if (error) {
      NSString *desc = [NSString stringWithFormat:
                        FSLocalizedString(@"Index %u is out-of-range"),
                        index];
      NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
      *error = [NSError errorWithDomain:FontScriptErrorDomain
                                   code:FontScriptErrorIndexOutOfRange
                               userInfo:dict];
    }
    return NO;
  }
  [self removeComponent:component error:error];
  if (error && *error) {
    return NO;
  }
  [_components insertObject:component atIndex:index];
  component.glyph = self;
  return YES;
}

- (BOOL)decomposeWithError:(NSError **)error {
  for (FSComponent *component in self.components) {
    if (![component decomposeWithError:error]) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)decomposeComponent:(nonnull FSComponent *)component error:(NSError **)error {
  if (!self.layer) {
    if (error) {
      NSString *desc = FSLocalizedString(@"Glyph is not a member of a layer");
      NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
      *error = [NSError errorWithDomain:FontScriptErrorDomain
                                   code:FontScriptErrorGlyphNotFoundInLayer
                               userInfo:dict];
    }
    return NO;
  }

  FSGlyph *glyph = self.layer.glyphs[component.baseGlyphName];
  for (FSContour *contour in glyph.contours) {
    [contour transformBy:component.transformation];
    [self appendContour:contour offset:CGPointZero];
  }
  return [self removeComponent:component error:error];
}

- (void)moveBy:(CGPoint)point {
}

- (void)drawWithPen:(NSObject<FSPen> *)pen {
  for (FSContour *contour in self.contours) {
    [contour drawWithPen:pen];
  }
  for (FSComponent *component in self.components) {
    [component drawWithPen:pen];
  }
}

- (void)drawWithPointPen:(NSObject<FSPointPen> *)pointPen {
  for (FSContour *contour in self.contours) {
    [contour drawWithPointPen:pointPen];
  }
  for (FSComponent *component in self.components) {
    [component drawWithPointPen:pointPen];
  }
}

@end
