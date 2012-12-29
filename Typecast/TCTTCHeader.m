//
//  TCTTCHeader.m
//  Type Designer
//
//  Created by David Schweinsberg on 29/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTTCHeader.h"
#import "TCDataInput.h"

@implementation TCTTCHeader

+ (BOOL)isTTCDataInput:(TCDataInput *)dataInput
{
    const int ttcf = 0x74746366;
    int ttcTag = [dataInput readInt];
    return ttcTag == ttcf;
}

- (id)initWithDataInput:(TCDataInput *)dataInput
{
    self = [super init];
    if (self)
    {
        _ttcTag = [dataInput readInt];
        _version = [dataInput readInt];
        _directoryCount = [dataInput readInt];
        NSMutableArray *tableDirectory = [[NSMutableArray alloc] initWithCapacity:_directoryCount];
        for (int i = 0; i < _directoryCount; ++i)
            [tableDirectory addObject:[NSNumber numberWithInt:[dataInput readInt]]];
        _tableDirectory = tableDirectory;
        if (_version == 0x00010000)
            _dsigTag = [dataInput readInt];
        _dsigLength = [dataInput readInt];
        _dsigOffset = [dataInput readInt];
    }
    return self;
}

@end
