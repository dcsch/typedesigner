//
//  TCGlyfTable.h
//  Typecast
//
//  Created by David Schweinsberg on 9/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTable.h"

@class TCDirectoryEntry;
@class TCDataInput;
@class TCMaxpTable;
@class TCLocaTable;

@interface TCGlyfTable : TCTable

@property (strong) NSArray *descript;

- (id)initWithDataInput:(TCDataInput *)dataInput
         directoryEntry:(TCDirectoryEntry *)entry
              maxpTable:(TCMaxpTable *)maxp
              locaTable:(TCLocaTable *)loca;

@end
