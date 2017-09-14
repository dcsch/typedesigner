//
//  AppDelegate.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/1/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import os.log

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var fontDocumentController: FontDocumentController?

  func applicationDidFinishLaunching(_ aNotification: Notification) {

    // Hold a reference to our document controller
    fontDocumentController = FontDocumentController()
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
    return false
  }
}
