//
//  TCResourceMap.h
//  Type Designer
//
//  Created by David Schweinsberg on 28/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCDataInput;
@class TCResourceType;

@interface TCResourceMap : NSObject

@property (strong) NSData *headerData;
@property int nextResourceMap;
@property int fileReferenceNumber;
@property int attributes;
@property (strong) NSArray *types;

- (id)initWithDataInput:(TCDataInput *)dataInput;

- (TCResourceType *)resourceTypeWithName:(NSString *)typeName;

@end
