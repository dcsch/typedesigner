//
//  TCGlyfTable.m
//  Typecast
//
//  Created by David Schweinsberg on 9/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCGlyfTable.h"
#import "TCDirectoryEntry.h"
#import "TCDataInput.h"

@implementation TCGlyfTable

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry
{
    self = [super init];
    if (self)
    {
        self.directoryEntry = [entry copy];
    }
    return self;
}

- (uint32_t)type
{
    return TCTable_glyf;
}

@end
