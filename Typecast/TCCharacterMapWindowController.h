//
//  TCCharacterMapWindowController.h
//  Type Designer
//
//  Created by David Schweinsberg on 22/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TCCmapIndexEntry;

@interface TCCharacterMapWindowController : NSWindowController

@property (weak) TCCmapIndexEntry *cmapIndexEntry;

@end
