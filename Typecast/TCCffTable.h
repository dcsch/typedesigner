//
//  TCCffTable.h
//  Type Designer
//
//  Created by David Schweinsberg on 30/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTable.h"

@class TCDirectoryEntry;
@class TCDataInput;
@class CFFNameIndex;
@class CFFTopDictIndex;
@class TCStringIndex;
@class CFFIndex;

@interface TCCffTable : TCTable

@property int major;
@property int minor;
@property int hdrSize;
@property int offSize;
@property (strong) CFFNameIndex *nameIndex;
@property (strong) CFFTopDictIndex *topDictIndex;
@property (strong) TCStringIndex *stringIndex;
@property (strong) CFFIndex *globalSubrIndex;

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry;

@end
