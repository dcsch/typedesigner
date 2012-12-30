//
//  TCID.m
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCID.h"

// Platform IDs
const short TCPlatformUnicode = 0;
const short TCPlatformMacintosh = 1;
const short TCPlatformISO = 2;
const short TCPlatformMicrosoft = 3;

// Unicode Encoding IDs
const short TCEncodingUnicode10Semantics = 0;
const short TCEncodingUnicode11Semantics = 1;
const short TCEncodingISO10646Semantics = 2;
const short TCEncodingUnicode20Semantics = 3;

// Microsoft Encoding IDs
//    const short TCEncodingUndefined = 0;
//    const short TCEncodingUGL = 1;
const short TCEncodingSymbol = 0;
const short TCEncodingUnicode = 1;
const short TCEncodingShiftJIS = 2;
const short TCEncodingPRC = 3;
const short TCEncodingBig5 = 4;
const short TCEncodingWansung = 5;
const short TCEncodingJohab = 6;
const short TCEncodingUCS4 = 10;

// Macintosh Encoding IDs
const short TCEncodingRoman = 0;
const short TCEncodingJapanese = 1;
const short TCEncodingChinese = 2;
const short TCEncodingKorean = 3;
const short TCEncodingArabic = 4;
const short TCEncodingHebrew = 5;
const short TCEncodingGreek = 6;
const short TCEncodingRussian = 7;
const short TCEncodingRSymbol = 8;
const short TCEncodingDevanagari = 9;
const short TCEncodingGurmukhi = 10;
const short TCEncodingGujarati = 11;
const short TCEncodingOriya = 12;
const short TCEncodingBengali = 13;
const short TCEncodingTamil = 14;
const short TCEncodingTelugu = 15;
const short TCEncodingKannada = 16;
const short TCEncodingMalayalam = 17;
const short TCEncodingSinhalese = 18;
const short TCEncodingBurmese = 19;
const short TCEncodingKhmer = 20;
const short TCEncodingThai = 21;
const short TCEncodingLaotian = 22;
const short TCEncodingGeorgian = 23;
const short TCEncodingArmenian = 24;
const short TCEncodingMaldivian = 25;
const short TCEncodingTibetan = 26;
const short TCEncodingMongolian = 27;
const short TCEncodingGeez = 28;
const short TCEncodingSlavic = 29;
const short TCEncodingVietnamese = 30;
const short TCEncodingSindhi = 31;
const short TCEncodingUninterp = 32;

// ISO Encoding IDs
const short TCEncodingASCII = 0;
const short TCEncodingISO10646 = 1;
const short TCEncodingISO8859_1 = 2;

@implementation TCID

//    // Microsoft Language IDs
//    const short languageSQI = 0x041c;
//    const short languageEUQ = 0x042d;
//    const short languageBEL = 0x0423;
//    const short languageBGR = 0x0402;
//    const short languageCAT = 0x0403;
//    const short languageSHL = 0x041a;
//    const short languageCSY = 0x0405;
//    const short languageDAN = 0x0406;
//    const short languageNLD = 0x0413;
//    const short languageNLB = 0x0813;
//    const short languageENU = 0x0409;
//    const short languageENG = 0x0809;
//    const short languageENA = 0x0c09;
//    const short languageENC = 0x1009;
//    const short languageENZ = 0x1409;
//    const short languageENI = 0x1809;
//    const short languageETI = 0x0425;
//    const short languageFIN = 0x040b;
//    const short languageFRA = 0x040c;
//    const short languageFRB = 0x080c;
//    const short languageFRC = 0x0c0c;
//    const short languageFRS = 0x100c;
//    const short languageFRL = 0x140c;
//    const short languageDEU = 0x0407;
//    const short languageDES = 0x0807;
//    const short languageDEA = 0x0c07;
//    const short languageDEL = 0x1007;
//    const short languageDEC = 0x1407;
//    const short languageELL = 0x0408;
//    const short languageHUN = 0x040e;
//    const short languageISL = 0x040f;
//    const short languageITA = 0x0410;
//    const short languageITS = 0x0810;
//    const short languageLVI = 0x0426;
//    const short languageLTH = 0x0427;
//    const short languageNOR = 0x0414;
//    const short languageNON = 0x0814;
//    const short languagePLK = 0x0415;
//    const short languagePTB = 0x0416;
//    const short languagePTG = 0x0816;
//    const short languageROM = 0x0418;
//    const short languageRUS = 0x0419;
//    const short languageSKY = 0x041b;
//    const short languageSLV = 0x0424;
//    const short languageESP = 0x040a;
//    const short languageESM = 0x080a;
//    const short languageESN = 0x0c0a;
//    const short languageSVE = 0x041d;
//    const short languageTRK = 0x041f;
//    const short languageUKR = 0x0422;
//
//    // Macintosh Language IDs
//    const short languageEnglish = 0;
//    const short languageFrench = 1;
//    const short languageGerman = 2;
//    const short languageItalian = 3;
//    const short languageDutch = 4;
//    const short languageSwedish = 5;
//    const short languageSpanish = 6;
//    const short languageDanish = 7;
//    const short languagePortuguese = 8;
//    const short languageNorwegian = 9;
//    const short languageHebrew = 10;
//    const short languageJapanese = 11;
//    const short languageArabic = 12;
//    const short languageFinnish = 13;
//    const short languageGreek = 14;
//    const short languageIcelandic = 15;
//    const short languageMaltese = 16;
//    const short languageTurkish = 17;
//    const short languageYugoslavian = 18;
//    const short languageChinese = 19;
//    const short languageUrdu = 20;
//    const short languageHindi = 21;
//    const short languageThai = 22;

// Name IDs
const short TCNameCopyrightNotice = 0;
const short TCNameFontFamilyName = 1;
const short TCNameFontSubfamilyName = 2;
const short TCNameUniqueFontIdentifier = 3;
const short TCNameFullFontName = 4;
const short TCNameVersionString = 5;
const short TCNamePostscriptName = 6;
const short TCNameTrademark = 7;
const short TCNameManufacturerName = 8;
const short TCNameDesigner = 9;
const short TCNameDescription = 10;
const short TCNameURLVendor = 11;
const short TCNameURLDesigner = 12;
const short TCNameLicenseDescription = 13;
const short TCNameLicenseInfoURL = 14;
const short TCNamePreferredFamily = 16;
const short TCNamePreferredSubfamily = 17;
const short TCNameCompatibleFull = 18;
const short TCNameSampleText = 19;
const short TCNamePostScriptCIDFindfontName = 20;

+ (NSString *)platformNameForID:(short)platformId
{
    switch (platformId)
    {
        case TCPlatformUnicode:   return @"Unicode";
        case TCPlatformMacintosh: return @"Macintosh";
        case TCPlatformISO:       return @"ISO";
        case TCPlatformMicrosoft: return @"Microsoft";
        default:                  return @"Custom";
    }
}

+ (NSString *)encodingNameForPlatformID:(short)platformId encodingID:(short)encodingId
{
    if (platformId == TCPlatformUnicode)
    {
        // Unicode specific encodings
        switch (encodingId)
        {
            case TCEncodingUnicode10Semantics: return @"Unicode 1.0 semantics";
            case TCEncodingUnicode11Semantics: return @"Unicode 1.1 semantics";
            case TCEncodingISO10646Semantics:  return @"ISO 10646:1993 semantics";
            case TCEncodingUnicode20Semantics: return @"Unicode 2.0 and onwards semantics";
            default:                           return @"";
        }
    }
    else if (platformId == TCPlatformMacintosh)
    {
        // Macintosh specific encodings
        switch (encodingId)
        {
            case TCEncodingRoman:      return @"Roman";
            case TCEncodingJapanese:   return @"Japanese";
            case TCEncodingChinese:    return @"Chinese";
            case TCEncodingKorean:     return @"Korean";
            case TCEncodingArabic:     return @"Arabic";
            case TCEncodingHebrew:     return @"Hebrew";
            case TCEncodingGreek:      return @"Greek";
            case TCEncodingRussian:    return @"Russian";
            case TCEncodingRSymbol:    return @"RSymbol";
            case TCEncodingDevanagari: return @"Devanagari";
            case TCEncodingGurmukhi:   return @"Gurmukhi";
            case TCEncodingGujarati:   return @"Gujarati";
            case TCEncodingOriya:      return @"Oriya";
            case TCEncodingBengali:    return @"Bengali";
            case TCEncodingTamil:      return @"Tamil";
            case TCEncodingTelugu:     return @"Telugu";
            case TCEncodingKannada:    return @"Kannada";
            case TCEncodingMalayalam:  return @"Malayalam";
            case TCEncodingSinhalese:  return @"Sinhalese";
            case TCEncodingBurmese:    return @"Burmese";
            case TCEncodingKhmer:      return @"Khmer";
            case TCEncodingThai:       return @"Thai";
            case TCEncodingLaotian:    return @"Laotian";
            case TCEncodingGeorgian:   return @"Georgian";
            case TCEncodingArmenian:   return @"Armenian";
            case TCEncodingMaldivian:  return @"Maldivian";
            case TCEncodingTibetan:    return @"Tibetan";
            case TCEncodingMongolian:  return @"Mongolian";
            case TCEncodingGeez:       return @"Geez";
            case TCEncodingSlavic:     return @"Slavic";
            case TCEncodingVietnamese: return @"Vietnamese";
            case TCEncodingSindhi:     return @"Sindhi";
            case TCEncodingUninterp:   return @"Uninterpreted";
            default:                   return @"";
        }
    }
    else if (platformId == TCPlatformISO)
    {
        // ISO specific encodings
        switch (encodingId)
        {
            case TCEncodingASCII:     return @"7-bit ASCII";
            case TCEncodingISO10646:  return @"ISO 10646";
            case TCEncodingISO8859_1: return @"ISO 8859-1";
            default:                  return @"";
        }
    }
    else if (platformId == TCPlatformMicrosoft)
    {
        // Windows specific encodings
        switch (encodingId)
        {
            case TCEncodingSymbol:   return @"Symbol";
            case TCEncodingUnicode:  return @"Unicode";
            case TCEncodingShiftJIS: return @"ShiftJIS";
            case TCEncodingPRC:      return @"PRC";
            case TCEncodingBig5:     return @"Big5";
            case TCEncodingWansung:  return @"Wansung";
            case TCEncodingJohab:    return @"Johab";
            case 7:                  return @"Reserved";
            case 8:                  return @"Reserved";
            case 9:                  return @"Reserved";
            case TCEncodingUCS4:     return @"UCS-4";
            default:                 return @"";
        }
    }
    return @"";
}

//    public static String getLanguageName(short platformId, short languageId) {
//
//        if (platformId == platformMacintosh) {
//            switch (languageId) {
//                case languageEnglish: return "English";
//                case languageFrench: return "French";
//                case languageGerman:  return "German";
//                case languageItalian: return "Italian";
//                case languageDutch: return "Dutch";
//                case languageSwedish: return "Swedish";
//                case languageSpanish: return "Spanish";
//                case languageDanish: return "Danish";
//                case languagePortuguese: return "Portuguese";
//                case languageNorwegian: return "Norwegian";
//                case languageHebrew: return "Hebrew";
//                case languageJapanese: return "Japanese";
//                case languageArabic: return "Arabic";
//                case languageFinnish: return "Finnish";
//                case languageGreek: return "Greek";
//                case languageIcelandic: return "Icelandic";
//                case languageMaltese: return "Maltese";
//                case languageTurkish: return "Turkish";
//                case languageYugoslavian: return "Yugoslavian";
//                case languageChinese: return "Chinese";
//                case languageUrdu: return "Urdu";
//                case languageHindi: return "Hindi";
//                case languageThai: return "Thai";
//                default: return "";
//            }
//        } else if (platformId == platformMicrosoft) {
//            switch (languageId) {
//                case languageSQI: return "Albanian (Albania)";
//                case languageEUQ: return "Basque (Basque)";
//                case languageBEL: return "Byelorussian (Byelorussia)";
//                case languageBGR: return "Bulgarian (Bulgaria)";
//                case languageCAT: return "Catalan (Catalan)";
//                case languageSHL: return "Croatian (Croatian)";
//                case languageCSY: return "Czech (Czech)";
//                case languageDAN: return "Danish (Danish)";
//                case languageNLD: return "Dutch (Dutch (Standard))";
//                case languageNLB: return "Dutch (Belgian (Flemish))";
//                case languageENU: return "English (American)";
//                case languageENG: return "English (British)";
//                case languageENA: return "English (Australian)";
//                case languageENC: return "English (Canadian)";
//                case languageENZ: return "English (New Zealand)";
//                case languageENI: return "English (Ireland)";
//                case languageETI: return "Estonian (Estonia)";
//                case languageFIN: return "Finnish (Finnish)";
//                case languageFRA: return "French (French (Standard))";
//                case languageFRB: return "French (Belgian)";
//                case languageFRC: return "French (Canadian)";
//                case languageFRS: return "French (Swiss)";
//                case languageFRL: return "French (Luxembourg)";
//                case languageDEU: return "German (German (Standard))";
//                case languageDES: return "German (Swiss)";
//                case languageDEA: return "German (Austrian)";
//                case languageDEL: return "German (Luxembourg)";
//                case languageDEC: return "German (Liechtenstein)";
//                case languageELL: return "Greek (Greek)";
//                case languageHUN: return "Hungarian (Hungarian)";
//                case languageISL: return "Icelandic (Icelandic)";
//                case languageITA: return "Italian (Italian (Standard))";
//                case languageITS: return "Italian (Swiss)";
//                case languageLVI: return "Latvian (Latvia)";
//                case languageLTH: return "Lithuanian (Lithuania)";
//                case languageNOR: return "Norwegian (Norwegian (Bokmal))";
//                case languageNON: return "Norwegian (Norwegian (Nynorsk))";
//                case languagePLK: return "Polish (Polish)";
//                case languagePTB: return "Portuguese (Portuguese (Brazilian))";
//                case languagePTG: return "Portuguese (Portuguese (Standard))";
//                case languageROM: return "Romanian (Romania)";
//                case languageRUS: return "Russian (Russian)";
//                case languageSKY: return "Slovak (Slovak)";
//                case languageSLV: return "Slovenian (Slovenia)";
//                case languageESP: return "Spanish (Spanish (Traditional Sort))";
//                case languageESM: return "Spanish (Mexican)";
//                case languageESN: return "Spanish (Spanish (Modern Sort))";
//                case languageSVE: return "Swedish (Swedish)";
//                case languageTRK: return "Turkish (Turkish)";
//                case languageUKR: return "Ukrainian (Ukraine)";
//                default: return "";
//            }
//        }
//        return "";
//    }

+ (NSString *)nameNameForID:(short)nameId
{
    switch (nameId)
    {
        case TCNameCopyrightNotice: return @"Copyright notice";
        case TCNameFontFamilyName: return @"Font Family name";
        case TCNameFontSubfamilyName: return @"Font Subfamily name";
        case TCNameUniqueFontIdentifier: return @"Unique font identifier";
        case TCNameFullFontName: return @"Full font name";
        case TCNameVersionString: return @"Version string";
        case TCNamePostscriptName: return @"Postscript name";
        case TCNameTrademark: return @"Trademark";
        case TCNameManufacturerName: return @"Manufacturer Name";
        case TCNameDesigner: return @"Designer";
        case TCNameDescription: return @"Description";
        case TCNameURLVendor: return @"URL Vendor";
        case TCNameURLDesigner: return @"URL Designer";
        case TCNameLicenseDescription: return @"License Description";
        case TCNameLicenseInfoURL: return @"License Info URL";
        case TCNamePreferredFamily: return @"Preferred Family";
        case TCNamePreferredSubfamily: return @"Preferred Subfamily";
        case TCNameCompatibleFull: return @"Compatible Full";
        case TCNameSampleText: return @"Sample text";
        case TCNamePostScriptCIDFindfontName: return @"PostScript CID findfont name";
        default: return @"";
    }
}

@end
