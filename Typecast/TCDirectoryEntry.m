//
//  TCDirectoryEntry.m
//  Typecast
//
//  Created by David Schweinsberg on 1/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCDirectoryEntry.h"
#import "TCDataInput.h"

@implementation TCDirectoryEntry

- (id)initWithDataInput:(TCDataInput *)dataInput
{
    self = [super init];
    if (self)
    {
        _tag = [dataInput readInt];
        _checksum = [dataInput readInt];
        _offset = [dataInput readInt];
        _length = [dataInput readInt];
   }
    return self;
}

- (NSString *)tagAsString
{
    return [NSString stringWithFormat:
            @"%c%c%c%c",
            (char)(_tag >> 24),
            (char)(_tag >> 16),
            (char)(_tag >> 8),
            (char)_tag];
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"'%@' - chksm = 0x%x, off = 0x%x, len = %d",
            [self tagAsString],
            _checksum,
            _offset,
            _length];
}

#pragma mark - NSCopying Methods

- (id)copyWithZone:(NSZone *)zone
{
    TCDirectoryEntry *entryCopy = [[TCDirectoryEntry allocWithZone:zone] init];
    entryCopy.tag = _tag;
    entryCopy.checksum = _checksum;
    entryCopy.offset = _offset;
    entryCopy.length = _length;
    return entryCopy;
}

@end
