//
//  TCResourceHeader.h
//  Type Designer
//
//  Created by David Schweinsberg on 28/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCDataInput;

@interface TCResourceHeader : NSObject

@property int dataOffset;
@property int mapOffset;
@property int dataLength;
@property int mapLength;

- (id)initWithDataInput:(TCDataInput *)dataInput;

@end
