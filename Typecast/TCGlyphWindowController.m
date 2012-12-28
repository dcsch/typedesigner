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
#import "TCHeadTable.h"
#import "TCHheaTable.h"
#import "TCHmtxTable.h"
#import "TCFontCollection.h"
#import "TCFont.h"

@interface TCGlyphWindowController ()

@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet TCGlyphView *glyphView;

- (void)calculateGlyphViewSize;

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

    // Listen to view resize notifications
    [[[self window] contentView] setPostsFrameChangedNotifications:YES];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserverForName:NSViewFrameDidChangeNotification
                    object:[[self window] contentView]
                     queue:nil
                usingBlock:
     ^(NSNotification *note) {
         [self calculateGlyphViewSize];
     }];

    [_scrollView setHasHorizontalRuler:YES];
    [_scrollView setHasVerticalRuler:YES];
    [_scrollView setRulersVisible:YES];

    TCFontCollection *fontCollection = [(TCDocument *)[self document] fontCollection];

    // TODO: Don't just select the first font
    TCFont *font = [fontCollection fonts][0];

    TCGlyph *glyph = [[TCGlyph alloc] initWithGlyphDescription:_glyphDescription
                                               leftSideBearing:[[font hmtxTable] leftSideBearingAtIndex:[_glyphDescription glyphIndex]]
                                                  advanceWidth:[[font hmtxTable] advanceWidthAtIndex:[_glyphDescription glyphIndex]]];
    [_glyphView setGlyph:glyph];
    //[_glyphView setFont:[(TCDocument *)[self document] font]];

    [self calculateGlyphViewSize];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
    return [NSString stringWithFormat:@"%@ – %d", displayName, [_glyphDescription glyphIndex]];
}

#pragma mark - Private Methods

- (void)calculateGlyphViewSize
{
    // Calculate a space in which to place the glyph in font design units. This will
    // include a substantial blank space around the glyph.

    TCFontCollection *fontCollection = [(TCDocument *)[self document] fontCollection];

    // TODO: Don't just select the first font
    TCFont *font = [fontCollection fonts][0];

    // Visible height: head.yMax - 2 * hhea.yDescender
    NSInteger visibleBottom = 2 * [[font hheaTable] descender];
    NSInteger visibleHeight = [[font headTable] yMax] - visibleBottom;
    NSInteger visibleLeft = visibleBottom;
    NSInteger visibleWidth = visibleHeight;

    [_glyphView setBounds:NSMakeRect(visibleLeft, visibleBottom, visibleWidth, visibleHeight)];

    NSRect rect = [_scrollView bounds];

    [_glyphView setFrame:NSMakeRect(-rect.size.height, -rect.size.height, 3 * rect.size.height, 3 * rect.size.height)];

    //[[_scrollView documentView] scrollPoint:NSMakePoint(rect.size.height, rect.size.height)];

    //    [_glyphView setBounds:NSMakeRect(-665, -665, 2725, 2725)];
    [_glyphView setNeedsDisplay:YES];
}

@end
