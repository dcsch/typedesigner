//
//  TCTablesWindowController.m
//  Typecast
//
//  Created by David Schweinsberg on 2/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTablesWindowController.h"
#import "TCTable.h"
#import "TCGlyphListViewController.h"
#import "TCCharacterMapListViewController.h"

@interface TCTablesWindowController () <NSTableViewDelegate>
{
    NSViewController *_containedViewController;
}

@property (weak) IBOutlet NSView *containerView;
@property (weak) IBOutlet NSArrayController *tableArrayController;

@end

@implementation TCTablesWindowController

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

#pragma mark - NSTableViewDelegate Methods

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    [[_containedViewController view] removeFromSuperview];
    [_containerView removeConstraints:[_containerView constraints]];
    _containedViewController = nil;

    id<TCTable> table = [[_tableArrayController selectedObjects] lastObject];
    if ([table type] == TCTable_glyf)
    {
        _containedViewController = [[TCGlyphListViewController alloc] initWithNibName:@"GlyphListView" bundle:nil];
        [_containedViewController setRepresentedObject:table];
        [(TCGlyphListViewController *)_containedViewController setDocument:[self document]];
    }
    else if ([table type] == TCTable_cmap)
    {
        _containedViewController = [[TCCharacterMapListViewController alloc] initWithNibName:@"CharacterMapListView" bundle:nil];
        [_containedViewController setRepresentedObject:table];
        [(TCCharacterMapListViewController *)_containedViewController setDocument:[self document]];
    }

    if (_containedViewController)
    {
        // Put into the container view
        [[_containedViewController view] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_containerView addSubview:[_containedViewController view]];

        // Add constraints that fill the container view
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:[_containedViewController view]
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_containerView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:0.0];
        [_containerView addConstraint:constraint];

        constraint = [NSLayoutConstraint constraintWithItem:[_containedViewController view]
                                                  attribute:NSLayoutAttributeLeft
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:_containerView
                                                  attribute:NSLayoutAttributeLeft
                                                 multiplier:1.0
                                                   constant:0.0];
        [_containerView addConstraint:constraint];

        constraint = [NSLayoutConstraint constraintWithItem:[_containedViewController view]
                                                  attribute:NSLayoutAttributeRight
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:_containerView
                                                  attribute:NSLayoutAttributeRight
                                                 multiplier:1.0
                                                   constant:0.0];
        [_containerView addConstraint:constraint];

        constraint = [NSLayoutConstraint constraintWithItem:[_containedViewController view]
                                                  attribute:NSLayoutAttributeBottom
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:_containerView
                                                  attribute:NSLayoutAttributeBottom
                                                 multiplier:1.0
                                                   constant:0.0];
        [_containerView addConstraint:constraint];
    }

    //NSLog(@"%@", table);
}

@end
