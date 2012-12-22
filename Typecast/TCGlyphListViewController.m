//
//  TCGlyphListViewController.m
//  Type Designer
//
//  Created by David Schweinsberg on 16/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCGlyphListViewController.h"
#import "TCDocument.h"
#import "TCGlyphWindowController.h"

@interface TCGlyphListViewController ()

@end

@implementation TCGlyphListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)showGlyphs:(NSArray *)glyphs
{
    TCGlyphWindowController *windowController = [[TCGlyphWindowController alloc] initWithWindowNibName:@"GlyphWindow"];
    [[self document] addWindowController:windowController];
    [windowController setGlyphDescription:[glyphs lastObject]];
    [windowController showWindow:self];
}

@end
