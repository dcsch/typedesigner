//
//  FSInfoPy.m
//  FontScript
//
//  Created by David Schweinsberg on 7/24/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSInfo.h"
#import "FSPythonObjects.h"
#import <objc/runtime.h>

@interface FSInfo (Python)

@end

@implementation FSInfo (Python)

- (InfoObject *)pyObject {
  NSValue *value = objc_getAssociatedObject(self, PYOBJECT_ASSOCIATED_OBJECT);
  return (InfoObject *)[value pointerValue];
}

- (void)setPyObject:(InfoObject *)pyObject {
  NSValue *value = [NSValue valueWithPointer:pyObject];
  objc_setAssociatedObject(self, PYOBJECT_ASSOCIATED_OBJECT, value, OBJC_ASSOCIATION_RETAIN);
}

@end

static void Info_dealloc(InfoObject *self) {
  Py_TYPE(self)->tp_free((PyObject *)self);
}

static PyObject *Info_getAttr(PyObject *self, PyObject *name) {
  FSInfo *info = ((InfoObject *)self)->info;
  if (!info) {
    PyErr_SetString(FontScriptError, "Peer object has been unloaded");
    return NULL;
  }

  NSString *attrName = [NSString stringWithUTF8String:PyUnicode_AsUTF8(name)];
  PyObject *value = NULL;
  if ([attrName isEqualToString:@"familyName"]) {
    value = PyUnicode_FromString(info.familyName.UTF8String);
  } else if ([attrName isEqualToString:@"styleName"]) {
    value = PyUnicode_FromString(info.styleName.UTF8String);
  } else {
    value = PyObject_GenericGetAttr(self, name);
  }
  return value;
}

PyTypeObject InfoType = {
  PyVarObject_HEAD_INIT(NULL, 0)
  .tp_name = "fontParts.Info",
  .tp_doc = "Info object",
  .tp_basicsize = sizeof(InfoObject),
  .tp_itemsize = 0,
  .tp_flags = Py_TPFLAGS_DEFAULT,
  .tp_dealloc = (destructor)Info_dealloc,
  .tp_getattro = Info_getAttr,
};
