//
//  TCResourceMap.m
//  Type Designer
//
//  Created by David Schweinsberg on 28/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCResourceMap.h"
#import "TCDataInput.h"
#import "TCResourceType.h"

@implementation TCResourceMap

- (id)initWithDataInput:(TCDataInput *)dataInput
{
    self = [super init];
    if (self)
    {
        _headerData = [dataInput readDataWithLength:16];
        _nextResourceMap = [dataInput readInt];
        _fileReferenceNumber = [dataInput readUnsignedShort];
        _attributes = [dataInput readUnsignedShort];

        int typeOffset = [dataInput readUnsignedShort];
        int nameOffset = [dataInput readUnsignedShort];
        int typeCount = [dataInput readUnsignedShort] + 1;

        // Read types
        NSMutableArray *types = [[NSMutableArray alloc] initWithCapacity:typeCount];
        for (int i = 0; i < typeCount; ++i)
            [types addObject:[[TCResourceType alloc] initWithDataInput:dataInput]];
        _types = types;

        // Read the references
        for (int i = 0; i < typeCount; ++i)
            [_types[i] readReferences:dataInput];

        // Read the names
        for (int i = 0; i < typeCount; ++i)
            [_types[i] readNames:dataInput];
    }
    return self;
}

- (TCResourceType *)resourceTypeWithName:(NSString *)typeName
{
    for (TCResourceType *type in _types)
    {
        NSString *s = [type typeAsString];
        if ([s isEqualToString:typeName])
            return type;
    }
    return nil;
}

@end
