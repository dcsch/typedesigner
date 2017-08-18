//
//  CFFType2Interpreter.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/11/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log

/**
 The Mnemonic representations of the Type 2 charstring instruction set.
 */
class T2Mnemonic {

  // One byte operators
  static let HSTEM = 0x01
  static let VSTEM = 0x03
  static let VMOVETO = 0x04
  static let RLINETO = 0x05
  static let HLINETO = 0x06
  static let VLINETO = 0x07
  static let RRCURVETO = 0x08
  static let CALLSUBR = 0x0a
  static let RETURN = 0x0b
  static let ESCAPE = 0x0c
  static let ENDCHAR = 0x0e
  static let HSTEMHM = 0x12
  static let HINTMASK = 0x13
  static let CNTRMASK = 0x14
  static let RMOVETO = 0x15
  static let HMOVETO = 0x16
  static let VSTEMHM = 0x17
  static let RCURVELINE = 0x18
  static let RLINECURVE = 0x19
  static let VVCURVETO = 0x1a
  static let HHCURVETO = 0x1b
  static let CALLGSUBR = 0x1d
  static let VHCURVETO = 0x1e
  static let HVCURVETO = 0x1f

  // Two byte operators
  static let DOTSECTION = 0x00
  static let AND = 0x03
  static let OR = 0x04
  static let NOT = 0x05
  static let ABS = 0x09
  static let ADD = 0x0a
  static let SUB = 0x0b
  static let DIV = 0x0c
  static let NEG = 0x0e
  static let EQ = 0x0f
  static let DROP = 0x12
  static let PUT = 0x14
  static let GET = 0x15
  static let IFELSE = 0x16
  static let RANDOM = 0x17
  static let MUL = 0x18
  static let SQRT = 0x1a
  static let DUP = 0x1b
  static let EXCH = 0x1c
  static let INDEX = 0x1d
  static let ROLL = 0x1e
  static let HFLEX = 0x22
  static let FLEX = 0x23
  static let HFLEX1 = 0x24
  static let FLEX1 = 0x25
}

public class CFFPoint {
  public var x: Int
  public var y: Int
  public var onCurve: Bool
  public var endOfContour: Bool

  init(x: Int, y: Int, onCurve: Bool, endOfContour: Bool) {
    self.x = x
    self.y = y
    self.onCurve = onCurve
    self.endOfContour = endOfContour
  }
}

public enum CFFType2InterpreterError: Error {
  case badOperand
  case badOperator
  case stackUnderflow
}

/**
 Type 2 Charstring Interpreter.  Operator descriptions are quoted from
 Adobe's Type 2 Charstring Format document — 5117.Type2.pdf.
 */
public class CFFType2Interpreter {

  static let ARGUMENT_STACK_LIMIT = 48
  static let SUBR_STACK_LIMIT = 10
  static let TRANSIENT_ARRAY_ELEMENT_COUNT = 32

  var argStack = [NSNumber]()
  var argStackIndex: Int {
    get {
      return argStack.count
    }
  }
  var subrStack = [(CFFCharstringType2, Int)]()
  var subrStackIndex: Int {
    get {
      return subrStack.count
    }
  }
  var transientArray = [NSNumber]()

  var stemCount = 0
  public var hstems = [Int]()
  public var vstems = [Int]()

//  var points = [(point: CGPoint, onCurve: Bool, endOfCurve: Bool)]()
  var points = [CFFPoint]()
  let localSubrIndex: CFFIndex
  let globalSubrIndex: CFFIndex
  let localSubrs: CFFCharstringType2
  let globalSubrs: CFFCharstringType2
  var cs: CFFCharstringType2
  var ip = 0

  /**
   Creates a new instance of T2Interpreter
   */
  public init(localSubrIndex: CFFIndex, globalSubrIndex: CFFIndex) {
    self.localSubrIndex = localSubrIndex
    self.globalSubrIndex = globalSubrIndex
    let localStart = localSubrIndex.offset[0] - 1
    let localEnd = localSubrIndex.dataLength - localStart
    localSubrs = CFFCharstringType2(
      index: 0,
      name: "Local subrs",
      data: localSubrIndex.data[localStart..<localEnd])
    let globalStart = globalSubrIndex.offset[0] - 1
    let globalEnd = globalSubrIndex.dataLength - globalStart
    globalSubrs = CFFCharstringType2(
      index: 0,
      name: "Global subrs",
      data: globalSubrIndex.data[globalStart..<globalEnd])

    // TODO redesign the class so we don't have this charstring as part of it
    cs = CFFCharstringType2()
  }

  /**
   Moves the current point to a position at the relative coordinates
   (dx1, dy1).
   */
  private func _rmoveto() throws {
    let dy1 = try popArg().intValue
    let dx1 = try popArg().intValue
    clearArg()
    let lastPoint = points.last ?? CFFPoint(x: 0, y: 0, onCurve: true,
                                            endOfContour: false)
    moveTo(x: lastPoint.x + dx1, y: lastPoint.y + dy1)
  }

  /**
   Moves the current point dx1 units in the horizontal direction.
   */
  private func _hmoveto() throws {
    let dx1 = try popArg().intValue
    clearArg()
    let lastPoint = points.last ?? CFFPoint(x: 0, y: 0, onCurve: true,
                                            endOfContour: false)
    moveTo(x: lastPoint.x + dx1, y: lastPoint.y)
  }

  /**
   Moves the current point dy1 units in the vertical direction.
   */
  private func _vmoveto() throws {
    let dy1 = try popArg().intValue
    clearArg()
    let lastPoint = points.last ?? CFFPoint(x: 0, y: 0, onCurve: true,
                                            endOfContour: false)
    moveTo(x: lastPoint.x, y: lastPoint.y + dy1)
  }

  /**
   Appends a line from the current point to a position at the
   relative coordinates dxa, dya. Additional rlineto operations are
   performed for all subsequent argument pairs. The number of
   lines is determined from the number of arguments on the stack.
   */
  private func _rlineto() throws {
    let count = argCount / 2
    var dx = [Int]()
    var dy = [Int]()
    for _ in 0..<count {
      try dy.insert(popArg().intValue, at: 0)
      try dx.insert(popArg().intValue, at: 0)
    }
    for i in 0..<count {
      if let lastPoint = points.last {
        lineTo(x: lastPoint.x + dx[i], y: lastPoint.y + dy[i])
      }
    }
    clearArg()
  }

  /**
   Appends a horizontal line of length dx1 to the current point.
   With an odd number of arguments, subsequent argument pairs
   are interpreted as alternating values of dy and dx, for which
   additional lineto operators draw alternating vertical and
   horizontal lines. With an even number of arguments, the
   arguments are interpreted as alternating horizontal and
   vertical lines. The number of lines is determined from the
   number of arguments on the stack.
   */
  private func _hlineto() throws {
    let count = argCount
    var nums = [Int]()
    for _ in 0..<count {
      try nums.insert(popArg().intValue, at: 0)
    }
    for i in 0..<count {
      if let lastPoint = points.last {
        if i % 2 == 0 {
          lineTo(x: lastPoint.x + nums[i], y: lastPoint.y)
        } else {
          lineTo(x: lastPoint.x, y: lastPoint.y + nums[i])
        }
      }
    }
    clearArg()
  }

  /**
   Appends a vertical line of length dy1 to the current point. With
   an odd number of arguments, subsequent argument pairs are
   interpreted as alternating values of dx and dy, for which
   additional lineto operators draw alternating horizontal and
   vertical lines. With an even number of arguments, the
   arguments are interpreted as alternating vertical and
   horizontal lines. The number of lines is determined from the
   number of arguments on the stack.
   */
  private func _vlineto() throws {
    let count = argCount
    var nums = [Int]()
    for _ in 0..<count {
      try nums.insert(popArg().intValue, at: 0)
    }
    for i in 0..<count {
      if let lastPoint = points.last {
        if i % 2 == 0 {
          lineTo(x: lastPoint.x, y: lastPoint.y + nums[i])
        } else {
          lineTo(x: lastPoint.x + nums[i], y: lastPoint.y)
        }
      }
    }
    clearArg()
  }

  /**
   Appends a Bezier curve, defined by dxa...dyc, to the current
   point. For each subsequent set of six arguments, an additional
   curve is appended to the current point. The number of curve
   segments is determined from the number of arguments on the
   number stack and is limited only by the size of the number
   stack.
   */
  private func _rrcurveto() throws {
    let count = argCount / 6
    var dxa = [Int]()
    var dya = [Int]()
    var dxb = [Int]()
    var dyb = [Int]()
    var dxc = [Int]()
    var dyc = [Int]()
    for _ in 0..<count {
      try dyc.insert(popArg().intValue, at: 0)
      try dxc.insert(popArg().intValue, at: 0)
      try dyb.insert(popArg().intValue, at: 0)
      try dxb.insert(popArg().intValue, at: 0)
      try dya.insert(popArg().intValue, at: 0)
      try dxa.insert(popArg().intValue, at: 0)
    }
    for i in 0..<count {
      if let lastPoint = points.last {
        let xa = lastPoint.x + dxa[i]
        let ya = lastPoint.y + dya[i]
        let xb = xa + dxb[i]
        let yb = ya + dyb[i]
        let xc = xb + dxc[i]
        let yc = yb + dyc[i]
        curveTo(cx1: xa, cy1: ya, cx2: xb, cy2: yb, x: xc, y: yc)
      }
    }
    clearArg()
  }

  /**
   Appends one or more Bezier curves, as described by the
   dxa...dxc set of arguments, to the current point. For each curve,
   if there are 4 arguments, the curve starts and ends horizontal.
   The first curve need not start horizontal (the odd argument
   case). Note the argument order for the odd argument case.
   */
  private func _hhcurveto() throws {
    let count = argCount / 4
    var dy1 = 0
    var dxa = [Int]()
    var dxb = [Int]()
    var dyb = [Int]()
    var dxc = [Int]()
    for _ in 0..<count {
      try dxc.insert(popArg().intValue, at: 0)
      try dyb.insert(popArg().intValue, at: 0)
      try dxb.insert(popArg().intValue, at: 0)
      try dxa.insert(popArg().intValue, at: 0)
    }
    if argCount == 1 {
      dy1 = try popArg().intValue
    }
    for i in 0..<count {
      if let lastPoint = points.last {
        let xa = lastPoint.x + dxa[i]
        let ya = lastPoint.y + (i == 0 ? dy1 : 0)
        let xb = xa + dxb[i]
        let yb = ya + dyb[i]
        let xc = xb + dxc[i]
        let yc = yb
        curveTo(cx1: xa, cy1: ya, cx2: xb, cy2: yb, x: xc, y: yc)
      }
    }
    clearArg()
  }

  /**
   Appends one or more Bezier curves to the current point. The
   tangent for the first Bezier must be horizontal, and the second
   must be vertical (except as noted below).
   If there is a multiple of four arguments, the curve starts
   horizontal and ends vertical. Note that the curves alternate
   between start horizontal, end vertical, and start vertical, and
   end horizontal. The last curve (the odd argument case) need not
   end horizontal/vertical.
   */
  private func _hvcurveto() throws {
    if argCount % 8 <= 1 {
      let count = argCount / 8
      var dxa = [Int]()
      var dxb = [Int]()
      var dyb = [Int]()
      var dyc = [Int]()
      var dyd = [Int]()
      var dxe = [Int]()
      var dye = [Int]()
      var dxf = [Int]()
      var dyf = 0;
      if (argCount % 8 == 1) {
        dyf = try popArg().intValue
      }
      for _ in 0..<count {
        try dxf.insert(popArg().intValue, at: 0)
        try dye.insert(popArg().intValue, at: 0)
        try dxe.insert(popArg().intValue, at: 0)
        try dyd.insert(popArg().intValue, at: 0)
        try dyc.insert(popArg().intValue, at: 0)
        try dyb.insert(popArg().intValue, at: 0)
        try dxb.insert(popArg().intValue, at: 0)
        try dxa.insert(popArg().intValue, at: 0)
      }
      for i in 0..<count {
        if let lastPoint = points.last {
          let xa = lastPoint.x + dxa[i]
          let ya = lastPoint.y
          let xb = xa + dxb[i]
          let yb = ya + dyb[i]
          let xc = xb
          let yc = yb + dyc[i]
          let xd = xc
          let yd = yc + dyd[i]
          let xe = xd + dxe[i]
          let ye = yd + dye[i]
          let xf = xe + dxf[i]
          let yf = ye + (i == count - 1 ? dyf : 0)
          curveTo(cx1: xa, cy1: ya, cx2: xb, cy2: yb, x: xc, y: yc)
          curveTo(cx1: xd, cy1: yd, cx2: xe, cy2: ye, x: xf, y: yf)
        }
      }
    } else {
      let count = argCount / 8
      var dya = [Int]()
      var dxb = [Int]()
      var dyb = [Int]()
      var dxc = [Int]()
      var dxd = [Int]()
      var dxe = [Int]()
      var dye = [Int]()
      var dyf = [Int]()
      var dxf = 0
      if argCount % 4 == 1 {
        dxf = try popArg().intValue
      }
      for _ in 0..<count {
        try dyf.insert(popArg().intValue, at: 0)
        try dye.insert(popArg().intValue, at: 0)
        try dxe.insert(popArg().intValue, at: 0)
        try dxd.insert(popArg().intValue, at: 0)
        try dxc.insert(popArg().intValue, at: 0)
        try dyb.insert(popArg().intValue, at: 0)
        try dxb.insert(popArg().intValue, at: 0)
        try dya.insert(popArg().intValue, at: 0)
      }
      let dy3 = try popArg().intValue
      let dy2 = try popArg().intValue
      let dx2 = try popArg().intValue
      let dx1 = try popArg().intValue

      if let lastPoint = points.last {
        let x1 = lastPoint.x + dx1
        let y1 = lastPoint.y
        let x2 = x1 + dx2
        let y2 = y1 + dy2
        let x3 = x2 + (count == 0 ? dxf : 0)
        let y3 = y2 + dy3
        curveTo(cx1: x1, cy1: y1, cx2: x2, cy2: y2, x: x3, y: y3)
      }

      for i in 0..<count {
        if let lastPoint = points.last {
          let xa = lastPoint.x
          let ya = lastPoint.y + dya[i]
          let xb = xa + dxb[i]
          let yb = ya + dyb[i]
          let xc = xb + dxc[i]
          let yc = yb
          let xd = xc + dxd[i]
          let yd = yc
          let xe = xd + dxe[i]
          let ye = yd + dye[i]
          let xf = xe + (i == count - 1 ? dxf : 0)
          let yf = ye + dyf[i]
          curveTo(cx1: xa, cy1: ya, cx2: xb, cy2: yb, x: xc, y: yc)
          curveTo(cx1: xd, cy1: yd, cx2: xe, cy2: ye, x: xf, y: yf)
        }
      }
    }
    clearArg()
  }

  /**
   Is equivalent to one rrcurveto for each set of six arguments
   dxa...dyc, followed by exactly one rlineto using the dxd, dyd
   arguments. The number of curves is determined from the count
   on the argument stack.
   */
  private func _rcurveline() throws {
    let count = (argCount - 2) / 6
    var dxa = [Int]()
    var dya = [Int]()
    var dxb = [Int]()
    var dyb = [Int]()
    var dxc = [Int]()
    var dyc = [Int]()
    let dyd = try popArg().intValue
    let dxd = try popArg().intValue
    for _ in 0..<count {
      try dyc.insert(popArg().intValue, at: 0)
      try dxc.insert(popArg().intValue, at: 0)
      try dyb.insert(popArg().intValue, at: 0)
      try dxb.insert(popArg().intValue, at: 0)
      try dya.insert(popArg().intValue, at: 0)
      try dxa.insert(popArg().intValue, at: 0)
    }
    var xc = 0
    var yc = 0
    for i in 0..<count {
      if let lastPoint = points.last {
        let xa = lastPoint.x + dxa[i]
        let ya = lastPoint.y + dya[i]
        let xb = xa + dxb[i]
        let yb = ya + dyb[i]
        xc = xb + dxc[i]
        yc = yb + dyc[i]
        curveTo(cx1: xa, cy1: ya, cx2: xb, cy2: yb, x: xc, y: yc)
      }
    }
    lineTo(x: xc + dxd, y: yc + dyd)
    clearArg()
  }

  /**
   Is equivalent to one rlineto for each pair of arguments beyond
   the six arguments dxb...dyd needed for the one rrcurveto
   command. The number of lines is determined from the count of
   items on the argument stack.
   */
  private func _rlinecurve() throws {
    let count = (argCount - 6) / 2
    var dxa = [Int]()
    var dya = [Int]()
    let dyd = try popArg().intValue
    let dxd = try popArg().intValue
    let dyc = try popArg().intValue
    let dxc = try popArg().intValue
    let dyb = try popArg().intValue
    let dxb = try popArg().intValue
    for _ in 0..<count {
      try dya.insert(popArg().intValue, at: 0)
      try dxa.insert(popArg().intValue, at: 0)
    }
    var xa = 0
    var ya = 0
    for i in 0..<count {
      if let lastPoint = points.last {
        xa = lastPoint.x + dxa[i]
        ya = lastPoint.y + dya[i]
        lineTo(x: xa, y: ya)
      }
    }
    let xb = xa + dxb
    let yb = ya + dyb
    let xc = xb + dxc
    let yc = yb + dyc
    let xd = xc + dxd
    let yd = yc + dyd
    curveTo(cx1: xb, cy1: yb, cx2: xc, cy2: yc, x: xd, y: yd)
    clearArg()
  }

  /**
   Appends one or more Bezier curves to the current point, where
   the first tangent is vertical and the second tangent is horizontal.
   This command is the complement of hvcurveto; see the
   description of hvcurveto for more information.
   */
  private func _vhcurveto() throws {
    if argCount % 8 <= 1 {
      let count = argCount / 8
      var dya = [Int]()
      var dxb = [Int]()
      var dyb = [Int]()
      var dxc = [Int]()
      var dxd = [Int]()
      var dxe = [Int]()
      var dye = [Int]()
      var dyf = [Int]()
      var dxf = 0
      if argCount % 8 == 1 {
        dxf = try popArg().intValue
      }
      for _ in 0..<count {
        try dyf.insert(popArg().intValue, at: 0)
        try dye.insert(popArg().intValue, at: 0)
        try dxe.insert(popArg().intValue, at: 0)
        try dxd.insert(popArg().intValue, at: 0)
        try dxc.insert(popArg().intValue, at: 0)
        try dyb.insert(popArg().intValue, at: 0)
        try dxb.insert(popArg().intValue, at: 0)
        try dya.insert(popArg().intValue, at: 0)
      }
      for i in 0..<count {
        if let lastPoint = points.last {
          let xa = lastPoint.x
          let ya = lastPoint.y + dya[i]
          let xb = xa + dxb[i]
          let yb = ya + dyb[i]
          let xc = xb + dxc[i]
          let yc = yb
          let xd = xc + dxd[i]
          let yd = yc
          let xe = xd + dxe[i]
          let ye = yd + dye[i]
          let xf = xe + (i == count - 1 ? dxf : 0)
          let yf = ye + dyf[i]
          curveTo(cx1: xa, cy1: ya, cx2: xb, cy2: yb, x: xc, y: yc)
          curveTo(cx1: xd, cy1: yd, cx2: xe, cy2: ye, x: xf, y: yf)
        }
      }
    } else {
      let count = argCount / 8
      var dxa = [Int]()
      var dxb = [Int]()
      var dyb = [Int]()
      var dyc = [Int]()
      var dyd = [Int]()
      var dxe = [Int]()
      var dye = [Int]()
      var dxf = [Int]()
      var dyf = 0
      if argCount % 4 == 1 {
        dyf = try popArg().intValue
      }
      for _ in 0..<count {
        try dxf.insert(popArg().intValue, at: 0)
        try dye.insert(popArg().intValue, at: 0)
        try dxe.insert(popArg().intValue, at: 0)
        try dyd.insert(popArg().intValue, at: 0)
        try dyc.insert(popArg().intValue, at: 0)
        try dyb.insert(popArg().intValue, at: 0)
        try dxb.insert(popArg().intValue, at: 0)
        try dxa.insert(popArg().intValue, at: 0)
      }
      let dx3 = try popArg().intValue
      let dy2 = try popArg().intValue
      let dx2 = try popArg().intValue
      let dy1 = try popArg().intValue

      if let lastPoint = points.last {
        let x1 = lastPoint.x
        let y1 = lastPoint.y + dy1
        let x2 = x1 + dx2
        let y2 = y1 + dy2
        let x3 = x2 + dx3
        let y3 = y2 + (count == 0 ? dyf : 0)
        curveTo(cx1: x1, cy1: y1, cx2: x2, cy2: y2, x: x3, y: y3)
      }

      for i in 0..<count {
        if let lastPoint = points.last {
          let xa = lastPoint.x + dxa[i]
          let ya = lastPoint.y
          let xb = xa + dxb[i]
          let yb = ya + dyb[i]
          let xc = xb
          let yc = yb + dyc[i]
          let xd = xc
          let yd = yc + dyd[i]
          let xe = xd + dxe[i]
          let ye = yd + dye[i]
          let xf = xe + dxf[i]
          let yf = ye + (i == count - 1 ? dyf : 0)
          curveTo(cx1: xa, cy1: ya, cx2: xb, cy2: yb, x: xc, y: yc)
          curveTo(cx1: xd, cy1: yd, cx2: xe, cy2: ye, x: xf, y: yf)
        }
      }
    }
    clearArg()
  }

  /**
   Appends one or more curves to the current point. If the argument
   count is a multiple of four, the curve starts and ends vertical. If
   the argument count is odd, the first curve does not begin with a
   vertical tangent.
   */
  private func _vvcurveto() throws {
    let count = argCount / 4
    var dx1 = 0
    var dya = [Int]()
    var dxb = [Int]()
    var dyb = [Int]()
    var dyc = [Int]()
    for _ in 0..<count {
      try dyc.insert(popArg().intValue, at: 0)
      try dyb.insert(popArg().intValue, at: 0)
      try dxb.insert(popArg().intValue, at: 0)
      try dya.insert(popArg().intValue, at: 0)
    }
    if argCount == 1 {
      dx1 = try popArg().intValue
    }
    for i in 0..<count {
      if let lastPoint = points.last {
        let xa = lastPoint.x + (i == 0 ? dx1 : 0)
        let ya = lastPoint.y + dya[i]
        let xb = xa + dxb[i]
        let yb = ya + dyb[i]
        let xc = xb
        let yc = yb + dyc[i]
        curveTo(cx1: xa, cy1: ya, cx2: xb, cy2: yb, x: xc, y: yc)
      }
    }
    clearArg()
  }

  /**
   Causes two Bézier curves, as described by the arguments (as
   shown in Figure 2 below), to be rendered as a straight line when
   the flex depth is less than fd /100 device pixels, and as curved lines
   when the flex depth is greater than or equal to fd/100 device
   pixels.
   */
  private func _flex() {
    clearArg()
  }

  /**
   Causes the two curves described by the arguments dx1...dx6 to
   be rendered as a straight line when the flex depth is less than
   0.5 (that is, fd is 50) device pixels, and as curved lines when the
   flex depth is greater than or equal to 0.5 device pixels.
   */
  private func _hflex() {
    clearArg()
  }

  /**
   Causes the two curves described by the arguments to be
   rendered as a straight line when the flex depth is less than 0.5
   device pixels, and as curved lines when the flex depth is greater
   than or equal to 0.5 device pixels.
   */
  private func _hflex1() {
    clearArg()
  }

  /**
   Causes the two curves described by the arguments to be
   rendered as a straight line when the flex depth is less than 0.5
   device pixels, and as curved lines when the flex depth is greater
   than or equal to 0.5 device pixels.
   */
  private func _flex1() {
    clearArg()
  }

  /**
   Finishes a charstring outline definition, and must be the
   last operator in a character's outline.
   */
  private func _endchar() throws {
    endContour()
    clearArg()
    while subrStackIndex > 0 {
      (cs, ip) = try popSubr()
    }
  }

  /**
   Specifies one or more horizontal stem hints. This allows multiple pairs
   of numbers, limited by the stack depth, to be used as arguments to a
   single hstem operator.
   */
  private func _hstem() throws {
    let pairCount = argCount / 2
    for _ in 0..<pairCount {
      try hstems.insert(popArg().intValue, at: 0)
      try hstems.insert(popArg().intValue, at: 0)
    }

    if argCount > 0 {

      // This will be the width value
      _ = try popArg()
    }
  }

  /**
   Specifies one or more vertical stem hints between the x coordinates x
   and x+dx, where x is relative to the origin of the coordinate axes.
   */
  private func _vstem() throws {
    let pairCount = argCount / 2
    for _ in 0..<pairCount {
      try vstems.insert(popArg().intValue, at: 0)
      try vstems.insert(popArg().intValue, at: 0)
    }

    if argCount > 0 {

      // This will be the width value
      _ = try popArg()
    }
  }

  /**
   Has the same meaning as hstem, except that it must be used in place
   of hstem if the charstring contains one or more hintmask operators.
   */
  private func _hstemhm() throws {
    stemCount += argCount / 2
    let pairCount = argCount / 2
    for _ in 0..<pairCount {
      try hstems.insert(popArg().intValue, at: 0)
      try hstems.insert(popArg().intValue, at: 0)
    }

    if argCount > 0 {

      // This will be the width value
      _ = try popArg()
    }
  }

  /**
   Has the same meaning as vstem, except that it must be used in place
   of vstem if the charstring contains one or more hintmask operators.
   */
  private func _vstemhm() throws {
    stemCount += argCount / 2
    let pairCount = argCount / 2
    for _ in 0..<pairCount {
      try vstems.insert(popArg().intValue, at: 0)
      try vstems.insert(popArg().intValue, at: 0)
    }

    if argCount > 0 {

      // This will be the width value
      _ = try popArg()
    }
  }

  /**
   Specifies which hints are active and which are not active.
   */
  private func _hintmask() {
    stemCount += argCount / 2
    ip += (stemCount - 1) / 8 + 1
    clearArg()
  }

  /**
   Specifies the counter spaces to be controlled, and their
   relative priority.
   */
  private func _cntrmask() {
    stemCount += argCount / 2
    ip += (stemCount - 1) / 8 + 1
    clearArg()
  }

  /**
   Returns the absolute value of num.
   */
  private func _abs() throws {
    let num = try popArg().doubleValue
    pushArg(NSNumber(value: abs(num)))
  }

  /**
   Returns the sum of the two numbers num1 and num2.
   */
  private func _add() throws {
    let num2 = try popArg().doubleValue
    let num1 = try popArg().doubleValue
    pushArg(NSNumber(value: num1 + num2))
  }

  /**
   Returns the result of subtracting num2 from num1.
   */
  private func _sub() throws {
    let num2 = try popArg().doubleValue
    let num1 = try popArg().doubleValue
    pushArg(NSNumber(value: num1 - num2))
  }

  /**
   Returns the quotient of num1 divided by num2. The result is
   undefined if overflow occurs and is zero for underflow.
   */
  private func _div() throws {
    let num2 = try popArg().doubleValue
    let num1 = try popArg().doubleValue
    pushArg(NSNumber(value: num1 / num2))
  }

  /**
   Returns the negative of num.
   */
  private func _neg() throws {
    let num = try popArg().doubleValue
    pushArg(NSNumber(value: -num))
  }

  /**
   Returns a pseudo random number num2 in the range (0,1], that
   is, greater than zero and less than or equal to one.
   */
  private func _random() {
    pushArg(NSNumber(value: 1.0 - Double(arc4random()) / Double(UInt32.max)))
  }

  /**
   Returns the product of num1 and num2. If overflow occurs, the
   result is undefined, and zero is returned for underflow.
   */
  private func _mul() throws {
    let num2 = try popArg().doubleValue
    let num1 = try popArg().doubleValue
    pushArg(NSNumber(value: num1 * num2))
  }

  /**
   Returns the square root of num. If num is negative, the result is
   undefined.
   */
  private func _sqrt() throws {
    let num = try popArg().doubleValue
    pushArg(NSNumber(value: sqrt(num)))
  }

  /**
   Removes the top element num from the Type 2 argument stack.
   */
  private func _drop() throws {
    _ = try popArg()
  }

  /**
   Exchanges the top two elements on the argument stack.
   */
  private func _exch() throws {
    let num2 = try popArg()
    let num1 = try popArg()
    pushArg(num2)
    pushArg(num1)
  }

  /**
   Retrieves the element i from the top of the argument stack and
   pushes a copy of that element onto that stack. If i is negative,
   the top element is copied. If i is greater than X, the operation is
   undefined.
   */
  private func _index() throws {
    let i = try popArg().intValue
    var nums = [NSNumber]()
    for _ in 0..<i {
      try nums.append(popArg())
    }
    for j in i - 1...0 {
      pushArg(nums[j])
    }
    pushArg(nums[i])
  }

  /**
   Performs a circular shift of the elements num(N-1) ... num0 on
   the argument stack by the amount J. Positive J indicates upward
   motion of the stack; negative J indicates downward motion.
   The value N must be a non-negative integer, otherwise the
   operation is undefined.
   */
  private func _roll() throws {
    let j = try popArg().intValue
    let n = try popArg().intValue
    var nums = [NSNumber]()
    for _ in 0..<n {
      try nums.append(popArg())
    }
    for i in n - 1...0 {
      pushArg(nums[(n + i + j) % n])
    }
  }

  /**
   Duplicates the top element on the argument stack.
   */
  private func _dup() throws {
    let any = try popArg()
    pushArg(any)
    pushArg(any)
  }

  /**
   Stores val into the transient array at the location given by i.
   */
  private func _put() throws {
    let i = try popArg().intValue
    let val = try popArg()
    transientArray[i] = val
  }

  /**
   Retrieves the value stored in the transient array at the location
   given by i and pushes the value onto the argument stack. If get
   is executed prior to put for i during execution of the current
   charstring, the value returned is undefined.
   */
  private func _get() throws {
    let i = try popArg().intValue
    pushArg(transientArray[i])
  }

  /**
   Puts a 1 on the stack if num1 and num2 are both non-zero, and
   puts a 0 on the stack if either argument is zero.
   */
  private func _and() throws {
    let num2 = try popArg().doubleValue
    let num1 = try popArg().doubleValue
    pushArg((num1 != 0.0) && (num2 != 0.0) ? NSNumber(value: 1) : NSNumber(value: 0))
  }

  /**
   Puts a 1 on the stack if either num1 or num2 are non-zero, and
   puts a 0 on the stack if both arguments are zero.
   */
  private func _or() throws {
    let num2 = try popArg().doubleValue
    let num1 = try popArg().doubleValue
    pushArg((num1 != 0.0) || (num2 != 0.0) ? NSNumber(value: 1) : NSNumber(value: 0))
  }

  /**
   Returns a 0 if num1 is non-zero; returns a 1 if num1 is zero.
   */
  private func _not() throws {
    let num1 = try popArg().doubleValue
    pushArg((num1 != 0.0) ? NSNumber(value: 0) : NSNumber(value: 1))
  }

  /**
   Puts a 1 on the stack if num1 equals num2, otherwise a 0 (zero)
   is put on the stack.
   */
  private func _eq() throws {
    let num2 = try popArg().doubleValue
    let num1 = try popArg().doubleValue
    pushArg(num1 == num2 ? NSNumber(value: 1) : NSNumber(value: 0))
  }

  /**
   Leaves the value s1 on the stack if v1 ? v2, or leaves s2 on the
   stack if v1 > v2. The value of s1 and s2 is usually the biased
   number of a subroutine.
   */
  private func _ifelse() throws {
    let v2 = try popArg().doubleValue
    let v1 = try popArg().doubleValue
    let s2 = try popArg()
    let s1 = try popArg()
    pushArg(v1 <= v2 ? s1 : s2)
  }

  /**
   Calls a charstring subroutine with index subr# (actually the subr
   number plus the subroutine bias number, as described in section
   2.3) in the Subrs array. Each element of the Subrs array is a
   charstring encoded like any other charstring. Arguments
   pushed on the Type 2 argument stack prior to calling the
   subroutine, and results pushed on this stack by the subroutine,
   act according to the manner in which the subroutine is coded.
   Calling an undefined subr (gsubr) has undefined results.
   */
  private func _callsubr() throws {
    var bias: Int
    let subrsCount = localSubrIndex.count
    if subrsCount < 1240 {
      bias = 107
    } else if subrsCount < 33900 {
      bias = 1131
    } else {
      bias = 32768
    }
    let i = try popArg().intValue
    let offset = localSubrIndex.offset[i + bias] - 1
    pushSubr((cs, ip))
    cs = localSubrs
    ip = offset
  }

  /**
   Operates in the same manner as callsubr except that it calls a
   global subroutine.
   */
  private func _callgsubr() throws {
    var bias: Int
    let subrsCount = globalSubrIndex.count
    if subrsCount < 1240 {
      bias = 107
    } else if subrsCount < 33900 {
      bias = 1131
    } else {
      bias = 32768
    }
    let i = try popArg().intValue
    let offset = globalSubrIndex.offset[i + bias] - 1
    pushSubr((cs, ip))
    cs = globalSubrs
    ip = offset
  }

  /**
   Returns from either a local or global charstring subroutine, and
   continues execution after the corresponding call(g)subr.
   */
  private func _return() throws {
    (cs, ip) = try popSubr()
  }

  public func execute(cs: CFFCharstringType2) throws -> [CFFPoint] {
    self.cs = cs

    hstems = []
    vstems = []

    points = []
    ip = self.cs.firstIndex
    while self.cs.moreBytes(from: ip) {

      // Operand(s)
      while self.cs.isOperand(at: ip) {
        do {
          pushArg(try self.cs.operand(at: ip))
        } catch {
          os_log("Error with operand")
          throw CFFType2InterpreterError.badOperand
        }
        ip = self.cs.nextOperandIndex(ip)
      }

      // Operator
      var opr = Int(self.cs.byte(at: ip))
      ip += 1
      if opr == 12 {
        opr = Int(self.cs.byte(at: ip))
        ip += 1

        // Two-byte operators
        switch opr {
        case T2Mnemonic.AND:
          try _and()
        case T2Mnemonic.OR:
          try _or()
        case T2Mnemonic.NOT:
          try _not()
        case T2Mnemonic.ABS:
          try _abs()
        case T2Mnemonic.ADD:
          try _add()
        case T2Mnemonic.SUB:
          try _sub()
        case T2Mnemonic.DIV:
          try _div()
        case T2Mnemonic.NEG:
          try _neg()
        case T2Mnemonic.EQ:
          try _eq()
        case T2Mnemonic.DROP:
          try _drop()
        case T2Mnemonic.PUT:
          try _put()
        case T2Mnemonic.GET:
          try _get()
        case T2Mnemonic.IFELSE:
          try _ifelse()
        case T2Mnemonic.RANDOM:
          _random()
        case T2Mnemonic.MUL:
          try _mul()
        case T2Mnemonic.SQRT:
          try _sqrt()
        case T2Mnemonic.DUP:
          try _dup()
        case T2Mnemonic.EXCH:
          try _exch()
        case T2Mnemonic.INDEX:
          try _index()
        case T2Mnemonic.ROLL:
          try _roll()
        case T2Mnemonic.HFLEX:
          _hflex()
        case T2Mnemonic.FLEX:
          _flex()
        case T2Mnemonic.HFLEX1:
          _hflex1()
        case T2Mnemonic.FLEX1:
          _flex1()
        default:
          throw CFFType2InterpreterError.badOperator
        }
      } else {

        // One-byte operators
        switch (opr) {
        case T2Mnemonic.HSTEM:
          try _hstem()
        case T2Mnemonic.VSTEM:
          try _vstem()
        case T2Mnemonic.VMOVETO:
          try _vmoveto()
        case T2Mnemonic.RLINETO:
          try _rlineto()
        case T2Mnemonic.HLINETO:
          try _hlineto()
        case T2Mnemonic.VLINETO:
          try _vlineto()
        case T2Mnemonic.RRCURVETO:
          try _rrcurveto()
        case T2Mnemonic.CALLSUBR:
          try _callsubr()
        case T2Mnemonic.RETURN:
          try _return()
        case T2Mnemonic.ENDCHAR:
          try _endchar()
        case T2Mnemonic.HSTEMHM:
          try _hstemhm()
        case T2Mnemonic.HINTMASK:
          _hintmask()
        case T2Mnemonic.CNTRMASK:
          _cntrmask()
        case T2Mnemonic.RMOVETO:
          try _rmoveto()
        case T2Mnemonic.HMOVETO:
          try _hmoveto()
        case T2Mnemonic.VSTEMHM:
          try _vstemhm()
        case T2Mnemonic.RCURVELINE:
          try _rcurveline()
        case T2Mnemonic.RLINECURVE:
          try _rlinecurve()
        case T2Mnemonic.VVCURVETO:
          try _vvcurveto()
        case T2Mnemonic.HHCURVETO:
          try _hhcurveto()
        case T2Mnemonic.CALLGSUBR:
          try _callgsubr()
        case T2Mnemonic.VHCURVETO:
          try _vhcurveto()
        case T2Mnemonic.HVCURVETO:
          try _hvcurveto()
        default:
          throw CFFType2InterpreterError.badOperator
        }
      }
    }
    return points
  }

  /**
   The number of arguments on the argument stack
   */
  private var argCount: Int {
    get {
      return argStack.count
    }
  }

  /**
   Pop a value off the argument stack
   */
  private func popArg() throws -> NSNumber {
    if let arg = argStack.popLast() {
      return arg
    } else {
      throw CFFType2InterpreterError.stackUnderflow
    }
  }

  /**
   Push a value on to the argument stack
   */
  private func pushArg(_ n: NSNumber) {
    argStack.append(n)
  }

  /**
   Pop a value off the subroutine stack
   */
  private func popSubr() throws -> (CFFCharstringType2, Int) {
    if let subr = subrStack.popLast() {
      return subr
    } else {
      throw CFFType2InterpreterError.stackUnderflow
    }
  }

  /**
   Push a value on to the subroutine stack
   */
  private func pushSubr(_ sp: (CFFCharstringType2, Int)) {
    subrStack.append(sp)
  }

  /**
   Clear the argument stack
   */
  private func clearArg() {
    argStack.removeAll()
  }

  private func moveTo(x: Int, y: Int) {
    endContour()
    points.append(CFFPoint(x: x, y: y, onCurve: true, endOfContour: false))
  }

  private func lineTo(x: Int, y: Int) {
    points.append(CFFPoint(x: x, y: y, onCurve: true, endOfContour: false))
  }

  private func curveTo(cx1: Int, cy1: Int, cx2: Int, cy2: Int, x: Int, y: Int) {
    points.append(CFFPoint(x: cx1, y: cy1, onCurve: false, endOfContour: false))
    points.append(CFFPoint(x: cx2, y: cy2, onCurve: false, endOfContour: false))
    points.append(CFFPoint(x: x, y: y, onCurve: true, endOfContour: false))
  }

  private func endContour() {
    if let lastPoint = points.last {
      lastPoint.endOfContour = true
    }
  }
}
