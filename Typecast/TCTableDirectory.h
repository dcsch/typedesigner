//
//  TCTableDirectory.h
//  Typecast
//
//  Created by David Schweinsberg on 1/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCDirectoryEntry;
@class TCDataInput;

@interface TCTableDirectory : NSObject

@property uint32_t version;
@property uint16_t numTables;
@property uint16_t searchRange;
@property uint16_t entrySelector;
@property uint16_t rangeShift;
@property (strong) NSArray *entries;

- (id)initWithDataInput:(TCDataInput *)dataInput;

- (TCDirectoryEntry *)entryWithTag:(uint32_t)tag;

@end
