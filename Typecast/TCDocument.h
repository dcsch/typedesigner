//
//  TCDocument.h
//  Typecast
//
//  Created by David Schweinsberg on 1/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "TCFontCollection.h"

//@class TCFont;
@class TCFontCollection;

@interface TCDocument : NSDocument

//@property (strong) TCFont *font;
@property (strong) TCFontCollection *fontCollection;

@end
