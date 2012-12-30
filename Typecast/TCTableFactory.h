//
//  TCTableFactory.h
//  Typecast
//
//  Created by David Schweinsberg on 2/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCTable;
@class TCFont;
@class TCDirectoryEntry;
@class TCDataInput;

@interface TCTableFactory : NSObject

+ (id<TCTable>)createTableForFont:(TCFont *)font
                    withDataInput:(TCDataInput *)dataInput
                   directoryEntry:(TCDirectoryEntry *)entry;

@end
