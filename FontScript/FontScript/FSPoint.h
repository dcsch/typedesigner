//
//  FSPoint.h
//  FontScript
//
//  Created by David Schweinsberg on 7/6/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "FSSegment.h"

@class FSContour;
@class FSGlyph;
@class FSLayer;
@class FSFont;

typedef NS_ENUM(NSUInteger, FSPointType)
{
  FSPointTypeMove,
  FSPointTypeLine,
  FSPointTypeCurve,
  FSPointTypeQCurve,
  FSPointTypeOffCurve
} NS_SWIFT_NAME(PointType);

NS_SWIFT_NAME(Point)
@interface FSPoint : NSObject <NSCopying>

- (nonnull instancetype)initWithPoint:(CGPoint)cgPoint type:(FSPointType)type smooth:(BOOL)smooth NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init __attribute__((unavailable));

// Parents
@property(null_unspecified, weak) FSContour *contour;
@property(null_unspecified, readonly, weak) FSGlyph *glyph;
@property(null_unspecified, readonly, weak) FSLayer *layer;
@property(null_unspecified, readonly, weak) FSFont *font;

// Identification
@property(nullable) NSString *name;
@property(null_unspecified, readonly) NSString *identifier;
@property(readonly) NSUInteger index;

// Coordinate
@property CGFloat x;
@property CGFloat y;
@property CGPoint cgPoint;

// Type
@property FSPointType type;
@property BOOL smooth;

// Transformations
- (void)transformBy:(CGAffineTransform)transform;
- (void)moveBy:(CGPoint)point;

// Normalization
- (void)round;

// Environment

@end
