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

@interface TCGlyfTable : TCTable

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry;

@end
