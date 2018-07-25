//
//  FSScript.m
//  FontScript
//
//  Created by David Schweinsberg on 5/25/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSScript.h"
#import "FSFont.h"

#if TARGET_OS_OSX
#import "FSPythonObjects.h"
#endif

NSErrorDomain const FontScriptErrorDomain = @"FontScriptErrorDomain";

@interface FSScript ()
{
  NSMutableArray<FSFont *> *_fonts;
}

@end

static __weak FSScript *script;

@implementation FSScript

+ (FSScript *)Shared {
  return script;
}

- (nonnull instancetype)initWithPath:(NSString *)path {
  self = [super init];
  if (self) {
    _fonts = [[NSMutableArray alloc] init];

#if TARGET_OS_OSX
    if (!Py_IsInitialized()) {
      wchar_t *p = Py_GetPath();
      size_t len = wcslen(p) * sizeof(wchar_t);
      NSString *pythonPath = [[NSString alloc] initWithBytes:p length:len encoding:NSUTF32LittleEndianStringEncoding];
      if (![pythonPath containsString:path]) {
        pythonPath = [pythonPath stringByAppendingFormat:@":%@", path];
        NSLog(@"Adding to PYTHONPATH: %@", pythonPath);
        Py_SetPath((const wchar_t *)[pythonPath cStringUsingEncoding:NSUTF32LittleEndianStringEncoding]);
        PyImport_AppendInittab("fontParts", PyInit_fontParts);
      }
    Py_Initialize();
    }
#endif
    script = self;
  }
  return self;
}

- (void)dealloc {
//  Py_FinalizeEx();
}
- (FSFont *)newFontWithFamilyName:(NSString *)familyName
                        styleName:(NSString *)styleName
                    showInterface:(BOOL)showInterface {
  FSFont *font = [[FSFont alloc] initWithFamilyName:familyName styleName:styleName showInterface:showInterface];
  [_fonts addObject:font];
  return font;
}

@end
