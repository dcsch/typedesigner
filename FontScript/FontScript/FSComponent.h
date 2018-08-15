//
//  FSComponent.h
//  FontScript
//
//  Created by David Schweinsberg on 7/19/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class FSGlyph;
@class FSLayer;
@class FSFont;
@protocol FSPen;
@protocol FSPointPen;

NS_SWIFT_NAME(Component)
@interface FSComponent : NSObject <NSCopying>

- (nonnull instancetype)initWithBaseGlyphName:(nonnull NSString *)baseGlyphName NS_DESIGNATED_INITIALIZER;
- (instancetype)init __attribute__((unavailable));

// Parents
@property(weak) FSGlyph *glyph;
@property(readonly, weak) FSLayer *layer;
@property(readonly, weak) FSFont *font;

// Identification
@property(readonly) NSString *identifier;
@property(readonly) NSUInteger index;

// Attributes
@property(nonnull) NSString *baseGlyphName;
@property CGAffineTransform transformation;
@property CGPoint offset;
@property CGPoint scale;

// Queries

// Pens and Drawing
- (void)drawWithPen:(id <FSPen>)pen;
- (void)drawWithPointPen:(id <FSPointPen>)pointPen;

// Transformations

// Normalization
- (BOOL)decomposeWithError:(NSError **)error;

// Environment

@end