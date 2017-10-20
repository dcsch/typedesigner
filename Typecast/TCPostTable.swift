//
//  TCPostTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/3/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils

class TCPostTable: TCBaseTable, Codable {
  let version: UInt32
  let italicAngle: UInt32
  let underlinePosition: Int16
  let underlineThickness: Int16
  let isFixedPitch: UInt32
  let minMemType42: UInt32
  let maxMemType42: UInt32
  let minMemType1: UInt32
  let maxMemType1: UInt32

  // v2
  let numGlyphs: Int
  let glyphNameIndex: [Int]
  let psGlyphName: [String]

  static let macGlyphName = [
    ".notdef",      // 0
    "null",         // 1
    "CR",           // 2
    "space",        // 3
    "exclam",       // 4
    "quotedbl",     // 5
    "numbersign",   // 6
    "dollar",       // 7
    "percent",      // 8
    "ampersand",    // 9
    "quotesingle",  // 10
    "parenleft",    // 11
    "parenright",   // 12
    "asterisk",     // 13
    "plus",         // 14
    "comma",        // 15
    "hyphen",       // 16
    "period",       // 17
    "slash",        // 18
    "zero",         // 19
    "one",          // 20
    "two",          // 21
    "three",        // 22
    "four",         // 23
    "five",         // 24
    "six",          // 25
    "seven",        // 26
    "eight",        // 27
    "nine",         // 28
    "colon",        // 29
    "semicolon",    // 30
    "less",         // 31
    "equal",        // 32
    "greater",      // 33
    "question",     // 34
    "at",           // 35
    "A",            // 36
    "B",            // 37
    "C",            // 38
    "D",            // 39
    "E",            // 40
    "F",            // 41
    "G",            // 42
    "H",            // 43
    "I",            // 44
    "J",            // 45
    "K",            // 46
    "L",            // 47
    "M",            // 48
    "N",            // 49
    "O",            // 50
    "P",            // 51
    "Q",            // 52
    "R",            // 53
    "S",            // 54
    "T",            // 55
    "U",            // 56
    "V",            // 57
    "W",            // 58
    "X",            // 59
    "Y",            // 60
    "Z",            // 61
    "bracketleft",  // 62
    "backslash",    // 63
    "bracketright", // 64
    "asciicircum",  // 65
    "underscore",   // 66
    "grave",        // 67
    "a",            // 68
    "b",            // 69
    "c",            // 70
    "d",            // 71
    "e",            // 72
    "f",            // 73
    "g",            // 74
    "h",            // 75
    "i",            // 76
    "j",            // 77
    "k",            // 78
    "l",            // 79
    "m",            // 80
    "n",            // 81
    "o",            // 82
    "p",            // 83
    "q",            // 84
    "r",            // 85
    "s",            // 86
    "t",            // 87
    "u",            // 88
    "v",            // 89
    "w",            // 90
    "x",            // 91
    "y",            // 92
    "z",            // 93
    "braceleft",    // 94
    "bar",          // 95
    "braceright",   // 96
    "asciitilde",   // 97
    "Adieresis",    // 98
    "Aring",        // 99
    "Ccedilla",     // 100
    "Eacute",       // 101
    "Ntilde",       // 102
    "Odieresis",    // 103
    "Udieresis",    // 104
    "aacute",       // 105
    "agrave",       // 106
    "acircumflex",  // 107
    "adieresis",    // 108
    "atilde",       // 109
    "aring",        // 110
    "ccedilla",     // 111
    "eacute",       // 112
    "egrave",       // 113
    "ecircumflex",  // 114
    "edieresis",    // 115
    "iacute",       // 116
    "igrave",       // 117
    "icircumflex",  // 118
    "idieresis",    // 119
    "ntilde",       // 120
    "oacute",       // 121
    "ograve",       // 122
    "ocircumflex",  // 123
    "odieresis",    // 124
    "otilde",       // 125
    "uacute",       // 126
    "ugrave",       // 127
    "ucircumflex",  // 128
    "udieresis",    // 129
    "dagger",       // 130
    "degree",       // 131
    "cent",         // 132
    "sterling",     // 133
    "section",      // 134
    "bullet",       // 135
    "paragraph",    // 136
    "germandbls",   // 137
    "registered",   // 138
    "copyright",    // 139
    "trademark",    // 140
    "acute",        // 141
    "dieresis",     // 142
    "notequal",     // 143
    "AE",           // 144
    "Oslash",       // 145
    "infinity",     // 146
    "plusminus",    // 147
    "lessequal",    // 148
    "greaterequal", // 149
    "yen",          // 150
    "mu",           // 151
    "partialdiff",  // 152
    "summation",    // 153
    "product",      // 154
    "pi",           // 155
    "integral'",    // 156
    "ordfeminine",  // 157
    "ordmasculine", // 158
    "Omega",        // 159
    "ae",           // 160
    "oslash",       // 161
    "questiondown", // 162
    "exclamdown",   // 163
    "logicalnot",   // 164
    "radical",      // 165
    "florin",       // 166
    "approxequal",  // 167
    "increment",    // 168
    "guillemotleft",// 169
    "guillemotright",//170
    "ellipsis",     // 171
    "nbspace",      // 172
    "Agrave",       // 173
    "Atilde",       // 174
    "Otilde",       // 175
    "OE",           // 176
    "oe",           // 177
    "endash",       // 178
    "emdash",       // 179
    "quotedblleft", // 180
    "quotedblright",// 181
    "quoteleft",    // 182
    "quoteright",   // 183
    "divide",       // 184
    "lozenge",      // 185
    "ydieresis",    // 186
    "Ydieresis",    // 187
    "fraction",     // 188
    "currency",     // 189
    "guilsinglleft",// 190
    "guilsinglright",//191
    "fi",           // 192
    "fl",           // 193
    "daggerdbl",    // 194
    "middot",       // 195
    "quotesinglbase",//196
    "quotedblbase", // 197
    "perthousand",  // 198
    "Acircumflex",  // 199
    "Ecircumflex",  // 200
    "Aacute",       // 201
    "Edieresis",    // 202
    "Egrave",       // 203
    "Iacute",       // 204
    "Icircumflex",  // 205
    "Idieresis",    // 206
    "Igrave",       // 207
    "Oacute",       // 208
    "Ocircumflex",  // 209
    "apple",        // 210
    "Ograve",       // 211
    "Uacute",       // 212
    "Ucircumflex",  // 213
    "Ugrave",       // 214
    "dotlessi",     // 215
    "circumflex",   // 216
    "tilde",        // 217
    "overscore",    // 218
    "breve",        // 219
    "dotaccent",    // 220
    "ring",         // 221
    "cedilla",      // 222
    "hungarumlaut", // 223
    "ogonek",       // 224
    "caron",        // 225
    "Lslash",       // 226
    "lslash",       // 227
    "Scaron",       // 228
    "scaron",       // 229
    "Zcaron",       // 230
    "zcaron",       // 231
    "brokenbar",    // 232
    "Eth",          // 233
    "eth",          // 234
    "Yacute",       // 235
    "yacute",       // 236
    "Thorn",        // 237
    "thorn",        // 238
    "minus",        // 239
    "multiply",     // 240
    "onesuperior",  // 241
    "twosuperior",  // 242
    "threesuperior",// 243
    "onehalf",      // 244
    "onequarter",   // 245
    "threequarters",// 246
    "franc",        // 247
    "Gbreve",       // 248
    "gbreve",       // 249
    "Idot",         // 250
    "Scedilla",     // 251
    "scedilla",     // 252
    "Cacute",       // 253
    "cacute",       // 254
    "Ccaron",       // 255
    "ccaron",       // 256
    "dcroat"        // 257
  ]

  override init() {
    version = 0
    italicAngle = 0
    underlinePosition = 0
    underlineThickness = 0
    isFixedPitch = 0
    minMemType42 = 0
    maxMemType42 = 0
    minMemType1 = 0
    maxMemType1 = 0
    numGlyphs = 0
    glyphNameIndex = []
    psGlyphName = []
    super.init()
  }

  init(data: Data) {
    let dataInput = TCDataInput(data: data)
    version = dataInput.readUInt32()
    italicAngle = dataInput.readUInt32()
    underlinePosition = dataInput.readInt16()
    underlineThickness = dataInput.readInt16()
    isFixedPitch = dataInput.readUInt32()
    minMemType42 = dataInput.readUInt32()
    maxMemType42 = dataInput.readUInt32()
    minMemType1 = dataInput.readUInt32()
    maxMemType1 = dataInput.readUInt32()

    if version == 0x00020000 {
      numGlyphs = Int(dataInput.readUInt16())
      var indicies = [Int]()
      for _ in 0..<numGlyphs {
        indicies.append(Int(dataInput.readUInt16()))
      }
      glyphNameIndex = indicies

//      var h = highestGlyphNameIndex()

      var high = 0
      for i in 0..<numGlyphs {
        if high < glyphNameIndex[i] {
          high = glyphNameIndex[i]
        }
      }
      if high > 257 {
        high -= 257
      }
      var psGlyphName = [String]()
      for _ in 0..<high {
        let len = Int(dataInput.readUInt8())
        let stringBytes = dataInput.read(length: len)
        if let str = String(bytes: stringBytes, encoding: .ascii) {
          psGlyphName.append(str)
        } else {
          psGlyphName.append("")
        }
      }
      self.psGlyphName = psGlyphName
    } else if (version == 0x00025000) {
      numGlyphs = 0
      glyphNameIndex = []
      psGlyphName = []
    } else if (version == 0x00030000) {
      numGlyphs = 0
      glyphNameIndex = []
      psGlyphName = []
    } else {
      numGlyphs = 0
      glyphNameIndex = []
      psGlyphName = []
    }
    super.init()
  }

  override class var tag: UInt32 {
    get {
      return TCTableTag.post.rawValue
    }
  }

//  func highestGlyphNameIndex() -> UInt16 {
//    var high: UInt16 = 0
//    for i in 0..<Int(numGlyphs) {
//      if high < glyphNameIndex[i] {
//        high = glyphNameIndex[i]
//      }
//    }
//    return high;
//  }

  func isMacGlyphName(at index: Int) -> Bool {
    if version == 0x00020000 {
      return glyphNameIndex[index] <= 257
    } else {
      return false
    }
  }

  override var description: String {
    get {
      var str = String(format:
        "'post' Table - PostScript Metrics\n---------------------------------\n" +
        "\n        'post' version:        %x" + //).append(Fixed.floatValue(version))
        "\n        italicAngle:           %x" + //).append(Fixed.floatValue(italicAngle))
        "\n        underlinePosition:     %d" + //).append(underlinePosition)
        "\n        underlineThickness:    %d" + //).append(underlineThickness)
        "\n        isFixedPitch:          %d" + //).append(isFixedPitch)
        "\n        minMemType42:          %d" + //).append(minMemType42)
        "\n        maxMemType42:          %d" + //).append(maxMemType42)
        "\n        minMemType1:           %d" + //).append(minMemType1)
        "\n        maxMemType1:           %d", //).append(maxMemType1);
        version,
        italicAngle,
        underlinePosition,
        underlineThickness,
        isFixedPitch,
        minMemType42,
        maxMemType42,
        minMemType1,
        maxMemType1)

      if version == 0x00020000 {
        str.append("\n\n        Format 2.0:  Non-Standard (for PostScript) TrueType Glyph Set.\n")
        str.append("        numGlyphs:      \(numGlyphs)\n")
        for i in 0..<numGlyphs {
          str.append("        Glyf \(i) -> ")
          if isMacGlyphName(at: i) {
            let nameIndex = glyphNameIndex[i]
            let name = TCPostTable.macGlyphName[nameIndex]
            str.append("Mac Glyph # \(nameIndex), '\(name)'\n")
          } else {
            let nameIndex = glyphNameIndex[i] - 257
            let name = psGlyphName[nameIndex - 1]
            str.append("PSGlyf Name # \(nameIndex), name= '\(name)'\n")
          }
        }
        str.append("\n        Full List of PSGlyf Names\n        ------------------------\n")
        for (i, name) in psGlyphName.enumerated() {
          str.append("        PSGlyf Name # \(i + 1): \(name)\n")
        }
      }
      return str
    }
  }
}
