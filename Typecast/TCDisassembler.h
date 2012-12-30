//
//  TCDisassembler.h
//  Type Designer
//
//  Created by David Schweinsberg on 30/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCDisassembler : NSObject

+ (NSString *)disassembleInstructions:(NSData *)instructions leadingSpaceCount:(int)leadingSpaceCount;

@end
