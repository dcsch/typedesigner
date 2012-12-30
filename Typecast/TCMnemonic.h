//
//  TCMnemonic.h
//  Type Designer
//
//  Created by David Schweinsberg on 29/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TC_SVTCA 0x00  // [a]
#define TC_SPVTCA 0x02 // [a]
#define TC_SFVTCA 0x04 // [a]
#define TC_SPVTL 0x06  // [a]
#define TC_SFVTL 0x08  // [a]
#define TC_SPVFS 0x0A
#define TC_SFVFS 0x0B
#define TC_GPV 0x0C
#define TC_GFV 0x0D
#define TC_SFVTPV 0x0E
#define TC_ISECT 0x0F
#define TC_SRP0 0x10
#define TC_SRP1 0x11
#define TC_SRP2 0x12
#define TC_SZP0 0x13
#define TC_SZP1 0x14
#define TC_SZP2 0x15
#define TC_SZPS 0x16
#define TC_SLOOP 0x17
#define TC_RTG 0x18
#define TC_RTHG 0x19
#define TC_SMD 0x1A
#define TC_ELSE 0x1B
#define TC_JMPR 0x1C
#define TC_SCVTCI 0x1D
#define TC_SSWCI 0x1E
#define TC_SSW 0x1F
#define TC_DUP 0x20
#define TC_POP 0x21
#define TC_CLEAR 0x22
#define TC_SWAP 0x23
#define TC_DEPTH 0x24
#define TC_CINDEX 0x25
#define TC_MINDEX 0x26
#define TC_ALIGNPTS 0x27
#define TC_UTP 0x29
#define TC_LOOPCALL 0x2A
#define TC_CALL 0x2B
#define TC_FDEF 0x2C
#define TC_ENDF 0x2D
#define TC_MDAP 0x2E  // [a]
#define TC_IUP 0x30   // [a]
#define TC_SHP 0x32
#define TC_SHC 0x34   // [a]
#define TC_SHZ 0x36   // [a]
#define TC_SHPIX 0x38
#define TC_IP 0x39
#define TC_MSIRP 0x3A // [a]
#define TC_ALIGNRP 0x3C
#define TC_RTDG 0x3D
#define TC_MIAP 0x3E  // [a]
#define TC_NPUSHB 0x40
#define TC_NPUSHW 0x41
#define TC_WS 0x42
#define TC_RS 0x43
#define TC_WCVTP 0x44
#define TC_RCVT 0x45
#define TC_GC 0x46	// [a]
#define TC_SCFS 0x48
#define TC_MD 0x49	// [a]
#define TC_MPPEM 0x4B
#define TC_MPS 0x4C
#define TC_FLIPON 0x4D
#define TC_FLIPOFF 0x4E
#define TC_DEBUG 0x4F
#define TC_LT 0x50
#define TC_LTEQ 0x51
#define TC_GT 0x52
#define TC_GTEQ 0x53
#define TC_EQ 0x54
#define TC_NEQ 0x55
#define TC_ODD 0x56
#define TC_EVEN 0x57
#define TC_IF 0x58
#define TC_EIF 0x59
#define TC_AND 0x5A
#define TC_OR 0x5B
#define TC_NOT 0x5C
#define TC_DELTAP1 0x5D
#define TC_SDB 0x5E
#define TC_SDS 0x5F
#define TC_ADD 0x60
#define TC_SUB 0x61
#define TC_DIV 0x62
#define TC_MUL 0x63
#define TC_ABS 0x64
#define TC_NEG 0x65
#define TC_FLOOR 0x66
#define TC_CEILING 0x67
#define TC_ROUND 0x68  // [ab]
#define TC_NROUND 0x6C // [ab]
#define TC_WCVTF 0x70
#define TC_DELTAP2 0x71
#define TC_DELTAP3 0x72
#define TC_DELTAC1 0x73
#define TC_DELTAC2 0x74
#define TC_DELTAC3 0x75
#define TC_SROUND 0x76
#define TC_S45ROUND 0x77
#define TC_JROT 0x78
#define TC_JROF 0x79
#define TC_ROFF 0x7A
#define TC_RUTG 0x7C
#define TC_RDTG 0x7D
#define TC_SANGW 0x7E
#define TC_AA 0x7F
#define TC_FLIPPT 0x80
#define TC_FLIPRGON 0x81
#define TC_FLIPRGOFF 0x82
#define TC_SCANCTRL 0x85
#define TC_SDPVTL 0x86 // [a]
#define TC_GETINFO 0x88
#define TC_IDEF 0x89
#define TC_ROLL 0x8A
#define TC_MAX 0x8B
#define TC_MIN 0x8C
#define TC_SCANTYPE 0x8D
#define TC_INSTCTRL 0x8E
#define TC_PUSHB 0xB0 // [abc]
#define TC_PUSHW 0xB8 // [abc]
#define TC_MDRP 0xC0  // [abcde]
#define TC_MIRP 0xE0  // [abcde]

@interface TCMnemonic : NSObject

+ (NSString *)mnemonicForOpcode:(short)opcode;

//+ (NSString *)commentForOpcode:(short)opcode;

@end
