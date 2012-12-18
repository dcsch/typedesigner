//
//  TCTablesWindowController.m
//  Typecast
//
//  Created by David Schweinsberg on 2/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTablesWindowController.h"
#import "TCTable.h"

@interface TCTablesWindowController () <NSTableViewDelegate>
{
    NSViewController *_containerViewController;
}

@property (weak) IBOutlet NSView *containerView;
@property (weak) IBOutlet NSArrayController *tableArrayController;

@end

@implementation TCTablesWindowController

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
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - NSTableViewDelegate Methods

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    [[_containerViewController view] removeFromSuperview];

    TCTable *table = [[_tableArrayController selectedObjects] lastObject];
    if ([table type] == TCTable_glyf)
    {
        _containerViewController = [[NSViewController alloc] initWithNibName:@"GlyphListView" bundle:nil];
        [[_containerViewController view] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_containerView addSubview:[_containerViewController view]];

        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:[_containerViewController view]
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_containerView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:0.0];
        [_containerView addConstraint:constraint];

        constraint = [NSLayoutConstraint constraintWithItem:[_containerViewController view]
                                                  attribute:NSLayoutAttributeLeft
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:_containerView
                                                  attribute:NSLayoutAttributeLeft
                                                 multiplier:1.0
                                                   constant:0.0];
        [_containerView addConstraint:constraint];

        constraint = [NSLayoutConstraint constraintWithItem:[_containerViewController view]
                                                  attribute:NSLayoutAttributeRight
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:_containerView
                                                  attribute:NSLayoutAttributeRight
                                                 multiplier:1.0
                                                   constant:0.0];
        [_containerView addConstraint:constraint];

        constraint = [NSLayoutConstraint constraintWithItem:[_containerViewController view]
                                                  attribute:NSLayoutAttributeBottom
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:_containerView
                                                  attribute:NSLayoutAttributeBottom
                                                 multiplier:1.0
                                                   constant:0.0];
        [_containerView addConstraint:constraint];
    }
}

@end
