//
//  FontDocument.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/27/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import os.log

class FontDocument: NSDocument {
  var font: Font?

  override init() {
    super.init()
    hasUndoManager = true
  }

  override func makeWindowControllers() {
    let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
    let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Document Window Controller")) as! NSWindowController

    // This will set the window controller's document property, so the data
    // must be set up by that point
    self.addWindowController(windowController)
  }

  override func windowControllerDidLoadNib(_ aController: NSWindowController) {
    super.windowControllerDidLoadNib(aController)
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
  }

  override func data(ofType typeName: String) throws -> Data {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
  }
    
  override func read(from data: Data, ofType typeName: String) throws {
    if typeName == "Font Project" {
      let decoder = JSONDecoder()
//      let decoder = PropertyListDecoder()
      self.font = try decoder.decode(TTFont.self, from: data)
      return
    }

    var suitcase = false
    if typeName == "Font Suitcase" || typeName == "Datafork TrueType font" {
      suitcase = true
    }
    let fontCollection = try FontCollection(data: data, isSuitcase: suitcase)
    if fontCollection.fonts.count > 1 {
//      self.fontCollection = fontCollection
    } else {
      self.font = fontCollection.fonts[0]
    }
  }

  override func read(from url: URL, ofType typeName: String) throws {
    try super.read(from: url, ofType: typeName)
  }

  override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
    let encoder = JSONEncoder()
//    let encoder = PropertyListEncoder()
    let data = try encoder.encode(font)
    return FileWrapper(regularFileWithContents: data)
  }

  override class var autosavesInPlace: Bool {
    return true
  }

  @IBAction func showTablesWindow(_ sender: Any?) {

//    // Show an existing tables window
//    for controller in windowControllers {
//      if controller is TCTablesWindowController {
//        controller.showWindow(self)
//        return
//      }
//    }
//
//    // Otherwise we create a new one
//    if let collection = fontCollection {
//
//      // TODO Manage collections
//      if collection.fonts.count == 1 {
//        let controller = TCTablesWindowController(windowNibName: "TablesWindow")
//        controller.font = collection.fonts[0]
//        addWindowController(controller)
//        controller.showWindow(self)
//      }
//    }
  }

  @IBAction func showFontProperties(_ sender: Any?) {
    let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
    let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Font Properties")) as! NSWindowController
    addWindowController(windowController)
    windowController.showWindow(self)
  }

  func buildFont(url: URL) throws {

    if let font = self.font {
      let directory = TCTableDirectory(isCFF: false)
      var tablesAsData = [Data]()

      // Offset is calculated from the beginning of the file, including the
      // table directory, so calculate the final size of the directory
      let tableCount = 9
      var offset = 16 * tableCount + 12

      font.headTable.checkSumAdjustment = 0

      let headData = TableWriter.write(table: font.headTable)
      tablesAsData.append(headData)

      directory.entries.append(TCTableDirectory.Entry(tag: TCHeadTable.tag.rawValue,
                                                      checksum: headData.checksum,
                                                      offset: offset,
                                                      length: headData.count))
      offset += headData.count

      let hheaData = TableWriter.write(table: font.hheaTable)
      tablesAsData.append(hheaData)

      directory.entries.append(TCTableDirectory.Entry(tag: TCHheaTable.tag.rawValue,
                                                      checksum: hheaData.checksum,
                                                      offset: offset,
                                                      length: hheaData.count))
      offset += hheaData.count

      let maxpData = TableWriter.write(table: font.maxpTable)
      tablesAsData.append(maxpData)

      directory.entries.append(TCTableDirectory.Entry(tag: TCMaxpTable.tag.rawValue,
                                                      checksum: maxpData.checksum,
                                                      offset: offset,
                                                      length: maxpData.count))
      offset += maxpData.count

      let os2Data = TableWriter.write(table: font.os2Table)
      tablesAsData.append(os2Data)

      directory.entries.append(TCTableDirectory.Entry(tag: TCOs2Table.tag.rawValue,
                                                      checksum: os2Data.checksum,
                                                      offset: offset,
                                                      length: os2Data.count))
      offset += os2Data.count

      let hmtxData = TableWriter.write(table: font.hmtxTable)
      tablesAsData.append(hmtxData)

      directory.entries.append(TCTableDirectory.Entry(tag: TCHmtxTable.tag.rawValue,
                                                      checksum: hmtxData.checksum,
                                                      offset: offset,
                                                      length: hmtxData.count))
      offset += hmtxData.count

      let cmapData = TableWriter.write(table: font.cmapTable)
      tablesAsData.append(cmapData)

      directory.entries.append(TCTableDirectory.Entry(tag: TCCmapTable.tag.rawValue,
                                                      checksum: cmapData.checksum,
                                                      offset: offset,
                                                      length: cmapData.count))
      offset += cmapData.count

      if let ttFont = font as? TTFont {
        let (glyfData, locaOffsets) = TableWriter.write(table: ttFont.glyfTable)
        let locaData = TableWriter.writeLoca(offsets: locaOffsets,
                                             shortEntries: font.headTable.indexToLocFormat == 0)

        tablesAsData.append(locaData)

        directory.entries.append(TCTableDirectory.Entry(tag: TCLocaTable.tag.rawValue,
                                                        checksum: locaData.checksum,
                                                        offset: offset,
                                                        length: locaData.count))
        offset += locaData.count

        tablesAsData.append(glyfData)

        directory.entries.append(TCTableDirectory.Entry(tag: TCGlyfTable.tag.rawValue,
                                                        checksum: glyfData.checksum,
                                                        offset: offset,
                                                        length: glyfData.count))
        offset += glyfData.count
      }

      let nameData = TableWriter.write(table: font.nameTable)
      tablesAsData.append(nameData)

      directory.entries.append(TCTableDirectory.Entry(tag: TCNameTable.tag.rawValue,
                                                      checksum: nameData.checksum,
                                                      offset: offset,
                                                      length: nameData.count))
      offset += nameData.count

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
      os_log("fileData count: %d", fileData.count)
      fileData.append(fontData)
      try fileData.write(to: url, options: .atomicWrite)
    }
  }
}
