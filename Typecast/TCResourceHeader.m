//
//  TCResourceHeader.m
//  Type Designer
//
//  Created by David Schweinsberg on 28/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCResourceHeader.h"
#import "TCDataInput.h"

@implementation TCResourceHeader

- (id)initWithDataInput:(TCDataInput *)dataInput
{
    self = [super init];
    if (self)
    {
        _dataOffset = [dataInput readInt];
        _mapOffset = [dataInput readInt];
        _dataLength = [dataInput readInt];
        _mapLength = [dataInput readInt];
    }
    return self;
}

@end
