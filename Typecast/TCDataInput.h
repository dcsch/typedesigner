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
- (int32_t)readInt;
- (int16_t)readShort;
- (uint16_t)readUnsignedShort;
- (int64_t)readLong;
- (void)reset;
- (void)skipByteCount:(NSUInteger)bytesToSkip;

@end
