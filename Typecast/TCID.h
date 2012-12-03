//
//  TCID.h
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

// Platform IDs
extern const short TCPlatformUnicode;
extern const short TCPlatformMacintosh;
extern const short TCPlatformISO;
extern const short TCPlatformMicrosoft;

@interface TCID : NSObject

+ (NSString *)platformNameForID:(short)platformId;

+ (NSString *)encodingNameForPlatformID:(short)platformId encodingID:(short)encodingId;

@end
