//
//  TCDataInput.h
//  Typecast
//
//  Created by David Schweinsberg on 1/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCDataInput : NSObject

- (id)initWithData:(NSData *)data;
- (uint32_t)readInt;
- (uint16_t)readShort;
- (uint64_t)readLong;
- (void)reset;
- (void)skipByteCount:(NSUInteger)bytesToSkip;

@end
