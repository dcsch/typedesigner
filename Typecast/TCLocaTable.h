//
//  TCLocaTable.h
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTable.h"

@class TCDirectoryEntry;
@class TCDataInput;
@class TCHeadTable;
@class TCMaxpTable;

@interface TCLocaTable : TCTable

@property (strong) NSArray *offsets;
@property uint16_t factor;

- (id)initWithDataInput:(TCDataInput *)dataInput
         directoryEntry:(TCDirectoryEntry *)entry
              headTable:(TCHeadTable *)head
              maxpTable:(TCMaxpTable *)maxp;

- (int32_t)offsetAtIndex:(NSUInteger)index;

@end
