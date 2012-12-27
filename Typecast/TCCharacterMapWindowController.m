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

@interface TCCharacterMapping : NSObject

@property NSUInteger characterCode;
@property NSUInteger glyphCode;
@property (strong, readonly) NSString *characterCodeString;

@end

@implementation TCCharacterMapping

- (NSString *)characterCodeString
{
    return [NSString stringWithFormat:@"%04lX", _characterCode];
}

@end


@interface TCCharacterMapWindowController ()

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

    NSMutableArray *characterMappings = [NSMutableArray array];
    TCCmapFormat *format = [_cmapIndexEntry format];
    for (NSValue *rangeValue in [format ranges])
    {
        NSRange range = [rangeValue rangeValue];
        for (NSUInteger i = range.location; i < range.location + range.length; ++i)
        {
            TCCharacterMapping *mapping = [[TCCharacterMapping alloc] init];
            [mapping setCharacterCode:i];
            [mapping setGlyphCode:[format glyphCodeAtCharacterCode:i]];
            [characterMappings addObject:mapping];
        }
    }
    [self setCharacterMappings:characterMappings];
}

- (void)insertObject:(TCCharacterMapping *)mapping inCharacterMappingsAtIndex:(NSUInteger)index
{
    [_characterMappings insertObject:mapping atIndex:index];
}

- (void)removeObjectFromCharacterMappingsAtIndex:(NSUInteger)index
{
    [_characterMappings removeObjectAtIndex:index];
}

- (void)setCharacterMappings:(NSMutableArray *)characterMappings
{
    _characterMappings = characterMappings;
}

- (NSArray *)CharacterMappings
{
    return _characterMappings;
}

@end
