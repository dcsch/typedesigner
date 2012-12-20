//
//  TCGlyfTable.m
//  Typecast
//
//  Created by David Schweinsberg on 9/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCGlyfTable.h"
#import "TCDirectoryEntry.h"
#import "TCDataInput.h"
#import "TCMaxpTable.h"
#import "TCLocaTable.h"
#import "TCGlyfSimpleDescript.h"
#import "TCGlyfCompositeDescript.h"
#import "TCPostTable.h"

@interface TCGlyfTable ()
{
    TCPostTable *_postTable;
}

@end

@implementation TCGlyfTable

- (id)initWithDataInput:(TCDataInput *)dataInput
         directoryEntry:(TCDirectoryEntry *)entry
              maxpTable:(TCMaxpTable *)maxpTable
              locaTable:(TCLocaTable *)locaTable
              postTable:(TCPostTable *)postTable
{
    self = [super init];
    if (self)
    {
        self.directoryEntry = [entry copy];
        _postTable = postTable;
        NSMutableArray *descript = [[NSMutableArray alloc] initWithCapacity:[maxpTable numGlyphs]];

        // Buffer the whole table so we can randomly access it
        NSData *data = [dataInput readDataWithLength:[entry length]];
        TCDataInput *glyfDataInput = [[TCDataInput alloc] initWithData:data];

        // Process all the simple glyphs
        for (int i = 0; i < [maxpTable numGlyphs]; ++i)
        {
            int len = [locaTable offsetAtIndex:i + 1] - [locaTable offsetAtIndex:i];
            if (len > 0)
            {
                [glyfDataInput reset];
                [glyfDataInput skipByteCount:[locaTable offsetAtIndex:i]];
                int16_t numberOfContours = [glyfDataInput readShort];
                if (numberOfContours >= 0)
                    [descript addObject:[[TCGlyfSimpleDescript alloc] initWithDataInput:glyfDataInput
                                                                            parentTable:self
                                                                             glyphIndex:i
                                                                       numberOfContours:numberOfContours]];
            }
            else
                [descript addObject:[NSNull null]];
        }

//        // Now do all the composite glyphs
//        for (int i = 0; i < maxp.getNumGlyphs(); i++) {
//            int len = loca.getOffset(i + 1) - loca.getOffset(i);
//            if (len > 0) {
//                bais.reset();
//                bais.skip(loca.getOffset(i));
//                DataInputStream dis = new DataInputStream(bais);
//                short numberOfContours = dis.readShort();
//                if (numberOfContours < 0) {
//                    _descript[i] = new GlyfCompositeDescript(this, i, dis);
//                }
//            }
//        }
        _descript = descript;
    }
    return self;
}

- (uint32_t)type
{
    return TCTable_glyf;
}

- (NSUInteger)countOfGlyphNames
{
    return [_postTable numGlyphs];
}

- (NSString *)objectInGlyphNamesAtIndex:(NSUInteger)index
{
    if ([_postTable version] == 0x00020000)
    {
        NSUInteger nameIndex = [[_postTable glyphNameIndex][index] unsignedShortValue];
        return (nameIndex > 257)
            ? [_postTable psGlyphName][nameIndex - 258]
            : [TCPostTable macGlyphNameAtIndex:nameIndex];
    }
    else
    {
        return nil;
    }
}

@end
