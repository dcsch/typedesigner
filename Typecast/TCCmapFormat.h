//
//  TCCmapFormat.h
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCDataInput;

@interface TCCmapFormat : NSObject

@property uint16_t format;
@property uint16_t length;
@property uint16_t language;

- (id)initWithDataInput:(TCDataInput *)dataInput;

+ (TCCmapFormat *)cmapFormatOfType:(int)formatType dataInput:(TCDataInput *)dataInput;

@end
