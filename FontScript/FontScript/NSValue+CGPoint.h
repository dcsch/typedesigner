//
//  NSValue+CGPoint.h
//  FontScript
//
//  Created by David Schweinsberg on 7/23/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSValue (CGPoint)

+ (instancetype)valueWithCGPoint:(CGPoint)point;
@property(readonly) CGPoint CGPointValue;

@end
