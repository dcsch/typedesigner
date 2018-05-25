#  UFOKit

A Swift library for low-level [Unified Font Object](http://unifiedfontobject.org/)
file handling.

A simple Playground to render a glyph in a view:
```swift
do {

  // Load the font and grab the set of glyphs
  let ufoReader = try UFOReader(url: URL(fileURLWithPath: "font.ufo"))
  let glyphSet = try ufoReader.glyphSet()

  // Use a pen that generates a CGPath from a glyph
  let pen = QuartzPen(glyphSet: glyphSet)
  
  // Read the glyph for 'A'
  try glyphSet.readGlyph(glyphName: "A", pointPen: pen)

  // Render in a simple view
  let glyphView = GlyphView(frame: NSRect(x: 0, y: 0, width: 240, height: 480))
  glyphView.glyphPath = pen.path
  glyphView.bounds = pen.path.boundingBox
  PlaygroundPage.current.liveView = glyphView
} catch {
  print("Error: \(error)")
}

// A simple view that only renders a CGPath
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
```

## Useful links
- [Unified Font Object (UFO) specification](http://unifiedfontobject.org/)
- [ufoLib — A low-level UFO reader and writer in Python](https://github.com/unified-font-object/ufoLib)
- [RoboFab](http://robofab.org/)
