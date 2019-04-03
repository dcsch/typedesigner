//
//  FSSegment.h
//  FontScript
//
//  Created by David Schweinsberg on 7/9/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FSPoint;
@class FSContour;
@class FSGlyph;
@class FSLayer;
@class FSFont;

typedef NS_ENUM(NSUInteger, FSSegmentType)
{
  FSSegmentTypeMove,
  FSSegmentTypeLine,
  FSSegmentTypeCurve,
  FSSegmentTypeQCurve
} NS_SWIFT_NAME(SegmentType);

NS_SWIFT_NAME(Segment)
@interface FSSegment : NSObject

- (nonnull instancetype)initWithPoints:(nonnull NSArray<FSPoint *> *)points NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init __attribute__((unavailable));

// Parents
@property(null_unspecified, weak) FSContour *contour;
@property(null_unspecified, readonly, weak) FSGlyph *glyph;
@property(null_unspecified, readonly, weak) FSLayer *layer;
@property(null_unspecified, readonly, weak) FSFont *font;

// Identification

// Attributes
@property(readonly) FSSegmentType type;
@property BOOL smooth;

// Points
@property(nonnull, readonly) NSArray<FSPoint *> *points;
@property(nullable, readonly) FSPoint *onCurvePoint;
@property(nonnull, readonly) NSArray<FSPoint *> *offCurvePoints;

// Transformations

// Normalization

// Environment

@end
