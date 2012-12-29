//
//  TCFontCollection.h
//  Typecast
//
//  Created by David Schweinsberg on 1/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCTTCHeader;

@interface TCFontCollection : NSObject

@property (strong) NSArray *fonts;
@property (strong) TCTTCHeader *ttcHeader;
@property (getter = isSuitcase) BOOL suitcase;

- (id)initWithData:(NSData *)data isSuitcase:(BOOL)suitcase;

@end
