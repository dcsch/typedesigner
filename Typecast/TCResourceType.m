//
//  TCResourceType.m
//  Type Designer
//
//  Created by David Schweinsberg on 28/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCResourceType.h"
#import "TCDataInput.h"
#import "TCResourceReference.h"

@implementation TCResourceType

- (id)initWithDataInput:(TCDataInput *)dataInput
{
    self = [super init];
    if (self)
    {
        _type = [dataInput readInt];
        _count = [dataInput readUnsignedShort] + 1;
        _offset = [dataInput readUnsignedShort];
    }
    return self;
}

- (void)readReferences:(TCDataInput *)dataInput
{
    NSMutableArray *references = [[NSMutableArray alloc] initWithCapacity:_count];
    for (int i = 0; i < _count; ++i)
        [references addObject:[[TCResourceReference alloc] initWithDataInput:dataInput]];
    _references = references;
}

- (void)readNames:(TCDataInput *)dataInput
{
    for (int i = 0; i < _count; ++i)
        [_references[i] readName:dataInput];
}

- (NSString *)typeAsString
{
    return [NSString stringWithFormat:
            @"%c%c%c%c",
            (char)((_type >> 24) & 0xff),
            (char)((_type >> 16) & 0xff),
            (char)((_type >> 8) & 0xff),
            (char)((_type) & 0xff)];
}

@end
