//
//  TCCmapFormatUnknown.h
//  Typecast
//
//  Created by David Schweinsberg on 4/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCCmapFormat.h"

// When we encounter a cmap format we don't understand, we can use this class
// to hold the bare minimum information about it.

@interface TCCmapFormatUnknown : TCCmapFormat

- (id)initWithFormatType:(uint16_t)format dataInput:(TCDataInput *)dataInput;

@end
