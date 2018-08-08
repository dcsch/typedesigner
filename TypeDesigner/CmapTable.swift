//
//  TCCmapTable.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/6/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils
import os.log

class CmapTable: Table, Codable {

  class IndexEntry: Codable {
    let platformID: ID.Platform
    let encodingID: Encoding
    let mappingIndex: Int

    init(platformID: ID.Platform, encodingID: Encoding, mappingIndex: Int) {
      self.platformID = platformID
      self.encodingID = encodingID
      self.mappingIndex = mappingIndex
    }

    private enum CodingKeys: String, CodingKey {
      case platformID
      case encodingID
      case mappingIndex
    }

    required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      platformID = try container.decode(ID.Platform.self, forKey: .platformID)
      let encodingInt = try container.decode(Int.self, forKey: .encodingID)
      encodingID = platformID.encoding(id: encodingInt)!
      mappingIndex = try container.decode(Int.self, forKey: .mappingIndex)
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(platformID, forKey: .platformID)
      try container.encode(encodingID.rawValue, forKey: .encodingID)
      try container.encode(mappingIndex, forKey: .mappingIndex)
    }
  
  }

  class OffsetIndexEntry: CustomStringConvertible {
    let platformID: ID.Platform
    let encodingID: Encoding
    let offset: Int
    var format: CmapFormat?

    init(dataInput: TCDataInput) {
      platformID = ID.Platform(rawValue: Int(dataInput.readUInt16())) ?? .unknown
      let encodingIDRawValue = Int(dataInput.readUInt16())
      encodingID = platformID.encoding(id: encodingIDRawValue) ?? ID.CustomEncoding.unknown
      offset = Int(dataInput.readUInt32())
    }

    var description: String {
      get {
        return "platform id: \(platformID.rawValue) (\(platformID)), encoding id: \(encodingID.rawValue) (\(encodingID)), offset: \(offset)"
      }
    }
  }

  var entries = [IndexEntry]()
  var mappings = [CharacterToGlyphMapping]()

  override init() {
    super.init()
  }

  init(data: Data) throws {
    let dataInput = TCDataInput(data: data)
    _ = dataInput.readUInt16()  // version (must be 0)
    let numTables = Int(dataInput.readUInt16())
    var bytesRead = 4
    var offsetEntries = [OffsetIndexEntry]()

    // Get each of the index entries
    for _ in 0..<numTables {
      let indexEntry = OffsetIndexEntry(dataInput: dataInput)
      offsetEntries.append(indexEntry)
      bytesRead += 8
      os_log("indexEntry: %@", String(describing: indexEntry))
    }

    // Sort into their order of offset
    offsetEntries.sort { (lhs: CmapTable.OffsetIndexEntry, rhs: CmapTable.OffsetIndexEntry) -> Bool in
      return lhs.offset < rhs.offset
    }

    // Build the entries list
    var index = 0
    var lastOffset = 0
    for offsetEntry in offsetEntries {
      if lastOffset > 0 && offsetEntry.offset > lastOffset {
        index += 1
      }
      let entry = IndexEntry(platformID: offsetEntry.platformID,
                             encodingID: offsetEntry.encodingID,
                             mappingIndex: index)
      entries.append(entry)
      lastOffset = offsetEntry.offset
    }

    // Get each of the tables
    lastOffset = 0
    var lastFormat: CmapFormat? = nil
    for offsetEntry in offsetEntries {
      if offsetEntry.offset == lastOffset {
        // This is a multiple entry
        offsetEntry.format = lastFormat
        continue
      } else if offsetEntry.offset > bytesRead {
        _ = dataInput.read(length: offsetEntry.offset - bytesRead)
      } else if offsetEntry.offset != bytesRead {
        // Something is amiss
        throw TableError.badOffset(message: "IndexEntry offset is bad")
      }
      let formatType = Int(dataInput.readUInt16())
      lastFormat = CmapFormatFactory.cmapFormat(type: formatType, dataInput: dataInput)
      lastOffset = offsetEntry.offset
      offsetEntry.format = lastFormat
      bytesRead += (lastFormat?.length)!

      if let format = lastFormat {
        mappings.append(CharacterToGlyphMapping(encodedMap: format))
      }
    }
    super.init()
  }

  override var description: String {
    get {
      let str = "cmap\n"
//      for entry in entries {
//        str += "\(entry)\n"
//      }
      return str
    }
  }
}
