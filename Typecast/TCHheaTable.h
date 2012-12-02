//
//  TCHheaTable.h
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTable.h"

@class TCDirectoryEntry;
@class TCDataInput;

@interface TCHheaTable : TCTable

@property uint32_t version;
@property int16_t ascender;
@property int16_t descender;
@property int16_t lineGap;
@property int16_t advanceWidthMax;
@property int16_t minLeftSideBearing;
@property int16_t minRightSideBearing;
@property int16_t xMaxExtent;
@property int16_t caretSlopeRise;
@property int16_t caretSlopeRun;
@property int16_t metricDataFormat;
@property uint32_t numberOfHMetrics;

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry;

@end
