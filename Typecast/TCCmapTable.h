//
//  TCCmapTable.h
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTable.h"

@class TCDirectoryEntry;
@class TCDataInput;

@interface TCCmapTable : TCTable

@property uint16_t version;
@property uint16_t numTables;
@property (strong) NSArray *entries;

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry;

@end
