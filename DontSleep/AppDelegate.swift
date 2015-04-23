//
//  AppDelegate.swift
//  DontSleep
//
//  Created by Mitch Winn on 4/22/15.
//  Copyright (c) 2015 Mitch Winn. All rights reserved.
//

import Cocoa
import IOKit.pwr_mgt

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var statusItem = NSStatusItem()
    var darkModeOn = false
    var sleepModeOn = false
    var assertionID : IOPMAssertionID = IOPMAssertionID(0)
    let kIOPMAssertPreventUserIdleDisplaySleep = "PreventUserIdleDisplaySleep" as CFString
    var success : IOReturn = 0
    
    var reasonForActivity = "DontSleep is on -- so don't sleep!" as CFString

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Create the new status item with a certain alloated space.
        // Magic number "-1" stands for NSVariableStatusItemLength. A bug in beta 3
        // caused a linker error due to NSVariableStatusItemLength chaning to CGFloat.
        self.statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        
        // Add an image to the statusItem.
        self.statusItem.image = NSImage(named: "sunny24")
        
        // Create a action when the item is clicked.
        self.statusItem.action = Selector("itemClicked:")
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func itemClicked(sender: AnyObject) {
        // Change the statusItem image.
        if self.sleepModeOn == false {
            self.statusItem.image = NSImage(named: "sunny24")
        
            success = IOPMAssertionCreateWithName(kIOPMAssertPreventUserIdleDisplaySleep,
                                                    IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                    reasonForActivity,
                                                    &assertionID)
            self.sleepModeOn = true
        } else {
            self.statusItem.image = NSImage(named: "sunny24")
            
            if success == kIOReturnSuccess {
                IOPMAssertionRelease(assertionID);
            }
        }
    }

}

