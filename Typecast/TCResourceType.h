//
//  TCResourceType.h
//  Type Designer
//
//  Created by David Schweinsberg on 28/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCDataInput;

@interface TCResourceType : NSObject

@property int type;
@property int count;
@property int offset;
@property (strong) NSArray *references;

- (id)initWithDataInput:(TCDataInput *)dataInput;
- (void)readReferences:(TCDataInput *)dataInput;
- (void)readNames:(TCDataInput *)dataInput;
- (NSString *)typeAsString;

@end
