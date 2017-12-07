//
//  TCMnemonic.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/7/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

enum TCMnemonic: UInt8 {
  case SVTCA = 0x00  // [a]
  case SPVTCA = 0x02 // [a]
  case SFVTCA = 0x04 // [a]
  case SPVTL = 0x06  // [a]
  case SFVTL = 0x08  // [a]
  case SPVFS = 0x0A
  case SFVFS = 0x0B
  case GPV = 0x0C
  case GFV = 0x0D
  case SFVTPV = 0x0E
  case ISECT = 0x0F
  case SRP0 = 0x10
  case SRP1 = 0x11
  case SRP2 = 0x12
  case SZP0 = 0x13
  case SZP1 = 0x14
  case SZP2 = 0x15
  case SZPS = 0x16
  case SLOOP = 0x17
  case RTG = 0x18
  case RTHG = 0x19
  case SMD = 0x1A
  case ELSE = 0x1B
  case JMPR = 0x1C
  case SCVTCI = 0x1D
  case SSWCI = 0x1E
  case SSW = 0x1F
  case DUP = 0x20
  case POP = 0x21
  case CLEAR = 0x22
  case SWAP = 0x23
  case DEPTH = 0x24
  case CINDEX = 0x25
  case MINDEX = 0x26
  case ALIGNPTS = 0x27
  case UTP = 0x29
  case LOOPCALL = 0x2A
  case CALL = 0x2B
  case FDEF = 0x2C
  case ENDF = 0x2D
  case MDAP = 0x2E  // [a]
  case IUP = 0x30   // [a]
  case SHP = 0x32
  case SHC = 0x34   // [a]
  case SHZ = 0x36   // [a]
  case SHPIX = 0x38
  case IP = 0x39
  case MSIRP = 0x3A // [a]
  case ALIGNRP = 0x3C
  case RTDG = 0x3D
  case MIAP = 0x3E  // [a]
  case NPUSHB = 0x40
  case NPUSHW = 0x41
  case WS = 0x42
  case RS = 0x43
  case WCVTP = 0x44
  case RCVT = 0x45
  case GC = 0x46	// [a]
  case SCFS = 0x48
  case MD = 0x49	// [a]
  case MPPEM = 0x4B
  case MPS = 0x4C
  case FLIPON = 0x4D
  case FLIPOFF = 0x4E
  case DEBUG = 0x4F
  case LT = 0x50
  case LTEQ = 0x51
  case GT = 0x52
  case GTEQ = 0x53
  case EQ = 0x54
  case NEQ = 0x55
  case ODD = 0x56
  case EVEN = 0x57
  case IF = 0x58
  case EIF = 0x59
  case AND = 0x5A
  case OR = 0x5B
  case NOT = 0x5C
  case DELTAP1 = 0x5D
  case SDB = 0x5E
  case SDS = 0x5F
  case ADD = 0x60
  case SUB = 0x61
  case DIV = 0x62
  case MUL = 0x63
  case ABS = 0x64
  case NEG = 0x65
  case FLOOR = 0x66
  case CEILING = 0x67
  case ROUND = 0x68  // [ab]
  case NROUND = 0x6C // [ab]
  case WCVTF = 0x70
  case DELTAP2 = 0x71
  case DELTAP3 = 0x72
  case DELTAC1 = 0x73
  case DELTAC2 = 0x74
  case DELTAC3 = 0x75
  case SROUND = 0x76
  case S45ROUND = 0x77
  case JROT = 0x78
  case JROF = 0x79
  case ROFF = 0x7A
  case RUTG = 0x7C
  case RDTG = 0x7D
  case SANGW = 0x7E
  case AA = 0x7F
  case FLIPPT = 0x80
  case FLIPRGON = 0x81
  case FLIPRGOFF = 0x82
  case SCANCTRL = 0x85
  case SDPVTL = 0x86 // [a]
  case GETINFO = 0x88
  case IDEF = 0x89
  case ROLL = 0x8A
  case MAX = 0x8B
  case MIN = 0x8C
  case SCANTYPE = 0x8D
  case INSTCTRL = 0x8E
  case PUSHB = 0xB0 // [abc]
  case PUSHW = 0xB8 // [abc]
  case MDRP = 0xC0  // [abcde]
  case MIRP = 0xE0  // [abcde]

  /**
   * Gets the mnemonic text for the specified opcode
   * - parameters:
   *   - opcode: The opcode for which the mnemonic is required
   * - returns: The mnemonic, with a description
   */
  static func mnemonic(opcode: UInt8) -> String {
    if opcode >= MIRP.rawValue {
      return String(format: "MIRP[%@%@%@%d]",
                    ((opcode & 16) == 0 ? "nrp0," : "srp0,"),
                    ((opcode & 8) == 0 ? "nmd," : "md,"),
                    ((opcode & 4) == 0 ? "nrd," : "rd,"),
                    (opcode & 3))
    } else if opcode >= MDRP.rawValue {
      return String(format: "MDRP[%@%@%@%d]",
                    ((opcode & 16) == 0 ? "nrp0," : "srp0,"),
                    ((opcode & 8) == 0 ? "nmd," : "md,"),
                    ((opcode & 4) == 0 ? "nrd," : "rd,"),
                    (opcode & 3))
    } else if opcode >= PUSHW.rawValue {
      return String(format: "PUSHW[%d]", ((opcode & 7) + 1))
    } else if opcode >= PUSHB.rawValue {
      return String(format: "PUSHB[%d]", ((opcode & 7) + 1))
    } else if opcode >= INSTCTRL.rawValue {
      return "INSTCTRL"
    } else if opcode >= SCANTYPE.rawValue {
      return "SCANTYPE"
    } else if opcode >= MIN.rawValue {
      return "MIN"
    } else if opcode >= MAX.rawValue {
      return "MAX"
    } else if opcode >= ROLL.rawValue {
      return "ROLL"
    } else if opcode >= IDEF.rawValue {
      return "IDEF"
    } else if opcode >= GETINFO.rawValue {
      return "GETINFO"
    } else if opcode >= SDPVTL.rawValue {
      return String(format: "SDPVTL[%d]", (opcode & 1))
    } else if opcode >= SCANCTRL.rawValue {
      return "SCANCTRL"
    } else if opcode >= FLIPRGOFF.rawValue {
      return "FLIPRGOFF"
    } else if opcode >= FLIPRGON.rawValue {
      return "FLIPRGON"
    } else if opcode >= FLIPPT.rawValue {
      return "FLIPPT"
    } else if opcode >= AA.rawValue {
      return "AA"
    } else if opcode >= SANGW.rawValue {
      return "SANGW"
    } else if opcode >= RDTG.rawValue {
      return "RDTG"
    } else if opcode >= RUTG.rawValue {
      return "RUTG"
    } else if opcode >= ROFF.rawValue {
      return "ROFF"
    } else if opcode >= JROF.rawValue {
      return "JROF"
    } else if opcode >= JROT.rawValue {
      return "JROT"
    } else if opcode >= S45ROUND.rawValue {
      return "S45ROUND"
    } else if opcode >= SROUND.rawValue {
      return "SROUND"
    } else if opcode >= DELTAC3.rawValue {
      return "DELTAC3"
    } else if opcode >= DELTAC2.rawValue {
      return "DELTAC2"
    } else if opcode >= DELTAC1.rawValue {
      return "DELTAC1"
    } else if opcode >= DELTAP3.rawValue {
      return "DELTAP3"
    } else if opcode >= DELTAP2.rawValue {
      return "DELTAP2"
    } else if opcode >= WCVTF.rawValue {
      return "WCVTF"
    } else if opcode >= NROUND.rawValue {
      return "NROUND[\(opcode & 3)]"
    } else if opcode >= ROUND.rawValue {
      return "ROUND[\(opcode & 3)]"
    } else if opcode >= CEILING.rawValue {
      return "CEILING"
    } else if opcode >= FLOOR.rawValue {
      return "FLOOR"
    } else if opcode >= NEG.rawValue {
      return "NEG"
    } else if opcode >= ABS.rawValue {
      return "ABS"
    } else if opcode >= MUL.rawValue {
      return "MUL"
    } else if opcode >= DIV.rawValue {
      return "DIV"
    } else if opcode >= SUB.rawValue {
      return "SUB"
    } else if opcode >= ADD.rawValue {
      return "ADD"
    } else if opcode >= SDS.rawValue {
      return "SDS"
    } else if opcode >= SDB.rawValue {
      return "SDB"
    } else if opcode >= DELTAP1.rawValue {
      return "DELTAP1"
    } else if opcode >= NOT.rawValue {
      return "NOT"
    } else if opcode >= OR.rawValue {
      return "OR"
    } else if opcode >= AND.rawValue {
      return "AND"
    } else if opcode >= EIF.rawValue {
      return "EIF"
    } else if opcode >= IF.rawValue {
      return "IF"
    } else if opcode >= EVEN.rawValue {
      return "EVEN"
    } else if opcode >= ODD.rawValue {
      return "ODD"
    } else if opcode >= NEQ.rawValue {
      return "NEQ"
    } else if opcode >= EQ.rawValue {
      return "EQ"
    } else if opcode >= GTEQ.rawValue {
      return "GTEQ"
    } else if opcode >= GT.rawValue {
      return "GT"
    } else if opcode >= LTEQ.rawValue {
      return "LTEQ"
    } else if opcode >= LT.rawValue {
      return "LT"
    } else if opcode >= DEBUG.rawValue {
      return "DEBUG"
    } else if opcode >= FLIPOFF.rawValue {
      return "FLIPOFF"
    } else if opcode >= FLIPON.rawValue {
      return "FLIPON"
    } else if opcode >= MPS.rawValue {
      return "MPS"
    } else if opcode >= MPPEM.rawValue {
      return "MPPEM"
    } else if opcode >= MD.rawValue {
      return "MD[\(opcode & 1)]"
    } else if opcode >= SCFS.rawValue {
      return "SCFS"
    } else if opcode >= GC.rawValue {
      return "GC[\(opcode & 1)]"
    } else if opcode >= RCVT.rawValue {
      return "RCVT"
    } else if opcode >= WCVTP.rawValue {
      return "WCVTP"
    } else if opcode >= RS.rawValue {
      return "RS"
    } else if opcode >= WS.rawValue {
      return "WS"
    } else if opcode >= NPUSHW.rawValue {
      return "NPUSHW"
    } else if opcode >= NPUSHB.rawValue {
      return "NPUSHB"
    } else if opcode >= MIAP.rawValue {
      return String(format: "MIAP[%@]", ((opcode & 1) == 0 ? "nrd+nci" : "rd+ci"))
    } else if opcode >= RTDG.rawValue {
      return "RTDG"
    } else if opcode >= ALIGNRP.rawValue {
      return "ALIGNRP"
    } else if opcode >= MSIRP.rawValue {
      return "MSIRP[\(opcode & 1)]"
    } else if opcode >= IP.rawValue {
      return "IP"
    } else if opcode >= SHPIX.rawValue {
      return "SHPIX"
    } else if opcode >= SHZ.rawValue {
      return "SHZ[\(opcode & 1)]"
    } else if opcode >= SHC.rawValue {
      return "SHC[\(opcode & 1)]"
    } else if opcode >= SHP.rawValue {
      return "SHP"
    } else if opcode >= IUP.rawValue {
      return String(format: "IUP[%@]", ((opcode & 1) == 0 ? "y" : "x"))
    } else if opcode >= MDAP.rawValue {
      return String(format: "MDAP[%@]", ((opcode & 1) == 0 ? "nrd" : "rd"))
    } else if opcode >= ENDF.rawValue {
      return "ENDF"
    } else if opcode >= FDEF.rawValue {
      return "FDEF"
    } else if opcode >= CALL.rawValue {
      return "CALL"
    } else if opcode >= LOOPCALL.rawValue {
      return "LOOPCALL"
    } else if opcode >= UTP.rawValue {
      return "UTP"
    } else if opcode >= ALIGNPTS.rawValue {
      return "ALIGNPTS"
    } else if opcode >= MINDEX.rawValue {
      return "MINDEX"
    } else if opcode >= CINDEX.rawValue {
      return "CINDEX"
    } else if opcode >= DEPTH.rawValue {
      return "DEPTH"
    } else if opcode >= SWAP.rawValue {
      return "SWAP"
    } else if opcode >= CLEAR.rawValue {
      return "CLEAR"
    } else if opcode >= POP.rawValue {
      return "POP"
    } else if opcode >= DUP.rawValue {
      return "DUP"
    } else if opcode >= SSW.rawValue {
      return "SSW"
    } else if opcode >= SSWCI.rawValue {
      return "SSWCI"
    } else if opcode >= SCVTCI.rawValue {
      return "SCVTCI"
    } else if opcode >= JMPR.rawValue {
      return "JMPR"
    } else if opcode >= ELSE.rawValue {
      return "ELSE"
    } else if opcode >= SMD.rawValue {
      return "SMD"
    } else if opcode >= RTHG.rawValue {
      return "RTHG"
    } else if opcode >= RTG.rawValue {
      return "RTG"
    } else if opcode >= SLOOP.rawValue {
      return "SLOOP"
    } else if opcode >= SZPS.rawValue {
      return "SZPS"
    } else if opcode >= SZP2.rawValue {
      return "SZP2"
    } else if opcode >= SZP1.rawValue {
      return "SZP1"
    } else if opcode >= SZP0.rawValue {
      return "SZP0"
    } else if opcode >= SRP2.rawValue {
      return "SRP2"
    } else if opcode >= SRP1.rawValue {
      return "SRP1"
    } else if opcode >= SRP0.rawValue {
      return "SRP0"
    } else if opcode >= ISECT.rawValue {
      return "ISECT"
    } else if opcode >= SFVTPV.rawValue {
      return "SFVTPV"
    } else if opcode >= GFV.rawValue {
      return "GFV"
    } else if opcode >= GPV.rawValue {
      return "GPV"
    } else if opcode >= SFVFS.rawValue {
      return "SFVFS"
    } else if opcode >= SPVFS.rawValue {
      return "SPVFS"
    } else if opcode >= SFVTL.rawValue {
      return String(format: "SFVTL[%@]", ((opcode & 1) == 0 ? "y-axis" : "x-axis"))
    } else if opcode >= SPVTL.rawValue {
      return String(format: "SPVTL[%@]", ((opcode & 1) == 0 ? "y-axis" : "x-axis"))
    } else if opcode >= SFVTCA.rawValue {
      return String(format: "SFVTCA[%@]", ((opcode & 1) == 0 ? "y-axis" : "x-axis"))
    } else if opcode >= SPVTCA.rawValue {
      return String(format: "SPVTCA[%@]", ((opcode & 1) == 0 ? "y-axis" : "x-axis"))
    } else if opcode >= SVTCA.rawValue {
      return String(format: "SVTCA[%@]", ((opcode & 1) == 0 ? "y-axis" : "x-axis"))
    } else {
      return "????"
    }
  }
}
