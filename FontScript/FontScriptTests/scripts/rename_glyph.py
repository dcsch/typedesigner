import fontParts
font = fontParts.NewFont(familyName="Test Family", styleName="Test Style")
layer = font.newLayer("Test Layer")
glyph = layer.newGlyph("A")

glyph.name = "B"
#glyphB = layer["B"]

layer.newGlyph("C")
glyph.name = "C"
