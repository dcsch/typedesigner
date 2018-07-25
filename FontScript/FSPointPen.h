//
//  FSPointPen.h
//  FontScript
//
//  Created by David Schweinsberg on 7/9/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSSegment.h"
#import "FSPoint.h"

NS_SWIFT_NAME(PointPen)
@protocol FSPointPen <NSObject>
- (void)beginPath;
- (void)beginPathWithIdentifier:(nonnull NSString *)identifier NS_SWIFT_NAME(beginPath(identifier:));
- (void)endPath;
- (void)addPoint:(nonnull FSPoint *)point NS_SWIFT_NAME(addPoint(_:));
- (void)addPoints:(nonnull NSArray<FSPoint *> *)points NS_SWIFT_NAME(addPoints(_:));
- (void)addCGPoint:(CGPoint)point
              type:(FSPointType)type
            smooth:(BOOL)smooth NS_SWIFT_NAME(addCGPoint(_:type:smooth:));
- (void)addCGPoint:(CGPoint)point
              type:(FSPointType)type
            smooth:(BOOL)smooth
              name:(nullable NSString *)name
        identifier:(nullable NSString *)identifier NS_SWIFT_NAME(addCGPoint(_:type:smooth:name:identifier:));
- (BOOL)addComponentWithBaseGlyphName:(nonnull NSString *)baseGlyphName
                       transformation:(CGAffineTransform)transformation
                           identifier:(nullable NSString *)identifier
                                error:(NSError **)error;
@end
