//
//  GlyphSet.swift
//  UFOKit
//
//  Created by David Schweinsberg on 12/18/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log

public enum GLIFFormatVersion: Int {
  case version1 = 1
  case version2 = 2
}

class UnicodesParser: NSObject, XMLParserDelegate {
  var unicodes: [Int] = []

  func parser(_ parser: XMLParser, didStartElement elementName: String,
              namespaceURI: String?, qualifiedName qName: String?,
              attributes attributeDict: [String: String] = [:]) {
    switch elementName {
    case "unicode":
      if let hexcode = attributeDict["hex"],
        let value = Int(hexcode, radix: 16),
        !unicodes.contains(value) {
        unicodes.append(value)
      }
    default:
      break
    }
  }

}

class ComponentsParser: NSObject, XMLParserDelegate {
  var components: [String] = []

  func parser(_ parser: XMLParser, didStartElement elementName: String,
              namespaceURI: String?, qualifiedName qName: String?,
              attributes attributeDict: [String: String] = [:]) {
    switch elementName {
    case "component":
      if let base = attributeDict["base"] {
        components.append(base)
      }
    default:
      break
    }
  }

}

public class GlyphSet {
  let dirURL: URL
  let ufoFormatVersion: UFOFormatVersion
  public var contents: [String: String]

  public init(dirURL: URL, ufoFormatVersion: UFOFormatVersion) throws {
    if !dirURL.hasDirectoryPath {
      throw UFOError.notDirectoryPath
    }
    self.dirURL = dirURL
    self.ufoFormatVersion = ufoFormatVersion
    self.contents = [:]
    try rebuildContents()
  }

  public func rebuildContents() throws {
    let contentsURL = dirURL.appendingPathComponent("contents.plist")
    let contentsData = try Data(contentsOf: contentsURL)
    let decoder = PropertyListDecoder()
    contents = try decoder.decode([String: String].self, from: contentsData)
  }

  public var reverseContents: [String: String] {
    get {
      return [:]
    }
  }

  public func writeContents() {

  }

  public func readLayerInfo() {

  }

  public func writeLayerInfo() {

  }

  public func glif(glyphName: String) throws -> Data {
    guard let fileName = contents[glyphName] else {
      throw UFOError.glyphNameNotFound
    }
    let fileURL = dirURL.appendingPathComponent(fileName)
    return try Data(contentsOf: fileURL)
  }

  public func glifModificationTime(glyphName: String) throws -> Date {
    guard let fileName = contents[glyphName] else {
      throw UFOError.glyphNameNotFound
    }
    let fileURL = dirURL.appendingPathComponent(fileName)
    let attr = try FileManager.default.attributesOfItem(atPath: fileURL.path)
    return attr[.modificationDate] as? Date ?? Date()
  }

  public func readGlyph(glyphName: String, pointPen: PointPen) throws {
    let glifData = try glif(glyphName: glyphName)
    let glifDoc = try XMLDocument(data: glifData, options: [])
    if let root = glifDoc.rootElement(),
      let children = root.children {
      for child in children {
        if child.name == "outline" {
          try buildOutline(outline: child, pointPen: pointPen)
        }
      }
    }
  }

  public func writeGlyph(glyphName: String) {

  }

  public func deleteGlyph(glyphName: String) {

  }

  public func unicodes(glyphNames: [String]? = nil) throws -> [String: [Int]] {
    var unicodes: [String: [Int]] = [:]
    let glyphNames = glyphNames ?? Array(contents.keys)
    for glyphName in glyphNames {
      let data = try glif(glyphName: glyphName)
      let parser = XMLParser(data: data)
      let delegate = UnicodesParser()
      parser.delegate = delegate
      parser.parse()
      unicodes[glyphName] = delegate.unicodes
    }
    return unicodes
  }

  public func componentReferences(glyphNames: [String]? = nil) throws -> [String: [String]] {
    var components: [String: [String]] = [:]
    let glyphNames = glyphNames ?? Array(contents.keys)
    for glyphName in glyphNames {
      let data = try glif(glyphName: glyphName)
      let parser = XMLParser(data: data)
      let delegate = ComponentsParser()
      parser.delegate = delegate
      parser.parse()
      components[glyphName] = delegate.components
    }
    return components
  }

//  public func imageReferences(glyphNames: [String]? = nil) throws {
//
//  }

  func buildOutline(outline: XMLNode, pointPen: PointPen) throws {
    guard let children = outline.children else { return }
    for node in children {
      if node.name == "contour" {
        if node.childCount == 1 {
          // Anchor
        } else {
          buildOutlineContour(contour: node, pointPen: pointPen)
        }
      } else if node.name == "component" {
        try buildOutlineComponent(component: node, pointPen: pointPen)
      }
    }
  }

  func buildOutlineContour(contour: XMLNode, pointPen: PointPen) {
    pointPen.beginPath(identifier: nil)
    if contour.childCount > 0 {
      buildOutlinePoints(contour: contour, pointPen: pointPen)
    }
    pointPen.endPath()
  }

  func buildOutlinePoints(contour: XMLNode, pointPen: PointPen) {
    for node in contour.children! {
      if let element = node as? XMLElement {
        let x = Double(element.attribute(forName: "x")?.stringValue ?? "0") ?? 0
        let y = Double(element.attribute(forName: "y")?.stringValue ?? "0") ?? 0
        let typeStr = element.attribute(forName: "type")?.stringValue ?? "offcurve"
        var type: SegmentType
        switch typeStr {
        case "move":
          type = .move
        case "line":
          type = .line
        case "offcurve":
          type = .offCurve
        case "curve":
          type = .curve
        case "qcurve":
          type = .qCurve
        default:
          type = .offCurve
        }
        let smooth = element.attribute(forName: "smooth")?.stringValue ?? "no" == "yes"
        let name = element.attribute(forName: "name")?.stringValue
        pointPen.addPoint(CGPoint(x: x, y: y), segmentType: type, smooth: smooth, name: name, identifier: nil)
      }
    }
  }

  func buildOutlineComponent(component: XMLNode, pointPen: PointPen) throws {
    if let element = component as? XMLElement {
      let base = element.attribute(forName: "base")?.stringValue ?? ""
      let xScale = CGFloat(Double(element.attribute(forName: "xScale")?.stringValue ?? "1") ?? 1)
      let xyScale = CGFloat(Double(element.attribute(forName: "xyScale")?.stringValue ?? "0") ?? 0)
      let yxScale = CGFloat(Double(element.attribute(forName: "yxScale")?.stringValue ?? "0") ?? 0)
      let yScale = CGFloat(Double(element.attribute(forName: "yScale")?.stringValue ?? "1") ?? 1)
      let xOffset = CGFloat(Double(element.attribute(forName: "xOffset")?.stringValue ?? "0") ?? 0)
      let yOffset = CGFloat(Double(element.attribute(forName: "yOffset")?.stringValue ?? "0") ?? 0)
      let transform = CGAffineTransform(a: xScale, b: xyScale,
                                        c: yxScale, d: yScale,
                                        tx: xOffset, ty: yOffset)
      try pointPen.addComponent(baseGlyphName: base, transformation: transform,
                                identifier: nil)
    }
  }

}
