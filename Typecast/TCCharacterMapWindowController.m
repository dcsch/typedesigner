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
#import "TCGlyphDescription.h"
#import "TCGlyfTable.h"
#import "Type_Designer-Swift.h"

@interface TCCharacterMapping : NSObject

@property (weak) TCFont *font;
@property NSUInteger characterCode;
@property NSUInteger glyphCode;
@property (strong, readonly) NSString *characterCodeString;
@property (strong, readonly) NSImage *glyphImage;
@property (strong, readonly) TCGlyph *glyph;

@end

@implementation TCCharacterMapping

- (NSString *)characterCodeString
{
    return [NSString stringWithFormat:@"%04lX", _characterCode];
}

- (NSImage *)glyphImage
{
    return nil;
}

- (TCGlyph *)glyph
{
    id<TCGlyphDescription> glyphDescription = [[[_font glyfTable] descript] objectAtIndex:_glyphCode];
    TCGlyph *glyph = [[TCGlyph alloc] initWithGlyphDescription:glyphDescription
                                               leftSideBearing:[[_font hmtxTable] leftSideBearingWithIndex:[glyphDescription glyphIndex]]
                                                  advanceWidth:[[_font hmtxTable] advanceWidthWithIndex:[glyphDescription glyphIndex]]];
    return glyph;
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

    TCFontCollection *fontCollection = [(TCDocument *)[self document] fontCollection];

    // TODO: Don't just select the first font
    TCFont *font = [fontCollection fonts][0];

    NSMutableArray *characterMappings = [NSMutableArray array];
    TCCmapFormat *format = [_cmapIndexEntry format];
    for (NSValue *rangeValue in [format ranges])
    {
        NSRange range = [rangeValue rangeValue];
        for (NSUInteger i = range.location; i < range.location + range.length; ++i)
        {
            TCCharacterMapping *mapping = [[TCCharacterMapping alloc] init];
            [mapping setFont:font];
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
