//
//  TCCharacterMapWindowController.m
//  Type Designer
//
//  Created by David Schweinsberg on 22/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCCharacterMapWindowController.h"
#import "TCCmapIndexEntry.h"
#import "TCCmapFormat.h"

@interface TCCharacterMapWindowController ()

@property (strong) NSMutableArray *entries;

@end

@implementation TCCharacterMapWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    _entries = [NSMutableArray array];
    TCCmapFormat *format = [_cmapIndexEntry format];
    for (NSValue *rangeValue in [format ranges])
    {
        NSRange range = [rangeValue rangeValue];
        for (NSUInteger i = range.location; i < range.location + range.length; ++i)
        {
            NSString *placeholderString = [NSString stringWithFormat:@"%ld", i];
            [_entries addObject:placeholderString];
        }
    }
}

@end
