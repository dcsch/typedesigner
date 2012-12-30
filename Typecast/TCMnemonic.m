//
//  TCMnemonic.m
//  Type Designer
//
//  Created by David Schweinsberg on 29/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCMnemonic.h"

@implementation TCMnemonic

/**
 * Gets the mnemonic text for the specified opcode
 * @param opcode The opcode for which the mnemonic is required
 * @return The mnemonic, with a description
 */
+ (NSString *)mnemonicForOpcode:(short)opcode
{
    if (opcode >= TC_MIRP)
        return [NSString stringWithFormat:
                @"MIRP[%@%@%@%d]",
                ((opcode & 16) == 0 ? @"nrp0," : @"srp0,"),
                ((opcode & 8) == 0 ? @"nmd," : @"md,"),
                ((opcode & 4) == 0 ? @"nrd," : @"rd,"),
                (opcode & 3)];
    else if (opcode >= TC_MDRP)
        return [NSString stringWithFormat:
                @"MDRP[%@%@%@%d]",
                ((opcode & 16) == 0 ? @"nrp0," : @"srp0,"),
                ((opcode & 8) == 0 ? @"nmd," : @"md,"),
                ((opcode & 4) == 0 ? @"nrd," : @"rd,"),
                (opcode & 3)];
    else if (opcode >= TC_PUSHW)
        return [NSString stringWithFormat:@"PUSHW[%d]", ((opcode & 7) + 1)];
    else if (opcode >= TC_PUSHB)
        return [NSString stringWithFormat:@"PUSHB[%d]", ((opcode & 7) + 1)];
    else if (opcode >= TC_INSTCTRL) return @"INSTCTRL";
    else if (opcode >= TC_SCANTYPE) return @"SCANTYPE";
    else if (opcode >= TC_MIN) return @"MIN";
    else if (opcode >= TC_MAX) return @"MAX";
    else if (opcode >= TC_ROLL) return @"ROLL";
    else if (opcode >= TC_IDEF) return @"IDEF";
    else if (opcode >= TC_GETINFO) return @"GETINFO";
    else if (opcode >= TC_SDPVTL)
        return [NSString stringWithFormat:@"SDPVTL[%d]", (opcode & 1)];
    else if (opcode >= TC_SCANCTRL) return @"SCANCTRL";
    else if (opcode >= TC_FLIPRGOFF) return @"FLIPRGOFF";
    else if (opcode >= TC_FLIPRGON) return @"FLIPRGON";
    else if (opcode >= TC_FLIPPT) return @"FLIPPT";
    else if (opcode >= TC_AA) return @"AA";
    else if (opcode >= TC_SANGW) return @"SANGW";
    else if (opcode >= TC_RDTG) return @"RDTG";
    else if (opcode >= TC_RUTG) return @"RUTG";
    else if (opcode >= TC_ROFF) return @"ROFF";
    else if (opcode >= TC_JROF) return @"JROF";
    else if (opcode >= TC_JROT) return @"JROT";
    else if (opcode >= TC_S45ROUND) return @"S45ROUND";
    else if (opcode >= TC_SROUND) return @"SROUND";
    else if (opcode >= TC_DELTAC3) return @"DELTAC3";
    else if (opcode >= TC_DELTAC2) return @"DELTAC2";
    else if (opcode >= TC_DELTAC1) return @"DELTAC1";
    else if (opcode >= TC_DELTAP3) return @"DELTAP3";
    else if (opcode >= TC_DELTAP2) return @"DELTAP2";
    else if (opcode >= TC_WCVTF) return @"WCVTF";
    else if (opcode >= TC_NROUND)
        return [NSString stringWithFormat:@"NROUND[%d]", (opcode & 3)];
    else if (opcode >= TC_ROUND)
        return [NSString stringWithFormat:@"ROUND[%d]", (opcode & 3)];
    else if (opcode >= TC_CEILING) return @"CEILING";
    else if (opcode >= TC_FLOOR) return @"FLOOR";
    else if (opcode >= TC_NEG) return @"NEG";
    else if (opcode >= TC_ABS) return @"ABS";
    else if (opcode >= TC_MUL) return @"MUL";
    else if (opcode >= TC_DIV) return @"DIV";
    else if (opcode >= TC_SUB) return @"SUB";
    else if (opcode >= TC_ADD) return @"ADD";
    else if (opcode >= TC_SDS) return @"SDS";
    else if (opcode >= TC_SDB) return @"SDB";
    else if (opcode >= TC_DELTAP1) return @"DELTAP1";
    else if (opcode >= TC_NOT) return @"NOT";
    else if (opcode >= TC_OR) return @"OR";
    else if (opcode >= TC_AND) return @"AND";
    else if (opcode >= TC_EIF) return @"EIF";
    else if (opcode >= TC_IF) return @"IF";
    else if (opcode >= TC_EVEN) return @"EVEN";
    else if (opcode >= TC_ODD) return @"ODD";
    else if (opcode >= TC_NEQ) return @"NEQ";
    else if (opcode >= TC_EQ) return @"EQ";
    else if (opcode >= TC_GTEQ) return @"GTEQ";
    else if (opcode >= TC_GT) return @"GT";
    else if (opcode >= TC_LTEQ) return @"LTEQ";
    else if (opcode >= TC_LT) return @"LT";
    else if (opcode >= TC_DEBUG) return @"DEBUG";
    else if (opcode >= TC_FLIPOFF) return @"FLIPOFF";
    else if (opcode >= TC_FLIPON) return @"FLIPON";
    else if (opcode >= TC_MPS) return @"MPS";
    else if (opcode >= TC_MPPEM) return @"MPPEM";
    else if (opcode >= TC_MD)
        return [NSString stringWithFormat:@"MD[%d]", (opcode & 1)];
    else if (opcode >= TC_SCFS) return @"SCFS";
    else if (opcode >= TC_GC)
        return [NSString stringWithFormat:@"GC[%d]", (opcode & 1)];
    else if (opcode >= TC_RCVT) return @"RCVT";
    else if (opcode >= TC_WCVTP) return @"WCVTP";
    else if (opcode >= TC_RS) return @"RS";
    else if (opcode >= TC_WS) return @"WS";
    else if (opcode >= TC_NPUSHW) return @"NPUSHW";
    else if (opcode >= TC_NPUSHB) return @"NPUSHB";
    else if (opcode >= TC_MIAP)
        return [NSString stringWithFormat:@"MIAP[%@]", ((opcode & 1) == 0 ? @"nrd+nci" : @"rd+ci")];
    else if (opcode >= TC_RTDG) return @"RTDG";
    else if (opcode >= TC_ALIGNRP) return @"ALIGNRP";
    else if (opcode >= TC_MSIRP)
        return [NSString stringWithFormat:@"MSIRP[%d]", (opcode & 1)];
    else if (opcode >= TC_IP) return @"IP";
    else if (opcode >= TC_SHPIX) return @"SHPIX";
    else if (opcode >= TC_SHZ)
        return [NSString stringWithFormat:@"SHZ[%d]", (opcode & 1)];
    else if (opcode >= TC_SHC)
        return [NSString stringWithFormat:@"SHC[%d]", (opcode & 1)];
    else if (opcode >= TC_SHP) return @"SHP";
    else if (opcode >= TC_IUP)
        return [NSString stringWithFormat:@"IUP[%@]", ((opcode & 1) == 0 ? @"y" : @"x")];
    else if (opcode >= TC_MDAP)
        return [NSString stringWithFormat:@"MDAP[%@]", ((opcode & 1) == 0 ? @"nrd" : @"rd")];
    else if (opcode >= TC_ENDF) return @"ENDF";
    else if (opcode >= TC_FDEF) return @"FDEF";
    else if (opcode >= TC_CALL) return @"CALL";
    else if (opcode >= TC_LOOPCALL) return @"LOOPCALL";
    else if (opcode >= TC_UTP) return @"UTP";
    else if (opcode >= TC_ALIGNPTS) return @"ALIGNPTS";
    else if (opcode >= TC_MINDEX) return @"MINDEX";
    else if (opcode >= TC_CINDEX) return @"CINDEX";
    else if (opcode >= TC_DEPTH) return @"DEPTH";
    else if (opcode >= TC_SWAP) return @"SWAP";
    else if (opcode >= TC_CLEAR) return @"CLEAR";
    else if (opcode >= TC_POP) return @"POP";
    else if (opcode >= TC_DUP) return @"DUP";
    else if (opcode >= TC_SSW) return @"SSW";
    else if (opcode >= TC_SSWCI) return @"SSWCI";
    else if (opcode >= TC_SCVTCI) return @"SCVTCI";
    else if (opcode >= TC_JMPR) return @"JMPR";
    else if (opcode >= TC_ELSE) return @"ELSE";
    else if (opcode >= TC_SMD) return @"SMD";
    else if (opcode >= TC_RTHG) return @"RTHG";
    else if (opcode >= TC_RTG) return @"RTG";
    else if (opcode >= TC_SLOOP) return @"SLOOP";
    else if (opcode >= TC_SZPS) return @"SZPS";
    else if (opcode >= TC_SZP2) return @"SZP2";
    else if (opcode >= TC_SZP1) return @"SZP1";
    else if (opcode >= TC_SZP0) return @"SZP0";
    else if (opcode >= TC_SRP2) return @"SRP2";
    else if (opcode >= TC_SRP1) return @"SRP1";
    else if (opcode >= TC_SRP0) return @"SRP0";
    else if (opcode >= TC_ISECT) return @"ISECT";
    else if (opcode >= TC_SFVTPV) return @"SFVTPV";
    else if (opcode >= TC_GFV) return @"GFV";
    else if (opcode >= TC_GPV) return @"GPV";
    else if (opcode >= TC_SFVFS) return @"SFVFS";
    else if (opcode >= TC_SPVFS) return @"SPVFS";
    else if (opcode >= TC_SFVTL)
        return [NSString stringWithFormat:@"SFVTL[%@]", ((opcode & 1) == 0 ? @"y-axis" : @"x-axis")];
    else if (opcode >= TC_SPVTL)
        return [NSString stringWithFormat:@"SPVTL[%@]", ((opcode & 1) == 0 ? @"y-axis" : @"x-axis")];
    else if (opcode >= TC_SFVTCA)
        return [NSString stringWithFormat:@"SFVTCA[%@]", ((opcode & 1) == 0 ? @"y-axis" : @"x-axis")];
    else if (opcode >= TC_SPVTCA)
        return [NSString stringWithFormat:@"SPVTCA[%@]", ((opcode & 1) == 0 ? @"y-axis" : @"x-axis")];
    else if (opcode >= TC_SVTCA)
        return [NSString stringWithFormat:@"SVTCA[%@]", ((opcode & 1) == 0 ? @"y-axis" : @"x-axis")];
    else
        return @"????";
}

/*
+ (NSString *)commentForOpcode:(short)opcode
{
    if (opcode >= TC_MIRP) return @"MIRP["+((opcode&16)==0?"nrp0,":"srp0,")+((opcode&8)==0?"nmd,":"md,")+((opcode&4)==0?"nrd,":"rd,")+(opcode&3)+"]\t\tMove Indirect Relative Point";
    else if (opcode >= TC_MDRP) return @"MDRP["+((opcode&16)==0?"nrp0,":"srp0,")+((opcode&8)==0?"nmd,":"md,")+((opcode&4)==0?"nrd,":"rd,")+(opcode&3)+"]\t\tMove Direct Relative Point";
    else if (opcode >= TC_PUSHW) return @"PUSHW["+((opcode&7)+1)+"]";
    else if (opcode >= TC_PUSHB) return @"PUSHB["+((opcode&7)+1)+"]";
    else if (opcode >= TC_INSTCTRL) return @"INSTCTRL\tINSTruction Execution ConTRol";
    else if (opcode >= TC_SCANTYPE) return @"SCANTYPE\tSCANTYPE";
    else if (opcode >= TC_MIN) return @"MIN\t\tMINimum of top two stack elements";
    else if (opcode >= TC_MAX) return @"MAX\t\tMAXimum of top two stack elements";
    else if (opcode >= TC_ROLL) return @"ROLL\t\tROLL the top three stack elements";
    else if (opcode >= TC_IDEF) return @"IDEF\t\tInstruction DEFinition";
    else if (opcode >= TC_GETINFO) return @"GETINFO\tGET INFOrmation";
    else if (opcode >= TC_SDPVTL) return @"SDPVTL["+(opcode&1)+"]\tSet Dual Projection_Vector To Line";
    else if (opcode >= TC_SCANCTRL) return @"SCANCTRL\tSCAN conversion ConTRoL";
    else if (opcode >= TC_FLIPRGOFF) return @"FLIPRGOFF\tFLIP RanGe OFF";
    else if (opcode >= TC_FLIPRGON) return @"FLIPRGON\tFLIP RanGe ON";
    else if (opcode >= TC_FLIPPT) return @"FLIPPT\tFLIP PoinT";
    else if (opcode >= TC_AA) return @"AA";
    else if (opcode >= TC_SANGW) return @"SANGW\t\tSet Angle _Weight";
    else if (opcode >= TC_RDTG) return @"RDTG\t\tRound Down To Grid";
    else if (opcode >= TC_RUTG) return @"RUTG\t\tRound Up To Grid";
    else if (opcode >= TC_ROFF) return @"ROFF\t\tRound OFF";
    else if (opcode >= TC_JROF) return @"JROF\t\tJump Relative On False";
    else if (opcode >= TC_JROT) return @"JROT\t\tJump Relative On True";
    else if (opcode >= TC_S45ROUND) return @"S45ROUND\tSuper ROUND 45 degrees";
    else if (opcode >= TC_SROUND) return @"SROUND\tSuper ROUND";
    else if (opcode >= TC_DELTAC3) return @"DELTAC3\tDELTA exception C3";
    else if (opcode >= TC_DELTAC2) return @"DELTAC2\tDELTA exception C2";
    else if (opcode >= TC_DELTAC1) return @"DELTAC1\tDELTA exception C1";
    else if (opcode >= TC_DELTAP3) return @"DELTAP3\tDELTA exception P3";
    else if (opcode >= TC_DELTAP2) return @"DELTAP2\tDELTA exception P2";
    else if (opcode >= TC_WCVTF) return @"WCVTF\t\tWrite Control Value Table in FUnits";
    else if (opcode >= TC_NROUND) return @"NROUND["+(opcode&3)+"]";
    else if (opcode >= TC_ROUND) return @"ROUND["+(opcode&3)+"]";
    else if (opcode >= TC_CEILING) return @"CEILING\tCEILING";
    else if (opcode >= TC_FLOOR) return @"FLOOR\t\tFLOOR";
    else if (opcode >= TC_NEG) return @"NEG\t\tNEGate";
    else if (opcode >= TC_ABS) return @"ABS\t\tABSolute value";
    else if (opcode >= TC_MUL) return @"MUL\t\tMULtiply";
    else if (opcode >= TC_DIV) return @"DIV\t\tDIVide";
    else if (opcode >= TC_SUB) return @"SUB\t\tSUBtract";
    else if (opcode >= TC_ADD) return @"ADD\t\tADD";
    else if (opcode >= TC_SDS) return @"SDS\t\tSet Delta_Shift in the graphics state";
    else if (opcode >= TC_SDB) return @"SDB\t\tSet Delta_Base in the graphics state";
    else if (opcode >= TC_DELTAP1) return @"DELTAP1\tDELTA exception P1";
    else if (opcode >= TC_NOT) return @"NOT\t\tlogical NOT";
    else if (opcode >= TC_OR) return @"OR\t\t\tlogical OR";
    else if (opcode >= TC_AND) return @"AND\t\tlogical AND";
    else if (opcode >= TC_EIF) return @"EIF\t\tEnd IF";
    else if (opcode >= TC_IF) return @"IF\t\t\tIF test";
    else if (opcode >= TC_EVEN) return @"EVEN";
    else if (opcode >= TC_ODD) return @"ODD";
    else if (opcode >= TC_NEQ) return @"NEQ\t\tNot EQual";
    else if (opcode >= TC_EQ) return @"EQ\t\t\tEQual";
    else if (opcode >= TC_GTEQ) return @"GTEQ\t\tGreater Than or Equal";
    else if (opcode >= TC_GT) return @"GT\t\t\tGreater Than";
    else if (opcode >= TC_LTEQ) return @"LTEQ\t\tLess Than or Equal";
    else if (opcode >= TC_LT) return @"LT\t\t\tLess Than";
    else if (opcode >= TC_DEBUG) return @"DEBUG";
    else if (opcode >= TC_FLIPOFF) return @"FLIPOFF\tSet the auto_flip Boolean to OFF";
    else if (opcode >= TC_FLIPON) return @"FLIPON\tSet the auto_flip Boolean to ON";
    else if (opcode >= TC_MPS) return @"MPS\t\tMeasure Point Size";
    else if (opcode >= TC_MPPEM) return @"MPPEM\t\tMeasure Pixels Per EM";
    else if (opcode >= TC_MD) return @"MD["+(opcode&1)+"]\t\t\tMeasure Distance";
    else if (opcode >= TC_SCFS) return @"SCFS\t\tSets Coordinate From the Stack using projection_vector and freedom_vector";
    else if (opcode >= TC_GC) return @"GC["+(opcode&1)+"]\t\t\tGet Coordinate projected onto the projection_vector";
    else if (opcode >= TC_RCVT) return @"RCVT\t\tRead Control Value Table";
    else if (opcode >= TC_WCVTP) return @"WCVTP\t\tWrite Control Value Table in Pixel units";
    else if (opcode >= TC_RS) return @"RS\t\t\tRead Store";
    else if (opcode >= TC_WS) return @"WS\t\t\tWrite Store";
    else if (opcode >= TC_NPUSHW) return @"NPUSHW";
    else if (opcode >= TC_NPUSHB) return @"NPUSHB";
    else if (opcode >= TC_MIAP) return @"MIAP["+((opcode&1)==0?"nrd+nci":"rd+ci")+"]\t\tMove Indirect Absolute Point";
    else if (opcode >= TC_RTDG) return @"RTDG\t\tRound To Double Grid";
    else if (opcode >= TC_ALIGNRP) return @"ALIGNRP\tALIGN Relative Point";
    else if (opcode >= TC_MSIRP) return @"MSIRP["+(opcode&1)+"]\t\tMove Stack Indirect Relative Point";
    else if (opcode >= TC_IP) return @"IP\t\t\tInterpolate Point by the last relative stretch";
    else if (opcode >= TC_SHPIX) return @"SHPIX\t\tSHift point by a PIXel amount";
    else if (opcode >= TC_SHZ) return @"SHZ["+(opcode&1)+"]\t\tSHift Zone by the last pt";
    else if (opcode >= TC_SHC) return @"SHC["+(opcode&1)+"]\t\tSHift Contour by the last point";
    else if (opcode >= TC_SHP) return @"SHP\t\tSHift Point by the last point";
    else if (opcode >= TC_IUP) return @"IUP["+((opcode&1)==0?"y":"x")+"]\t\tInterpolate Untouched Points through the outline";
    else if (opcode >= TC_MDAP) return @"MDAP["+((opcode&1)==0?"nrd":"rd")+"]\t\tMove Direct Absolute Point";
    else if (opcode >= TC_ENDF) return @"ENDF\t\tEND Function definition";
    else if (opcode >= TC_FDEF) return @"FDEF\t\tFunction DEFinition ";
    else if (opcode >= TC_CALL) return @"CALL\t\tCALL function";
    else if (opcode >= TC_LOOPCALL) return @"LOOPCALL\tLOOP and CALL function";
    else if (opcode >= TC_UTP) return @"UTP\t\tUnTouch Point";
    else if (opcode >= TC_ALIGNPTS) return @"ALIGNPTS\tALIGN Points";
    else if (opcode >= TC_MINDEX) return @"MINDEX\tMove the INDEXed element to the top of the stack";
    else if (opcode >= TC_CINDEX) return @"CINDEX\tCopy the INDEXed element to the top of the stack";
    else if (opcode >= TC_DEPTH) return @"DEPTH\t\tReturns the DEPTH of the stack";
    else if (opcode >= TC_SWAP) return @"SWAP\t\tSWAP the top two elements on the stack";
    else if (opcode >= TC_CLEAR) return @"CLEAR\t\tClear the entire stack";
    else if (opcode >= TC_POP) return @"POP\t\tPOP top stack element";
    else if (opcode >= TC_DUP) return @"DUP\t\tDuplicate top stack element";
    else if (opcode >= TC_SSW) return @"SSW\t\tSet Single-width";
    else if (opcode >= TC_SSWCI) return @"SSWCI\t\tSet Single_Width_Cut_In";
    else if (opcode >= TC_SCVTCI) return @"SCVTCI\tSet Control Value Table Cut In";
    else if (opcode >= TC_JMPR) return @"JMPR\t\tJuMP";
    else if (opcode >= TC_ELSE) return @"ELSE";
    else if (opcode >= TC_SMD) return @"SMD\t\tSet Minimum_ Distance";
    else if (opcode >= TC_RTHG) return @"RTHG\t\tRound To Half Grid";
    else if (opcode >= TC_RTG) return @"RTG\t\tRound To Grid";
    else if (opcode >= TC_SLOOP) return @"SLOOP\t\tSet LOOP variable";
    else if (opcode >= TC_SZPS) return @"SZPS\t\tSet Zone PointerS";
    else if (opcode >= TC_SZP2) return @"SZP2\t\tSet Zone Pointer 2";
    else if (opcode >= TC_SZP1) return @"SZP1\t\tSet Zone Pointer 1";
    else if (opcode >= TC_SZP0) return @"SZP0\t\tSet Zone Pointer 0";
    else if (opcode >= TC_SRP2) return @"SRP2\t\tSet Reference Point 2";
    else if (opcode >= TC_SRP1) return @"SRP1\t\tSet Reference Point 1";
    else if (opcode >= TC_SRP0) return @"SRP0\t\tSet Reference Point 0";
    else if (opcode >= TC_ISECT) return @"ISECT\t\tmoves point p to the InterSECTion of two lines";
    else if (opcode >= TC_SFVTPV) return @"SFVTPV\tSet Freedom_Vector To Projection Vector";
    else if (opcode >= TC_GFV) return @"GFV\t\tGet Freedom_Vector";
    else if (opcode >= TC_GPV) return @"GPV\t\tGet Projection_Vector";
    else if (opcode >= TC_SFVFS) return @"SFVFS\t\tSet Freedom_Vector From Stack";
    else if (opcode >= TC_SPVFS) return @"SPVFS\t\tSet Projection_Vector From Stack";
    else if (opcode >= TC_SFVTL) return @"SFVTL["+((opcode&1)==0?"y-axis":"x-axis")+"]\t\tSet Freedom_Vector To Line";
    else if (opcode >= TC_SPVTL) return @"SPVTL["+((opcode&1)==0?"y-axis":"x-axis")+"]\t\tSet Projection_Vector To Line";
    else if (opcode >= TC_SFVTCA) return @"SFVTCA["+((opcode&1)==0?"y-axis":"x-axis")+"]\tSet Freedom_Vector to Coordinate Axis";
    else if (opcode >= TC_SPVTCA) return @"SPVTCA["+((opcode&1)==0?"y-axis":"x-axis")+"]\tSet Projection_Vector To Coordinate Axis";
    else if (opcode >= TC_SVTCA) return @"SVTCA["+((opcode&1)==0?"y-axis":"x-axis")+"]\t\tSet freedom and projection Vectors To Coordinate Axis";
    else return @"????";
}
*/
@end
