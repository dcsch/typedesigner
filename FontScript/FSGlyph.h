//
//  FSGlyph.h
//  FontScript
//
//  Created by David Schweinsberg on 5/28/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class FSFont;
@class FSLayer;
@class FSContour;
@class FSComponent;
@protocol FSPen;
@protocol FSPointPen;

NS_SWIFT_NAME(Glyph)
@interface FSGlyph : NSObject <NSCopying>

- (nonnull instancetype)initWithName:(nonnull NSString *)name layer:(nullable FSLayer *)layer NS_DESIGNATED_INITIALIZER;
- (instancetype)init __attribute__((unavailable));

// Parents
@property(weak) FSLayer *layer;
@property(weak) FSFont *font;

// Identification
@property(nonnull) NSString *name;
- (BOOL)setName:(nonnull NSString *)name error:(NSError **)error;
@property(nonnull) NSArray<NSNumber *> *unicodes;
@property(nullable) NSNumber *unicode;

// Metrics
@property CGFloat width;
@property CGFloat leftMargin;
@property CGFloat rightMargin;
@property CGFloat height;
@property CGFloat bottomMargin;
@property CGFloat topMargin;

// Queries
@property(readonly) CGRect bounds;

// Pens and Drawing
- (void)drawWithPen:(NSObject<FSPen> *)pen;
- (void)drawWithPointPen:(NSObject<FSPointPen> *)pointPen;

// Layers

// Global

// Contours
@property(nonnull, readonly) NSArray<FSContour *> *contours;
- (FSContour *)appendContour:(nonnull FSContour *)contour offset:(CGPoint)offset;
- (BOOL)removeContour:(nonnull FSContour *)contour error:(NSError **)error;
- (BOOL)removeContourAtIndex:(NSUInteger)index error:(NSError **)error;
- (void)clearContours;
- (BOOL)reorderContour:(nonnull FSContour *)contour toIndex:(NSUInteger)index error:(NSError **)error;

// Components
@property(readonly) NSArray<FSComponent *> *components;
- (FSComponent *)appendComponentWithGlyphName:(nonnull NSString *)glyphName
                                       offset:(CGPoint)offset
                                        scale:(CGPoint)scale;
- (FSComponent *)appendComponent:(nonnull FSComponent *)component;
- (BOOL)removeComponent:(nonnull FSComponent *)component error:(NSError **)error;
- (BOOL)removeComponentAtIndex:(NSUInteger)index error:(NSError **)error;
- (void)clearComponents;
- (BOOL)reorderComponent:(nonnull FSComponent *)component toIndex:(NSUInteger)index error:(NSError **)error;
- (BOOL)decomposeWithError:(NSError **)error;
- (BOOL)decomposeComponent:(nonnull FSComponent *)component error:(NSError **)error;

// Anchors

// Guidelines

// Image

// Note

// Sub-Objects

// Transformations
- (void)moveBy:(CGPoint)point;

// Interpolation

// Normalization

// Environment

@end
