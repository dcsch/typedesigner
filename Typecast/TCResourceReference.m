//
//  TCResourceReference.m
//  Type Designer
//
//  Created by David Schweinsberg on 28/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCResourceReference.h"
#import "TCDataInput.h"

@implementation TCResourceReference

- (id)initWithDataInput:(TCDataInput *)dataInput
{
    self = [super init];
    if (self)
    {
        _resourceID = [dataInput readUnsignedShort];
        _nameOffset = [dataInput readShort];
        _attributes = [dataInput readUnsignedByte];
        _dataOffset = ([dataInput readUnsignedByte] << 16) | [dataInput readUnsignedShort];
        _handle = [dataInput readInt];
    }
    return self;
}

- (void)readName:(TCDataInput *)dataInput
{
    if (_nameOffset > -1)
    {
        int len = [dataInput readUnsignedByte];
        NSData *data = [dataInput readDataWithLength:len];
        _name = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    }
}

@end
