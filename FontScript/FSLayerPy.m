//
//  FSLayerPy.m
//  FontScript
//
//  Created by David Schweinsberg on 7/23/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSLayer.h"
#import "FSPythonObjects.h"
#import <objc/runtime.h>
#include <Python/structmember.h>

@interface FSLayer (Python)

@end

@implementation FSLayer (Python)

- (LayerObject *)pyObject {
  NSValue *value = objc_getAssociatedObject(self, PYOBJECT_ASSOCIATED_OBJECT);
  return (LayerObject *)[value pointerValue];
}

- (void)setPyObject:(LayerObject *)pyObject {
  NSValue *value = [NSValue valueWithPointer:pyObject];
  objc_setAssociatedObject(self, PYOBJECT_ASSOCIATED_OBJECT, value, OBJC_ASSOCIATION_RETAIN);
}

@end

static void Layer_dealloc(LayerObject *self) {
  Py_TYPE(self)->tp_free((PyObject *)self);
}

static PyObject *Layer_newGlyph(LayerObject *self, PyObject *args, PyObject *keywds) {
  FSLayer *layer = self->layer;
  if (!layer) {
    PyErr_SetString(FontScriptError, "Peer object has been unloaded");
    return NULL;
  }

  GlyphObject *glyphObject = (GlyphObject *)GlyphType.tp_alloc(&GlyphType, 0);
  if (glyphObject) {
    static char *kwlist[] = { "name", "clear", NULL };
    const char *name = NULL;
    bool clear = true;
    if (!PyArg_ParseTupleAndKeywords(args, keywds, "s|p", kwlist, &name, &clear))
      return NULL;
    FSGlyph *glyph = [layer newGlyphWithName:[NSString stringWithUTF8String:name] clear:clear];
    glyphObject->glyph = glyph;
    glyph.pyObject = glyphObject;
  }
  return (PyObject *)glyphObject;
}

static PyMethodDef Layer_methods[] = {
  { "newGlyph", (PyCFunction)Layer_newGlyph, METH_VARARGS | METH_KEYWORDS, NULL },
  { NULL }
};

PyTypeObject LayerType = {
  PyVarObject_HEAD_INIT(NULL, 0)
  .tp_name = "fontParts.Layer",
  .tp_doc = "Layer object",
  .tp_basicsize = sizeof(LayerObject),
  .tp_itemsize = 0,
  .tp_flags = Py_TPFLAGS_DEFAULT,
  .tp_dealloc = (destructor)Layer_dealloc,
  //  .tp_members = Layer_members,
  .tp_methods = Layer_methods,
  //  .tp_getset = Layer_getsetters,
};
