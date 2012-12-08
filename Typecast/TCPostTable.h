//
//  TCPostTable.h
//  Typecast
//
//  Created by David Schweinsberg on 8/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTable.h"

@class TCDirectoryEntry;
@class TCDataInput;

@interface TCPostTable : TCTable

@property uint32_t version;
@property uint32_t italicAngle;
@property int16_t underlinePosition;
@property int16_t underlineThickness;
@property uint32_t isFixedPitch;
@property uint32_t minMemType42;
@property uint32_t maxMemType42;
@property uint32_t minMemType1;
@property uint32_t maxMemType1;

// v2
@property uint16_t numGlyphs;
@property (strong) NSArray *glyphNameIndex;
@property (strong) NSArray *psGlyphName;

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry;

@end
