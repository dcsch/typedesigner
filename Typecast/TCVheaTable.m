//
//  TCVheaTable.m
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCVheaTable.h"
#import "Type_Designer-Swift.h"

@implementation TCVheaTable

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry
{
    self = [super init];
    if (self)
    {
        self.directoryEntry = [entry copy];
        _version = [dataInput readUInt32];
        _ascent = [dataInput readInt16];
        _descent = [dataInput readInt16];
        _lineGap = [dataInput readInt16];
        _advanceHeightMax = [dataInput readInt16];
        _minTopSideBearing = [dataInput readInt16];
        _minBottomSideBearing = [dataInput readInt16];
        _yMaxExtent = [dataInput readInt16];
        _caretSlopeRise = [dataInput readInt16];
        _caretSlopeRun = [dataInput readInt16];
        for (int i = 0; i < 5; ++i) {
            [dataInput readInt16];
        }
        _metricDataFormat = [dataInput readInt16];
        _numberOfLongVerMetrics = [dataInput readUInt16];
    }
    return self;
}

- (uint32_t)type
{
    return TCTable_vhea;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"'vhea' Table - Vertical Header\n------------------------------"
            @"\n        'vhea' version:       %x"
            @"\n        xAscender:            %d"
            @"\n        xDescender:           %d"
            @"\n        xLineGap:             %d"
            @"\n        advanceHeightMax:     %d"
            @"\n        minTopSideBearing:    %d"
            @"\n        minBottomSideBearing: %d"
            @"\n        yMaxExtent:           %d"
            @"\n        horizCaretSlopeNum:   %d"
            @"\n        horizCaretSlopeDenom: %d"
            @"\n        reserved0:            0"
            @"\n        reserved1:            0"
            @"\n        reserved2:            0"
            @"\n        reserved3:            0"
            @"\n        reserved4:            0"
            @"\n        metricDataFormat:     %d"
            @"\n        numOf_LongVerMetrics: %d",
            _version,
            _ascent,
            _descent,
            _lineGap,
            _advanceHeightMax,
            _minTopSideBearing,
            _minBottomSideBearing,
            _yMaxExtent,
            _caretSlopeRise,
            _caretSlopeRun,
            _metricDataFormat,
            _numberOfLongVerMetrics];
}

@end
