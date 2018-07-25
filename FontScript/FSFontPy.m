//
//  FSFontPy.m
//  FontScript
//
//  Created by David Schweinsberg on 7/23/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSFont.h"
#import "FSFontPrivate.h"
#import "FSPythonObjects.h"
#include <Python/structmember.h>
#import <objc/runtime.h>

@interface FSFont (Python)

@end

@implementation FSFont (Python)

- (FontObject *)pyObject {
  NSValue *value = objc_getAssociatedObject(self, PYOBJECT_ASSOCIATED_OBJECT);
  return (FontObject *)[value pointerValue];
}

- (void)setPyObject:(FontObject *)pyObject {
  NSValue *value = [NSValue valueWithPointer:pyObject];
  objc_setAssociatedObject(self, PYOBJECT_ASSOCIATED_OBJECT, value, OBJC_ASSOCIATION_RETAIN);
}

@end

static void Font_dealloc(FontObject *self) {
  Py_TYPE(self)->tp_free((PyObject *)self);
}

static PyObject *Font_getpath(FontObject *self, void *closure) {
  FSFont *font = self->font;
  if (!font) {
    PyErr_SetString(FontScriptError, "Peer object has been unloaded");
    return NULL;
  }
  NSString *path = font.url ? font.url.path : @"";
  return PyUnicode_FromString(path.UTF8String);
}

static PyObject *Font_getinfo(FontObject *self, void *closure) {
  FSFont *font = self->font;
  if (!font) {
    PyErr_SetString(FontScriptError, "Peer object has been unloaded");
    return NULL;
  }

  if (!font.info.pyObject) {
    InfoObject *infoObject = (InfoObject *)InfoType.tp_alloc(&InfoType, 0);
    if (infoObject) {
      font.info.pyObject = infoObject;
      infoObject->info = font.info;
    }
  }
  return (PyObject *)font.info.pyObject;
}

static PyGetSetDef Font_getsetters[] = {
  { "path", (getter) Font_getpath, NULL, NULL, NULL },
  { "info", (getter) Font_getinfo, NULL, NULL, NULL },
  { NULL }
};

static PyObject *Font_save(FontObject *self, PyObject *args, PyObject *keywds) {
  FSFont *font = self->font;
  if (!font) {
    PyErr_SetString(FontScriptError, "Peer object has been unloaded");
    return NULL;
  }

  const char *path = "";
  int showProgress = 0;
  int formatVersion = 0;
  static char *kwlist[] = { "path", "showProgress", "formatVersion", NULL };

  if (!PyArg_ParseTupleAndKeywords(args, keywds, "|spi", kwlist, &path, &showProgress, &formatVersion))
    return NULL;

  font.url = [NSURL fileURLWithPath:[NSString stringWithUTF8String:path]];

  return PyLong_FromLong(0);
}

extern PyTypeObject LayerType;

static PyObject *Font_newLayer(FontObject *self, PyObject *args, PyObject *keywds) {
  FSFont *font = self->font;
  if (!font) {
    PyErr_SetString(FontScriptError, "Peer object has been unloaded");
    return NULL;
  }

  LayerObject *layerObject = (LayerObject *)LayerType.tp_alloc(&LayerType, 0);
  if (layerObject) {
    static char *kwlist[] = { "name", "color", NULL };
    const char *name = NULL;
    PyObject *color = NULL;
    if (!PyArg_ParseTupleAndKeywords(args, keywds, "s|O", kwlist, &name, &color))
      return NULL;
    FSLayer *layer = [font newLayerWithName:[NSString stringWithUTF8String:name] color:nil];
    layerObject->layer = layer;
    layer.pyObject = layerObject;
  }
  return (PyObject *)layerObject;
}

static PyMethodDef Font_methods[] = {
  { "save", (PyCFunction)Font_save, METH_VARARGS | METH_KEYWORDS, NULL },
  { "newLayer", (PyCFunction)Font_newLayer, METH_VARARGS | METH_KEYWORDS, NULL },
  { NULL }
};

PyTypeObject FontType = {
  PyVarObject_HEAD_INIT(NULL, 0)
  .tp_name = "fontParts.Font",
  .tp_doc = "Font object",
  .tp_basicsize = sizeof(FontObject),
  .tp_itemsize = 0,
  .tp_flags = Py_TPFLAGS_DEFAULT,
  .tp_dealloc = (destructor)Font_dealloc,
  .tp_methods = Font_methods,
  .tp_getset = Font_getsetters,
};
