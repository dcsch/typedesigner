//
//  TCResourceReference.h
//  Type Designer
//
//  Created by David Schweinsberg on 28/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCDataInput;

@interface TCResourceReference : NSObject

@property int resourceID;
@property short nameOffset;
@property short attributes;
@property int dataOffset;
@property int handle;
@property (strong) NSString *name;

- (id)initWithDataInput:(TCDataInput *)dataInput;
- (void)readName:(TCDataInput *)dataInput;

@end
