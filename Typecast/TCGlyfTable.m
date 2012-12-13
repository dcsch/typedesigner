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

@implementation TCGlyfTable

- (id)initWithDataInput:(TCDataInput *)dataInput
         directoryEntry:(TCDirectoryEntry *)entry
              maxpTable:(TCMaxpTable *)maxp
              locaTable:(TCLocaTable *)loca
{
    self = [super init];
    if (self)
    {
        self.directoryEntry = [entry copy];
        NSMutableArray *descript = [[NSMutableArray alloc] initWithCapacity:[maxp numGlyphs]];

        // Buffer the whole table so we can randomly access it
        NSData *data = [dataInput readDataWithLength:[entry length]];
        TCDataInput *glyfDataInput = [[TCDataInput alloc] initWithData:data];

        // Process all the simple glyphs
        for (int i = 0; i < [maxp numGlyphs]; ++i)
        {
            int len = [loca offsetAtIndex:i + 1] - [loca offsetAtIndex:i];
            if (len > 0)
            {
                [glyfDataInput reset];
                [glyfDataInput skipByteCount:[loca offsetAtIndex:i]];
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

@end
