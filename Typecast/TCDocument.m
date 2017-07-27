//
//  TCDocument.m
//  Typecast
//
//  Created by David Schweinsberg on 1/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCDocument.h"
#import "TCTablesWindowController.h"
#import "Type_Designer-Swift.h"
#import "TCFontCollection.h"
#import "TCFont.h"

@implementation TCDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (void)makeWindowControllers
{
    // If this is a font collection, show the collection window, otherwise,
    // show the table window
    NSWindowController *controller;
    if ([[_fontCollection fonts] count] > 1)
        controller = [[TCCollectionWindowController alloc] initWithWindowNibName:@"CollectionWindow"];
    else
    {
        controller = [[TCTablesWindowController alloc] initWithWindowNibName:@"TablesWindow"];
        [(TCTablesWindowController *)controller setFont:[_fontCollection fonts][0]];
    }
    [self addWindowController:controller];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    BOOL suitcase = NO;
    if ([typeName isEqualToString:@"Font Suitcase"] ||
        [typeName isEqualToString:@"Datafork TrueType font"])
        suitcase = YES;

    _fontCollection = [[TCFontCollection alloc] initWithData:data isSuitcase:suitcase];
    if (_fontCollection == nil)
        return NO;

    // TEMPORARY
    //_font = [_fontCollection fonts][0];

    return YES;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    if ([typeName isEqualToString:@"Font Suitcase"])
    {
        // The font data is in the resource fork, so load that
        NSURL *resourceURL = [url URLByAppendingPathComponent:@"..namedfork/rsrc"];
        return [super readFromURL:resourceURL ofType:typeName error:outError];
    }
    else
        return [super readFromURL:url ofType:typeName error:outError];
}

@end
