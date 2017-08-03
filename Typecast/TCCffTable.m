//
//  TCCffTable.m
//  Type Designer
//
//  Created by David Schweinsberg on 30/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCCffTable.h"
#import "Type_Designer-Swift.h"
#import "CFFIndex.h"
#import "CFFDict.h"
#import "CFFCharset.h"
#import "CFFCharstringType2.h"

@implementation TCCffTable

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry
{
    self = [super init];
    if (self)
    {
        self.directoryEntry = [entry copy];

        NSData *data = [dataInput readDataWithLength:[entry length]];
        TCDataInput *di = [[TCDataInput alloc] initWithData:data];

        // Header
        _major = [di readUInt8];
        _minor = [di readUInt8];
        _hdrSize = [di readUInt8];
        _offSize = [di readUInt8];

        // Name INDEX
        [dataInput reset];
        [dataInput skipWithByteCount:_hdrSize];
        _nameIndex = [[CFFNameIndex alloc] initWithDataInput:di];

        // Top DICT INDEX
        _topDictIndex = [[CFFTopDictIndex alloc] initWithDataInput:di];

        // String INDEX
        _stringIndex = [[TCStringIndex alloc] initWithDataInput:di];

        // Global Subr INDEX
        _globalSubrIndex = [[CFFIndex alloc] initWithDataInput:di];

        // Encodings go here -- but since this is an OpenType font will this
        // not always be a CIDFont?  In which case there are no encodings
        // within the CFF data.

        // Load each of the fonts
        NSMutableArray *charStringsIndexArray = [[NSMutableArray alloc] initWithCapacity:[_topDictIndex count]];
        NSMutableArray *charsets = [[NSMutableArray alloc] initWithCapacity:[_topDictIndex count]];
        NSMutableArray *charstringsArray = [[NSMutableArray alloc] initWithCapacity:[_topDictIndex count]];
        for (int i = 0; i < [_topDictIndex count]; ++i)
        {
            // Charstrings INDEX
            // We load this before Charsets because we may need to know the number
            // of glyphs
            CFFDict *topDict = [_topDictIndex topDictAtIndex:i];
            int charStringsOffset = [[topDict valueForKey:17] intValue];
            [di reset];
            [di skipWithByteCount:charStringsOffset];

            CFFIndex *charStringsIndex = [[CFFIndex alloc] initWithDataInput:di];
            [charStringsIndexArray addObject:charStringsIndex];
            int glyphCount = [charStringsIndex count];

            // Charsets
            int charsetOffset = [[topDict valueForKey:15] intValue];
            [di reset];
            [di skipWithByteCount:charsetOffset];
            int format = [di readUInt8];
            CFFCharset *charset = nil;
            switch (format)
            {
                case 0:
                    charset = [[CFFCharsetFormat0 alloc] initWithDataInput:di glyphCount:glyphCount];
                    break;
                case 1:
                    charset = [[CFFCharsetFormat1 alloc] initWithDataInput:di glyphCount:glyphCount];
                    break;
                case 2:
                    charset = [[CFFCharsetFormat2 alloc] initWithDataInput:di glyphCount:glyphCount];
                    break;
            }
            [charsets addObject:charset];

            // Create the charstrings
            NSMutableArray *charstrings = [[NSMutableArray alloc] initWithCapacity:glyphCount];
            [charstringsArray addObject:charstrings];
            for (int j = 0; j < glyphCount; ++j)
            {
                int offset = [[charStringsIndex offset][j] intValue] - 1;
                int len = [[charStringsIndex offset][j + 1] intValue] - offset - 1;
                [charstrings addObject:[[CFFCharstringType2 alloc] initWithIndex:i
                                                                            name:[_stringIndex stringAtIndex:[charset SIDForGID:j]]
                                                                            data:[charStringsIndex data]
                                                                          offset:offset
                                                                          length:len
                                                                  localSubrIndex:nil
                                                                 globalSubrIndex:nil]];

                //NSLog(@"%@", [[charstrings lastObject] description]);
            }
        }
    }
    return self;
}

- (uint32_t)type
{
    return TCTable_CFF;
}

@end
