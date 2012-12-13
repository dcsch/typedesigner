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

- (uint32_t)type
{
    return TCTable_head;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"'head' Table - Font Header\n--------------------------"
            @"\n  'head' version:      %x"  //  //).append(Fixed.floatValue(_versionNumber))
            @"\n  fontRevision:        %x"  //  //).append(Fixed.roundedFloatValue(_fontRevision, 8))
            @"\n  checkSumAdjustment:  0x%x"  //).append(Integer.toHexString(_checkSumAdjustment).toUpperCase())
            @"\n  magicNumber:         0x%x"  //).append(Integer.toHexString(_magicNumber).toUpperCase())
            @"\n  flags:               0x%x"  //).append(Integer.toHexString(_flags).toUpperCase())
            @"\n  unitsPerEm:          %d"  //).append(_unitsPerEm)
            @"\n  created:             %lld"  //).append(_created)
            @"\n  modified:            %lld"  //).append(_modified)
            @"\n  xMin:                %d"  //).append(_xMin)
            @"\n  yMin:                %d"  //).append(_yMin)
            @"\n  xMax:                %d"  //).append(_xMax)
            @"\n  yMax:                %d"  //).append(_yMax)
            @"\n  macStyle bits:       %X"  //).append(Integer.toHexString(_macStyle).toUpperCase())
            @"\n  lowestRecPPEM:       %d"  //).append(_lowestRecPPEM)
            @"\n  fontDirectionHint:   %d"  //).append(_fontDirectionHint)
            @"\n  indexToLocFormat:    %d"  //).append(_indexToLocFormat)
            @"\n  glyphDataFormat:     %d",  //).append(_glyphDataFormat)
            _versionNumber,
            _fontRevision,
            _checkSumAdjustment,
            _magicNumber,
            _flags,
            _unitsPerEm,
            _created,
            _modified,
            _xMin,
            _yMin,
            _xMax,
            _yMax,
            _macStyle,
            _lowestRecPPEM,
            _fontDirectionHint,
            _indexToLocFormat,
            _glyphDataFormat];
}

@end