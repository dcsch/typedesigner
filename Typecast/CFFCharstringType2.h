//
//  CFFCharstringType2.h
//  Type Designer
//
//  Created by David Schweinsberg on 16/01/13.
//  Copyright (c) 2013 David Schweinsberg. All rights reserved.
//

#import "CFFCharstring.h"

@interface CFFCharstringType2 : CFFCharstring

- (id)initWithIndex:(int)index
               name:(NSString *)name
               data:(NSData *)data
             offset:(int)offset
             length:(int)length
     localSubrIndex:(CFFIndex *)localSubrIndex
    globalSubrIndex:(CFFIndex *)globalSubrIndex;

@end
