//
//  FSIdentifier.h
//  FontScript
//
//  Created by David Schweinsberg on 7/6/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_SWIFT_NAME(Identifier)
@interface FSIdentifier : NSObject

+ (NSString *)RandomIdentifierWithError:(NSError **)error;

@end
