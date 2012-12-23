//
//  TCCmapFormat0.m
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCCmapFormat0.h"
#import "TCDataInput.h"

@interface TCCmapFormat0 ()

@property (strong) NSArray *glyphIdArray;

@end


@implementation TCCmapFormat0

- (id)initWithDataInput:(TCDataInput *)dataInput
{
    self = [super initWithDataInput:dataInput];
    if (self)
    {
        [self setRanges:@[[NSValue valueWithRange:NSMakeRange(0, 255)]]];

        [self setFormat:0];
        NSMutableArray *glyphIdArray = [[NSMutableArray alloc] initWithCapacity:256];
        for (int i = 0; i < 256; ++i)
            [glyphIdArray addObject:[NSNumber numberWithUnsignedChar:[dataInput readUnsignedByte]]];
    }
    return self;
}

@end
