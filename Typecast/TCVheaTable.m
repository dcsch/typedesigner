//
//  TCVheaTable.m
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCVheaTable.h"
#import "TCDirectoryEntry.h"
#import "TCDataInput.h"

@implementation TCVheaTable

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry
{
    self = [super init];
    if (self)
    {
        self.directoryEntry = [entry copy];
        _version = [dataInput readInt];
        _ascent = [dataInput readShort];
        _descent = [dataInput readShort];
        _lineGap = [dataInput readShort];
        _advanceHeightMax = [dataInput readShort];
        _minTopSideBearing = [dataInput readShort];
        _minBottomSideBearing = [dataInput readShort];
        _yMaxExtent = [dataInput readShort];
        _caretSlopeRise = [dataInput readShort];
        _caretSlopeRun = [dataInput readShort];
        for (int i = 0; i < 5; ++i) {
            [dataInput readShort];
        }
        _metricDataFormat = [dataInput readShort];
        _numberOfLongVerMetrics = [dataInput readUnsignedShort];
    }
    return self;
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
