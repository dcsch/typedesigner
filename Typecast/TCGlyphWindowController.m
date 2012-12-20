//
//  TCGlyphWindowController.m
//  Type Designer
//
//  Created by David Schweinsberg on 19/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCGlyphWindowController.h"
#import "TCDocument.h"
#import "TCGlyph.h"
#import "TCGlyphView.h"
#import "TCHmtxTable.h"

@interface TCGlyphWindowController ()

@property (weak) IBOutlet TCGlyphView *glyphView;

@end

@implementation TCGlyphWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self)
    {
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    TCFont *font = [(TCDocument *)[self document] font];
    TCGlyph *glyph = [[TCGlyph alloc] initWithGlyphDescription:_glyphDescription
                                               leftSideBearing:[[font hmtxTable] leftSideBearingAtIndex:[_glyphDescription glyphIndex]]
                                                  advanceWidth:[[font hmtxTable] advanceWidthAtIndex:[_glyphDescription glyphIndex]]];
    [_glyphView setGlyph:glyph];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
    return [NSString stringWithFormat:@"%@ – %d", displayName, [_glyphDescription glyphIndex]];
}

@end
