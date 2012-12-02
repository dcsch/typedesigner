//
//  TCHeadTable.h
//  Typecast
//
//  Created by David Schweinsberg on 2/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTable.h"

@class TCDirectoryEntry;
@class TCDataInput;

@interface TCHeadTable : TCTable

@property (strong) TCDirectoryEntry *directoryEntry;
@property uint32_t versionNumber;
@property uint32_t fontRevision;
@property uint32_t checkSumAdjustment;
@property uint32_t magicNumber;
@property uint16_t flags;
@property uint16_t unitsPerEm;
@property uint64_t created;
@property uint64_t modified;
@property int16_t xMin;
@property int16_t yMin;
@property int16_t xMax;
@property int16_t yMax;
@property uint16_t macStyle;
@property uint16_t lowestRecPPEM;
@property int16_t fontDirectionHint;
@property int16_t indexToLocFormat;
@property int16_t glyphDataFormat;

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry;

@end
