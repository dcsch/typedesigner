//
//  TCDisassembler.m
//  Type Designer
//
//  Created by David Schweinsberg on 30/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCDisassembler.h"
#import "TCMnemonic.h"

@implementation TCDisassembler

/**
 * Advance the instruction pointer to the next executable opcode.
 * This will be the next byte, unless the current opcode is a push
 * instruction, in which case it will be the byte immediately beyond
 * the last data byte.
 * @param ip The current instruction pointer
 * @return The new instruction pointer
 */
+ (int)advanceIP:(int)ip instructions:(NSData *)instructions
{
    const uint8_t *instrBytes = [instructions bytes];

    // The high word specifies font, cvt, or glyph program
    int i = ip & 0xffff;
    int dataCount;
    ++ip;
    if (TC_NPUSHB == instrBytes[i])
    {
        // Next byte is the data byte count
        dataCount = instrBytes[++i];
        ip += dataCount + 1;
    }
    else if (TC_NPUSHW == instrBytes[i])
    {
        // Next byte is the data word count
        dataCount = instrBytes[++i];
        ip += dataCount * 2 + 1;
    }
    else if (TC_PUSHB == (instrBytes[i] & 0xf8))
    {
        dataCount = (short)((instrBytes[i] & 0x07) + 1);
        ip += dataCount;
    }
    else if (TC_PUSHW == (instrBytes[i] & 0xf8))
    {
        dataCount = (short)((instrBytes[i] & 0x07) + 1);
        ip += dataCount * 2;
    }
    return ip;
}

+ (short)pushCountAtIP:(int)ip instructions:(NSData *)instructions
{
    const uint8_t *instrBytes = [instructions bytes];

    short instr = instrBytes[ip & 0xffff];
    if ((TC_NPUSHB == instr) || (TC_NPUSHW == instr))
        return instrBytes[(ip & 0xffff) + 1];
    else if ((TC_PUSHB == (instr & 0xf8)) || (TC_PUSHW == (instr & 0xf8)))
        return (short)((instr & 0x07) + 1);
    return 0;
}

+ (NSArray *)pushValuesAtIP:(int)ip instructions:(NSData *)instructions
{
    int count = [self pushCountAtIP:ip instructions:instructions];
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:count];
    int i = ip & 0xffff;
    const uint8_t *instrBytes = [instructions bytes];
    short instr = instrBytes[i];
    if (TC_NPUSHB == instr) {
        for (int j = 0; j < count; j++) {
            values[j] = [NSNumber numberWithUnsignedChar:instrBytes[i + j + 2]];
        }
    } else if (TC_PUSHB == (instr & 0xf8)) {
        for (int j = 0; j < count; j++) {
            values[j] = [NSNumber numberWithUnsignedChar:instrBytes[i + j + 1]];
        }
    } else if (TC_NPUSHW == instr) {
        for (int j = 0; j < count; j++) {
            values[j] = [NSNumber numberWithShort:((short)instrBytes[i + j*2 + 2] << 8) | instrBytes[i + j*2 + 3]];
        }
    } else if (TC_PUSHW == (instr & 0xf8)) {
        for (int j = 0; j < count; j++) {
            values[j] = [NSNumber numberWithShort:((short)instrBytes[i + j*2 + 1] << 8) | instrBytes[i + j*2 + 2]];
        }
    }
    return values;
}

+ (NSString *)disassembleInstructions:(NSData *)instructions leadingSpaceCount:(int)leadingSpaceCount
{
    NSMutableString *str = [[NSMutableString alloc] init];
    int ip = 0;
    const uint8_t *instrBytes = [instructions bytes];
    while (ip < [instructions length])
    {
        for (int i = 0; i < leadingSpaceCount; ++i)
            [str appendString:@" "];

        [str appendFormat:@"%d: %@", ip, [TCMnemonic mnemonicForOpcode:instrBytes[ip]]];
        if ([self pushCountAtIP:ip instructions:instructions] > 0)
        {
            NSArray *values = [self pushValuesAtIP:ip instructions:instructions];
            for (int j = 0; j < [values count]; ++j)
            {
                if (((instrBytes[ip] & 0xf8) == TC_PUSHW) ||
                    (instrBytes[ip] == TC_NPUSHW))
                    [str appendFormat:@" %d", [values[j] shortValue]];
                else
                    [str appendFormat:@" %d", [values[j] unsignedCharValue]];
            }
        }
        [str appendString:@"\n"];
        ip = [self advanceIP:ip instructions:instructions];
    }
    return str;
}

@end
