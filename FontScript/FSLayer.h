//
//  FSLayer.h
//  FontScript
//
//  Created by David Schweinsberg on 5/28/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class FSGlyph;

NS_SWIFT_NAME(Layer)
@interface FSLayer : NSObject

@property NSString *name;
@property CGColorRef color;
@property NSMutableDictionary<NSString *, FSGlyph *> *glyphs;

- (nonnull instancetype)init NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithName:(nonnull NSString *)name color:(CGColorRef)color;

- (FSGlyph *)newGlyphWithName:(nonnull NSString *)name clear:(BOOL)clear;

@end
