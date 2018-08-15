//
//  FSBPoint.m
//  FontScript
//
//  Created by David Schweinsberg on 8/14/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSBPoint.h"

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
  _point.cgPoint = anchor;
}

@end
