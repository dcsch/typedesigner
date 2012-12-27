//
//  TCCmapFormat2.m
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCCmapFormat2.h"
#import "TCDataInput.h"

@interface TCSubHeader : NSObject

@property uint16_t firstCode;
@property uint16_t entryCount;
@property int16_t idDelta;
@property uint16_t idRangeOffset;
@property int arrayIndex;

@end


@implementation TCSubHeader

@end


@interface TCCmapFormat2 ()
{
    uint16_t _subHeaderKeys[256];
    NSMutableArray *_subHeaders;
    NSMutableArray *_glyphIndexArray;
}

@end


@implementation TCCmapFormat2

- (id)initWithDataInput:(TCDataInput *)dataInput
{
    self = [super initWithDataInput:dataInput];
    if (self)
    {
        [self setFormat:2];
        int pos = 6;
        
        // Read the subheader keys, noting the highest value, as this will
        // determine the number of subheaders to read.
        int highest = 0;
        for (int i = 0; i < 256; ++i)
        {
            _subHeaderKeys[i] = [dataInput readUnsignedShort];
            highest = MAX(highest, _subHeaderKeys[i]);
            pos += 2;
        }
        int subHeaderCount = highest / 8 + 1;
        _subHeaders = [[NSMutableArray alloc] initWithCapacity:subHeaderCount];
        
        // Read the subheaders, once again noting the highest glyphIndexArray
        // index range.
        int indexArrayOffset = 8 * subHeaderCount + 518;
        highest = 0;
        for (int i = 0; i < subHeaderCount; ++i)
        {
            TCSubHeader *subHeader = [[TCSubHeader alloc] init];
            [subHeader setFirstCode:[dataInput readUnsignedShort]];
            [subHeader setEntryCount:[dataInput readUnsignedShort]];
            [subHeader setIdDelta:[dataInput readShort]];
            [subHeader setIdRangeOffset:[dataInput readUnsignedShort]];
            
            // Calculate the offset into the _glyphIndexArray
            pos += 8;
            [subHeader setArrayIndex:(pos - 2 + [subHeader idRangeOffset] - indexArrayOffset) / 2];
            
            // What is the highest range within the glyphIndexArray?
            highest = MAX(highest, [subHeader arrayIndex] + [subHeader entryCount]);
            
            [_subHeaders addObject:subHeader];
        }
        
        // Read the glyphIndexArray
        _glyphIndexArray = [[NSMutableArray alloc] initWithCapacity:highest];
        for (int i = 0; i < highest; ++i)
            [_glyphIndexArray addObject:[NSNumber numberWithUnsignedShort:[dataInput readUnsignedShort]]];

        // Determines the ranges
        NSMutableArray *ranges = [NSMutableArray arrayWithCapacity:[_subHeaders count]];
        for (int index = 0; index < [_subHeaders count]; ++index)
        {
            // Find the high-byte (if any)
            int highByte = 0;
            if (index != 0)
            {
                for (int i = 0; i < 256; ++i)
                {
                    if (_subHeaderKeys[i] / 8 == index)
                    {
                        highByte = i << 8;
                        break;
                    }
                }
            }

            TCSubHeader *subHeader = _subHeaders[index];
            NSRange range = NSMakeRange(highByte | [subHeader firstCode],
                                        highByte | [subHeader firstCode] + [subHeader entryCount] - 1);
            [ranges addObject:[NSValue valueWithRange:range]];
        }
        [self setRanges:ranges];
    }
    return self;
}

- (NSUInteger)glyphCodeAtCharacterCode:(NSUInteger)characterCode
{
    // Get the appropriate subheader
    int index = 0;
    int highByte = characterCode >> 8;
    if (highByte != 0) {
        index = _subHeaderKeys[highByte] / 8;
    }
    TCSubHeader *sh = _subHeaders[index];

    // Is the charCode out-of-range?
    int lowByte = characterCode & 0xff;
    if (lowByte < sh.firstCode ||
        lowByte >= (sh.firstCode + sh.entryCount)) {
        return 0;
    }

    // Now calculate the glyph index
    int glyphIndex =
        [_glyphIndexArray[sh.arrayIndex + (lowByte - sh.firstCode)] intValue];
    if (glyphIndex != 0) {
        glyphIndex += sh.idDelta;
        glyphIndex %= 65536;
    }
    return glyphIndex;
}

@end
