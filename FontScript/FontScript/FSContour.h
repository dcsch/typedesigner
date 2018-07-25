//
//  FSContour.h
//  FontScript
//
//  Created by David Schweinsberg on 6/14/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSPoint.h"

@class FSGlyph;
@class FSLayer;
@class FSFont;
@class FSSegment;
@protocol FSPen;
@protocol FSPointPen;

NS_SWIFT_NAME(Contour)
@interface FSContour : NSObject <NSCopying>

- (nonnull instancetype)initWithGlyph:(nullable FSGlyph *)glyph NS_DESIGNATED_INITIALIZER;
- (instancetype)init __attribute__((unavailable));

// Parents
@property(weak) FSGlyph *glyph;
@property(readonly, weak) FSLayer *layer;
@property(readonly, weak) FSFont *font;

// Identification
@property(readonly) NSString *identifier;
@property NSUInteger index;

// Winding Direction
@property BOOL clockwise;
- (void)reverse;

// Queries

// Pens and Drawing
- (void)drawWithPen:(NSObject<FSPen> *)pen;
- (void)drawWithPointPen:(NSObject<FSPointPen> *)pen;

// Segments
@property(nonnull, readonly) NSArray<FSSegment *> *segments;

// bPoints

// Points
@property(readonly) NSArray<FSPoint *> *points;
- (void)appendPoint:(CGPoint)point type:(FSPointType)type smooth:(BOOL)smooth;
- (void)insertPoint:(CGPoint)point type:(FSPointType)type smooth:(BOOL)smooth atIndex:(NSUInteger)index;
- (void)removePoint:(CGPoint)point;

// Transformations
- (void)transformBy:(CGAffineTransform)transform;
- (void)moveBy:(CGPoint)point;

// Normalization

// Environment

@end
