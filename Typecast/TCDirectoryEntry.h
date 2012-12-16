//
//  TCDirectoryEntry.h
//  Typecast
//
//  Created by David Schweinsberg on 1/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCDataInput;

@interface TCDirectoryEntry : NSObject <NSCopying>

@property uint32_t tag;
@property uint32_t checksum;
@property uint32_t offset;
@property uint32_t length;
@property (strong, readonly) NSString *tagAsString;

- (id)initWithDataInput:(TCDataInput *)dataInput;

@end
