//
//  AppDelegate.swift
//  NVRAMManager
//
//  Created by yekki on 2017/1/23.
//  Copyright © 2017年 yekki. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var mainWindowController: MainWindowController?


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let mainWindowController = MainWindowController()
        
        mainWindowController.showWindow(self)
        
        self.mainWindowController = mainWindowController
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

