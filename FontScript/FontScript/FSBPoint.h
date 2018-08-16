//
//  FSBPoint.h
//  FontScript
//
//  Created by David Schweinsberg on 8/14/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSPoint.h"

NS_SWIFT_NAME(BPoint)
@interface FSBPoint : NSObject

- (nonnull instancetype)initWithPoint:(nonnull FSPoint *)point NS_DESIGNATED_INITIALIZER;
- (instancetype)init __attribute__((unavailable));

// Parents
@property(weak) FSContour *contour;

// Attributes
@property FSPointType type;

// Points
@property CGPoint anchor;
@property CGPoint bcpIn;
@property CGPoint bcpOut;

// Transformations
- (void)transformBy:(CGAffineTransform)transform;
- (void)moveBy:(CGPoint)point;

@end
