//
//  CFFDict.m
//  Type Designer
//
//  Created by David Schweinsberg on 30/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "CFFDict.h"

@interface CFFDict ()

@property (strong) NSMutableDictionary *entries;
@property (strong) NSData *data;
@property int index;

- (BOOL)addKeyAndValueEntry;
- (BOOL)isOperandAtCurrentIndex;
- (id)nextOperand;
- (NSString *)decodeRealNibble:(int)nibble;

@end

@implementation CFFDict

- (id)initWithData:(NSData *)data offset:(int)offset length:(int)length
{
    self = [super init];
    if (self)
    {
        _data = data;
        _index = offset;
        _entries = [NSMutableDictionary dictionary];
        while (_index < offset + length)
            [self addKeyAndValueEntry];
    }
    return self;
}

- (id)valueForKey:(int)key
{
    return [_entries objectForKey:[NSNumber numberWithInteger:key]];
}

- (BOOL)addKeyAndValueEntry
{
    NSMutableArray *operands = [[NSMutableArray alloc] init];
    id operand = nil;

    while ([self isOperandAtCurrentIndex])
    {
        operand = [self nextOperand];
        [operands addObject:operand];
    }
    int operator = ((uint8_t *)[_data bytes])[_index++];
    if (operator == 12)
    {
        operator <<= 8;
        operator |= ((uint8_t *)[_data bytes])[_index++];
    }
    if ([operands count] == 1)
        _entries[[NSNumber numberWithInteger:operator]] = operand;
    else
        _entries[[NSNumber numberWithInteger:operator]] = operands;
    return YES;
}

- (BOOL)isOperandAtCurrentIndex
{
    int b0 = ((uint8_t *)[_data bytes])[_index];
    if ((32 <= b0 && b0 <= 254)
        || b0 == 28
        || b0 == 29
        || b0 == 30)
        return YES;
    return NO;
}

//    private boolean isOperatorAtIndex() {
//        int b0 = _data[_index];
//        if (0 <= b0 && b0 <= 21) {
//            return true;
//        }
//        return false;
//    }

- (id)nextOperand
{
    uint8_t *bytes = (uint8_t *)[_data bytes];
    int b0 = bytes[_index];
    if (32 <= b0 && b0 <= 246)
    {
        // 1 byte integer
        ++_index;
        return [NSNumber numberWithInteger:b0 - 139];
    }
    else if (247 <= b0 && b0 <= 250)
    {
        // 2 byte integer
        int b1 = bytes[_index + 1];
        _index += 2;
        return [NSNumber numberWithInteger:(b0 - 247) * 256 + b1 + 108];
    }
    else if (251 <= b0 && b0 <= 254)
    {
        // 2 byte integer
        int b1 = bytes[_index + 1];
        _index += 2;
        return [NSNumber numberWithInteger:-(b0 - 251) * 256 - b1 - 108];
    }
    else if (b0 == 28)
    {
        // 3 byte integer
        int b1 = bytes[_index + 1];
        int b2 = bytes[_index + 2];
        _index += 3;
        return [NSNumber numberWithInteger:b1 << 8 | b2];
    }
    else if (b0 == 29)
    {
        // 5 byte integer
        int b1 = bytes[_index + 1];
        int b2 = bytes[_index + 2];
        int b3 = bytes[_index + 3];
        int b4 = bytes[_index + 4];
        _index += 5;
        return [NSNumber numberWithInteger:b1 << 24 | b2 << 16 | b3 << 8 | b4];
    }
    else if (b0 == 30)
    {
        // Real number
        NSMutableString *fString = [[NSMutableString alloc] init];
        int nibble1 = 0;
        int nibble2 = 0;
        ++_index;
        while ((nibble1 != 0xf) && (nibble2 != 0xf))
        {
            nibble1 = bytes[_index] >> 4;
            nibble2 = bytes[_index] & 0xf;
            ++_index;
            [fString appendString:[self decodeRealNibble:nibble1]];
            [fString appendString:[self decodeRealNibble:nibble2]];
        }
        return [NSNumber numberWithFloat:[fString floatValue]];
    } else {
        return [NSNull null];
    }
}

- (NSString *)decodeRealNibble:(int)nibble
{
    static NSString *nibbles[] = {
        @"0",
        @"1",
        @"2",
        @"3",
        @"4",
        @"5",
        @"6",
        @"7",
        @"8",
        @"9",
        @".",
        @"E",
        @"E-",
        @"",
        @"-",
        @""
    };
    return nibbles[nibble % 0x10];
}

//    public String toString() {
//        StringBuffer sb = new StringBuffer();
//        Enumeration<Integer> keys = _entries.keys();
//        while (keys.hasMoreElements()) {
//            Integer key = keys.nextElement();
//            if ((key.intValue() & 0xc00) == 0xc00) {
//                sb.append("12 ").append(key.intValue() & 0xff).append(": ");
//            } else {
//                sb.append(key.toString()).append(": ");
//            }
//            sb.append(_entries.get(key).toString()).append("\n");
//        }
//        return sb.toString();
//    }
//}

@end
