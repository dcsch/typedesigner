//
//  FSFontPrivate.h
//  FontScript
//
//  Created by David Schweinsberg on 7/24/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSFont.h"

@interface FSFont ()
{
  NSMutableArray<FSLayer *> *_layers;
}

@property(readwrite) NSURL *url;

@end
