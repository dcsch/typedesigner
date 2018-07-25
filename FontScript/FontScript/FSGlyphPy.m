//
//  FSGlyphPy.m
//  FontScript
//
//  Created by David Schweinsberg on 7/24/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSGlyph.h"
#import "FSPythonObjects.h"
#import <objc/runtime.h>
#include <Python/structmember.h>

@interface FSGlyph (Python)

@end

@implementation FSGlyph (Python)

- (GlyphObject *)pyObject {
  NSValue *value = objc_getAssociatedObject(self, PYOBJECT_ASSOCIATED_OBJECT);
  return (GlyphObject *)[value pointerValue];
}

- (void)setPyObject:(GlyphObject *)pyObject {
  NSValue *value = [NSValue valueWithPointer:pyObject];
  objc_setAssociatedObject(self, PYOBJECT_ASSOCIATED_OBJECT, value, OBJC_ASSOCIATION_RETAIN);
}

@end

static void Glyph_dealloc(GlyphObject *self) {
  Py_TYPE(self)->tp_free((PyObject *)self);
}

static PyObject *Glyph_getName(GlyphObject *self, void *closure) {
  FSGlyph *glyph = self->glyph;
  return PyUnicode_FromString(glyph.name.UTF8String);
}

static int Glyph_setName(GlyphObject *self, PyObject *value, void *closure) {
  if (value == NULL || !PyUnicode_Check(value)) {
    PyErr_SetString(PyExc_TypeError,
                    "The name attribute value must be a string");
    return -1;
  }
  FSGlyph *glyph = self->glyph;
  NSError *error = nil;
  [glyph setName:[NSString stringWithUTF8String:PyUnicode_AsUTF8(value)] error:&error];
  if (error) {
    PyErr_SetString(PyExc_ValueError, error.localizedDescription.UTF8String);
    return -1;
  }
  return 0;
}

static PyObject *Glyph_getUnicodes(GlyphObject *self, void *closure) {
  FSGlyph *glyph = self->glyph;
  PyObject *list = PyList_New(0);
  for (NSNumber *unicode in glyph.unicodes) {
    PyList_Append(list, PyLong_FromLong(unicode.longValue));
  }
  return list;
}

static int Glyph_setUnicodes(GlyphObject *self, PyObject *value, void *closure) {
  if (value == NULL || !PyList_Check(value)) {
    PyErr_SetString(PyExc_TypeError,
                    "The unicodes attribute value must be a list");
    return -1;
  }
  NSMutableArray<NSNumber *> *unicodes = [[NSMutableArray alloc] init];
  for (Py_ssize_t i = 0; i < PyList_Size(value); ++i) {
    PyObject *item = PyList_GetItem(value, i);
    if (!PyLong_Check(item)) {
      PyErr_SetString(PyExc_TypeError, "Unicode values must be an integer");
      return -1;
    }
    [unicodes addObject:[NSNumber numberWithLong:PyLong_AsLong(item)]];
  }
  FSGlyph *glyph = self->glyph;
  glyph.unicodes = unicodes;
  return 0;
}

static PyObject *Glyph_getUnicode(GlyphObject *self, void *closure) {
  FSGlyph *glyph = self->glyph;
  return PyLong_FromLong(glyph.unicode.longValue);
}

static int Glyph_setUnicode(GlyphObject *self, PyObject *value, void *closure) {
  if (value == NULL || !(PyLong_Check(value) || value == Py_None)) {
    PyErr_SetString(PyExc_TypeError,
                    "The unicode attribute value must be an integer or None");
    return -1;
  }
  FSGlyph *glyph = self->glyph;
  if (value == Py_None) {
    glyph.unicodes = [NSArray array];
  } else {
    glyph.unicode = [NSNumber numberWithLong:PyLong_AsLong(value)];
  }
  return 0;
}

static PyObject *Glyph_getWidth(GlyphObject *self, void *closure) {
  FSGlyph *glyph = self->glyph;
  return PyFloat_FromDouble(glyph.width);
}

static int Glyph_setWidth(GlyphObject *self, PyObject *value, void *closure) {
  if (value == NULL || !(PyLong_Check(value) || PyFloat_Check(value))) {
    PyErr_SetString(PyExc_TypeError,
                    "The width attribute value must be an integer or float");
    return -1;
  }
  FSGlyph *glyph = self->glyph;
  glyph.width = PyFloat_AsDouble(value);
  return 0;
}

static PyObject *Glyph_getLeftMargin(GlyphObject *self, void *closure) {
  FSGlyph *glyph = self->glyph;
  return PyFloat_FromDouble(glyph.leftMargin);
}

static int Glyph_setLeftMargin(GlyphObject *self, PyObject *value, void *closure) {
  if (value == NULL || !(PyLong_Check(value) || PyFloat_Check(value))) {
    PyErr_SetString(PyExc_TypeError,
                    "The leftMargin attribute value must be an integer or float");
    return -1;
  }
  FSGlyph *glyph = self->glyph;
  glyph.leftMargin = PyFloat_AsDouble(value);
  return 0;
}

static PyObject *Glyph_getRightMargin(GlyphObject *self, void *closure) {
  FSGlyph *glyph = self->glyph;
  return PyFloat_FromDouble(glyph.rightMargin);
}

static int Glyph_setRightMargin(GlyphObject *self, PyObject *value, void *closure) {
  if (value == NULL || !(PyLong_Check(value) || PyFloat_Check(value))) {
    PyErr_SetString(PyExc_TypeError,
                    "The rightMargin attribute value must be an integer or float");
    return -1;
  }
  FSGlyph *glyph = self->glyph;
  glyph.rightMargin = PyFloat_AsDouble(value);
  return 0;
}

static PyGetSetDef Glyph_getsetters[] = {
  { "name", (getter)Glyph_getName, (setter)Glyph_setName, NULL, NULL },
  { "unicodes", (getter)Glyph_getUnicodes, (setter)Glyph_setUnicodes, NULL, NULL },
  { "unicode", (getter)Glyph_getUnicode, (setter)Glyph_setUnicode, NULL, NULL },
  { "width", (getter)Glyph_getWidth, (setter)Glyph_setWidth, NULL, NULL },
  { "leftMargin", (getter)Glyph_getLeftMargin, (setter)Glyph_setLeftMargin, NULL, NULL },
  { "rightMargin", (getter)Glyph_getRightMargin, (setter)Glyph_setRightMargin, NULL, NULL },
  { NULL }
};

PyTypeObject GlyphType = {
  PyVarObject_HEAD_INIT(NULL, 0)
  .tp_name = "fontParts.Glyph",
  .tp_doc = "Glyph object",
  .tp_basicsize = sizeof(GlyphObject),
  .tp_itemsize = 0,
  .tp_flags = Py_TPFLAGS_DEFAULT,
  .tp_dealloc = (destructor)Glyph_dealloc,
  .tp_getset = Glyph_getsetters,
};
