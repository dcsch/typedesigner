//
//  TCCmapIndexEntry.m
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCCmapIndexEntry.h"
#import "Type_Designer-Swift.h"

@implementation TCCmapIndexEntry

- (id)initWithDataInput:(TCDataInput *)dataInput
{
    self = [super init];
    if (self)
    {
        _platformId = [dataInput readUInt16];
        _encodingId = [dataInput readUInt16];
        _offset = [dataInput readUInt32];
    }
    return self;
}

- (NSComparisonResult)compare:(TCCmapIndexEntry *)anEntry
{
    if (_offset < [anEntry offset])
        return NSOrderedAscending;
    else if (_offset > [anEntry offset])
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

- (NSString *)platformDescription
{
    return [TCID platformNameWithPlatformID:_platformId];
}

- (NSString *)encodingDescription
{
    return [TCID encodingNameWithPlatformID:_platformId encodingID:_encodingId];
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"platform id: %d (%@), encoding id: %d (%@), offset: %d",
            _platformId,
            [TCID platformNameWithPlatformID:_platformId],
            _encodingId,
            [TCID encodingNameWithPlatformID:_platformId encodingID:_encodingId],
            _offset];
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return key;
}

- (NSString *)testName
{
    return @"This is a test";
}

@end
