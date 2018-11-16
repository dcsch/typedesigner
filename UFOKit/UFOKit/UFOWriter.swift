//
//  UFOWriter.swift
//  UFOKit
//
//  Created by David Schweinsberg on 10/15/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Foundation

public class UFOWriter {
  public let url: URL
  public let formatVersion: UFOFormatVersion
  public let fileCreator: String
  public let layerContents: [(String, String)]

  public init(url: URL, formatVersion: UFOFormatVersion = .version3,
              fileCreator: String = FileCreator.defaultFileCreator) throws {
    self.url = url
    self.formatVersion = formatVersion
    self.fileCreator = fileCreator

    // Does the file already exist? If so, what version is it?
    var previousFormatVersion: UFOFormatVersion?
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: url.path) {
      let metaInfo = try UFOReader.readMetaInfo(url: url)
      previousFormatVersion = metaInfo.formatVersion
      if previousFormatVersion!.rawValue > formatVersion.rawValue {
        throw UFOError.cannotSaveToEarlierVersion
      }
    } else {
      try fileManager.createDirectory(at: url, withIntermediateDirectories: false)
    }

    // Use any existing layer contents, otherwise we have to create them
    if let version = previousFormatVersion, version == .version3 {
      self.layerContents = try UFOReader.readLayerContents(url: url)
    } else {
      let defaultGlyphsURL = url.appendingPathComponent(DirectoryName.defaultGlyphsDirName)
      if fileManager.fileExists(atPath: defaultGlyphsURL.path) {
        self.layerContents = [(LayerName.defaultLayerName, DirectoryName.defaultGlyphsDirName)]
      } else {
        self.layerContents = [(String, String)]()
      }
    }

    try writeMetaInfo()
  }

  func writeMetaInfo() throws {
    let metaInfo = MetaInfo(creator: fileCreator,
                            formatVersion: formatVersion)
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    let metaInfoData = try encoder.encode(metaInfo)
    let metaInfoURL = url.appendingPathComponent(Filename.metaInfoFilename)
    try metaInfoData.write(to: metaInfoURL)
  }

  public func writeGroups(_ groups: [String: [String]]) throws {
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    let groupsData = try encoder.encode(groups)
    let groupsURL = url.appendingPathComponent(Filename.groupsFilename)
    try groupsData.write(to: groupsURL)
  }

  public func writeInfo(_ info: FontInfo) throws {
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    let infoData = try encoder.encode(info)
    let infoURL = url.appendingPathComponent(Filename.fontInfoFilename)
    try infoData.write(to: infoURL)
  }

  public func writeKerning(_ kerning: [String: [String: Int]]) throws {
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    let kerningData = try encoder.encode(kerning)
    let kerningURL = url.appendingPathComponent(Filename.kerningFilename)
    try kerningData.write(to: kerningURL)
  }

  public func writeLib(_ libData: Data) throws {
    let libURL = url.appendingPathComponent(Filename.libFilename)
    try libData.write(to: libURL)
  }

  public func writeFeatures(_ features: String) throws {
    let featuresData = features.data(using: .ascii) ?? Data()
    let featuresURL = url.appendingPathComponent(Filename.fontInfoFilename)
    try featuresData.write(to: featuresURL)
  }

  public func writeLayerContents() throws {
    if [.version1, .version2].contains(formatVersion) {
      return
    }

    // Convert the tuples into arrays
    var layerArrays = [[String]]()
    for layer in layerContents {
      layerArrays.append([layer.0, layer.1])
    }
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    let layerContentsData = try encoder.encode(layerArrays)
    let layerContentsURL = url.appendingPathComponent(Filename.layerContentsFilename)
    try layerContentsData.write(to: layerContentsURL)
  }

  public func glyphSet() throws -> GlyphSet {
    let glyphDirURL = url.appendingPathComponent(DirectoryName.defaultGlyphsDirName,
                                                 isDirectory: true)
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: glyphDirURL.path) {
      try fileManager.createDirectory(at: glyphDirURL, withIntermediateDirectories: false)
    }
    return try GlyphSet(dirURL: glyphDirURL, ufoFormatVersion: formatVersion)
  }

}
