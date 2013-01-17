//
//  CFFCharstringType2.m
//  Type Designer
//
//  Created by David Schweinsberg on 16/01/13.
//  Copyright (c) 2013 David Schweinsberg. All rights reserved.
//

#import "CFFCharstringType2.h"

static NSString *_oneByteOperators[] = {
    @"-Reserved-",
    @"hstem",
    @"-Reserved-",
    @"vstem",
    @"vmoveto",
    @"rlineto",
    @"hlineto",
    @"vlineto",
    @"rrcurveto",
    @"-Reserved-",
    @"callsubr",
    @"return",
    @"escape",
    @"-Reserved-",
    @"endchar",
    @"-Reserved-",
    @"-Reserved-",
    @"-Reserved-",
    @"hstemhm",
    @"hintmask",
    @"cntrmask",
    @"rmoveto",
    @"hmoveto",
    @"vstemhm",
    @"rcurveline",
    @"rlinecurve",
    @"vvcurveto",
    @"hhcurveto",
    @"shortint",
    @"callgsubr",
    @"vhcurveto",
    @"hvcurveto"
};

static NSString *_twoByteOperators[] = {
    @"-Reserved- (dotsection)",
    @"-Reserved-",
    @"-Reserved-",
    @"and",
    @"or",
    @"not",
    @"-Reserved-",
    @"-Reserved-",
    @"-Reserved-",
    @"abs",
    @"add",
    @"sub",
    @"div",
    @"-Reserved-",
    @"neg",
    @"eq",
    @"-Reserved-",
    @"-Reserved-",
    @"drop",
    @"-Reserved-",
    @"put",
    @"get",
    @"ifelse",
    @"random",
    @"mul",
    @"-Reserved-",
    @"sqrt",
    @"dup",
    @"exch",
    @"index",
    @"roll",
    @"-Reserved-",
    @"-Reserved-",
    @"-Reserved-",
    @"hflex",
    @"flex",
    @"hflex1",
    @"flex1",
    @"-Reserved-"
};

@interface CFFCharstringType2 ()
{
    int _index;
    NSString *_name;
    NSData *_data;
    int _offset;
    int _length;
    CFFIndex *_localSubrIndex;
    CFFIndex *_globalSubrIndex;
    int _ip;
}

- (void)disassembleToString:(NSMutableString *)string;
- (void)resetIP;
- (BOOL)isOperandAtIndex;
- (id)nextOperand;
- (uint8_t)nextByte;
- (BOOL)moreBytes;

@end


@implementation CFFCharstringType2

- (id)initWithIndex:(int)index
               name:(NSString *)name
               data:(NSData *)data
             offset:(int)offset
             length:(int)length
     localSubrIndex:(CFFIndex *)localSubrIndex
    globalSubrIndex:(CFFIndex *)globalSubrIndex
{
    self = [super init];
    if (self)
    {
        _index = index;
        _name = name;
        _data = data;
        _offset = offset;
        _length = length;
        _localSubrIndex = localSubrIndex;
        _globalSubrIndex = globalSubrIndex;
    }
    return self;
}

- (int)index
{
    return _index;
}

- (NSString *)name
{
    return _name;
}

- (void)disassembleToString:(NSMutableString *)string
{
    NSNumber *operand = nil;
    while ([self isOperandAtIndex])
    {
        operand = [self nextOperand];
        [string appendFormat:@"%@ ", operand];
    }
    uint8_t operator = [self nextByte];
    NSString *mnemonic;
    if (operator == 12)
    {
        operator = [self nextByte];

        // Check we're not exceeding the upper limit of our mnemonics
        if (operator > 38)
            operator = 38;

        mnemonic = _twoByteOperators[operator];
    } else {
        mnemonic = _oneByteOperators[operator];
    }
    [string appendString:mnemonic];
}

- (void)resetIP
{
    _ip = _offset;
}

- (BOOL)isOperandAtIndex
{
    int b0 = ((const uint8_t *)[_data bytes])[_ip];
    if ((32 <= b0 && b0 <= 255) || b0 == 28)
        return YES;

    return NO;
}

- (id)nextOperand
{
    const uint8_t *bytes = (const uint8_t *)[_data bytes];

    int b0 = bytes[_ip];
    if (32 <= b0 && b0 <= 246)
    {
        // 1 byte integer
        ++_ip;
        return [NSNumber numberWithInteger:b0 - 139];
    }
    else if (247 <= b0 && b0 <= 250)
    {
        // 2 byte integer
        int b1 = bytes[_ip + 1];
        _ip += 2;
        return [NSNumber numberWithInteger:(b0 - 247) * 256 + b1 + 108];
    }
    else if (251 <= b0 && b0 <= 254)
    {
        // 2 byte integer
        int b1 = bytes[_ip + 1];
        _ip += 2;
        return [NSNumber numberWithInteger:-(b0 - 251) * 256 - b1 - 108];
    }
    else if (b0 == 28)
    {
        // 3 byte integer
        int b1 = bytes[_ip + 1];
        int b2 = bytes[_ip + 2];
        _ip += 3;
        return [NSNumber numberWithInteger:b1 << 8 | b2];
    }
    else if (b0 == 255)
    {
        // 16-bit signed integer with 16 bits of fraction
        int b1 = (uint8_t) bytes[_ip + 1];
        int b2 = bytes[_ip + 2];
        int b3 = bytes[_ip + 3];
        int b4 = bytes[_ip + 4];
        _ip += 5;
        return [NSNumber numberWithFloat:(b1 << 8 | b2) + ((b3 << 8 | b4) / 65536.0)];
    } else {
        return [NSNull null];
    }
}

- (uint8_t)nextByte
{
    return ((const uint8_t *)[_data bytes])[_ip++];
}

- (BOOL)moreBytes
{
    return _ip < _offset + _length;
}

- (NSString *)description
{
    NSMutableString *str = [[NSMutableString alloc] init];
    [self resetIP];
    while ([self moreBytes])
    {
        [self disassembleToString:str];
        [str appendString:@"\n"];
    }
    return str;
}

@end
