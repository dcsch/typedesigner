//
//  CFFCharstring.h
//  Type Designer
//
//  Created by David Schweinsberg on 4/01/13.
//  Copyright (c) 2013 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CFFIndex;

@interface CFFCharstring : NSObject

- (int)index;
- (NSString *)name;

@end
