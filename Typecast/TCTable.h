//
//  TCTable.h
//  Typecast
//
//  Created by David Schweinsberg on 1/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

// Baseline data [OpenType]
#define TCTable_BASE 0x42415345

// PostScript font program (compact font format) [PostScript]
#define TCTable_CFF  0x43464620

// Digital signature
#define TCTable_DSIG 0x44534947

// Embedded bitmap data
#define TCTable_EBDT 0x45424454

// Embedded bitmap location data
#define TCTable_EBLC 0x45424c43

// Embedded bitmap scaling data
#define TCTable_EBSC 0x45425343

// Glyph definition data [OpenType]
#define TCTable_GDEF 0x47444546

// Glyph positioning data [OpenType]
#define TCTable_GPOS 0x47504f53

// Glyph substitution data [OpenType]
#define TCTable_GSUB 0x47535542

// Justification data [OpenType]
#define TCTable_JSTF 0x4a535446

// Linear threshold table
#define TCTable_LTSH 0x4c545348

// Multiple master font metrics [PostScript]
#define TCTable_MMFX 0x4d4d4658

// Multiple master supplementary data [PostScript]
#define TCTable_MMSD 0x4d4d5344

// OS/2 and Windows specific metrics [r]
#define TCTable_OS_2 0x4f532f32

// PCL5
#define TCTable_PCLT 0x50434c54

// Vertical Device Metrics table
#define TCTable_VDMX 0x56444d58

// character to glyph mapping [r]
#define TCTable_cmap 0x636d6170

// Control Value Table
#define TCTable_cvt  0x63767420

// font program
#define TCTable_fpgm 0x6670676d

// Apple's font variations table [PostScript]
#define TCTable_fvar 0x66766172

// grid-fitting and scan conversion procedure (grayscale)
#define TCTable_gasp 0x67617370

// glyph data [r]
#define TCTable_glyf 0x676c7966

// horizontal device metrics
#define TCTable_hdmx 0x68646d78

// font header [r]
#define TCTable_head 0x68656164U

// horizontal header [r]
#define TCTable_hhea 0x68686561

// horizontal metrics [r]
#define TCTable_hmtx 0x686d7478

// kerning
#define TCTable_kern 0x6b65726e

// index to location [r]
#define TCTable_loca 0x6c6f6361

// maximum profile [r]
#define TCTable_maxp 0x6d617870

// naming table [r]
#define TCTable_name 0x6e616d65

// CVT Program
#define TCTable_prep 0x70726570

// PostScript information [r]
#define TCTable_post 0x706f7374

// Vertical Metrics header
#define TCTable_vhea 0x76686561

// Vertical Metrics
#define TCTable_vmtx 0x766d7478

@class TCDirectoryEntry;


@protocol TCTable

- (uint32_t)type;

- (TCDirectoryEntry *)directoryEntry;

@end

// A simple base implememtation of TCTable, for classes that don't need to be
// derived from any other base classes.
@interface TCTable : NSObject <TCTable>

@property (readonly) uint32_t type;
@property (strong) TCDirectoryEntry *directoryEntry;

@end
