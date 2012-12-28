//
//  TCFontCollection.h
//  Typecast
//
//  Created by David Schweinsberg on 1/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCFontCollection : NSObject

@property (strong) NSArray *fonts;
@property (getter = isSuitcase) BOOL suitcase;

- (id)initWithData:(NSData *)data isSuitcase:(BOOL)suitcase;

@end
