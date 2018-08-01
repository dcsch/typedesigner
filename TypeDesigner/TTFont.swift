//
//  TTFont.swift
//  Type Designer
//
//  Created by David Schweinsberg on 11/16/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import IOUtils
import os.log

/**
 An OpenType font with TrueType outlines.
 */
class TTFont: OpenTypeFont {
  var glyfTable: GlyfTable
  var gaspTable: GaspTable?
  var kernTable: KernTable?
  var hdmxTable: HdmxTable?
  var vdmxTable: VdmxTable?

  override init(data: Data, tablesOrigin: Int) throws {

    // Load the table directory
    let dataInput = TCDataInput(data: data)
    let tableDirectory = TableDirectory(dataInput: dataInput)

    // We need to look ahead at the head and maxp tables
    var tableData = try OpenTypeFont.tableData(directory: tableDirectory, tag: .head,
                                       data: data, tablesOrigin: tablesOrigin)
    let headTable = HeadTable(data: tableData)
    tableData = try OpenTypeFont.tableData(directory: tableDirectory, tag: .maxp,
                                   data: data, tablesOrigin: tablesOrigin)
    let maxpTable = MaxpTable(data: tableData)

    // 'loca' is required by 'glyf'
    tableData = try OpenTypeFont.tableData(directory: tableDirectory, tag: .loca,
                                   data: data, tablesOrigin: tablesOrigin)
    let locaTable = LocaTable(data: tableData,
                              shortEntries: headTable.indexToLocFormat == 0,
                              numGlyphs: maxpTable.numGlyphs)

    // If this is a TrueType outline, then we'll have at least the
    // 'glyf' table (along with the 'loca' table)
    tableData = try OpenTypeFont.tableData(directory: tableDirectory, tag: .glyf,
                                   data: data, tablesOrigin: tablesOrigin)
    glyfTable = GlyfTable(data: tableData, maxpTable: maxpTable, locaTable: locaTable)

    if tableDirectory.hasEntry(tag: .gasp) {
      let gaspData = try OpenTypeFont.tableData(directory: tableDirectory, tag: .gasp,
                                        data: data, tablesOrigin: tablesOrigin)
      gaspTable = GaspTable(data: gaspData)
    }

    if tableDirectory.hasEntry(tag: .kern) {
      let kernData = try OpenTypeFont.tableData(directory: tableDirectory, tag: .kern,
                                        data: data, tablesOrigin: tablesOrigin)
      kernTable = KernTable(data: kernData)
    }

    if tableDirectory.hasEntry(tag: .hdmx) {
      let hdmxData = try OpenTypeFont.tableData(directory: tableDirectory, tag: .hdmx,
                                        data: data, tablesOrigin: tablesOrigin)
      hdmxTable = HdmxTable(data: hdmxData, numGlyphs: maxpTable.numGlyphs)
    }

    if tableDirectory.hasEntry(tag: .VDMX) {
      let vdmxData = try OpenTypeFont.tableData(directory: tableDirectory, tag: .VDMX,
                                        data: data, tablesOrigin: tablesOrigin)
      vdmxTable = VdmxTable(data: vdmxData)
    }

    try super.init(data: data, tablesOrigin: tablesOrigin)
  }

  private enum CodingKeys: String, CodingKey {
    case glyf
    case gasp
    case kern
    case hdmx
    case vdmx
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    glyfTable = try container.decode(GlyfTable.self, forKey: .glyf)
    gaspTable = try container.decode(GaspTable.self, forKey: .gasp)
    kernTable = try container.decode(KernTable.self, forKey: .kern)
    hdmxTable = try container.decode(HdmxTable.self, forKey: .hdmx)
    vdmxTable = try container.decode(VdmxTable.self, forKey: .vdmx)
    try super.init(from: container.superDecoder())
  }

  override func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(glyfTable, forKey: .glyf)
    try container.encode(gaspTable, forKey: .gasp)
    try container.encode(kernTable, forKey: .kern)
    try container.encode(hdmxTable, forKey: .hdmx)
    try container.encode(vdmxTable, forKey: .vdmx)
    try super.encode(to: container.superEncoder())
  }

  override func buildFont(url: URL) throws {
    let directory = TableDirectory(isCFF: false)
    var tablesAsData = [Data]()

    // Offset is calculated from the beginning of the file, including the
    // table directory, so calculate the final size of the directory
    var tableCount = 10
    if hdmxTable != nil {
      tableCount += 1
    }
    if vdmxTable != nil {
      tableCount += 1
    }
    if kernTable != nil {
      tableCount += 1
    }
    if gaspTable != nil {
      tableCount += 1
    }
    var offset = 16 * tableCount + 12

    headTable.checkSumAdjustment = 0

    let headData = TableWriter.write(table: headTable)
    tablesAsData.append(headData)
    offset = directory.appendEntry(tag: .head, offset: offset, data: headData)

    let hheaData = TableWriter.write(table: hheaTable)
    tablesAsData.append(hheaData)
    offset = directory.appendEntry(tag: .hhea, offset: offset, data: hheaData)

    let maxpData = TableWriter.write(table: maxpTable)
    tablesAsData.append(maxpData)
    offset = directory.appendEntry(tag: .maxp, offset: offset, data: maxpData)

    let os2Data = TableWriter.write(table: os2Table)
    tablesAsData.append(os2Data)
    offset = directory.appendEntry(tag: .OS_2, offset: offset, data: os2Data)

    let hmtxData = TableWriter.write(table: hmtxTable)
    tablesAsData.append(hmtxData)
    offset = directory.appendEntry(tag: .hmtx, offset: offset, data: hmtxData)

    if let vdmxTable = vdmxTable {
      let vdmxData = TableWriter.write(table: vdmxTable)
      tablesAsData.append(vdmxData)
      offset = directory.appendEntry(tag: .VDMX, offset: offset, data: vdmxData)
    }

    if let hdmxTable = hdmxTable {
      let hdmxData = TableWriter.write(table: hdmxTable)
      tablesAsData.append(hdmxData)
      offset = directory.appendEntry(tag: .hdmx, offset: offset, data: hdmxData)
    }

    let cmapData = TableWriter.write(table: cmapTable)
    tablesAsData.append(cmapData)
    offset = directory.appendEntry(tag: .cmap, offset: offset, data: cmapData)

    let (glyfData, locaOffsets) = TableWriter.write(table: glyfTable)
    let locaData = TableWriter.writeLoca(offsets: locaOffsets,
                                         shortEntries: headTable.indexToLocFormat == 0)
    tablesAsData.append(locaData)
    offset = directory.appendEntry(tag: .loca, offset: offset, data: locaData)

    tablesAsData.append(glyfData)
    offset = directory.appendEntry(tag: .glyf, offset: offset, data: glyfData)

    if let kernTable = kernTable {
      let kernData = TableWriter.write(table: kernTable)
      tablesAsData.append(kernData)
      offset = directory.appendEntry(tag: .kern, offset: offset, data: kernData)
    }

    let nameData = TableWriter.write(table: nameTable)
    tablesAsData.append(nameData)
    offset = directory.appendEntry(tag: .name, offset: offset, data: nameData)

    let postData = TableWriter.write(table: postTable)
    tablesAsData.append(postData)
    offset = directory.appendEntry(tag: .post, offset: offset, data: postData)

    if let gaspTable = gaspTable {
      let gaspData = TableWriter.write(table: gaspTable)
      tablesAsData.append(gaspData)
      offset = directory.appendEntry(tag: .gasp, offset: offset, data: gaspData)
    }

    var fontData = Data()
    for tableData in tablesAsData {
      fontData.append(tableData)
    }

    // Calculate checksum and store in the head.checkSumAdjustment field
    let checksum = fontData.checksum
    let (checkSumAdjustment, _) = UInt32(0xb1b0afba).subtractingReportingOverflow(checksum)
    var bigEndian = checkSumAdjustment.bigEndian
    fontData.replaceSubrange(8..<12, with: &bigEndian, count: 4)

    var fileData = TableWriter.write(directory: directory)
    fileData.append(fontData)
    try fileData.write(to: url, options: .atomicWrite)
  }
}
