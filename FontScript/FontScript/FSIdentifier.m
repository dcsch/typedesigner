//
//  FSIdentifier.m
//  FontScript
//
//  Created by David Schweinsberg on 7/6/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSIdentifier.h"
#import "FontScriptFunctions.h"

static NSString *_RandomIdentifier(NSArray<NSString *> *existing, NSUInteger recursionDepth, NSError **error) {

  // UFO identifier implementation
  if (recursionDepth >= 50) {
    if (error) {
      NSString *desc = [NSString stringWithFormat:
                        FSLocalizedString(@"Failed to create a unique identifier"),
                        index];
      NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
      *error = [NSError errorWithDomain:FontScriptErrorDomain
                                   code:FontScriptErrorIdentifierNotUnique
                               userInfo:dict];
    }
    return nil;
  }
  const NSString *characters = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
  const NSUInteger identifierLength = 10;
  NSMutableString *identifier = [NSMutableString stringWithCapacity:identifierLength];
  for (NSUInteger i = 0; i < identifierLength; ++i) {
    NSRange range = NSMakeRange(rand() % characters.length, 1);
    [identifier appendString:[characters substringWithRange:range]];
  }
  if ([existing containsObject:identifier]) {
    return _RandomIdentifier(existing, recursionDepth + 1, error);
  } else {
    return identifier;
  }
}

@implementation FSIdentifier

// TODO: This doesn't allow existing identifiers to be loaded externally.
// We'll need this when loading existing fonts
+ (NSString *)RandomIdentifierWithError:(NSError **)error {
  static NSMutableArray<NSString *> *existing = nil;
  if (!existing) {
    existing = [[NSMutableArray alloc] init];
  }
  NSString *identifier = _RandomIdentifier(existing, 0, error);
  if (identifier) {
    [existing addObject:identifier];
  }
  return identifier;
}

@end
