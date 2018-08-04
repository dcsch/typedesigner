import fontParts
font = fontParts.NewFont(familyName="Test Family", styleName="Test Style")
layer = font.newLayer("Test Layer")
glyph = layer.newGlyph("A")

try:
    glyph.unicodes = "bad string"
except TypeError:
    print("Correctly failed to set unicodes to a string")

try:
    glyph.unicodes = ['A', 'B', 'C']
except TypeError:
    print("Correctly failed to set unicode items to a string")

glyph.unicodes = [10, 20, 30]
print(glyph.unicodes)
print(glyph.unicode)

glyph.unicode = None
print(glyph.unicodes)
print(glyph.unicode)

glyph.unicode = 5
print(glyph.unicodes)
print(glyph.unicode)

try:
    glyph.unicode = "Foo"
except TypeError:
    print("Correctly failed to set unicode to a string")
