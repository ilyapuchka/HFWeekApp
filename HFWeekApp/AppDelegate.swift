//
//  AppDelegate.swift
//  HFWeekApp
//
//  Created by Ilya Puchka on 22.03.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, MLCalendarViewDelegate {

    @IBOutlet weak var window: NSWindow!
    
    lazy var statusItem: NSStatusItem = {
        let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        statusItem.highlightMode = false
        statusItem.button?.target = self
        statusItem.button?.action = Selector("showContextMenu:")
        let options: NSEventMask = [.LeftMouseUpMask, .RightMouseUpMask]
        statusItem.button?.sendActionOn(Int(options.rawValue))
        return statusItem
    }()
    
    lazy var statusMenu: NSMenu = {
        let rightClickMenu = NSMenu()
        rightClickMenu.addItem(NSMenuItem(title: "Close", action: Selector("closeApp"), keyEquivalent: ""))
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
    
    lazy var calendar: MLCalendarView = {
        let calendar = MLCalendarView()
        calendar.selectionColor = .lightGrayColor()
        calendar.delegate = self
        return calendar
    }()
    
    func didSelectDate(selectedDate: NSDate!) {
        guard let selectedDate = selectedDate else { return }
        let week = HFCalendar.weekForDate(selectedDate)
        calendar.setStartDate(HFCalendar.startDateForWeek(week), endDate: HFCalendar.endDateForWeek(week))
        calendar.setWeek(week.handle)
    }
    
    func didSelectCurrentWeek() {
        let week = HFCalendar.currentWeek()
        calendar.setStartDate(HFCalendar.startDateForWeek(week), endDate: HFCalendar.endDateForWeek(week))
        calendar.setWeek(week.handle)
    }
    
    func didSelectNextWeek(week: String) {
        let currentWeek = HFWeek(string: week)!
        let week = currentWeek.nextWeek
        calendar.setStartDate(HFCalendar.startDateForWeek(week), endDate: HFCalendar.endDateForWeek(week))
        calendar.setWeek(week.handle)
    }
    
    func didSelectPreviousWeek(week: String) {
        let currentWeek = HFWeek(string: week)!
        let week = currentWeek.previousWeek
        calendar.setStartDate(HFCalendar.startDateForWeek(week), endDate: HFCalendar.endDateForWeek(week))
        calendar.setWeek(week.handle)
    }
    
    var timer: NSTimer!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        updateWeek()
        setupTimer()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("setupTimer"), name: NSSystemTimeZoneDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateWeek"), name: NSSystemClockDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("setupTimer"), name: NSSystemClockDidChangeNotification, object: nil)
        
//        SMLoginItemSetEnabled(NSBundle.mainBundle().bundleIdentifier!, true)
    }
    
    func setupTimer() {
        if let timer = timer {
            timer.invalidate()
        }
        
        let nextWeekDate = HFCalendar.startDateForWeek(HFCalendar.currentWeek().nextWeek)
        timer = NSTimer(fireDate: nextWeekDate, interval: 7*24*60*60, target: self, selector: Selector("updateWeek"), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func updateWeek() {
        let week = HFCalendar.currentWeek()
        calendar.setStartDate(HFCalendar.startDateForWeek(week), endDate: HFCalendar.endDateForWeek(week))
        calendar.setWeek(week.handle)
        statusItem.title = week.handle
    }
    
    func closeApp() {
        NSApp.terminate(nil)
    }
    
    func showContextMenu(sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        if (event.type == NSEventType.RightMouseUp) {
            statusItem.popUpStatusItemMenu(statusMenu)
        }
        else{
            popover.showRelativeToRect(sender.bounds, ofView: sender, preferredEdge: NSRectEdge.MaxY)
        }
    }
}

