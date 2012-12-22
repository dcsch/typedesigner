//
//  TCFont.h
//  Typecast
//
//  Created by David Schweinsberg on 1/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCTable;
@class TCTableDirectory;
@class TCHeadTable;
@class TCHheaTable;
@class TCMaxpTable;
@class TCLocaTable;
@class TCVheaTable;
@class TCCmapTable;
@class TCHmtxTable;
@class TCNameTable;
@class TCOs2Table;
@class TCPostTable;
@class TCGlyfTable;

@interface TCFont : NSObject

@property (strong) TCTableDirectory *tableDirectory;
@property (strong) NSArray *tables;
@property (strong) TCHeadTable *headTable;
@property (strong) TCHheaTable *hheaTable;
@property (strong) TCMaxpTable *maxpTable;
@property (strong) TCLocaTable *locaTable;
@property (strong) TCVheaTable *vheaTable;
@property (strong) TCCmapTable *cmapTable;
@property (strong) TCHmtxTable *hmtxTable;
@property (strong) TCNameTable *nameTable;
@property (strong) TCOs2Table *os2Table;
@property (strong) TCPostTable *postTable;
@property (strong) TCGlyfTable *glyfTable;
@property (readonly) int ascent;
@property (readonly) int descent;

- (id)initWithData:(NSData *)data;
- (TCTable *)tableWithType:(NSUInteger)tableType;

@end
