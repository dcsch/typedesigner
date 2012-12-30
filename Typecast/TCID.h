//
//  TCID.h
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

// Platform IDs
extern const short TCPlatformUnicode;
extern const short TCPlatformMacintosh;
extern const short TCPlatformISO;
extern const short TCPlatformMicrosoft;

// Name IDs
extern const short TCNameCopyrightNotice;
extern const short TCNameFontFamilyName;
extern const short TCNameFontSubfamilyName;
extern const short TCNameUniqueFontIdentifier;
extern const short TCNameFullFontName;
extern const short TCNameVersionString;
extern const short TCNamePostscriptName;
extern const short TCNameTrademark;
extern const short TCNameManufacturerName;
extern const short TCNameDesigner;
extern const short TCNameDescription;
extern const short TCNameURLVendor;
extern const short TCNameURLDesigner;
extern const short TCNameLicenseDescription;
extern const short TCNameLicenseInfoURL;
extern const short TCNamePreferredFamily;
extern const short TCNamePreferredSubfamily;
extern const short TCNameCompatibleFull;
extern const short TCNameSampleText;
extern const short TCNamePostScriptCIDFindfontName;

@interface TCID : NSObject

+ (NSString *)platformNameForID:(short)platformId;

+ (NSString *)encodingNameForPlatformID:(short)platformId encodingID:(short)encodingId;

+ (NSString *)nameNameForID:(short)nameId;

@end
