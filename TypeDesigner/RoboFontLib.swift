//
//  RoboFontLib.swift
//  Type Designer
//
//  Created by David Schweinsberg on 7/25/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Foundation

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
  var glyphOrder: [String]
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

  init() {
    glyphOrder = []
  }
}
