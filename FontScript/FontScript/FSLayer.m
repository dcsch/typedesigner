//
//  FSLayer.m
//  FontScript
//
//  Created by David Schweinsberg on 5/28/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSLayer.h"
#import "FSGlyph.h"

@implementation FSLayer

- (nonnull instancetype)init {
  self = [super init];
  if (self) {
    NSLog(@"Layer init");

    _glyphs = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (nonnull instancetype)initWithName:(nonnull NSString *)name color:(CGColorRef)color {
  self = [self init];
  if (self) {
    self.name = name;
    self.color = color;
  }
  return self;
}

- (void)dealloc {
  NSLog(@"Layer dealloc");
}

- (FSGlyph *)newGlyphWithName:(nonnull NSString *)name clear:(BOOL)clear {
  FSGlyph *glyph;
  if (![_glyphs.allKeys containsObject:name]) {
    glyph = [[FSGlyph alloc] initWithName:name layer:self];
  } else if (clear) {
    [_glyphs removeObjectForKey:name];
  } else {
    glyph = _glyphs[name];
  }
  _glyphs[name] = glyph;
  return glyph;
}

@end
