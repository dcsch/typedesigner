//
//  TCCollectionWindowController.m
//  Type Designer
//
//  Created by David Schweinsberg on 30/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCCollectionWindowController.h"
#import "TCTablesWindowController.h"

@interface TCCollectionWindowController ()

@end

@implementation TCCollectionWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self)
    {
        [self setShouldCloseDocument:YES];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)showFonts:(NSArray *)fonts
{
    TCTablesWindowController *windowController = [[TCTablesWindowController alloc] initWithWindowNibName:@"TablesWindow"];
    [[self document] addWindowController:windowController];
    [windowController setFont:[fonts lastObject]];
    [windowController showWindow:self];
}

@end
