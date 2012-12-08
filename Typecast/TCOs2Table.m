//
//  TCOs2Table.m
//  Typecast
//
//  Created by David Schweinsberg on 8/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCOs2Table.h"
#import "TCDirectoryEntry.h"
#import "TCDataInput.h"


@implementation TCPanose

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        const uint8_t *panose = [data bytes];
        _bFamilyType = panose[0];
        _bSerifStyle = panose[1];
        _bWeight = panose[2];
        _bProportion = panose[3];
        _bContrast = panose[4];
        _bStrokeVariation = panose[5];
        _bArmStyle = panose[6];
        _bLetterform = panose[7];
        _bMidline = panose[8];
        _bXHeight = panose[9];
    }
    return self;
}

- (NSString *)description
{
    return [[NSString alloc] initWithFormat:
            @"%d %d %d %d %d %d %d %d %d %d",
            _bFamilyType,
            _bSerifStyle,
            _bWeight,
            _bProportion,
            _bContrast,
            _bStrokeVariation,
            _bArmStyle,
            _bLetterform,
            _bMidline,
            _bXHeight];
}

@end


@implementation TCOs2Table

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry
{
    self = [super init];
    if (self)
    {
        self.directoryEntry = [entry copy];
        _version = [dataInput readUnsignedShort];
        _xAvgCharWidth = [dataInput readShort];
        _usWeightClass = [dataInput readUnsignedShort];
        _usWidthClass = [dataInput readUnsignedShort];
        _fsType = [dataInput readShort];
        _ySubscriptXSize = [dataInput readShort];
        _ySubscriptYSize = [dataInput readShort];
        _ySubscriptXOffset = [dataInput readShort];
        _ySubscriptYOffset = [dataInput readShort];
        _ySuperscriptXSize = [dataInput readShort];
        _ySuperscriptYSize = [dataInput readShort];
        _ySuperscriptXOffset = [dataInput readShort];
        _ySuperscriptYOffset = [dataInput readShort];
        _yStrikeoutSize = [dataInput readShort];
        _yStrikeoutPosition = [dataInput readShort];
        _sFamilyClass = [dataInput readShort];
        _panose = [[TCPanose alloc] initWithData:[dataInput readDataWithLength:10]];
        _ulUnicodeRange1 = [dataInput readInt];
        _ulUnicodeRange2 = [dataInput readInt];
        _ulUnicodeRange3 = [dataInput readInt];
        _ulUnicodeRange4 = [dataInput readInt];
        _achVendorID = [dataInput readInt];
        _fsSelection = [dataInput readShort];
        _usFirstCharIndex = [dataInput readUnsignedShort];
        _usLastCharIndex = [dataInput readUnsignedShort];
        _sTypoAscender = [dataInput readShort];
        _sTypoDescender = [dataInput readShort];
        _sTypoLineGap = [dataInput readShort];
        _usWinAscent = [dataInput readUnsignedShort];
        _usWinDescent = [dataInput readUnsignedShort];
        _ulCodePageRange1 = [dataInput readInt];
        _ulCodePageRange2 = [dataInput readInt];

        // OpenType 1.3
        if (_version == 2) {
            _sxHeight = [dataInput readShort];
            _sCapHeight = [dataInput readShort];
            _usDefaultChar = [dataInput readUnsignedShort];
            _usBreakChar = [dataInput readUnsignedShort];
            _usMaxContext = [dataInput readUnsignedShort];
        }
    }
    return self;
}

- (uint32_t)type
{
    return TCTable_OS_2;
}

- (NSString *)description
{
    NSString *str = [[NSString alloc] initWithFormat:
                     @"'OS/2' Table - OS/2 and Windows Metrics\n---------------------------------------"
                     @"\n  'OS/2' version:      %d"  // append(_version)
                     @"\n  xAvgCharWidth:       %d"  // append(_xAvgCharWidth)
                     @"\n  usWeightClass:       %d"  // append(_usWeightClass)
                     @"\n  usWidthClass:        %d"  // append(_usWidthClass)
                     @"\n  fsType:              0x%X"  // append(Integer.toHexString(_fsType  // toUpperCase())
                     @"\n  ySubscriptXSize:     %d"  // append(_ySubscriptXSize)
                     @"\n  ySubscriptYSize:     %d"  // append(_ySubscriptYSize)
                     @"\n  ySubscriptXOffset:   %d"  // append(_ySubscriptXOffset)
                     @"\n  ySubscriptYOffset:   %d"  // append(_ySubscriptYOffset)
                     @"\n  ySuperscriptXSize:   %d"  // append(_ySuperscriptXSize)
                     @"\n  ySuperscriptYSize:   %d"  // append(_ySuperscriptYSize)
                     @"\n  ySuperscriptXOffset: %d"  // append(_ySuperscriptXOffset)
                     @"\n  ySuperscriptYOffset: %d"  // append(_ySuperscriptYOffset)
                     @"\n  yStrikeoutSize:      %d"  // append(_yStrikeoutSize)
                     @"\n  yStrikeoutPosition:  %d"  // append(_yStrikeoutPosition)
                     @"\n  sFamilyClass:        %d"  // append(_sFamilyClass>>8)
                     @"    subclass = %d"  // append(_sFamilyClass&0xff)
                     @"\n  PANOSE:              %@"  // append(_panose.toString())
                     @"\n  Unicode Range 1( Bits 0 - 31 ): %X"  // append(Integer.toHexString(_ulUnicodeRange1  // toUpperCase())
                     @"\n  Unicode Range 2( Bits 32- 63 ): %X"  // append(Integer.toHexString(_ulUnicodeRange2  // toUpperCase())
                     @"\n  Unicode Range 3( Bits 64- 95 ): %X"  // append(Integer.toHexString(_ulUnicodeRange3  // toUpperCase())
                     @"\n  Unicode Range 4( Bits 96-127 ): %X"  // append(Integer.toHexString(_ulUnicodeRange4  // toUpperCase())
                     @"\n  achVendID:           '%c%c%c%c"  // append(getVendorIDAsString())
                     @"'\n  fsSelection:         0x%X"  // append(Integer.toHexString(_fsSelection  // toUpperCase())
                     @"\n  usFirstCharIndex:    0x%X"  // append(Integer.toHexString(_usFirstCharIndex  // toUpperCase())
                     @"\n  usLastCharIndex:     0x%X"  // append(Integer.toHexString(_usLastCharIndex  // toUpperCase())
                     @"\n  sTypoAscender:       %d"  // append(_sTypoAscender)
                     @"\n  sTypoDescender:      %d"  // append(_sTypoDescender)
                     @"\n  sTypoLineGap:        %d"  // append(_sTypoLineGap)
                     @"\n  usWinAscent:         %d"  // append(_usWinAscent)
                     @"\n  usWinDescent:        %d"  // append(_usWinDescent)
                     @"\n  CodePage Range 1( Bits 0 - 31 ): %X"  // append(Integer.toHexString(_ulCodePageRange1  // toUpperCase())
                     @"\n  CodePage Range 2( Bits 32- 63 ): %X",  // append(Integer.toHexString(_ulCodePageRange2  // toUpperCase())
                     _version,
                     _xAvgCharWidth,
                     _usWeightClass,
                     _usWidthClass,
                     _fsType,
                     _ySubscriptXSize,
                     _ySubscriptYSize,
                     _ySubscriptXOffset,
                     _ySubscriptYOffset,
                     _ySuperscriptXSize,
                     _ySuperscriptYSize,
                     _ySuperscriptXOffset,
                     _ySuperscriptYOffset,
                     _yStrikeoutSize,
                     _yStrikeoutPosition,
                     _sFamilyClass >> 8,
                     _sFamilyClass & 0xff,
                     _panose,
                     _ulUnicodeRange1,
                     _ulUnicodeRange2,
                     _ulUnicodeRange3,
                     _ulUnicodeRange4,
                     (_achVendorID >> 24) & 0xff,
                     (_achVendorID >> 16) & 0xff,
                     (_achVendorID >> 8) & 0xff,
                     _achVendorID & 0xff,
                     _fsSelection,
                     _usFirstCharIndex,
                     _usLastCharIndex,
                     _sTypoAscender,
                     _sTypoDescender,
                     _sTypoLineGap,
                     _usWinAscent,
                     _usWinDescent,
                     _ulCodePageRange1,
                     _ulCodePageRange2];
    return str;
}

@end
