//
//  TCCharacterMapListViewController.m
//  Type Designer
//
//  Created by David Schweinsberg on 22/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCCharacterMapListViewController.h"
#import "TCCharacterMapWindowController.h"
#import "Type_Designer-Swift.h"

@interface TCCharacterMapListViewController ()

@end

@implementation TCCharacterMapListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)showCharacterMaps:(NSArray *)maps
{
    TCCharacterMapWindowController *windowController = [[TCCharacterMapWindowController alloc] initWithWindowNibName:@"CharacterMapWindow"];
    [[self document] addWindowController:windowController];
    [windowController setCmapIndexEntry:[maps lastObject]];
    [windowController showWindow:self];
}

@end
