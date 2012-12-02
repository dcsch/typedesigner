//
//  TCMaxpTable.h
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTable.h"

@class TCDirectoryEntry;
@class TCDataInput;

@interface TCMaxpTable : TCTable

@property uint32_t versionNumber;
@property uint16_t numGlyphs;
@property uint16_t maxPoints;
@property uint16_t maxContours;
@property uint16_t maxCompositePoints;
@property uint16_t maxCompositeContours;
@property uint16_t maxZones;
@property uint16_t maxTwilightPoints;
@property uint16_t maxStorage;
@property uint16_t maxFunctionDefs;
@property uint16_t maxInstructionDefs;
@property uint16_t maxStackElements;
@property uint16_t maxSizeOfInstructions;
@property uint16_t maxComponentElements;
@property uint16_t maxComponentDepth;

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry;

@end
