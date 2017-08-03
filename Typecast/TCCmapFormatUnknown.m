//
//  TCCmapFormatUnknown.m
//  Typecast
//
//  Created by David Schweinsberg on 4/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCCmapFormatUnknown.h"
#import "Type_Designer-Swift.h"

@implementation TCCmapFormatUnknown

- (id)initWithFormatType:(uint16_t)format dataInput:(TCDataInput *)dataInput
{
    self = [super initWithDataInput:dataInput];
    if (self)
    {
        [self setFormat:format];

        // We don't know how to handle this data, so we'll just skip over it
        NSArray *array = [dataInput readWithLength:[self length] - 4];
//        [dataInput skipWithByteCount:[self length] - 4];
    }
    return self;
}

@end
