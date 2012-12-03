//
//  TCCmapFormat6.m
//  Typecast
//
//  Created by David Schweinsberg on 4/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCCmapFormat6.h"
#import "TCDataInput.h"

@implementation TCCmapFormat6

- (id)initWithDataInput:(TCDataInput *)dataInput
{
    self = [super initWithDataInput:dataInput];
    if (self)
    {
        [self setFormat:6];
    }
    return self;
}

@end
