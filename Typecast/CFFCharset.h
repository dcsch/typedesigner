//
//  CFFCharset.h
//  Type Designer
//
//  Created by David Schweinsberg on 4/01/13.
//  Copyright (c) 2013 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCDataInput;

@interface CFFCharset : NSObject

- (int)format;
- (int)SIDForGID:(int)gid;

@end


@interface CFFCharsetFormat0 : CFFCharset

- (id)initWithDataInput:(TCDataInput *)dataInput glyphCount:(int)glyphCount;

@end


@interface CFFCharsetFormat1 : CFFCharset

- (id)initWithDataInput:(TCDataInput *)dataInput glyphCount:(int)glyphCount;

@end


@interface CFFCharsetFormat2 : CFFCharset

- (id)initWithDataInput:(TCDataInput *)dataInput glyphCount:(int)glyphCount;

@end
