//
//  TCCmapIndexEntry.h
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCCmapFormat;
@class TCDataInput;

@interface TCCmapIndexEntry : NSObject

@property uint16_t platformId;
@property uint16_t encodingId;
@property uint32_t offset;
@property (strong) TCCmapFormat *format;

@property (strong, readonly) NSString *platformDescription;
@property (strong, readonly) NSString *encodingDescription;

- (id)initWithDataInput:(TCDataInput *)dataInput;

- (NSComparisonResult)compare:(TCCmapIndexEntry *)anEntry;

@end
