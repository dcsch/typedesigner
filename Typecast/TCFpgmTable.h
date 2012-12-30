//
//  TCFpgmTable.h
//  Type Designer
//
//  Created by David Schweinsberg on 30/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCProgram.h"
#import "TCTable.h"

@class TCDirectoryEntry;
@class TCDataInput;

@interface TCFpgmTable : TCProgram <TCTable>

@property (strong) TCDirectoryEntry *directoryEntry;
@property (strong, readonly) NSString *name;

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry;

@end
