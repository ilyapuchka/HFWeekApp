//
//  AppDelegate.swift
//  HFWeekApp
//
//  Created by Ilya Puchka on 22.03.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    lazy var calendarPresenter = CalendarPresenter()
    var calendar: MLCalendarView { return calendarPresenter.calendar }
    
    lazy var statusItem: NSStatusItem = {
        let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        statusItem.button?.target = self
        statusItem.button?.action = #selector(AppDelegate.showContextMenu(_:))
        let options: NSEventMask = [.LeftMouseUpMask, .RightMouseUpMask]
        statusItem.button?.sendActionOn(Int(options.rawValue))
        return statusItem
    }()
    
    lazy var statusMenu: NSMenu = {
        let rightClickMenu = NSMenu()
        rightClickMenu.addItem(NSMenuItem(title: "Close", action: #selector(AppDelegate.closeApp), keyEquivalent: ""))
        return rightClickMenu
    }()

    lazy var popover: NSPopover! = {
        let popover = NSPopover()
        popover.contentViewController = self.calendar
        popover.appearance = NSAppearance(named: NSAppearanceNameAqua)
        popover.animates = true
        popover.behavior = .Transient
        return popover
    }()
    
    var timer: NSTimer!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        updateWeek()
        setupTimer()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.setupTimer), name: NSSystemTimeZoneDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.updateWeek), name: NSSystemClockDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.setupTimer), name: NSSystemClockDidChangeNotification, object: nil)
    }
    
    func setupTimer() {
        if let timer = timer {
            timer.invalidate()
        }
        
        let nextWeekDate = HFCalendar.startDateForWeek(HFCalendar.currentWeek().nextWeek)
        timer = NSTimer(fireDate: nextWeekDate, interval: 7*24*60*60, target: self, selector: #selector(AppDelegate.updateWeek), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func updateWeek() {
        calendarPresenter.updateWeek()
        statusItem.title = HFCalendar.currentWeek().handle
    }
    
    func showContextMenu(sender: NSStatusBarButton) {
        switch NSApp.currentEvent!.type {
        case .RightMouseUp:
            statusItem.popUpStatusItemMenu(statusMenu)
        default:
            popover.showRelativeToRect(sender.bounds, ofView: sender, preferredEdge: NSRectEdge.MaxY)
        }
    }
    
    func closeApp() {
        NSApp.terminate(nil)
    }

}

