//
//  NSValue+CGPoint.m
//  FontScript
//
//  Created by David Schweinsberg on 7/23/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "NSValue+CGPoint.h"

@implementation NSValue (CGPoint)

+ (instancetype)valueWithCGPoint:(CGPoint)point {
  return [self valueWithBytes:&point objCType:@encode(CGPoint)];
}

- (CGPoint)CGPointValue {
  CGPoint point;
  [self getValue:&point];
  return point;
}

@end
