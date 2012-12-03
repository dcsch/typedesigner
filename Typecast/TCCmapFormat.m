//
//  TCCmapFormat.m
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCCmapFormat.h"
#import "TCDataInput.h"
#import "TCCmapFormat0.h"

@implementation TCCmapFormat

- (id)initWithDataInput:(TCDataInput *)dataInput
{
    self = [super init];
    if (self)
    {
        _length = [dataInput readUnsignedShort];
        _language = [dataInput readUnsignedShort];
    }
    return self;
}

+ (TCCmapFormat *)cmapFormatOfType:(int)formatType dataInput:(TCDataInput *)dataInput
{
    switch (formatType)
    {
        case 0:
            return [[TCCmapFormat0 alloc] initWithDataInput:dataInput];
        case 2:
            return [[TCCmapFormat2 alloc] initWithDataInput:dataInput];
        case 4:
            return [[TCCmapFormat4 alloc] initWithDataInput:dataInput];
        case 6:
            return [[TCCmapFormat6 alloc] initWithDataInput:dataInput];
        default:
            return [[TCCmapFormatUnknown alloc] initWithFormatType:formatType dataInput:dataInput];
    }
}

@end
