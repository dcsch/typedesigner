//
//  TCProgram.m
//  Typecast
//
//  Created by David Schweinsberg on 9/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCProgram.h"
#import "Type_Designer-Swift.h"

@implementation TCProgram

- (void)readInstructionsWithDataInput:(TCDataInput *)dataInput length:(NSUInteger)length
{
  [dataInput readWithLength:length];
//    _instructions = [dataInput readDataWithLength:length];
}

@end
