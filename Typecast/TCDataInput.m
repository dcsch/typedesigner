//
//  TCDataInput.m
//  Typecast
//
//  Created by David Schweinsberg on 1/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCDataInput.h"

@interface TCDataInput ()

@property (strong) NSData *data;
@property const unsigned char *bytes;
@property NSUInteger offset;

@end

@implementation TCDataInput

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        _data = data;
        _bytes = [data bytes];
        _offset = 0;
    }
    return self;
}

- (uint32_t)readInt
{
    uint32_t value = CFSwapInt32BigToHost(*(uint32_t *)(_bytes + _offset));
    _offset += 4;
    return value;
}

- (uint16_t)readShort
{
    uint16_t value = CFSwapInt16BigToHost(*(uint16_t *)(_bytes + _offset));
    _offset += 2;
    return value;
}

- (uint64_t)readLong
{
    uint64_t value = CFSwapInt64BigToHost(*(uint64_t *)(_bytes + _offset));
    _offset += 8;
    return value;
}

- (void)reset
{
    _offset = 0;
}

- (void)skipByteCount:(NSUInteger)bytesToSkip
{
    _offset += bytesToSkip;
}

@end
