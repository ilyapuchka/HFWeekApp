//
//  TodayViewController.swift
//  HFWeekToday
//
//  Created by Ilya Puchka on 08.09.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {
    
    lazy var calendarPresenter = CalendarPresenter()
    var calendar: MLCalendarView { return calendarPresenter.calendar }
    
    override var nibName: String? {
        return "TodayViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.selectionColor = NSColor.darkGrayColor().colorWithAlphaComponent(0.5)
        calendar.backgroundColor = .clearColor()
        calendar.textColor = .whiteColor()

        view.addSubview(calendar.view)
        
        NSNotificationCenter.defaultCenter().addObserver(calendarPresenter, selector: #selector(calendarPresenter.updateWeek), name: NSSystemClockDidChangeNotification, object: nil)
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you

        calendarPresenter.updateWeek()
        completionHandler(.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInset: NSEdgeInsets) -> NSEdgeInsets {
        return NSEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
    }

}
