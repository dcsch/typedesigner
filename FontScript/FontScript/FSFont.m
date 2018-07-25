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

- (FSLayer *)newLayerWithName:(nonnull NSString *)name color:(CGColorRef)color {
  FSLayer *layer = [[FSLayer alloc] initWithName:name color:color];
  [_layers addObject:layer];
  return layer;
}

@end
