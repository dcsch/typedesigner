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
- (nonnull instancetype)init __attribute__((unavailable));

// Parents
@property(nullable, weak) FSGlyph *glyph;
@property(nullable, readonly, weak) FSLayer *layer;
@property(nullable, readonly, weak) FSFont *font;

// Identification
@property(null_unspecified, readonly) NSString *identifier;
@property(readonly) NSUInteger index;

// Attributes
@property(nonnull) NSString *baseGlyphName;
@property CGAffineTransform transformation;
@property CGPoint offset;
@property CGPoint scale;

// Queries

// Pens and Drawing
- (void)drawWithPen:(nonnull id <FSPen>)pen;
- (void)drawWithPointPen:(nonnull id <FSPointPen>)pointPen;

// Transformations

// Normalization
- (BOOL)decomposeWithError:(NSError *_Nullable*_Nullable)error;

// Environment

@end
