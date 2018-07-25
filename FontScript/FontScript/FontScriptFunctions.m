//
//  FontScriptFunctions.m
//  FontScript
//
//  Created by David Schweinsberg on 7/24/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FontScriptFunctions.h"

NSString *FSLocalizedString(NSString *string) {
  return
  NSLocalizedStringFromTableInBundle(string,
                                     nil,
                                     [NSBundle bundleWithIdentifier:@"com.typista.FontScript"],
                                     nil);
}
