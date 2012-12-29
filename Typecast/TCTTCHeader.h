//
//  TCTTCHeader.h
//  Type Designer
//
//  Created by David Schweinsberg on 29/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCDataInput;

@interface TCTTCHeader : NSObject

@property int ttcTag;
@property int version;
@property int directoryCount;
@property (strong) NSArray *tableDirectory;
@property int dsigTag;
@property int dsigLength;
@property int dsigOffset;

- (id)initWithDataInput:(TCDataInput *)dataInput;

+ (BOOL)isTTCDataInput:(TCDataInput *)dataInput;

@end
