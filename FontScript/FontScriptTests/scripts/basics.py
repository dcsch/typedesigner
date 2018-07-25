import fontParts

#fonts = fontParts.AllFonts()
#fonts = fontParts.AllFonts("magic")
#fonts = fontParts.AllFonts(["familyName", "styleName"])

font = fontParts.NewFont(familyName="My Family", styleName="My Style")
print(font)
print(font.info.familyName)
print(font.info.styleName)

font.save(path="foo/bar/name.ufo")
print(font.path)

layer = font.newLayer("My Layer 1")
print(layer)

glyph = layer.newGlyph("A")
glyph.width = 123
glyph.width = 123.456

fonts = fontParts.AllFonts()
for f in fonts:
    print("Font at: ", f.path)
