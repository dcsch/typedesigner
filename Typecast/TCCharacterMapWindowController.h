//
//  TCCharacterMapWindowController.h
//  Type Designer
//
//  Created by David Schweinsberg on 22/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TCCmapIndexEntry;
@class TCCharacterMapping;

@interface TCCharacterMapWindowController : NSWindowController

@property (weak) TCCmapIndexEntry *cmapIndexEntry;
@property (strong, nonatomic) NSMutableArray *characterMappings;

- (void)insertObject:(TCCharacterMapping *)mapping inCharacterMappingsAtIndex:(NSUInteger)index;
- (void)removeObjectFromCharacterMappingsAtIndex:(NSUInteger)index;
- (void)setCharacterMappings:(NSMutableArray *)characterMappings;
- (NSArray *)CharacterMappings;

@end
