//
//  CFFDict.h
//  Type Designer
//
//  Created by David Schweinsberg on 30/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFFDict : NSObject

- (id)initWithData:(NSData *)data offset:(int)offset length:(int)length;

- (id)valueForKey:(int)key;

@end
