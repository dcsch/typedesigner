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
@property (strong) TCHeadTable *head;
@property (strong) TCHheaTable *hhea;
@property (strong) TCMaxpTable *maxp;
@property (strong) TCLocaTable *loca;
@property (strong) TCVheaTable *vhea;
@property (strong) TCCmapTable *cmap;
@property (strong) TCHmtxTable *hmtxTable;
@property (strong) TCNameTable *name;
@property (strong) TCOs2Table *os2;
@property (strong) TCPostTable *post;
@property (strong) TCGlyfTable *glyf;

- (id)initWithData:(NSData *)data;
- (TCTable *)tableWithType:(NSUInteger)tableType;

@end
