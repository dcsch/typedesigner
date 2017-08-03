//
//  TCAppDelegate.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/1/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation
import os.log

@NSApplicationMain
class TCAppDelegate: NSObject, NSApplicationDelegate {

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  @IBAction func showPreferencePanel(sender: Any?) {
    //    if (!preferenceController)
    //        preferenceController = [[PreferencesWindowController alloc] init];
    //    [preferenceController showWindow:self];
    os_log("No preference panel as yet")
  }

}
