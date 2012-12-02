//
//  TCFont.h
//  Typecast
//
//  Created by David Schweinsberg on 1/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCTable;
@class TCTableDirectory;

@interface TCFont : NSObject

@property (strong) TCTableDirectory *tableDirectory;
@property (strong) NSArray *tables;

- (id)initWithData:(NSData *)data;
- (TCTable *)tableWithType:(NSUInteger)tableType;

@end
