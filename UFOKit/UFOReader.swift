//
//  UFOReader.swift
//  UFOKit
//
//  Created by David Schweinsberg on 12/22/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

public class UFOReader {
  public let url: URL
  public let metaInfo: MetaInfo

  public init(url: URL) throws {
    self.url = url
    metaInfo = try UFOReader.readMetaInfo(url: url)
  }

  class func readMetaInfo(url: URL) throws -> MetaInfo {
    let metaInfoURL = url.appendingPathComponent(Filename.metaInfoFilename)
    let metaInfoData = try Data(contentsOf: metaInfoURL)
    let decoder = PropertyListDecoder()
    return try decoder.decode(MetaInfo.self, from: metaInfoData)
  }

  public func readGroups() throws -> [String: [String]] {
    let groupsURL = url.appendingPathComponent(Filename.groupsFilename)
    let groupsData = try Data(contentsOf: groupsURL)
    let decoder = PropertyListDecoder()
    return try decoder.decode([String: [String]].self, from: groupsData)
  }

  public func readInfo() throws -> FontInfo {
    let infoURL = url.appendingPathComponent(Filename.fontInfoFilename)
    let infoData = try Data(contentsOf: infoURL)
    let decoder = PropertyListDecoder()
    if metaInfo.formatVersion == .version1 {
      let fontInfoV1 = try decoder.decode(FontInfoV1.self, from: infoData)
      return try FontInfo(fontInfoV1: fontInfoV1)
    }
    return try decoder.decode(FontInfo.self, from: infoData)
  }

  public func readKerning() throws -> [String: [String: Int]] {
    let kerningURL = url.appendingPathComponent(Filename.kerningFilename)
    let kerningData = try Data(contentsOf: kerningURL)
    let decoder = PropertyListDecoder()
    return try decoder.decode([String: [String: Int]].self, from: kerningData)
  }

  public func readLib() throws -> Data {
    let libURL = url.appendingPathComponent(Filename.libFilename)
    return try Data(contentsOf: libURL)
  }

  public func readFeatures() throws -> String {
    let featuresURL = url.appendingPathComponent(Filename.featuresFilename)
    let featuresData = try Data(contentsOf: featuresURL)
    return String(data: featuresData, encoding: .ascii) ?? ""
  }

  class func readLayerContents(url: URL) throws -> [(String, String)] {
    let layerContentsURL = url.appendingPathComponent(Filename.layerContentsFilename)
    let layerContentsData = try Data(contentsOf: layerContentsURL)
    let decoder = PropertyListDecoder()
    let layerArrays = try decoder.decode([[String]].self, from: layerContentsData)

    // Convert the arrays into tuples
    var layerContents = [(String, String)]()
    for layer in layerArrays {
      layerContents.append((layer[0], layer[1]))
    }
    return layerContents
  }

  public func glyphSet() throws -> GlyphSet {
    let glyphDirURL = url.appendingPathComponent(DirectoryName.defaultGlyphsDirName)
    return try GlyphSet(dirURL: glyphDirURL, ufoFormatVersion: metaInfo.formatVersion)
  }

  public func characterMapping() throws -> [Int: [String]] {
    var characterMap: [Int: [String]] = [:]
    let glyphSet = try self.glyphSet()
    let unicodes = try glyphSet.unicodes()
    for (glyphName, unicodes) in unicodes {
      for unicode in unicodes {
        if var glyphNames = characterMap[unicode] {
          glyphNames.append(glyphName)
        } else {
          characterMap[unicode] = [glyphName]
        }
      }
    }
    return characterMap
  }

}
