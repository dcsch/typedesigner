//
//  TCDocument.h
//  Typecast
//
//  Created by David Schweinsberg on 1/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TCFont.h"

@interface TCDocument : NSDocument

@property (strong) NSArray *bogus;
@property (strong) TCFont *font;

@end
