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
- (nonnull instancetype)init __attribute__((unavailable));

// Parents
@property(nullable, weak) FSLayer *layer;
@property(nullable, readonly, weak) FSFont *font;

// Identification
@property(nonnull) NSString *name;
- (BOOL)setName:(nonnull NSString *)name error:(NSError *_Nullable*_Nullable)error;
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
@property(nonnull, readonly) id <FSPen> pen;
@property(nonnull, readonly) id <FSPointPen> pointPen;
- (void)drawWithPen:(nonnull id <FSPen>)pen;
- (void)drawWithPointPen:(nonnull id <FSPointPen>)pointPen;

// Layers

// Global

// Contours
@property(nonnull, readonly) NSArray<FSContour *> *contours;
- (nonnull FSContour *)appendContour:(nonnull FSContour *)contour offset:(CGPoint)offset;
- (BOOL)removeContour:(nonnull FSContour *)contour error:(NSError *_Nullable*_Nullable)error;
- (BOOL)removeContourAtIndex:(NSUInteger)index error:(NSError *_Nullable*_Nullable)error;
- (void)clearContours;
- (BOOL)reorderContour:(nonnull FSContour *)contour toIndex:(NSUInteger)index error:(NSError *_Nullable*_Nullable)error;

// Components
@property(nonnull, readonly) NSArray<FSComponent *> *components;
- (nonnull FSComponent *)appendComponentWithGlyphName:(nonnull NSString *)glyphName
                                               offset:(CGPoint)offset
                                                scale:(CGPoint)scale;
- (nonnull FSComponent *)appendComponent:(nonnull FSComponent *)component;
- (BOOL)removeComponent:(nonnull FSComponent *)component error:(NSError *_Nullable*_Nullable)error;
- (BOOL)removeComponentAtIndex:(NSUInteger)index error:(NSError *_Nullable*_Nullable)error;
- (void)clearComponents;
- (BOOL)reorderComponent:(nonnull FSComponent *)component toIndex:(NSUInteger)index error:(NSError *_Nullable*_Nullable)error;
- (BOOL)decomposeWithError:(NSError *_Nullable*_Nullable)error;
- (BOOL)decomposeComponent:(nonnull FSComponent *)component error:(NSError *_Nullable*_Nullable)error;

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
