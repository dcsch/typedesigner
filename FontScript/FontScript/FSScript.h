//
//  FSScript.h
//  FontScript
//
//  Created by David Schweinsberg on 5/25/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FSFont;

NS_SWIFT_NAME(Script)
@interface FSScript : NSObject

@property(nonnull, readonly) NSArray<FSFont *> *fonts;

+ (nonnull FSScript *)Shared;

- (nonnull instancetype)initWithPath:(nonnull NSString *)path NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init __attribute__((unavailable));

- (nonnull FSFont *)newFontWithFamilyName:(nonnull NSString *)familyName
                                styleName:(nonnull NSString *)styleName
                            showInterface:(BOOL)showInterface;

@end

@interface FSScript (Python)

- (void)importModule:(nonnull NSString *)moduleName;
- (void)runModule:(nonnull NSString *)moduleName function:(nonnull NSString *)functionName arguments:(nonnull NSArray *)args;

@end
