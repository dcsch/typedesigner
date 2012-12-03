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

@interface TCFont : NSObject

@property (strong) TCTableDirectory *tableDirectory;
@property (strong) NSArray *tables;
@property (strong) TCHeadTable *head;
@property (strong) TCHheaTable *hhea;
@property (strong) TCMaxpTable *maxp;
@property (strong) TCLocaTable *loca;

- (id)initWithData:(NSData *)data;
- (TCTable *)tableWithType:(NSUInteger)tableType;

@end
