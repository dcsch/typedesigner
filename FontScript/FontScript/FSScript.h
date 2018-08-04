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

@property(readonly) NSArray<FSFont *> *fonts;

+ (FSScript *)Shared;

- (nonnull instancetype)initWithPath:(NSString *)path NS_DESIGNATED_INITIALIZER;
- (instancetype)init __attribute__((unavailable));

- (FSFont *)newFontWithFamilyName:(NSString *)familyName
                        styleName:(NSString *)styleName
                    showInterface:(BOOL)showInterface;

@end

@interface FSScript (Python)

- (void)importModule:(NSString *)moduleName;
- (void)runModule:(NSString *)moduleName function:(NSString *)functionName arguments:(NSArray *)args;

@end
