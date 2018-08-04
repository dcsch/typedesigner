//
//  FSTestPen.h
//  FontScriptTests
//
//  Created by David Schweinsberg on 7/20/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSPen.h"

@interface FSTestPen : NSObject <FSPen>

@property(readonly) NSArray<NSString *> *records;

- (void)reset;

@end
