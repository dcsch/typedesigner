//
//  TCNameTable.h
//  Typecast
//
//  Created by David Schweinsberg on 5/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTable.h"

@class TCDirectoryEntry;
@class TCDataInput;


@interface TCNameRecord : NSObject

@property int16_t platformId;
@property int16_t encodingId;
@property int16_t languageId;
@property int16_t nameId;
@property int16_t stringLength;
@property int16_t stringOffset;
@property (strong) NSString *record;

- (id)initWithDataInput:(TCDataInput *)dataInput;

- (void)loadStringFromDataInput:(TCDataInput *)dataInput;

@end


@interface TCNameTable : TCTable

@property int16_t formatSelector;
@property int16_t numberOfNameRecords;
@property int16_t stringStorageOffset;
@property (strong) NSArray *nameRecords;

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry;

- (TCNameRecord *)recordWithID:(int16_t)nameId;

@end
