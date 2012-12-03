//
//  TCHheaTable.m
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCHheaTable.h"
#import "TCDirectoryEntry.h"
#import "TCDataInput.h"

@implementation TCHheaTable

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry
{
    self = [super init];
    if (self)
    {
        self.directoryEntry = [entry copy];
        _version = [dataInput readInt];
        _ascender = [dataInput readShort];
        _descender = [dataInput readShort];
        _lineGap = [dataInput readShort];
        _advanceWidthMax = [dataInput readShort];
        _minLeftSideBearing = [dataInput readShort];
        _minRightSideBearing = [dataInput readShort];
        _xMaxExtent = [dataInput readShort];
        _caretSlopeRise = [dataInput readShort];
        _caretSlopeRun = [dataInput readShort];
        for (int i = 0; i < 5; i++) {
            [dataInput readShort];
        }
        _metricDataFormat = [dataInput readShort];
        _numberOfHMetrics = [dataInput readUnsignedShort];
    }
    return self;
}

- (uint32_t)type
{
    return TCTable_hhea;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"'hhea' Table - Horizontal Header\n--------------------------------"
            @"\n        'hhea' version:       %x"  // .append(Fixed.floatValue(version))
            @"\n        yAscender:            %d"  // .append(ascender)
            @"\n        yDescender:           %d"  // .append(descender)
            @"\n        yLineGap:             %d"  // .append(lineGap)
            @"\n        advanceWidthMax:      %d"  // .append(advanceWidthMax)
            @"\n        minLeftSideBearing:   %d"  // .append(minLeftSideBearing)
            @"\n        minRightSideBearing:  %d"  // .append(minRightSideBearing)
            @"\n        xMaxExtent:           %d"  // .append(xMaxExtent)
            @"\n        horizCaretSlopeNum:   %d"  // .append(caretSlopeRise)
            @"\n        horizCaretSlopeDenom: %d"  // .append(caretSlopeRun)
            @"\n        reserved0:            0"
            @"\n        reserved1:            0"
            @"\n        reserved2:            0"
            @"\n        reserved3:            0"
            @"\n        reserved4:            0"
            @"\n        metricDataFormat:     %d"  // .append(metricDataFormat)
            @"\n        numOf_LongHorMetrics: %d",  // .append(numberOfHMetrics)
            _version,
            _ascender,
            _descender,
            _lineGap,
            _advanceWidthMax,
            _minLeftSideBearing,
            _minRightSideBearing,
            _xMaxExtent,
            _caretSlopeRise,
            _caretSlopeRun,
            _metricDataFormat,
            _numberOfHMetrics];
}

@end
