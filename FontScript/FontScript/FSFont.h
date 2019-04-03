//
//  FSFont.h
//  FontScript
//
//  Created by David Schweinsberg on 5/26/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class FSInfo;
@class FSLayer;

NS_SWIFT_NAME(Font)
@interface FSFont : NSObject

- (nonnull instancetype)init NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)initWithFamilyName:(nonnull NSString *)familyName
                                 styleName:(nonnull NSString *)styleName
                             showInterface:(BOOL)showInterface;

// File Operations
@property(null_unspecified, readonly) NSURL *url;
- (void)saveToURL:(nonnull NSURL *)url showProgress:(BOOL)progress formatVersion:(NSUInteger)version;

// Sub-Objects
@property(nonnull, readonly) FSInfo *info;

// Layers
@property(nonnull, readonly) NSArray<FSLayer *> *layers;
@property(nonnull) FSLayer *defaultLayer;
- (nonnull FSLayer *)newLayerWithName:(nonnull NSString *)name color:(nonnull CGColorRef)color NS_SWIFT_NAME(newLayer(name:color:));
- (nonnull FSLayer *)layerWithName:(nonnull NSString *)name color:(nonnull CGColorRef)color NS_SWIFT_NAME(layer(name:color:));

@end
