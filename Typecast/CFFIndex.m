//
//  CFFIndex.m
//  Type Designer
//
//  Created by David Schweinsberg on 3/01/13.
//  Copyright (c) 2013 David Schweinsberg. All rights reserved.
//

#import "CFFIndex.h"
#import "TCDataInput.h"
#import "CFFDict.h"
#import "CFFStandardStrings.h"

@interface CFFIndex ()

- (int)dataLength;

@end

@implementation CFFIndex

- (id)initWithDataInput:(TCDataInput *)dataInput
{
    self = [super init];
    if (self)
    {
        _count = [dataInput readUnsignedShort];
        NSMutableArray *offset = [[NSMutableArray alloc] initWithCapacity:_count];
        _offSize = [dataInput readUnsignedByte];
        for (int i = 0; i < _count + 1; ++i)
        {
            int thisOffset = 0;
            for (int j = 0; j < _offSize; ++j)
            {
                thisOffset |= [dataInput readUnsignedByte] << ((_offSize - j - 1) * 8);
            }
            [offset addObject:[NSNumber numberWithInt:thisOffset]];
        }
        _offset = offset;
        _data = [dataInput readDataWithLength:[self dataLength]];
    }
    return self;
}

- (int)dataLength
{
    return [[_offset lastObject] intValue] - 1;
}

//    public String toString() {
//        StringBuffer sb = new StringBuffer();
//        sb.append("DICT\n");
//        sb.append("count: ").append(_count).append("\n");
//        sb.append("offSize: ").append(_offSize).append("\n");
//        for (int i = 0; i < _count + 1; ++i) {
//            sb.append("offset[").append(i).append("]: ").append(_offset[i]).append("\n");
//        }
//        sb.append("data:");
//        for (int i = 0; i < _data.length; ++i) {
//            if (i % 8 == 0) {
//                sb.append("\n");
//            } else {
//                sb.append(" ");
//            }
//            sb.append(_data[i]);
//        }
//        sb.append("\n");
//        return sb.toString();
//    }

@end


@implementation CFFTopDictIndex

- (CFFDict *)topDictAtIndex:(int)index
{
    int offset = [[self offset][index] intValue] - 1;
    int len = [[self offset][index + 1] intValue] - offset - 1;
    return [[CFFDict alloc] initWithData:[self data] offset:offset length:len];
}

//    public String toString() {
//        StringBuffer sb = new StringBuffer();
//        for (int i = 0; i < getCount(); ++i) {
//            sb.append(getTopDict(i).toString()).append("\n");
//        }
//        return sb.toString();
//    }

@end


@implementation CFFNameIndex

//    public String getName(int index) {
//        String name = null;
//        int offset = getOffset(index) - 1;
//        int len = getOffset(index + 1) - offset - 1;
//
//        // Ensure the name hasn't been deleted
//        if (getData()[offset] != 0) {
//            StringBuffer sb = new StringBuffer();
//            for (int i = offset; i < offset + len; ++i) {
//                sb.append((char) getData()[i]);
//            }
//            name = sb.toString();
//        } else {
//            name = "DELETED NAME";
//        }
//        return name;
//    }
//
//    public String toString() {
//        StringBuffer sb = new StringBuffer();
//        for (int i = 0; i < getCount(); ++i) {
//            sb.append(getName(i)).append("\n");
//        }
//        return sb.toString();
//    }

@end
    

@implementation TCStringIndex

- (NSString *)stringAtIndex:(int)index
{
    if (index < [CFFStandardStrings stringCount])
        return [CFFStandardStrings stringAtIndex:index];
    else
    {
        index -= [CFFStandardStrings stringCount];
        if (index >= [self count])
            return nil;

        int offset = [[self offset][index] intValue] - 1;
        int len = [[self offset][index + 1] intValue] - offset - 1;

        NSData *stringData = [[self data] subdataWithRange:NSMakeRange(offset, len)];
        return [[NSString alloc] initWithData:stringData encoding:NSASCIIStringEncoding];
    }
}

//    public String toString() {
//        int nonStandardBase = CffStandardStrings.standardStrings.length;
//        StringBuffer sb = new StringBuffer();
//        for (int i = 0; i < getCount(); ++i) {
//            sb.append(nonStandardBase + i).append(": ");
//            sb.append(getString(nonStandardBase + i)).append("\n");
//        }
//        return sb.toString();
//    }

@end
