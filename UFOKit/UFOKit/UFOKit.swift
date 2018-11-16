//
//  UFOKit.swift
//  UFOKit
//
//  Created by David Schweinsberg on 10/16/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Foundation

public struct DirectoryName {
  public static let defaultGlyphsDirName = "glyphs"
}

public struct Filename {
  public static let metaInfoFilename = "metainfo.plist"
  public static let fontInfoFilename = "fontinfo.plist"
  public static let libFilename = "lib.plist"
  public static let groupsFilename = "groups.plist"
  public static let kerningFilename = "kerning.plist"
  public static let featuresFilename = "features.fea"
  public static let layerContentsFilename = "layercontents.plist"
  public static let layerInfoFilename = "layerinfo.plist"
  public static let contentsFilename = "contents.plist"
}

public struct LayerName {
  public static let defaultLayerName = "public.default"
}

public struct FileCreator {
  public static let defaultFileCreator = "com.typista.UFOKit"
}

public enum GlifError: Error {
  case moreThanOneOutline
  case moreThanOneAdvance
  case moreThanOneImage
  case moreThanOneNote
  case moreThanOneLib
  case illegalUnicodeValue
}

public enum UFOError: Error {
  case unsupportedVersion
  case notDirectoryPath
  case glyphNameNotFound
  case cannotConvertValue
  case cannotSaveToEarlierVersion
  case advanceValueMissing
  case pathNotBegun
  case currentPathNotEnded
  case openContourEndsOffCurve
  case moveMustBeFirst
  case offCurveNotFollowedByCurve
  case tooManyOffCurvesBeforeCurve
  case offCurveCannotBeSmooth
}

public enum UFOFormatVersion: Int, Codable {
  case version1 = 1
  case version2 = 2
  case version3 = 3
}

public struct MetaInfo: Codable {
  let creator: String
  let formatVersion: UFOFormatVersion
}
