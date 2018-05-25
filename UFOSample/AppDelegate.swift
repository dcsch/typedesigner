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
  var isGlobal: Int
  var magnetic: Int
  var name: String
  var x: Int
  var y: Int
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
    namesViewController = items[0].viewController as! NamesViewController
    glyphViewController = items[1].viewController as! ViewController

    let nc = NotificationCenter.default
    nc.addObserver(forName: NSTableView.selectionDidChangeNotification, object: nil, queue: nil) { (notification: Notification) in
      do {
        let selectedRow = self.namesViewController.tableView.selectedRow
        if let glyphSet = self.glyphSet,
          let libProps = self.libProps {
          let pen = QuartzPen(glyphSet: glyphSet)
          try glyphSet.readGlyph(glyphName: libProps.glyphOrder![selectedRow], pointPen: pen)
          self.glyphViewController.glyphView.glyphPath = pen.path
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

  @IBAction func openDocument(_ sender: Any?) {
    let panel = NSOpenPanel()
    panel.allowedFileTypes = ["ufo"]
    panel.beginSheetModal(for: NSApp.mainWindow!) { (response: NSApplication.ModalResponse) in
      if response == .OK {
        self.open(url: panel.url!)
      }
    }
  }
}
