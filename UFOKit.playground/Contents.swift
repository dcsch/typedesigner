//: Playground - noun: a place where people can play

//import Cocoa
import PlaygroundSupport
import UFOKit

do {
  let homeURL = FileManager.default.homeDirectoryForCurrentUser
//  let ufoURL = homeURL.appendingPathComponent("adobe-fonts/source-sans-pro/Roman/Instances/Regular/font.ufo")
  let ufoURL = homeURL.appendingPathComponent("projects/fonts/Lato-Black (UFO3).ufo")
  let ufoReader = try UFOReader(url: ufoURL)
  let glyphSet = try ufoReader.glyphSet()

  let pen = QuartzPen(glyphSet: glyphSet)
  try glyphSet.readGlyph(glyphName: "A", pointPen: pen)
  let glyphView = GlyphView(frame: NSRect(x: 0, y: 0, width: 240, height: 480))
  glyphView.glyphPath = pen.path
  glyphView.bounds = pen.path.boundingBox

  PlaygroundPage.current.liveView = glyphView
} catch {
  print("Error: \(error)")
}

class GlyphView: NSView {
  var glyphPath: CGPath?

  override func draw(_ dirtyRect: NSRect) {
    guard let context = NSGraphicsContext.current?.cgContext else {
      return
    }
    context.setFillColor(CGColor.white)
    context.fill(self.bounds)
    if let path = glyphPath {
      context.addPath(path)
    }
    context.setFillColor(CGColor.black)
    context.fillPath()
  }
}
