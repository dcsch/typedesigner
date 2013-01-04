//
//  CFFCharstring.m
//  Type Designer
//
//  Created by David Schweinsberg on 4/01/13.
//  Copyright (c) 2013 David Schweinsberg. All rights reserved.
//

#import "CFFCharstring.h"
#import "CFFIndex.h"

@implementation CFFCharstring

- (int)index
{
    return -1;
}

- (NSString *)name
{
    return nil;
}

@end


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

@end
