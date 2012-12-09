//
//  TCProgram.h
//  Typecast
//
//  Created by David Schweinsberg on 9/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCDataInput;

@interface TCProgram : NSObject

@property (strong) NSData *instructions;

- (void)readInstructionsWithDataInput:(TCDataInput *)dataInput length:(NSUInteger)length;

@end
