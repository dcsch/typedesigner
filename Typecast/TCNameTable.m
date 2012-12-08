//
//  TCNameTable.m
//  Typecast
//
//  Created by David Schweinsberg on 5/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCNameTable.h"
#import "TCDirectoryEntry.h"
#import "TCDataInput.h"
#import "TCID.h"

@implementation TCNameRecord

- (id)initWithDataInput:(TCDataInput *)dataInput
{
    self = [super init];
    if (self)
    {
        _platformId = [dataInput readShort];
        _encodingId = [dataInput readShort];
        _languageId = [dataInput readShort];
        _nameId = [dataInput readShort];
        _stringLength = [dataInput readShort];
        _stringOffset = [dataInput readShort];
    }
    return self;
}

- (void)loadStringFromDataInput:(TCDataInput *)dataInput
{
    [dataInput skipByteCount:_stringOffset];
    NSData *stringData = [dataInput readDataWithLength:_stringLength];

    if (_platformId == TCPlatformUnicode)
    {
        // Unicode (big-endian)
        _record = [[NSString alloc] initWithData:stringData
                                        encoding:NSUTF16BigEndianStringEncoding];
    }
    else if (_platformId == TCPlatformMacintosh)
    {
        // Macintosh encoding, ASCII
        _record = [[NSString alloc] initWithData:stringData
                                        encoding:NSASCIIStringEncoding];
    }
    else if (_platformId == TCPlatformISO)
    {
        // ISO encoding, ASCII
        _record = [[NSString alloc] initWithData:stringData
                                        encoding:NSASCIIStringEncoding];
    }
    else if (_platformId == TCPlatformMicrosoft)
    {
        // Microsoft encoding, Unicode
        _record = [[NSString alloc] initWithData:stringData
                                        encoding:NSUTF16LittleEndianStringEncoding];
    }
}

@end


@interface TCNameTable ()

@end

@implementation TCNameTable

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry
{
    self = [super init];
    if (self)
    {
        self.directoryEntry = [entry copy];
        _formatSelector = [dataInput readShort];
        _numberOfNameRecords = [dataInput readShort];
        _stringStorageOffset = [dataInput readShort];
        NSMutableArray *nameRecords = [[NSMutableArray alloc] initWithCapacity:_numberOfNameRecords];

        // Load the records, which contain the encoding information and string
        // offsets
        for (int i = 0; i < _numberOfNameRecords; ++i)
            [nameRecords addObject:[[TCNameRecord alloc] initWithDataInput:dataInput]];
        _nameRecords = nameRecords;

        // Load the string data into a buffer so the records can copy out the
        // bits they are interested in
        NSData *stringStorageData = [dataInput readDataWithLength:[entry length] - _stringStorageOffset];

        // Now let the records get their hands on them
        for (TCNameRecord *record in _nameRecords)
            [record loadStringFromDataInput:[[TCDataInput alloc] initWithData:stringStorageData]];
    }
    return self;
}

- (uint32_t)type
{
    return TCTable_name;
}

@end
