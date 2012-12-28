//
//  TCFontCollection.m
//  Typecast
//
//  Created by David Schweinsberg on 1/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCFontCollection.h"
#import "TCDataInput.h"
#import "TCResourceHeader.h"
#import "TCResourceMap.h"
#import "TCResourceType.h"
#import "TCResourceReference.h"
#import "TCFont.h"

@implementation TCFontCollection

- (id)initWithData:(NSData *)data isSuitcase:(BOOL)suitcase
{
    self = [super init];
    if (self)
    {
        _suitcase = suitcase;
        [self loadFromData:data];
    }
    return self;
}

- (void)loadFromData:(NSData *)fontData
{
    TCDataInput *dataInput = [[TCDataInput alloc] initWithData:fontData];

    if ([self isSuitcase])
    {
        // This is a Macintosh font suitcase resource
        TCResourceHeader *resourceHeader = [[TCResourceHeader alloc] initWithDataInput:dataInput];

        // Seek to the map offset and read the map
        [dataInput reset];
        [dataInput skipByteCount:[resourceHeader mapOffset]];
        TCResourceMap *map = [[TCResourceMap alloc] initWithDataInput:dataInput];

        // Get the 'sfnt' resources
        TCResourceType *resourceType = [map resourceTypeWithName:@"sfnt"];

        // Load the font data
        NSMutableArray *fonts = [[NSMutableArray alloc] initWithCapacity:[resourceType count]];
        for (TCResourceReference *resourceReference in [resourceType references])
        {
            TCFont *font = [[TCFont alloc] init];
            [fonts addObject:font];
            int offset = [resourceHeader dataOffset] + [resourceReference dataOffset] + 4;
            [font readFromDataInput:dataInput directoryOffset:offset tablesOrigin:offset];
        }
        _fonts = fonts;

//    } else if (TTCHeader.isTTC(dis)) {
//
//        // This is a TrueType font collection
//        dis.reset();
//        _ttcHeader = new TTCHeader(dis);
//        _fonts = new OTFont[_ttcHeader.getDirectoryCount()];
//        for (int i = 0; i < _ttcHeader.getDirectoryCount(); i++) {
//            _fonts[i] = new OTFont(this);
//            _fonts[i].read(dis, _ttcHeader.getTableDirectory(i), 0);
//        }
    }
    else
    {
        // This is a standalone font file
        TCFont *font = [[TCFont alloc] init];
        [font readFromDataInput:dataInput directoryOffset:0 tablesOrigin:0];
        _fonts = @[font];
    }
}

@end
