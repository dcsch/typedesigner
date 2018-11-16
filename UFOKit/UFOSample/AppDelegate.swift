//
//  AppDelegate.swift
//  UFOSample
//
//  Created by David Schweinsberg on 12/18/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import AppKit
import UFOKit

struct RoboFontGuide: Codable {
  var angle: Int
  var isGlobal: Bool
  var magnetic: Int
  var name: String
  var x: Int
  var y: Int

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    angle = try container.decode(Int.self, forKey: .angle)
    do {
      isGlobal = try container.decode(Bool.self, forKey: .isGlobal)
    } catch DecodingError.typeMismatch {
      isGlobal = try container.decode(Int.self, forKey: .isGlobal) == 1 ? true : false
    }
    magnetic = try container.decode(Int.self, forKey: .magnetic)
    name = try container.decode(String.self, forKey: .name)
    x = try container.decode(Int.self, forKey: .x)
    y = try container.decode(Int.self, forKey: .y)
  }
}

struct RoboFontSort: Codable {
  var ascending: [String]
  var type: String
}

class RoboFontLib: Codable {
  var compileSettingsAutohint: Bool?
  var compileSettingsCheckOutlines: Bool?
  var compileSettingsDecompose: Bool?
  var compileSettingsGenerateFormat: Int?
  var compileSettingsReleaseMode: Bool?
  var foregroundLayerStrokeColor: [Double]?
  var guides: [RoboFontGuide]?
  var italicSlantOffset: Int?
  var layerOrder: [String]?
  var maskLayerStrokeColor: [Double]?
  var segmentType: String?
  var shouldAddPointsInSplineConversion: Bool?
  var sort: [RoboFontSort]?
  var groupColors: [String: [Double]]?
  var glyphOrder: [String]?
  var postscriptNames: [String: String]?

  enum CodingKeys: String, CodingKey {
    case compileSettingsAutohint = "com.typemytype.robofont.compileSettings.autohint"
    case compileSettingsCheckOutlines = "com.typemytype.robofont.compileSettings.checkOutlines"
    case compileSettingsDecompose = "com.typemytype.robofont.compileSettings.decompose"
    case compileSettingsGenerateFormat = "com.typemytype.robofont.compileSettings.generateFormat"
    case compileSettingsReleaseMode = "com.typemytype.robofont.compileSettings.releaseMode"
    case foregroundLayerStrokeColor = "com.typemytype.robofont.foreground.layerStrokeColor"
    case guides = "com.typemytype.robofont.guides"
    case italicSlantOffset = "com.typemytype.robofont.italicSlantOffset"
    case layerOrder = "com.typemytype.robofont.layerOrder"
    case maskLayerStrokeColor = "com.typemytype.robofont.mask.layerStrokeColor"
    case segmentType = "com.typemytype.robofont.segmentType"
    case shouldAddPointsInSplineConversion = "com.typemytype.robofont.shouldAddPointsInSplineConversion"
    case sort = "com.typemytype.robofont.sort"
    case groupColors = "com.typesupply.MetricsMachine4.groupColors"
    case glyphOrder = "public.glyphOrder"
    case postscriptNames = "public.postscriptNames"
  }
}

class RoboFontGlifLib: Codable {
  var mark: [Double]?
  var autohint: Data?

  enum CodingKeys: String, CodingKey {
    case mark = "com.typemytype.robofont.mark"
    case autohint = "com.adobe.type.autohint"
  }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var namesViewController: NamesViewController!
  var glyphViewController: ViewController!
  var info: UFOKit.FontInfo?
  var glyphSet: GlyphSet?
  var libProps: RoboFontLib?

  func applicationDidFinishLaunching(_ aNotification: Notification) {

    let splitViewController = NSApp.windows[0].contentViewController as! NSSplitViewController
    let items = splitViewController.splitViewItems
    namesViewController = items[0].viewController as? NamesViewController
    glyphViewController = items[1].viewController as? ViewController

    let nc = NotificationCenter.default
    nc.addObserver(forName: NSTableView.selectionDidChangeNotification, object: nil, queue: nil) { (notification: Notification) in
      do {
        let selectedRow = self.namesViewController.tableView.selectedRow
        if let glyphSet = self.glyphSet,
          let libProps = self.libProps {
          var glyph = Glyph()
          let pen = QuartzPen(glyphSet: glyphSet)
          try glyphSet.readGlyph(glyphName: libProps.glyphOrder![selectedRow], glyph: &glyph, pointPen: pen)
          self.glyphViewController.glyphView.glyphPath = pen.path
          if let data = glyph.lib {
            let cleanData = AdobeMigration.migrate(data: data)
            let decoder = PropertyListDecoder()
            let glifLibProps = try decoder.decode(RoboFontGlifLib.self, from: cleanData)
            if let autohint = glifLibProps.autohint,
              let autohintStr = String(data: autohint, encoding: .utf8) {
              print(autohintStr)
            }
          }
        }
        self.glyphViewController.sizeToFit()
        self.glyphViewController.glyphView.needsDisplay = true
      } catch {
        print("Exception: \(error)")
      }
    }
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  func open(url: URL) {
    do {
      let ufoReader = try UFOReader(url: url)

      let libData = try ufoReader.readLib()
      let decoder = PropertyListDecoder()
      libProps = try decoder.decode(RoboFontLib.self, from: libData)
      self.namesViewController.names = libProps!.glyphOrder!
      self.namesViewController.tableView.reloadData()

      glyphSet = try ufoReader.glyphSet()
      info = try ufoReader.readInfo()
      let pen = QuartzPen(glyphSet: glyphSet!)
      try glyphSet!.readGlyph(glyphName: ".notdef", pointPen: pen)
      if let info = self.info {
        glyphViewController.fontBounds = info.bounds
      }
      glyphViewController.glyphView.glyphPath = pen.path
      self.glyphViewController.sizeToFit()
      glyphViewController.glyphView.needsDisplay = true
    } catch UFOError.notDirectoryPath {
      print("Exception: ")
    } catch {
      print("Something else: \(error)")
    }
  }

  func save(url: URL) {
    if let info = info {
      do {
        let ufoWriter = try UFOWriter(url: url)
        try ufoWriter.writeInfo(info)
        // TODO groups
        // TODO kerning
        // TODO features
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let libData = try encoder.encode(libProps)
        try ufoWriter.writeLib(libData)
        // TODO layercontents

        if let libProps = libProps, let glyphNames = libProps.glyphOrder {
          let writerGlyphSet = try ufoWriter.glyphSet()
          for glyphName in glyphNames {
            try writerGlyphSet.writeGlyph(glyphName: glyphName) { (_ pen: PointPen) in
              if let glyphSet = glyphSet {
                do {
                  try glyphSet.readGlyph(glyphName: glyphName, pointPen: pen)
                } catch {
                  print("Exception: \(error)")
                }
              }
            }
          }
          try writerGlyphSet.writeContents()
        }
      } catch UFOError.notDirectoryPath {
        print("Exception: ")
      } catch {
        print("Something else: \(error)")
      }
    }
  }

  @IBAction func openDocument(_ sender: Any?) {
    let panel = NSOpenPanel()
    panel.allowedFileTypes = ["ufo"]
    panel.beginSheetModal(for: NSApp.mainWindow!) { (response: NSApplication.ModalResponse) in
      if response == .OK {
        self.open(url: panel.url!)
      }
    }
  }

  @IBAction func saveDocument(_ sender: Any?) {
    let panel = NSSavePanel()
    panel.allowedFileTypes = ["ufo"]
    panel.beginSheetModal(for: NSApp.mainWindow!) { (response: NSApplication.ModalResponse) in
      if response == .OK {
        self.save(url: panel.url!)
      }
    }
  }

}
