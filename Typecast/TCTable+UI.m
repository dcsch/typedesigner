//
//  TCTable+UI.m
//  Type Designer
//
//  Created by David Schweinsberg on 16/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTable+UI.h"

@implementation TCTable (UI)

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

- (NSArray *)components
{
    return nil;
}

@end
