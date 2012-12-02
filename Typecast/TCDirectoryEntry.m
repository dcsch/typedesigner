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
