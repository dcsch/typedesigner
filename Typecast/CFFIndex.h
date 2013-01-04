//
//  CFFIndex.h
//  Type Designer
//
//  Created by David Schweinsberg on 3/01/13.
//  Copyright (c) 2013 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCDataInput;
@class CFFDict;

@interface CFFIndex : NSObject

@property int count;
@property int offSize;
@property NSArray *offset;
@property NSData *data;

- (id)initWithDataInput:(TCDataInput *)dataInput;

@end


@interface CFFTopDictIndex : CFFIndex

- (CFFDict *)topDictAtIndex:(int)index;

@end


@interface CFFNameIndex : CFFIndex

@end


@interface TCStringIndex : CFFIndex

- (NSString *)stringAtIndex:(int)index;

@end
