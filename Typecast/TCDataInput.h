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
- (int64_t)readLong;
- (int32_t)readInt;
- (int16_t)readShort;
- (uint16_t)readUnsignedShort;
- (uint8_t)readUnsignedByte;
- (void)reset;
- (void)skipByteCount:(NSUInteger)bytesToSkip;

@end
