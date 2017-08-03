//
//  TCFpgmTable.m
//  Type Designer
//
//  Created by David Schweinsberg on 30/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCFpgmTable.h"
#import "Type_Designer-Swift.h"
#import "TCDisassembler.h"

@implementation TCFpgmTable

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry
{
    self = [super init];
    if (self)
    {
        self.directoryEntry = [entry copy];
        [self readInstructionsWithDataInput:dataInput length:[entry length]];
    }
    return self;
}

- (uint32_t)type
{
    return TCTable_fpgm;
}

- (NSString *)name
{
    uint32_t type = [self type];
    return [NSString stringWithFormat:
            @"%c%c%c%c",
            (char)(type >> 24),
            (char)(type >> 16),
            (char)(type >> 8),
            (char)type];
}

- (NSString *)description
{
    return [TCDisassembler disassembleInstructions:[self instructions]
                                 leadingSpaceCount:0];
}

@end
