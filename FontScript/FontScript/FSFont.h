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

@property(readonly) NSURL *url;
@property(readonly) NSArray<FSLayer *> *layers;

- (nonnull instancetype)init NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)initWithFamilyName:(NSString *)familyName
                                 styleName:(NSString *)styleName
                             showInterface:(BOOL)showInterface;

// File Operations
- (void)saveToURL:(nonnull NSURL *)url showProgress:(BOOL)progress formatVersion:(NSUInteger)version;

// Sub-Objects
@property(readonly) FSInfo *info;

// Layers
- (FSLayer *)newLayerWithName:(nonnull NSString *)name color:(CGColorRef)color;

@end
