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

@property(nonnull) NSString *name;
@property(nonnull) CGColorRef color;
@property(nonnull) NSMutableDictionary<NSString *, FSGlyph *> *glyphs;

- (nonnull instancetype)init NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithName:(nonnull NSString *)name color:(nonnull CGColorRef)color;

- (nonnull FSGlyph *)newGlyphWithName:(nonnull NSString *)name clear:(BOOL)clear NS_SWIFT_NAME(newGlyph(name:clear:));
- (nonnull FSGlyph *)newGlyphWithName:(nonnull NSString *)name NS_SWIFT_NAME(newGlyph(name:));

@end
