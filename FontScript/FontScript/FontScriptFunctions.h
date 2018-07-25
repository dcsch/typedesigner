//
//  FontScriptFunctions.h
//  FontScript
//
//  Created by David Schweinsberg on 7/24/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSErrorDomain const FontScriptErrorDomain;

NSString *FSLocalizedString(NSString *string);

NS_ERROR_ENUM(FontScriptErrorDomain)
{
  FontScriptErrorUnknown = -1,
  FontScriptErrorGlyphNameInUse = -999,
  FontScriptErrorContourNotLocated = -1000,
  FontScriptErrorIndexOutOfRange = -1001,
  FontScriptErrorIdentifierNotUnique = -1002,
  FontScriptErrorGlyphNotFoundInLayer = -1003
};
