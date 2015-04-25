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
    // MARK: Variables
    
    /// The main window.
    @IBOutlet weak var window: NSWindow!
    
    /// Status menu item control.
    var statusItem = NSStatusItem()

    /// Flag specifing if dark mode is currently on or off.
    var darkModeOn = false
    
    /// Flag specifing if dont sleep mode is currently on or off.
    var dontSleepModeOn = false
    
    /// Assertion object handling display sleeping.
    var assertionID : IOPMAssertionID = IOPMAssertionID(0)
    
    /// Assertion type.
    let kIOPMAssertPreventUserIdleDisplaySleep = "PreventUserIdleDisplaySleep" as CFString

    /// Specifies whether or not the assertion succeeded.
    var success : IOReturn = 0
    
    /// Status for the assertion depicting the reason for the activity.
    var reasonForActivity = "DontSleep is on -- so don't sleep!" as CFString
    
    // MARK: Methods
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Create the new status item with a certain alloated space.
        // Magic number "-1" stands for NSVariableStatusItemLength. A bug in beta 3
        // caused a linker error due to NSVariableStatusItemLength changing to a CGFloat.
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        
        // Create an action when the item is clicked.
        statusItem.action = Selector("itemClicked:")
        
        // If the mac os x theme is currently light, use the light image.
        statusItem.image = NSImage(named: "Sunny")
        
        // Set image as a template in order for dark mode changes to take effect.
        statusItem.image?.setTemplate(true) 
    }
    
    /**
        Selector method that gets called whenever the status menu item gets
        clicked.
        
        :param: sender The calling sender.
    */
    func itemClicked(sender: AnyObject) {
        // If the flag sleepModeOn is false DontSleep!
        if dontSleepModeOn == false {
            // Change the statusItem image to include rays to
            // indicate that dont sleep mode is on.
            statusItem.image = NSImage(named: "SunnyRays")
            
            // Set image as a template in order for dark mode changes to take effect.
            statusItem.image?.setTemplate(true)
            
            // Create the assertion that will prevent the application from sleeping.
            success = IOPMAssertionCreateWithName(kIOPMAssertPreventUserIdleDisplaySleep,
                                                  IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                  reasonForActivity,
                                                  &assertionID)
            
            // Flag that sleep mode is on.
            dontSleepModeOn = true
            
        // Sleep mode is already on so release the display sleep assertion.
        } else {
            // Change the status menu item back to the default image.
            statusItem.image = NSImage(named: "Sunny")
            
            // Set image as a template in order for dark mode changes to take effect.
            statusItem.image?.setTemplate(true)
            
            // If the assertion previously succeeded, relase it.
            if success == kIOReturnSuccess {
                IOPMAssertionRelease(assertionID);
            }
            
            // Reset the sleep mode flag.
            dontSleepModeOn = false
        }
    }
}

