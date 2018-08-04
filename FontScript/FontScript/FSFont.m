//
//  FSFont.m
//  FontScript
//
//  Created by David Schweinsberg on 5/26/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSFont.h"
#import "FSFontPrivate.h"
#import "FSInfo.h"
#import "FSLayer.h"

@interface FSFont ()
{
  FSLayer *_defaultLayer;
}

@end

@implementation FSFont

- (nonnull instancetype)init {
  self = [super init];
  if (self) {
    NSLog(@"Font init");

    _info = [[FSInfo alloc] init];
    _layers = [[NSMutableArray alloc] init];
  }
  return self;
}

- (nonnull instancetype)initWithFamilyName:(NSString *)familyName
                                 styleName:(NSString *)styleName
                             showInterface:(BOOL)showInterface {
  self = [self init];
  if (self) {
    self.info.familyName = familyName;
    self.info.styleName = styleName;
  }
  return self;
}

- (void)dealloc {
  NSLog(@"Font dealloc");
}

- (void)saveToURL:(nonnull NSURL *)url showProgress:(BOOL)progress formatVersion:(NSUInteger)version {

}

- (nonnull FSLayer *)defaultLayer {
  if (_defaultLayer == nil) {
    if (_layers.count == 0) {
      [self newLayerWithName:@"default" color:CGColorGetConstantColor(kCGColorBlack)];
    }
    _defaultLayer = _layers[0];
  }
  return _defaultLayer;
}

- (void)setDefaultLayer:(FSLayer *)defaultLayer {
  _defaultLayer = defaultLayer;
}

- (nonnull FSLayer *)newLayerWithName:(nonnull NSString *)name color:(CGColorRef)color {
  FSLayer *layer = [self layerWithName:name color:color];
  [_layers addObject:layer];
  return layer;
}

- (nonnull FSLayer *)layerWithName:(nonnull NSString *)name color:(CGColorRef)color {
  return [[FSLayer alloc] initWithName:name color:color];
}

@end
