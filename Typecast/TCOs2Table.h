//
//  TCOs2Table.h
//  Typecast
//
//  Created by David Schweinsberg on 8/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCTable.h"

@class TCDirectoryEntry;
@class TCDataInput;


@interface TCPanose : NSObject

@property uint8_t bFamilyType;
@property uint8_t bSerifStyle;
@property uint8_t bWeight;
@property uint8_t bProportion;
@property uint8_t bContrast;
@property uint8_t bStrokeVariation;
@property uint8_t bArmStyle;
@property uint8_t bLetterform;
@property uint8_t bMidline;
@property uint8_t bXHeight;

- (id)initWithData:(NSData *)data;

@end


@interface TCOs2Table : TCTable

@property uint16_t version;
@property int16_t xAvgCharWidth;
@property uint16_t usWeightClass;
@property uint16_t usWidthClass;
@property int16_t fsType;
@property int16_t ySubscriptXSize;
@property int16_t ySubscriptYSize;
@property int16_t ySubscriptXOffset;
@property int16_t ySubscriptYOffset;
@property int16_t ySuperscriptXSize;
@property int16_t ySuperscriptYSize;
@property int16_t ySuperscriptXOffset;
@property int16_t ySuperscriptYOffset;
@property int16_t yStrikeoutSize;
@property int16_t yStrikeoutPosition;
@property int16_t sFamilyClass;
@property (strong) TCPanose *panose;
@property int32_t ulUnicodeRange1;
@property int32_t ulUnicodeRange2;
@property int32_t ulUnicodeRange3;
@property int32_t ulUnicodeRange4;
@property int32_t achVendorID;
@property int16_t fsSelection;
@property uint16_t usFirstCharIndex;
@property uint16_t usLastCharIndex;
@property int16_t sTypoAscender;
@property int16_t sTypoDescender;
@property int16_t sTypoLineGap;
@property uint16_t usWinAscent;
@property uint16_t usWinDescent;
@property int32_t ulCodePageRange1;
@property int32_t ulCodePageRange2;
@property int16_t sxHeight;
@property int16_t sCapHeight;
@property uint16_t usDefaultChar;
@property uint16_t usBreakChar;
@property uint16_t usMaxContext;

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry;

@end
