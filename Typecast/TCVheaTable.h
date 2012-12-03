//
//  TCVheaTable.h
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTable.h"

@class TCDirectoryEntry;
@class TCDataInput;

@interface TCVheaTable : TCTable

@property uint32_t version;
@property int16_t ascent;
@property int16_t descent;
@property int16_t lineGap;
@property int16_t advanceHeightMax;
@property int16_t minTopSideBearing;
@property int16_t minBottomSideBearing;
@property int16_t yMaxExtent;
@property int16_t caretSlopeRise;
@property int16_t caretSlopeRun;
@property int16_t metricDataFormat;
@property uint16_t numberOfLongVerMetrics;

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry;

@end
