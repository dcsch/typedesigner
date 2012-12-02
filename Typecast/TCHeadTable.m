//
//  TCHeadTable.m
//  Typecast
//
//  Created by David Schweinsberg on 2/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCHeadTable.h"
#import "TCDirectoryEntry.h"
#import "TCDataInput.h"

@implementation TCHeadTable

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry
{
    self = [super init];
    if (self)
    {
        self.directoryEntry = [entry copy];
        _versionNumber = [dataInput readInt];
        _fontRevision = [dataInput readInt];
        _checkSumAdjustment = [dataInput readInt];
        _magicNumber = [dataInput readInt];
        _flags = [dataInput readShort];
        _unitsPerEm = [dataInput readShort];
        _created = [dataInput readLong];
        _modified = [dataInput readLong];
        _xMin = [dataInput readShort];
        _yMin = [dataInput readShort];
        _xMax = [dataInput readShort];
        _yMax = [dataInput readShort];
        _macStyle = [dataInput readShort];
        _lowestRecPPEM = [dataInput readShort];
        _fontDirectionHint = [dataInput readShort];
        _indexToLocFormat = [dataInput readShort];
        _glyphDataFormat = [dataInput readShort];
    }
    return self;
}

@end
