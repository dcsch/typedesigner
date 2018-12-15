//
//  UCD.swift
//  Type Designer
//
//  Created by David Schweinsberg on 12/7/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log

class UCD {

  enum GeneralCategory {
    case uppercaseLetter
    case lowercaseLetter
    case titlecaseLetter
    case modifierLetter
    case otherLetter
    case nonspacingMark
    case spacingMark
    case enclosingMark
    case decimalNumber
    case letterNumber
    case otherNumber
    case connectorPunctuation
    case dashPunctuation
    case openPunctuation
    case closePunctuation
    case initialPunctuation
    case finalPunctuation
    case otherPunctuation
    case mathSymbol
    case currencySymbol
    case modifierSymbol
    case otherSymbol
    case spaceSeparator
    case lineSeparator
    case paragraphSeparator
    case control
    case format
    case surrogate
    case privateUse
    case unassigned
  }

  enum BidirectionalClass {
    case leftToRight
    case rightToLeft
    case arabicLetter
    case europeanNumber
    case europeanSeparator
    case europeanTerminator
    case arabicNumber
    case commonSeparator
    case nonspacingMark
    case boundaryNeutral
    case paragraphSeparator
    case segmentSeparator
    case whiteSpace
    case otherNeutral
    case leftToRightEmbedding
    case leftToRightOverride
    case rightToLeftEmbedding
    case rightToLeftOverride
    case popDirectionalFormat
    case leftToRightIsolate
    case rightToLeftIsolate
    case firstStringIsolate
    case popDirectionalIsolate
  }

  enum CompatibilityFormattingTag {
    case font
    case noBreak
    case initial
    case medial
    case final
    case isolated
    case circle
    case superscriptForm
    case subscriptForm
    case vertical
    case wide
    case narrow
    case small
    case square
    case fraction
    case compatibility
  }

  struct DecompositionMapping {
    var compatibilityFormattingTag: CompatibilityFormattingTag?
    var codePoints: [Unicode.Scalar]
  }

  struct Block {
    var name: String
    var range: ClosedRange<Int>
  }

  struct UnicodeData {
    var codeValue: Unicode.Scalar
    var characterName: String
    var generalCategory: GeneralCategory
    var canonicalCombiningClasses: Int
    var bidirectionalClass: BidirectionalClass
    var decompositionMapping: DecompositionMapping?
  }

  var blocks: [Block]
  var unicodeData: [Unicode.Scalar: UnicodeData]

  init() {
    blocks = []
    unicodeData = [:]

    if let url = Bundle.main.url(forResource: "Blocks", withExtension: "txt", subdirectory: "ucd") {
      do {
        let contents = try String(contentsOf: url, encoding: .utf8)
        let lines = contents.components(separatedBy: .newlines)
        let separator = CharacterSet.init(charactersIn: ";")
        for line in lines {
          if line.starts(with: "#") || line.isEmpty {
            continue
          }
          let elements = line.components(separatedBy: separator)

          // First component is a unicode range, the second is the block name
          var range: ClosedRange<Int>?
          let rangeStr = elements[0]
          if var sepIndex = rangeStr.firstIndex(of: ".") {
            let beginStr = rangeStr.prefix(upTo: sepIndex)
            sepIndex = rangeStr.index(after: sepIndex)
            sepIndex = rangeStr.index(after: sepIndex)
            let endStr = rangeStr.suffix(from: sepIndex)
            if let begin = Int(beginStr, radix: 16),
              let end = Int(endStr, radix: 16) {
              range = begin...end
            }
          }
          if let range = range {
            blocks.append(Block(name: elements[1].trimmingCharacters(in: .whitespaces), range: range))
          }
        }
      } catch {
        os_log("Error loading Blocks.txt")
      }
    }

    if let url = Bundle.main.url(forResource: "UnicodeData", withExtension: "txt", subdirectory: "ucd") {
      do {
        let contents = try String(contentsOf: url, encoding: .utf8)
        let lines = contents.components(separatedBy: .newlines)
        let separator = CharacterSet.init(charactersIn: ";")
        for line in lines {
          let elements = line.components(separatedBy: separator)

          if let codeInt = Int(elements[0], radix: 16),
            let codeValue = Unicode.Scalar(codeInt),
            let canonicalCombiningClasses = Int(elements[3]) {
            let characterName = elements[1]

            let generalCategory: GeneralCategory?

            switch (elements[2]) {
            case "Lu":
              generalCategory = .uppercaseLetter
            case "Ll":
              generalCategory = .lowercaseLetter
            case "Lt":
              generalCategory = .titlecaseLetter
            case "Lm":
              generalCategory = .modifierLetter
            case "Lo":
              generalCategory = .otherLetter
            case "Mn":
              generalCategory = .nonspacingMark
            case "Mc":
              generalCategory = .spacingMark
            case "Me":
              generalCategory = .enclosingMark
            case "Nd":
              generalCategory = .decimalNumber
            case "Nl":
              generalCategory = .letterNumber
            case "No":
              generalCategory = .otherNumber
            case "Pc":
              generalCategory = .connectorPunctuation
            case "Pd":
              generalCategory = .dashPunctuation
            case "Ps":
              generalCategory = .openPunctuation
            case "Pe":
              generalCategory = .closePunctuation
            case "Pi":
              generalCategory = .initialPunctuation
            case "Pf":
              generalCategory = .finalPunctuation
            case "Po":
              generalCategory = .otherPunctuation
            case "Sm":
              generalCategory = .mathSymbol
            case "Sc":
              generalCategory = .currencySymbol
            case "Sk":
              generalCategory = .modifierSymbol
            case "So":
              generalCategory = .otherSymbol
            case "Zs":
              generalCategory = .spaceSeparator
            case "Zl":
              generalCategory = .lineSeparator
            case "Zp":
              generalCategory = .paragraphSeparator
            case "Cc":
              generalCategory = .control
            case "Cf":
              generalCategory = .format
            case "Cs":
              generalCategory = .surrogate
            case "Co":
              generalCategory = .privateUse
            case "Cn":
              generalCategory = .unassigned
            default:
              generalCategory = .unassigned
            }

            let bidirectionalClass: BidirectionalClass?

            switch (elements[4]) {
            case "L":
              bidirectionalClass = .leftToRight
            case "R":
              bidirectionalClass = .rightToLeft
            case "AL":
              bidirectionalClass = .arabicLetter
            case "EN":
              bidirectionalClass = .europeanNumber
            case "ES":
              bidirectionalClass = .europeanSeparator
            case "ET":
              bidirectionalClass = .europeanTerminator
            case "AN":
              bidirectionalClass = .arabicNumber
            case "CS":
              bidirectionalClass = .commonSeparator
            case "NSM":
              bidirectionalClass = .nonspacingMark
            case "BN":
              bidirectionalClass = .boundaryNeutral
            case "B":
              bidirectionalClass = .paragraphSeparator
            case "S":
              bidirectionalClass = .segmentSeparator
            case "WS":
              bidirectionalClass = .whiteSpace
            case "ON":
              bidirectionalClass = .otherNeutral
            case "LRE":
              bidirectionalClass = .leftToRightEmbedding
            case "LRO":
              bidirectionalClass = .leftToRightOverride
            case "RLE":
              bidirectionalClass = .rightToLeftEmbedding
            case "RLO":
              bidirectionalClass = .rightToLeftOverride
            case "PDF":
              bidirectionalClass = .popDirectionalFormat
            case "LRI":
              bidirectionalClass = .leftToRightIsolate
            case "RLI":
              bidirectionalClass = .rightToLeftIsolate
            case "FSI":
              bidirectionalClass = .firstStringIsolate
            case "PDI":
              bidirectionalClass = .popDirectionalIsolate
            default:
              bidirectionalClass = .leftToRight
            }

            let compatibilityFormattingTag: CompatibilityFormattingTag?
            let codePoints: [Unicode.Scalar]?
            let decompositionMappingStr = elements[5]
            if !decompositionMappingStr.isEmpty {
              let elements = decompositionMappingStr.components(separatedBy: .whitespaces)
              let codePointStrings: ArraySlice<String>
              if elements[0].hasPrefix("<") {
                switch (elements[0]) {
                case "<font>":
                  compatibilityFormattingTag = .font
                case "<noBreak>":
                  compatibilityFormattingTag = .noBreak
                case "<initial>":
                  compatibilityFormattingTag = .initial
                case "<medial>":
                  compatibilityFormattingTag = .medial
                case "<final>":
                  compatibilityFormattingTag = .final
                case "<isolated>":
                  compatibilityFormattingTag = .isolated
                case "<circle>":
                  compatibilityFormattingTag = .circle
                case "<super>":
                  compatibilityFormattingTag = .superscriptForm
                case "<sub>":
                  compatibilityFormattingTag = .subscriptForm
                case "<vertical>":
                  compatibilityFormattingTag = .vertical
                case "<wide>":
                  compatibilityFormattingTag = .wide
                case "<narrow>":
                  compatibilityFormattingTag = .narrow
                case "<small>":
                  compatibilityFormattingTag = .small
                case "<square>":
                  compatibilityFormattingTag = .square
                case "<fraction>":
                  compatibilityFormattingTag = .fraction
                case "<compat>":
                  compatibilityFormattingTag = .compatibility
                default:
                  compatibilityFormattingTag = nil
                }
                codePointStrings = elements.dropFirst()
              } else {
                compatibilityFormattingTag = nil
                codePointStrings = ArraySlice(elements)
              }
              codePoints = codePointStrings.map {
                Unicode.Scalar(Int($0, radix: 16) ?? 0) ?? Unicode.Scalar(UInt8(0))
              }
            } else {
              compatibilityFormattingTag = nil
              codePoints = nil
            }

            let decompositionMapping: DecompositionMapping?
            if let codePoints = codePoints {
              decompositionMapping = DecompositionMapping(compatibilityFormattingTag: compatibilityFormattingTag,
                                                          codePoints: codePoints)
            } else {
              decompositionMapping = nil
            }

            unicodeData[codeValue] = UnicodeData(codeValue: codeValue,
                                                 characterName: characterName,
                                                 generalCategory: generalCategory ?? .unassigned,
                                                 canonicalCombiningClasses: canonicalCombiningClasses,
                                                 bidirectionalClass: bidirectionalClass ?? .leftToRight,
                                                 decompositionMapping: decompositionMapping)
          }
        }
      } catch {
        os_log("Error loading UnicodeData")
      }
    }

  }
}
