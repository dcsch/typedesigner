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
@class TCPostTable;

@interface TCGlyfTable : TCTable

@property (strong) NSArray *descript;

- (id)initWithData:(NSData *)data
    directoryEntry:(TCDirectoryEntry *)entry
         maxpTable:(TCMaxpTable *)maxpTable
         locaTable:(TCLocaTable *)locaTable
         postTable:(TCPostTable *)postTable;

- (NSUInteger)countOfGlyphNames;
- (NSString *)objectInGlyphNamesAtIndex:(NSUInteger)index;

@end
