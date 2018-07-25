//
//  FSPythonObjects.h
//  FontScript
//
//  Created by David Schweinsberg on 7/23/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#include <FontScript/FontScript.h>
#include <Python/Python.h>

#define PYOBJECT_ASSOCIATED_OBJECT "pyobject"

typedef struct {
  PyObject_HEAD
  __unsafe_unretained FSFont *font;
} FontObject;

typedef struct {
  PyObject_HEAD
  __unsafe_unretained FSInfo *info;
} InfoObject;

typedef struct {
  PyObject_HEAD
  __unsafe_unretained FSLayer *layer;
} LayerObject;

typedef struct  {
  PyObject_HEAD
  __unsafe_unretained FSGlyph *glyph;
} GlyphObject;

@interface FSFont (PyObject)
@property FontObject *pyObject;
@end

@interface FSInfo (PyObject)
@property InfoObject *pyObject;
@end

@interface FSLayer (PyObject)
@property LayerObject *pyObject;
@end

@interface FSGlyph (PyObject)
@property GlyphObject *pyObject;
@end

extern PyTypeObject FontType;
extern PyTypeObject InfoType;
extern PyTypeObject LayerType;
extern PyTypeObject GlyphType;
extern PyObject *FontScriptError;

PyMODINIT_FUNC PyInit_fontParts(void);
