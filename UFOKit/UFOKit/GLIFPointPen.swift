//
//  GLIFPointPen.swift
//  UFOKit
//
//  Created by David Schweinsberg on 10/17/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Foundation

public class GLIFPointPen: PointPen {
  let outlineElement: XMLElement
  var currentContour: XMLElement?
  var prevOffCurveCount = 0

  public init(outlineElement: XMLElement) {
    self.outlineElement = outlineElement
  }

  public func beginPath(identifier: String? = nil) throws {
    if currentContour != nil {
      throw UFOError.currentPathNotEnded
    }
    currentContour = XMLElement(name: "contour")
    prevOffCurveCount = 0
  }

  public func endPath() throws {
    if let currentContour = currentContour {
      if firstSegmentType == .move && lastSegmentType == .offCurve {
        throw UFOError.openContourEndsOffCurve
      }
      outlineElement.addChild(currentContour)
    } else {
      throw UFOError.pathNotBegun
    }
    currentContour = nil
  }

  public func addPoint(_ pt: CGPoint,
                       segmentType: SegmentType = .offCurve,
                       smooth: Bool = false,
                       name: String? = nil,
                       identifier: String? = nil) throws {
    if let currentContour = currentContour {
      let point = XMLElement(name: "point")
      point.setAttributesWith(["x": String(format: "%g", pt.x),
                               "y": String(format: "%g", pt.y)])
      if currentContour.childCount > 0 && segmentType == .move {
        throw UFOError.moveMustBeFirst
      }
      if segmentType == .line && currentContour.childCount > 0 && lastSegmentType == .offCurve {
        throw UFOError.offCurveNotFollowedByCurve
      }
      if segmentType == .curve && prevOffCurveCount > 2 {
        throw UFOError.tooManyOffCurvesBeforeCurve
      }
      if segmentType != .offCurve {
        point.addAttribute(GLIFPointPen.createAttribute(name: "type",
                                                        value: String(describing: segmentType)))
        prevOffCurveCount = 0
      } else {
        prevOffCurveCount += 1
      }
      if smooth {
        if segmentType == .offCurve {
          throw UFOError.offCurveCannotBeSmooth
        }
        point.addAttribute(GLIFPointPen.createAttribute(name: "smooth", value: "yes"))
      }
      if let name = name {
        point.addAttribute(GLIFPointPen.createAttribute(name: "name", value: name))
      }
      if let identifier = identifier {
        point.addAttribute(GLIFPointPen.createAttribute(name: "identifier", value: identifier))
      }
      currentContour.addChild(point)
    } else {
      throw UFOError.pathNotBegun
    }
  }

  public func addComponent(baseGlyphName: String,
                           transformation: CGAffineTransform,
                           identifier: String? = nil) throws {
    if let currentContour = currentContour {
      let component = XMLElement(name: "component")
      component.addAttribute(GLIFPointPen.createAttribute(name: "base", value: baseGlyphName))
      if transformation.a != 1.0 {
        component.addAttribute(
          GLIFPointPen.createAttribute(name: "xScale",
                                       value: String(format: "%g", transformation.a)))
      }
      if transformation.b != 0.0 {
        component.addAttribute(
          GLIFPointPen.createAttribute(name: "xyScale",
                                       value: String(format: "%g", transformation.b)))
      }
      if transformation.c != 0.0 {
        component.addAttribute(
          GLIFPointPen.createAttribute(name: "yxScale",
                                       value: String(format: "%g", transformation.c)))
      }
      if transformation.d != 1.0 {
        component.addAttribute(
          GLIFPointPen.createAttribute(name: "yScale",
                                       value: String(format: "%g", transformation.d)))
      }
      if transformation.tx != 0.0 {
        component.addAttribute(
          GLIFPointPen.createAttribute(name: "xOffset",
                                       value: String(format: "%g", transformation.tx)))
      }
      if transformation.ty != 0.0 {
        component.addAttribute(
          GLIFPointPen.createAttribute(name: "yOffset",
                                       value: String(format: "%g", transformation.ty)))
      }
      currentContour.addChild(component)
    } else {
      throw UFOError.pathNotBegun
    }
  }

  class func createAttribute(name: String, value: String) -> XMLNode {
    return XMLNode.attribute(withName: name, stringValue: value) as! XMLNode
  }

  class func segmentType(contour: XMLElement, index: Int) -> SegmentType? {
    if let point = contour.child(at: index) as? XMLElement {
      if let typeStr = point.attribute(forName: "type")?.stringValue {
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
        return type
      }
      return .offCurve
    }
    return nil
  }

  var firstSegmentType: SegmentType? {
    get {
      if let currentContour = currentContour {
        return GLIFPointPen.segmentType(contour: currentContour, index: 0)
      } else {
        return nil
      }
    }
  }

  var lastSegmentType: SegmentType? {
    get {
      if let currentContour = currentContour {
        return GLIFPointPen.segmentType(contour: currentContour, index: currentContour.childCount - 1)
      } else {
        return nil
      }
    }
  }

}
