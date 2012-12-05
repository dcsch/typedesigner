//
//  TCHmtxTable.h
//  Typecast
//
//  Created by David Schweinsberg on 4/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTable.h"

@class TCDirectoryEntry;
@class TCDataInput;
@class TCHheaTable;
@class TCMaxpTable;

@interface TCHmtxTable : TCTable

- (id)initWithDataInput:(TCDataInput *)dataInput
         directoryEntry:(TCDirectoryEntry *)entry
              hheaTable:(TCHheaTable *)hhea
              maxpTable:(TCMaxpTable *)maxp;

- (uint16_t)advanceWidthAtIndex:(int)index;

- (int16_t)leftSideBearingAtIndex:(int)index;

@end
